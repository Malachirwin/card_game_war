require_relative 'lib/war_game'

counter = 0

game = WarGame.new
game.start
until game.winner do
  puts game.play_round
  counter += 1
end
puts "Winner: #{game.winner.name}"
puts "They played #{counter} rounds"
