# frozen_string_literal: true

module CurvyPoker::Ranking
  RSpec.describe PairRank do
    def evaluate(cards)
      PairRank.evaluate hand(cards), CurvyPoker::Game::PokerGameRules.new
    end

    context 'with a pair' do
      example do
        expect(evaluate('23445')).to be_a PairRank
      end

      example 'with a wildcard should be a pair' do
        expect(evaluate('234*5')).to be_a PairRank
      end

      it 'an equal pair is the same regardless of order' do
        expect(evaluate('23445'))
          .to eq(evaluate('43425'))
      end

      it 'ranks a high pair over a lower pair' do
        low_rank  = evaluate 'T872T'
        high_rank = evaluate '9AA87'

        expect(high_rank).to be > low_rank
      end

      it 'ranks a pair using kick' do
        low_rank  = evaluate '32455'
        high_rank = evaluate '23855'

        expect(high_rank).to be > low_rank
      end

      it 'uses a wildcard to make the largest scoring pair' do
        pair_a = evaluate '23858'
        pair_b = evaluate '2385*'

        expect(pair_a).to eq pair_b
      end
    end

    context 'when a hand does not have a pair' do
      it 'does not rank as a pair' do
        expect(evaluate('23456')).to be_falsey
      end
    end
  end
end
