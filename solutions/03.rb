class Integer

  def is_prime?
    self == 1 ? false : (2..self / 2).none?{ |i| self % i == 0 }
  end

end

class RationalSequence
  include Enumerable

  def initialize(limit)
    @limit = limit
    @direction = :left
    @nominator, @denominator = 1, 1
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

  def each
    found_prime_numbers, current = 0, 2

    while found_prime_numbers < @limit  do
      if current.is_prime?
        found_prime_numbers += 1
        yield current
      end
      current += 1
    end
  end

end

class FibonacciSequence
  include Enumerable

  def initialize(limit, first: 1, second: 1)
    @limit = limit
    @first = first
    @second = second
  end

  def each
    current, previous = @second, @first
    counter = 1

    while counter <= @limit
      yield previous
      current, previous = current + previous, current
      counter += 1
    end
  end
end

module DrunkenMathematician
  module_function

  def meaningless(n)
    rational = RationalSequence.new(n).partition do |r|
      r.numerator.is_prime? or r.denominator.is_prime?
    end

    rational.first.inject(1, :*) / rational.last.inject(1, :*)
  end

  def aimless(n)
    sum = 0
    PrimeSequence.new(n).each_slice(2) do |pair|
      sum += Rational(pair[0], pair[1] || 1)
    end
    sum
  end

  def worthless(n)
    sequence, sum = RationalSequence.new(2**16), 0
    fibonacci_max = FibonacciSequence.new(n).to_a.last

    sequence.take_while do |number|
      sum += number
      sum <= fibonacci_max
    end

  end
end
