require_relative 'card_deck'

class WarRound

  def war_round(player1_card, player2_card)
    if player1_card.rank.to_i < player2_card.rank.to_i
      war_result = "player 2 wins"
    elsif
      player1_card.rank.to_i > player2_card.rank.to_i
      war_result = "player 1 wins"
    else
      war_result = "tie"
    end
    war_result
  end
end
