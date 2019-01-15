# frozen_string_literal: true

module CurvyPoker::Ranking
  RSpec.describe FullHouseRank do
    def evaluate(cards)
      FullHouseRank.evaluate hand(cards), CurvyPoker::Game::PokerGameRules.new
    end

    context 'when a hand is a full house' do
      example do
        expect(evaluate('AAKKK')).to be_a FullHouseRank
      end

      example 'wildcard completes a full house' do
        expect(evaluate('AAK*K')).to be_a FullHouseRank
      end

      # Not required as this also ranks as a higher four of a kind
      # example 'two wildcards complete a full house' do
      #   expect(evaluate('3*K*K')).to be_a FullHouseRank
      # end

      context 'when scoring' do
        it 'equal house scores the same regardless of order' do
          expect(evaluate('AAKKA'))
            .to eq(evaluate('KKAAA'))
        end

        it 'ranks the triplet first' do
          low_rank  = evaluate 'JJJTT'
          high_rank = evaluate 'QQQ22'

          expect(high_rank).to be > low_rank
        end

        it 'ranks the triplet first with a wildcard' do
          low_rank  = evaluate 'JJJTT'
          high_rank = evaluate 'QQ*22'

          expect(high_rank).to be > low_rank
        end

        it 'ranks the pair after the triplet' do
          low_rank  = evaluate 'QQQ22'
          high_rank = evaluate 'TTQQQ'

          expect(high_rank).to be > low_rank
        end
      end
    end

    context 'when a hand is not a full house' do
      example 'two wildcards do not make a full house' do
        expect(evaluate('A*K*2')).to be_falsey
      end
    end
  end
end
