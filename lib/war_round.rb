require_relative 'card_deck'
require_relative 'player'
require_relative 'card'


class WarRound

  def war_round(player1, player2, played_cards = [])
    round_winner = ''
    winning_card = nil
    losing_card = nil
    player2_cards_left = player2.cards_left
    player1_cards_left = player1.cards_left
    if player1.cards_left > 0 && player2.cards_left > 0
      player1_card = player1.play
      player2_card = player2.play
      played_cards << player1_card
      played_cards << player2_card
      played_cards = played_cards.shuffle
      if player1_card.rank < player2_card.rank
        player2.take(played_cards)
        round_winner = 'player2'
        winning_card = player2_card
        losing_card = player1_card
      elsif player1_card.rank > player2_card.rank
        player1.take(played_cards)
        round_winner = 'player1'
        winning_card = player1_card
        losing_card = player2_card
      else
        round_winner = 'tie'
        played_cards << player1.play
        played_cards << player2.play
        round_winner, winning_card, losing_card = war_round(player1, player2, played_cards)
      end
    elsif player2_cards_left == 0
      player1.take(played_cards)
    elsif player1_cards_left == 0
      player2.take(played_cards)
    end
    [round_winner, winning_card, losing_card]
  end

end
