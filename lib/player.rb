class Player
  def initialize(name, cards=[])
    @cards = cards
    @name = name
  end

  def name
    @name
  end

  def cards_left
    @cards.count
  end

  def play
    @cards.shift
  end

  def take(cards)
    @cards.push(*cards)
  end

  def shuffle_hand
    @cards = @cards.shuffle
  end
end
