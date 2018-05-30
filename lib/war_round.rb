require_relative 'card_deck'
require_relative 'player'
require_relative 'card'
require 'pry'


class WarRound

  def initialize
    @add_cards = []
    @tie_count = 0
  end

  def war_round(player1, player2)
    player1_card = player1.play
    player2_card = player2.play
    if player1_card.rank.to_i < player2_card.rank.to_i
      player2.take([player1_card, player2_card])
      war_result = "player 2 wins"
      if @add_cards != []
        player2.take(@add_cards)
      end
    elsif player1_card.rank.to_i > player2_card.rank.to_i
      player1.take([player1_card, player2_card])
      war_result = "player 1 wins"
      if @add_cards != []
        player1.take(@add_cards)
      end
    else
      @add_cards << player1_card
      @add_cards << player2_card
      war_result = war_round(player1, player2)
    end
    war_result
  end

  # def play(player1, player2)
  #   player1_card = player1.play
  #   player2_card = player2.play
  #   player2.take([player1_card, player2_card])
  # end
end
