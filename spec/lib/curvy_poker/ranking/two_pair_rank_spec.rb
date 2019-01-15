# frozen_string_literal: true

module CurvyPoker::Ranking
  RSpec.describe TwoPairRank do
    def evaluate(cards)
      TwoPairRank.evaluate hand(cards), CurvyPoker::Game::PokerGameRules.new
    end

    context 'with two pairs' do
      example do
        expect(evaluate('22T8T')).to be_a TwoPairRank
      end

      # Note: it's better to use the wildcard to make a trip, so no need to test this
      # example 'a wildcard can make two pairs' do
      #   expect(evaluate('2*445')).to be_a TwoPairRank
      # end

      it 'an equal pair is the same regardless of order' do
        expect(evaluate('22445'))
          .to eq(evaluate('42425'))
      end

      it 'ranks a high pair over a lower pair' do
        low_rank  = evaluate 'A877A'
        high_rank = evaluate '9AA88'

        expect(high_rank).to be > low_rank
      end

      it 'ranks two pairs using kick' do
        low_rank  = evaluate '24455'
        high_rank = evaluate '45345'

        expect(high_rank).to be > low_rank
      end
    end

    context 'when a hand does not have two pairs' do
      example do
        expect(evaluate('23445')).to be_falsey
      end
    end
  end
end
