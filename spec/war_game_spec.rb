require 'rspec'
require 'war_game'

describe 'WarGame' do
  it 'checks if starts game' do
    game = WarGame.new
    expect(game.start).to
  end

  it 'plays a round of war' do
    game = WarGame.new
    game.start
    expect(game.play_round).to
  end

  it 'tests for game winner' do
    game = WarGame.new
    game.start
    game.play_round
    expect(game.winner).to
  end
end
