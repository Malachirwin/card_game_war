require 'war_game'

describe 'WarGame' do
  it 'checks if starts game' do
    game = WarGame.new
    game.start
    expect(@player1)
    expect(@player2)
  end

  it 'plays a round of war' do
    game = WarGame.new
    game.start
    expect(game.play_round).to be_instance_of String
  end

  it 'tests for game winner' do
    game = WarGame.new
    game.start
    10000.times do
      game.play_round
    end
    expect(game.winner.name).to be_instance_of String
  end
end
