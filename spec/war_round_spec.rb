require 'rspec'
require 'war_round'
require 'player'

describe 'WarRound' do
  it 'plays a round of war player2 wins and takes cards' do
    player2_card = Card.new('S', 7)
    player2 = Player.new([player2_card])
    player2_original_cards_left = player2.cards_left
    player1_card = Card.new('H', 6)
    player1 = Player.new([player1_card])
    player1_original_cards_left = player1.cards_left
    WarRound.new.play(player1, player2)
    expect(player2.cards_left).to eq (player2_original_cards_left + 1)
    # expect(player1.cards_left).to eq (player1_original_cards_left - 1)
  end
  it 'plays a round of war player1 wins' do
    player1_card = Card.new('D', 10)
    player2_card = Card.new('C', 2)
    expect(WarRound.new.war_round(player1_card, player2_card)).to eq 'player 1 wins'
  end
  it 'plays a round of war tie' do
    player1_card = Card.new('D', 10)
    player2_card = Card.new('C', 10)
    expect(WarRound.new.war_round(player1_card, player2_card)).to eq 'tie'
  end
end
