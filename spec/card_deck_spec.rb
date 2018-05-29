require 'rspec'
require 'card_deck'

describe "CardDeck" do
  it 'should have 52 cards when created' do
    deck = CardDeck.new
    expect(deck.cards_left).to eq 52
  end

  it 'should deal the top card' do
    deck = CardDeck.new
    expect(deck.deal).to eq 0
  end
  it 'returns true if deck has cards' do
    deck = CardDeck.new
    expect(deck.has_cards?).to eq true
  end
end
