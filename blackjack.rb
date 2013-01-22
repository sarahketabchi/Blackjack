module Blackjack
  class Card

    SUITS = {
      :spade => 'S',
      :club => 'C',
      :diamond => 'D',
      :heart => 'H'
    }

    CARD_VALUES = {
      :duece => "2",
      :three => "3",
      :four => "4",
      :five => "5",
      :six => "6",
      :seven => "7",
      :eight => "8",
      :nine => "9",
      :ten => "10",
      :jack => "J",
      :queen => "Q",
      :king => "K",
      :ace => "A"
    }

    BLACKJACK_VALUES = {
      :duece => 2,
      :three => 3,
      :four => 4,
      :five => 5,
      :six => 6,
      :seven => 7,
      :eight => 8,
      :nine => 9,
      :ten => 10,
      :jack => 10,
      :queen => 10,
      :king => 10
    }

    def self.suits
      SUITS.keys
    end

    def self.values
      CARD_VALUES.keys
    end

    attr_reader :suit, :value

    def initialize(suit, value)
      unless Card.suits.include?(suit) && Card.values.include?(value)
        raise "illegal suit (#{suit.inspect}) or value (#{value.inspect})"
      end

      @suit, @value = suit, value
    end

    def blackjack_value
      raise "ace has special value" if value == :ace
      BLACKJACK_VALUES[value]
    end
  end


  class Deck
    def self.all_cards
      full_deck = []
      Card.suits.each do |suit|
        Card.values.each { |value| full_deck << Card.new(suit, value) }
      end
      full_deck
    end

    attr_reader :cards, :discard_pile

    def initialize(cards = Deck.all_cards)
      @cards = cards
    end

    def shuffle
      @cards.shuffle!
    end

    def take(n)
      @cards.pop(n)
    end

    def return(cards)
      @cards.unshift(*cards)
    end
  end

  class Hand
    def self.deal_from(deck)
      Hand.new(deck.take(2))
    end

    attr_reader :cards

    def initialize(cards)
      @cards = cards
    end

    def points
      score = 0
      aces = 0
      @cards.each do |obj|
        if obj.value == :ace
          aces += 1
          next
        end
        score += obj.blackjack_value
      end
      aces.times { ((score + 11) <= 21) ? score += 11 : score += 1  }
      score
    end

    def busted?
      points > 21
    end

    def hit(deck)
      deck.take(1)
  end

end