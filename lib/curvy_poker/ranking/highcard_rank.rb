# frozen_string_literal: true

module CurvyPoker
  module Ranking
    class HighcardRank < CurvyPoker::Ranking::Rank
      @category_rank = 0

      def self.evaluate(hand, game_rules)
        # By default every hand has a high card
        new(hand.cards, game_rules: game_rules)
      end
    end
  end
end
