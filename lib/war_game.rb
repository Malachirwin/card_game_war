require_relative 'player'
require_relative 'card_deck'
require_relative 'war_round'

class WarGame
  attr_reader :player1, :player2
  def start
    deck = CardDeck.new
    deck.deal(player1_cards = [], player2_cards = [])
    @player1 = Player.new('player1', player1_cards)
    @player2 = Player.new('player2', player2_cards)
  end

  def play_round
    reture_this = ''
    result, winning_card, losing_card = WarRound.new.war_round(@player1, @player2)
    if result == 'player2'
      return_this = "player 2 took #{losing_card.value} with #{winning_card.value}"
    elsif result == 'player1'
      return_this = "player 1 took #{losing_card.value} with #{winning_card.value}"
    else
    end
    return_this
  end

  def winner
    if @player2.cards_left == 0
      @player1
    elsif @player1.cards_left == 0
      @player2
    end
  end
end
