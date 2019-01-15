# frozen_string_literal: true

module CurvyPoker
  RSpec.describe Game do
    context '#showdown' do
      it 'returns an array of the winning hand(s)' do
        subject.deal(hand('23456'))

        expect(subject.showdown).to be_an Array
      end

      it 'returns all winning hands' do
        hand_a = hand('23456')
        hand_b = hand('65432')

        subject.deal(hand_a)
        subject.deal(hand_b)

        expect(subject.showdown).to eq([hand_a, hand_b])
      end
    end

    it 'runs a game of poker' do
      winning_hand = hand('AA234')

      subject.deal hand('TT872')
      subject.deal winning_hand

      expect(subject.showdown).to eq([winning_hand])
    end

    context 'when an illegal hand is payed according to the game rules' do
      it 'validates a hand is 5 cards' do
        expect { subject.deal hand('2') }.to raise_error(ArgumentError)
        expect { subject.deal hand('234567') }.to raise_error(ArgumentError)
      end

      it 'provides an error message' do
        expect { subject.deal hand('4') }.to raise_error('A hand must consist of 5 cards')
      end
    end

    context 'poker game rules for sorting high cards' do
      example 'ACE is the highest ranked card' do
        rules = CurvyPoker::Game::PokerGameRules.new
        expect(rules.high_card(%w[T Q K A J])).to eq 'A'
      end
    end
  end
end
