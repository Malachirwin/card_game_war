require_relative 'lib/card_deck'
require_relative 'lib/card'
require_relative 'lib/war_round'
player1_hand = []
player2_hand = []
def demo_deal(player1_hand, player2_hand)
  player1_hand << Card.new('H', '10')
  player1_hand << Card.new('C', '3')
  player1_hand << Card.new('D', '5')
  player1_hand << Card.new('C', '6')
  player1_hand << Card.new('H', '11')
  player2_hand << Card.new('S', '4')
  player2_hand << Card.new('H', '6')
  player2_hand << Card.new('C', '5')
  player2_hand << Card.new('S', '10')
  player2_hand << Card.new('D', '4')
end
demo_deal(player1_hand, player2_hand)

equal_tie = ''
cards = []

4.times do
  print "player 1 card #{player1_hand.first.rank + player1_hand.first.suit}"
  puts
  print "player 2 card #{player2_hand.first.rank + player2_hand.first.suit}"
  puts
  result = WarRound.new.war_round(player1_hand.first, player2_hand.first)
  cards << player1_hand.shift
  cards << player2_hand.shift
  if result == "player 1 wins"
    puts "player 1 wins"
    player1_hand.concat(cards)
    cards = []
  elsif result == "player 2 wins"
    puts "player 2 wins"
    player2_hand.concat(cards)
    cards = []
  else
    puts "tie"
    equal_tie = 'tie'
    cards << player1_hand.shift
    cards << player2_hand.shift
  end
  sleep(0)
end
