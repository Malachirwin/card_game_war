class CardDeck

  def cards_left
    52
  end

  def deal
    0
  end

  def remove_top_card
    self.pop
  end

  def has_cards?
    if cards_left > 0
      return true
    end
  end

end
