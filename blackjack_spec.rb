require 'rspec'
require_relative 'blackjack'

include Blackjack

describe Card do
  subject(:card) { Card.new(:spade, :ten) }

  describe "card" do
    its(:suit) { should eq(:spade) }
    its(:value) { should eq(:ten) }
  end
end


describe "should not allow bogus cards to be made" do
  it "should not allow bad cards" do
    expect do 
      Card.new(:monkey, :fifty)
    end.to raise_error(RuntimeError)
  end
end

describe Deck do
  subject(:deck) { Deck.new }
  describe "should have 52 cards in a deck" do

    it "should give a qty of 52 cards" do
      cards = Deck.all_cards
      cards.count.should == 52
    end


    it "should be shuffled and not be the same" do
      cards = Deck.all_cards
      cards.shuffle != cards
    end

    it "should have remove cards from the deck" do
      deck.take(2)
      deck.cards.count.should == 50
    end
  end

  describe "returning cards to deck" do

    let(:deck) do
      Deck.new([Card.new(:spade, :eight),
                Card.new(:spade, :three),
                Card.new(:spade, :six)])
    end

    let(:cards_to_return) do
      [Card.new(:heart, :three), Card.new(:heart, :six)]
    end

    it "should add cards it gets back to the bottom of the deck" do
      #deck.cards.count.should == 1
      deck.return(cards_to_return)
      deck.cards.count.should == 5
    end

  end
end


describe Hand do
  subject(:hand) { Hand.new([Card.new(:heart, :three), Card.new(:heart, :six)]) }

  describe "Hand class should..." do
    it "should on a fresh hand have 2" do
      hand.cards.count == 2
    end

    it "3 of hearts and 6 of hearts should add to 9" do
      hand.points.should == 9
    end

    let(:hand2) do
      Hand.new([Card.new(:heart, :ace),
                Card.new(:spade, :king)])
    end

    it "ace of hearts and king of spades should be 21" do
      hand2.points.should == 21
    end

    let(:hand3) do
      Hand.new([Card.new(:heart, :king),
                Card.new(:spade, :seven),
                Card.new(:spade, :ace),
                Card.new(:heart, :ace),
                Card.new(:club, :ace)])
    end

    it "should still add correctly with 3 aces" do
      hand3.points.should == 20
    end
  end

  describe "should test the busted? method" do

    let(:hand4) do
      Hand.new([Card.new(:heart, :king),
                Card.new(:spade, :nine),
                Card.new(:spade, :ace),
                Card.new(:heart, :ace),
                Card.new(:club, :ace)])
    end

    it "should return false when not busted (points < 21)" do
      hand.busted?.should == false
    end

    it "should return true when busted > 21" do
      hand4.busted?.should == true
    end

    let(:hand5) do
      Hand.new([Card.new(:heart, :ace),
                Card.new(:spade, :king)])
    end

    let(:deck) { double("deck") }

    it "should get a third card" do
      hand5.hit(deck)
      hand5.cards.count.should == 3
    end


  end

end