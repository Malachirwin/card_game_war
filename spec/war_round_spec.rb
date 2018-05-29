require 'rspec'
require 'war_round'

describe 'WarRound' do
  it 'plays a round of war' do
    expect(WarRound.new.war_round('6 hearts', '7 spades')).to eq 5
  end
end
