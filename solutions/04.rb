class Card
  attr_accessor :rank, :suit

  def initialize(rank, suit)
    @rank, @suit = rank, suit
  end

  def to_s
    "#{rank.to_s.capitalize} of #{suit.to_s.capitalize}"
  end

  def ==(other)
    @rank == other.rank && @suit == other.suit
  end
end

class Deck
  include Enumerable

  def each(&block)
    @cards.each(&block)
  end

  def initialize(cards = all_cards_deck)
    @cards = cards
  end

  def ranks
    [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
  end

  def suits
    [:clubs, :diamonds, :hearts, :spades]
  end

  def get_rank(card)
    ranks.index(card.rank)
  end


  def get_suit(card)
    suits.index(card.suit)
  end

  def all_cards_deck
    suits.product(ranks).map { |suit, rank| Card.new(rank, suit) }
  end

  def size
    @cards.size
  end

  def draw_top_card
    @cards.shift
  end

  def draw_bottom_card
    @cards.pop
  end

  def top_card
    @cards.first
  end

  def bottom_card
    @cards.last
  end

  def shuffle
    @cards.shuffle!
  end

  def sort
    @cards = @cards.sort_by { |card| [ - get_suit(card), - get_rank(card)] }
  end

  def to_s
    @cards.join("\n")
  end

  def deal
    Hand.new(self, 0)
  end

  class Hand < Deck
    def initialize(deck, size)
      super deck.to_a.slice!(0, size)
      @deck = deck
      (0..size).each { deck.draw_top_card }
      self.sort
    end

    def ranks
      @deck.ranks
    end
  end
end

class WarDeck < Deck

  def deal
    Hand.new(self, 26)
  end


  class Hand < Deck::Hand
    def play_card
      draw_bottom_card
    end

    def allow_face_up?
      size <= 3
    end
  end
end

class BeloteDeck < Deck

  def ranks
    [7, 8, 9, :jack, :queen, :king, 10, :ace]
  end

  def deal
    Hand.new(self, 8)
  end

  class Hand < Deck::Hand
    def highest_of_suit(suit)
      one_suit = @cards.select { |card| card.suit == suit }
      one_suit.max_by { |card| get_rank(card) }
    end

    def belote?
      sort

      @cards.each_cons(2).any? do |pair|
        pair.first.rank == :king and pair.last.rank == :queen and
        pair.first.suit == pair.last.suit
      end
    end

    def tierce?
      consecutive_cards?(3)
    end

    def quarte?
      consecutive_cards?(4)
    end

    def quint?
      consecutive_cards?(5)
    end

    def carre_of_jacks?
      has_carre?(:jack)
    end

    def carre_of_nines?
      has_carre?(9)
    end

    def carre_of_aces?
      has_carre?(:ace)
    end

    def consecutive_cards?(count)
      sort

      @cards.each_cons(count).any? do |cons|
        if cons.first.suit == cons.last.suit
          get_rank(cons.first) - get_rank(cons.last) == count - 1
        end
      end
    end

    def has_carre?(rank)
      @cards.count { |card| card.rank == rank } == 4
    end
  end
end

class SixtySixDeck < Deck
  def ranks
    [9, :jack, :queen, :king, 10, :ace]
  end

  def deal
    Hand.new(self, 6)
  end

  class Hand < Deck::Hand
    def twenty?(trump_suit)
      pair_of_queen_and_king.any? do |pair|
        pair.first.suit != trump_suit and ! pair.nil?
      end
    end

    def forty?(trump_suit)
      pair_of_queen_and_king.any? do |pair|
        pair.first.suit == trump_suit and ! pair.nil?
      end
    end

    def pair_of_queen_and_king
      sort

      @cards.each_cons(2).find_all do |pair|
        rank_cards = pair.first.rank == :king and pair.last.rank == :queen and
        suit_cards = pair.first.suit == pair.last.suit
      end
    end
  end
end
