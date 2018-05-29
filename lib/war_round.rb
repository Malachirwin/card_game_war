require 'card'
require 'pry'

class WarRound

  def initalize
    result = nil
  end

  def war_round(player1_card, player2_card)
    if player1_card.rank < player2_card.rank
      result = "player 2 wins"
    end
  end
end
