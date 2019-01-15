# frozen_string_literal: true

module CurvyPoker::Ranking
  RSpec.describe StraightRank do
    def evaluate(cards)
      StraightRank.evaluate hand(cards), CurvyPoker::Game::PokerGameRules.new
    end

    context 'with a straight' do
      example do
        expect(evaluate('T9876')).to be_a StraightRank
      end

      example 'a wildcard can make a straight' do
        expect(evaluate('T987*')).to be_a StraightRank
      end

      example 'two wildcards can make a straight' do
        expect(evaluate('*2*45')).to be_a StraightRank
        expect(evaluate('QJ**8')).to be_a StraightRank
      end

      context 'when an ace low is used to make a straight' do
        example { expect(evaluate('A2345')).to be_a StraightRank }
        example { expect(evaluate('A*345')).to be_a StraightRank }

        it 'scores the Ace as low when comparing to other straights' do
          expect(evaluate('23456')).to be > evaluate('A2345')
        end

        it 'scores' do
          rules=StraightRank::AceLowRules.new
          expect(rules.high_card(['A','2'])).to be '2'
        end
      end

      it 'ranks a high match over a lower match' do
        low_rank  = evaluate 'KQJT9'
        high_rank = evaluate 'AKQJT'

        expect(high_rank).to be > low_rank
      end

      it 'ranks a high match with wildcards over a lower match' do
        low_rank  = evaluate 'KQJT9'
        high_rank = evaluate '*KQ*T'

        expect(high_rank).to be > low_rank
      end

      it 'ranks uses wildcards for the low position cards' do
        low_rank  = evaluate 'KQJT9'
        high_rank = evaluate 'AKQJ*'

        expect(high_rank).to be > low_rank
      end
    end

    context 'when a hand does not have a straight' do
      example do
        expect(evaluate('T9*43')).to be_falsey
      end

      example { expect(evaluate('A*346')).to be_falsey }
    end
  end
end
