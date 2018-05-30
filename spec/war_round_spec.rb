require 'rspec'
require 'war_round'
require 'player'

describe 'WarRound' do
  # it 'plays a round of war player2 wins and takes cards' do
  #   player2_hand = [Card.new('S', 7)]
  #   player2 = Player.new([player2_hand])
  #   player2_original_cards_left = player2.cards_left
  #   player1_hand = [Card.new('H', 6)]
  #   player1 = Player.new([player1_hand])
  #   player1_original_cards_left = player1.cards_left
  #   WarRound.new.play(player1, player2)
  #   expect(player2.cards_left).to eq (player2_original_cards_left + 1)
  #   # expect(player1.cards_left).to eq (player1_original_cards_left - 1)
  # end
  it 'plays a round of war player1 wins and takes cards' do
    player1_card = [Card.new('D', 10)]
    player2_card = [Card.new('C', 2)]
    player1 = Player.new(player1_card)
    player2 = Player.new(player2_card)
    player2_original_cards_left = player2.cards_left
    player1_original_cards_left = player1.cards_left
    WarRound.new.war_round(player1, player2)
    expect(player1.cards_left).to eq (player1_original_cards_left + 1)
  end
  it 'plays a round of war player1 wins and takes cards' do
    player1_card = [Card.new('D', 2)]
    player2_card = [Card.new('C', 10)]
    player1 = Player.new(player1_card)
    player2 = Player.new(player2_card)
    player2_original_cards_left = player2.cards_left
    player1_original_cards_left = player1.cards_left
    WarRound.new.war_round(player1, player2)
    expect(player2.cards_left).to eq (player2_original_cards_left + 1)
  end
  it 'plays a round of war tie' do
    tie_count = 1
    player1_card = [Card.new('D', 10), Card.new('H', 3), Card.new('H', 2), Card.new('H', 7)]
    player2_card = [Card.new('C', 10), Card.new('H', 5), Card.new('H', 6), Card.new('H', 8)]
    player1 = Player.new(player1_card)
    player2 = Player.new(player2_card)
    player2_original_cards_left = player2.cards_left
    player1_original_cards_left = player1.cards_left
    WarRound.new.war_round(player1, player2)
    expect(player2.cards_left).to eq (player2_original_cards_left + (tie_count + 2))
  end
end
