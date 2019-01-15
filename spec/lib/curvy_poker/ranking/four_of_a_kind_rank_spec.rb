# frozen_string_literal: true

module CurvyPoker::Ranking
  RSpec.describe FourOfAKindRank do
    def evaluate(cards)
      FourOfAKindRank.evaluate hand(cards), CurvyPoker::Game::PokerGameRules.new
    end

    context 'when a hand is a four of a kind' do
      example do
        expect(evaluate('AAAAK')).to be_a FourOfAKindRank
      end

      example 'wildcard completes four of a kind' do
        expect(evaluate('AAA*K')).to be_a FourOfAKindRank
      end

      example '2 wildcards complete four of a kind' do
        expect(evaluate('AA2**')).to be_a FourOfAKindRank
      end

      example '3 wildcards complete four of a kind' do
        expect(evaluate('A2***')).to be_a FourOfAKindRank
      end

      context 'when scoring' do
        it 'equal hands scores the same regardless of order' do
          expect(evaluate('AAKAA'))
            .to eq(evaluate('KAAAA'))
        end

        it 'ranks the four of a kind first' do
          low_rank  = evaluate 'TTTTK'
          high_rank = evaluate 'AAAAQ'

          expect(high_rank).to be > low_rank
        end

        it 'ranks the four of a kind with a wildcard' do
          low_rank  = evaluate 'JJJJT'
          high_rank = evaluate 'QQ*Q2'

          expect(high_rank).to be > low_rank
        end

        it 'ranks the single after the four of a kind' do
          low_rank  = evaluate 'QQQQ3'
          high_rank = evaluate 'TQQQQ'

          expect(high_rank).to be > low_rank
        end
      end
    end

    context 'when a hand is not four of a kind' do
      example 'three of a kind is not four of a kind' do
        expect(evaluate('AAAK2')).to be_falsey
      end
    end
  end
end
