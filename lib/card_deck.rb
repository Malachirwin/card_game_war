class CardDeck
  def initialize
    @deck = create_deck
  end

  def create_deck
    suits = ['H', 'D', 'S', 'C']
    suits.map do |suit|
      13.times.map do |number|
        rank = number + 1
        Card.new(suit, rank)
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
    0
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
