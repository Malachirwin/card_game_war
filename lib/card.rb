class Card

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end

  def rank
    @rank
  end

  def suit
    @suit
  end
  def value
    [@suit, @rank]
  end
end
