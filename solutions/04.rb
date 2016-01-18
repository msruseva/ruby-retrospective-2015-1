class Card
  include Comparable

  attr_accessor :rank, :suit, :deck

  def initialize (rank, suit)
    @rank = rank
    @suit = suit
    @deck = Deck.new([])
  end

  def to_s
    "#{rank.to_s.capitalize} of #{suit.to_s.capitalize}"
  end

  def <=> (other)
    suits_comparison = deck.suits.index(@suit) <=> deck.suits.index(other.suit)
    if suits_comparison == 0
      return rank_index <=> other.rank_index
    end
    return suits_comparison
  end

  def rank_index
    deck.ranks.index(@rank)
  end
end

class Deck
  include Enumerable

  attr_accessor :cards

  def initialize(cards = nil)
    if cards == nil
      all_cards_deck
    else
      @cards = cards
    end
    @cards.each { |card| card.deck = self }
  end

  def all_cards_deck
    @cards = Array.new
    suits.each do |suit|
      ranks.each do |rank|
        @cards << Card.new(rank, suit)
      end
    end
  end

  def ranks
    [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :qeen, :king, :ace].reverse
  end

  def suits
    [:spades, :hearts, :diamonds, :clubs]
  end

  def size
    @cards.size
  end

  def draw_top_card
    @cards.slice!(0)
  end

  def draw_bottom_card
    @cards.pop
  end

  def top_card
    @cards.at(0)
  end

  def bottom_card
    @cards.at(-1)
  end

  def shuffle
    @cards.shuffle!
  end

  def sort
    @cards.sort!
  end

  def to_s
    @cards.join("\n")
  end
end

class Hand
  attr_accessor :cards

  def initialize(cards = nil)
    @cards = cards
  end

  def size
    @cards.size
  end
end

class WarHand < Hand
  def play_card
    @cards.pop
  end

  def allow_face_up?
    size <= 3
  end
end

class WarDeck < Deck
  def deal
    hand = Array.new(26) { draw_top_card }
    WarHand.new(hand)
  end
end

class BeloteHand < Hand
  def highest_of_suit(suit)
    suit_cards = @cards.select { |card| card.suit == suit }
    suit_cards.sort.first
  end

  def belote?
    @cards.sort.each_cons(2) do |cons|
      if cons[0] == :king and cons[1] == :qeen and cons[0].suit == cons[1].suit
        return true
      end
    end
    return false
  end

  def tierce?
    @cards.sort.each_cons(3) do |cons|
      same_rank = cons[0].rank_index == (cons[-1].rank_index - 2)
      same_suit = cons.all? { |card| card.suit == cons[0].suit }
      if same_rank and same_suit
        return true
      end
    end
    return false
  end

  def quarte?
    @cards.sort.each_cons(4) do |cons|
      same_rank = cons[0].rank_index == (cons[-1].rank_index - 3)
      same_suit = cons.all? { |card| card.suit == cons[0].suit }
      if same_rank and same_suit
        return true
      end
    end
    return false
  end

  def quint?
    @cards.sort.each_cons(5) do |cons|
      same_rank = cons[0].rank_index == (cons[-1].rank_index - 4)
      same_suit = cons.all? { |card| card.suit == cons[0].suit }
      if same_rank and same_suit
        return true
      end
    end
    return false
  end

  def carre_of_jacks?
    has_carre? do |card|
      card.rank == :jack
    end
  end

  def carre_of_nines?
    has_carre? do |card|
      card.rank == 9
    end
  end

  def carre_of_aces?
    has_carre? do |card|
      card.rank == :ace
    end
  end

  def has_carre? (&block)
    @cards.sort.each_cons(4) do |cons|
      if cons.all? block
        return true
      end
    end
    return false
  end
end

class BeloteDeck < Deck
  def ranks
    [7, 8, 9, :jack, :qeen, :king, 10, :ace].reverse
  end

  def deal
    hand = Array.new(8) { draw_top_card }
    BeloteHand.new(hand)
  end
end

class SixtySixHand < Hand
  def twenty?(trump_suit)
    @cards.sort.each_cons(2) do |cons|
      rank_cards = cons[0] == :king and cons[1] == :qeen
      suit_cards = cons[0].suit == cons[1].suit
      if rank_cards and (suit_cards != trump_suit)
        return true
      end
    end
    return false
  end

  def forty?(trump_suit)
    @cards.sort.each_cons(2) do |cons|
      rank_cards = cons[0] == :king and cons[1] == :qeen
      suit_cards = cons[0].suit == cons[1].suit
      if rank_cards and (suit_cards == trump_suit)
        return true
      end
    end
    return false
  end
end

class SixtySixDeck < Deck
  def ranks
    [9, :jack, :qeen, :king, 10, :ace].reverse
  end

  def deal
    hand = Array.new(6) { draw_top_card }
    SixtySixHand.new(hand)
  end
end
