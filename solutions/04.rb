SUITS = [:spades, :hearts, :diamonds, :clubs]

class Card
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank, @suit = rank, suit
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

  def initialize(cards = full_deck)
    @deck = cards
  end

  def each(&block)
    @deck.each(&block)
  end

  def size
    @deck.size
  end

  def draw_top_card
    @deck.shift
  end

  def draw_bottom_card
    @deck.pop
  end

  def top_card
    @deck.first
  end

  def bottom_card
    @deck.last
  end

  def shuffle
    @deck.shuffle!
  end

  def sort
    @deck = [].tap{|deck| SUITS.each{|suit| deck << sort_by_rank(suit)}}.flatten
  end

  def to_s
    @deck.join("\n")
  end

  def deal
    self.class.new(@deck.shift(self.hand_size))
  end

  private

  def full_deck
    @deck = self.class::RANKS.product(SUITS).map {|r,s| Card.new(r,s)}
  end

  def sort_by_rank(suit)
    carts_to_sort = @deck.select { |card| card.suit == suit }
    carts_to_sort.sort_by! { |card| self.class::RANKS.index(card.rank)}
  end
end

class WarDeck < Deck
  attr_reader :hand_size

  def initialize(*arguments)
    super
    @hand_size = 26
  end

  def play_card
    draw_top_card
  end

  def allow_face_up?
    size <= 3
  end
end

class BeloteDeck < Deck

  attr_reader :hand_size

  RANKS = [:ace, :king, :queen, :jack, 10, 9, 8, 7]
  THREE_CONSECUTIVE = RANKS.each_cons(3)
  FOUR_CONSECUTIVE = RANKS.each_cons(4)
  FIVE_CONSECUTIVE = RANKS.each_cons(5)

  def initialize(*cards)
    super
    @hand_size = 8
  end

  def highest_of_suit(suit)
    get_sorted(suit).first
  end

  def belote?
    [].tap{|call| SUITS.each{|suit| call << twenty?(suit)}}.any?
  end

  def tierce?
    have_announcements(3, THREE_CONSECUTIVE)
  end

  def quarte?
    have_announcements(4, FOUR_CONSECUTIVE)
  end

  def quint?
    have_announcements(5, FIVE_CONSECUTIVE)
  end

  def carre_of_jacks?
    carre_of(:jack)
  end

  def carre_of_nines?
    carre_of(9)
  end

  def carre_of_aces?
    carre_of(:ace)
  end

  private

  def get_sorted(suit)
    sort.select { |card| card.suit == suit }
  end

  def carre_of(rank)
    @deck.select { |card| card.rank == rank }.size == 4
  end

  def have_announcements(count, consecutive)
    announcement = []
    split_hand.each do |slice|
      slice.each_cons(count) {|cut| announcement << consecutive.member?(cut)}
    end
    announcement.any?
  end

  def twenty?(suit)
    @deck.member?(Card.new(:king, suit)) &&
      @deck.member?(Card.new(:queen, suit))
  end

  def split_hand
    [].tap {|splits| SUITS.each {|suit| splits << get_sorted(suit).map(&:rank)}}
  end
end

class SixtySixDeck < Deck

  attr_reader :hand_size

  RANKS = [:ace, :king, :queen, :jack, 10, 9]

  def initialize(*arguments)
    super
    @hand_size = 6
  end

  def twenty?(trump_suit)
    [].tap{|call| (SUITS - [trump_suit]).each{|suit| call << forty?(suit)}}.any?
  end

  def forty?(trump_suit)
    @deck.member?(Card.new(:king, trump_suit)) &&
      @deck.member?(Card.new(:queen, trump_suit))
  end
end
