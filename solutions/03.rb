class RationalSequence
  include Enumerable


  def initialize(limit)
    @limit = limit
    @direction = :left
    @nominator = 1
    @denominator = 1
    @rational_numbers = []
  end

  def each
    1.upto(@limit) do
      while @rational_numbers.include?(divide) do
        move
      end
      @rational_numbers << divide
      yield divide
    end
  end

  def move
    if @denominator == 1 and @direction == :left
      @nominator += 1
      @direction = :right
    elsif @nominator == 1 and @direction == :right
      @denominator += 1
      @direction = :left
    elsif @direction == :right
      @denominator += 1
      @nominator -= 1
    elsif @direction == :left
      @denominator -= 1
      @nominator += 1
    end
  end

  def divide
    Rational(@nominator, @denominator)
  end
end

class PrimeSequence
  include Enumerable

  def initialize(limit)
    @limit = limit
  end

  def self.is_prime(number)
    return false if number == 1
    divider = 2
    while number > divider do
      if number % divider == 0
        return false
      end
      divider += 1
    end
    return true
  end

  def each
    found_prime_numbers = 0
    current = 2
    while found_prime_numbers < @limit  do
      if PrimeSequence.is_prime(current)
        found_prime_numbers += 1
        yield current
      end
      current += 1
    end
  end
end

class FibonacciSequence
  include Enumerable

  def initialize(limit, options = {})
    @limit = limit
    @first = options[:first] || 1
    @second = options[:second] || 1
  end

  def each
    current, previous = @second, @first
    counter = 1
    while counter <= @limit
      yield previous
      temp = previous
      previous = current
      current = current + temp
      counter += 1
    end
  end
end

module DrunkenMathematician
  module_function

  def meaningless(n)
    rationals = RationalSequence.new(n)
    group_one = []
    group_two = []
    rationals.each do |rat|
      if PrimeSequence.is_prime(rat.numerator) or PrimeSequence.is_prime(rat.denominator)
        group_one << rat
      else
        group_two << rat
      end
    end
    group_one.reduce(1, :*) / group_two.reduce(1, :*)
  end

  def aimless(n)
    primes = PrimeSequence.new(n)
    sum = 0
    primes.each_slice(2) do |pair|
      sum += Rational(pair[0], (pair[1] || 1))
    end
    sum
  end

  def worthless(n)
    seq = RationalSequence.new(2**16)
    sum = 0
    result = []
    fibonacci_max = FibonacciSequence.new(n).max
    seq.each do |rat|
      sum += rat
      if sum > fibonacci_max
        return result
      end
      result << rat
    end
  end
end
