require 'rspec'
require 'war_round'

describe 'WarRound' do
  it 'plays a round of war player2 wins' do
    player1_card = Card.new('H', 6)
    player2_card = Card.new('S', 7)
    expect(WarRound.new.war_round(player1_card, player2_card)).to eq 'player 2 wins'
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
