# frozen_string_literal: true

module CurvyPoker::Ranking
  RSpec.describe ThreeOfAKindRank do
    def evaluate(cards)
      ThreeOfAKindRank.evaluate hand(cards), CurvyPoker::Game::PokerGameRules.new
    end

    context 'with three of a kind' do
      example do
        expect(evaluate('23444')).to be_a ThreeOfAKindRank
      end

      example 'a wildcard can make a three of a kind' do
        expect(evaluate('2*445')).to be_a ThreeOfAKindRank
      end

      example 'two wildcards can make a three of a kind' do
        expect(evaluate('T*4*5')).to be_a ThreeOfAKindRank
      end

      it 'scores the same regardless of order' do
        expect(evaluate('22245'))
          .to eq(evaluate('42225'))
      end

      it 'ranks a high match over a lower match' do
        low_rank  = evaluate 'A87AA'
        high_rank = evaluate '9AA8A'

        expect(high_rank).to be > low_rank
      end

      it 'ranks equal matches using kick' do
        low_rank  = evaluate '24555'
        high_rank = evaluate '45T55'

        expect(high_rank).to be > low_rank
      end

      it 'ranks a hand using wildcards the same as without' do
        hand_a = evaluate 'T*4*5'
        hand_b = evaluate 'TT4T5'

        expect(hand_a).to eq hand_b
      end
    end

    context 'when a hand does not have three of a kind' do
      example do
        expect(evaluate('23445')).to be_falsey
      end
    end
  end
end
