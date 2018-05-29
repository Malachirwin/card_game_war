require 'card'
require 'pry'

class WarRound

  def initalize
    result = nil
  end

  def war_round(player1, player2)
    if player1.to_i < player2.to_i
      result = "player 2 wins"
    end
  end
end
