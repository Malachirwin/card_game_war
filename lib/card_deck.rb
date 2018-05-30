class CardDeck
  def initialize
    @deck = create_deck
  end

  def create_deck
    suits = ['H', 'D', 'S', 'C']
    suits.map do |suit|
      13.times.map do |number|
        rank = number + 1
        Card.new(suit, rank.to_s)
      end
    end.flatten
  end

  def shuffle
    @deck = @deck.shuffle
  end

  def cards_left
    @deck.length
  end

  def deal
    shuffle
    player1_hand =[]
    player2_hand =[]
    alternator = 0
    while has_cards?
      if alternator == 0
        player1_hand << remove_top_card
        alternator = 1
      else
        player2_hand << remove_top_card
        alternator = 0
      end
    end
    [player1_hand, player2_hand]
  end

  def remove_top_card
    @deck.pop
  end

  def has_cards?
    if cards_left > 0
      return true
    end
  end

end
