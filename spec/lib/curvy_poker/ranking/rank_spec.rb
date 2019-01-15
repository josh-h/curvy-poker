# frozen_string_literal: true

module CurvyPoker::Ranking
  RSpec.describe Rank do
    let(:rules) { CurvyPoker::Game::PokerGameRules.new }

    before do
      Rank.descendants.each { |child| Rank.add_rank_evaluator(child, rules) }
    end

    def evaluate(cards)
      Rank.evaluate hand(cards), rules
    end

    it 'displays its name' do
      rank = HighcardRank.new %w[2 3 4 5 6], game_rules: rules
      expect(rank.to_s).to eq('HIGHCARD')
    end

    context 'when scoring hands' do
      it 'scores pair over highcard' do
        low_rank  = HighcardRank.evaluate hand('6789Q'), rules
        high_rank = PairRank.evaluate hand('23445'), rules

        expect(high_rank).to be > low_rank
        expect(low_rank).to be < high_rank
      end

      it 'scores two pairs over a pair' do
        expect(evaluate('22T8T')).to be > evaluate('QQ853')
      end

      it 'scores three of a kind over two pairs' do
        expect(evaluate('2228T')).to be > evaluate('28T8T')
      end

      it 'scores a straight over three of a kind' do
        expect(evaluate('23456')).to be > evaluate('2228T')
      end

      it 'scores a full house over a straight' do
        expect(evaluate('22333')).to be > evaluate('23456')
      end

      it 'scores four of a kind over a full house' do
        expect(evaluate('2222')).to be > evaluate('AAAKK')
      end

      it 'factors the kick on equal ranking categories' do
        winning = evaluate('AA234')
        loosing = Rank.evaluate hand('T872T'), rules

        expect(winning).to be > loosing
      end
    end
  end
end
