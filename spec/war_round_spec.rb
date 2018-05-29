require 'rspec'
require 'war_round'

describe 'WarRound' do
  it 'plays a round of war' do
    player1_card = Card.new('H', 6)
    player2_card = Card.new('S', 7)
    expect(WarRound.new.war_round(player1_card, player2_card)).to eq 'player 2 wins'
  end
end
