class Player
  def initialize(cards=[])
    @cards = cards
  end

  def cards_left
    @cards.count
  end

  def play
    @cards.pop
  end

  def take(cards)
    @cards.push(*cards)
  end
end
