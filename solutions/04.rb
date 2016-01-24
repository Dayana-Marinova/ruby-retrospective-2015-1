SUITS = [:spades, :hearts, :diamonds, :clubs]

class Card
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    rank.to_s.capitalize + " of " + suit.to_s.capitalize
  end

  def ==(other)
    rank == other.rank && suit == other.suit
  end

  alias_method :eql?, :==
end

class Deck
  include Enumerable

  RANKS = [:ace, :king, :queen, :jack, 10, 9, 8, 7, 6, 5, 4, 3, 2]

  attr_reader :cards

  def initialize(cards = all_cards)
    @cards = cards.shuffle
  end

  def each(&block)
    @cards.each(&block)
  end

  def size
    @cards.size
  end

  def draw_top_card
    @cards.delete(@cards.first)
  end

  def draw_bottom_card
    @cards.delete(@cards.last)
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
    sorted_deck = []
    SUITS.each { |suit| sorted_deck << sort_by_ranks(suit) }
    @cards = sorted_deck.flatten
  end

  def to_s
    @cards.each { |card| p card.to_s }
  end

  def deal
  end

  private

  def all_cards
    name = self.class
    cards = []
    SUITS.each {|suit| name::RANKS.each {|rank| cards << Card.new(rank, suit)}}
    cards
  end

  def sort_by_ranks(suit)
    carts_to_sort = @cards.select { |card| card.suit == suit }
    carts_to_sort.sort_by! { |card| self.class::RANKS.index(card.rank)}
  end
end

class WarDeck < Deck

  def initialize(*arguments)
    super
  end

  def deal
    WarDeck.new(draw)
  end

  def play_card
    draw_top_card
  end

  def allow_face_up?
    size <= 3
  end

  private

  def draw
    cards = []
    (size / 2).times{ |i| cards << draw_top_card }
    cards
  end
end

class BeloteDeck < Deck

  RANKS = [:ace, :king, :queen, :jack, 10, 9, 8, 7]

  THREE_CONSECUTIVE = [
    [:ace, :king, :queen],
    [:king, :queen, :jack],
    [:queen, :jack, 10],
    [:jack, 10, 9],
    [10, 9, 8],
    [9, 8, 7]
  ]

  FOUR_CONSECUTIVE = [
    [:ace, :king, :queen, :jack],
    [:king, :queen, :jack, 10],
    [:queen, :jack, 10, 9],
    [:jack, 10, 9, 8],
    [10, 9, 8, 7]
  ]

  FIVE_CONSECUTIVE = [
    [:ace, :king, :queen, :jack, 10],
    [:king, :queen, :jack, 10, 9],
    [:queen, :jack, 10, 9, 8],
    [:jack, 10, 9, 8, 7]
  ]


  def initialize(*arguments)
    super
  end

  def deal
    BeloteDeck.new(draw)
  end

  def highest_of_suit(suit)
    sort.select { |card| card.suit == suit }.first
  end

  def belote?
    twenty = []
    SUITS.each do |suit|
      twenty << @cards.include?(Card.new(:king, suit)) &&
      @cards.include?(Card.new(:queen, suit))
    end
    twenty.any?
  end

  def tierce?
    three_consecutive = []
    THREE_CONSECUTIVE.each do |tierce|
      split_hand.each {|element| three_consecutive << (element == tierce) }
    end
    three_consecutive.any?
  end

  def quarte?
    four_consecutive = []
    FOUR_CONSECUTIVE.each do |quarte|
      split_hand.each {|element| four_consecutive << (element == quarte) }
    end
    four_consecutive.any?
  end

  def quint?
    five_consecutive = []
    FIVE_CONSECUTIVE.each do |quint|
      split_hand.each {|element| five_consecutive << (element == quint) }
    end
    five_consecutive.any?
  end

  def split_hand
    splits = []
    SUITS.each do |suit|
      splits << sort.select{ |card| card.suit == suit }.map(&:rank)
    end
    splits
  end

  def carre_of_jacks?
    @cards.select { |card| card.rank == :jack }.size == 4
  end

  def carre_of_nines?
    @cards.select { |card| card.rank == 9 }.size == 4
  end

  def carre_of_aces?
    @cards.select { |card| card.rank == :ace }.size == 4
  end

  private

  def draw
    cards = []
    (size / 4).times{ |i| cards << draw_top_card }
    cards
  end
end

class SixtySixDeck < Deck

  RANKS = [:ace, :king, :queen, :jack, 10, 9]

  def initialize(*arguments)
    super
  end

  def deal
    SixtySixDeck.new(draw)
  end

  def twenty?(trump_suit)
    twenty = []
    (SUITS - [trump_suit]).each do |suit|
      twenty << @cards.include?(Card.new(:king, suit)) &&
      @cards.include?(Card.new(:queen, suit))
    end
    twenty.any?
  end

  def forty?(trump_suit)
    @cards.include?(Card.new(:king, trump_suit)) &&
    @cards.include?(Card.new(:queen, trump_suit))
  end

  private

  def draw
    cards = []
    6.times{ |i| cards << draw_top_card }
    cards
  end
end
