# frozen_string_literal: true

module CurvyPoker
  RSpec.describe CLI do
    it 'runs a game with 2 hands' do
      expect(subject.run_game 'AA234', '23569')
        .to eq 'PAIR HIGHCARD a'
    end

    it 'tie games are possible' do
      expect(subject.run_game 'AA234', '4A2A3')
        .to eq 'PAIR PAIR ab'
    end

    it 'is more fun to play with several friends' do
      expect(subject.run_game 'AA234', '23569', 'KKQ25')
        .to eq 'PAIR HIGHCARD PAIR a'
    end
  end
end
