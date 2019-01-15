# frozen_string_literal: true

module CurvyPoker
  module Ranking
    class TwoPairRank < Rank
      @category_rank = 2

      def self.evaluate(hand, game_rules)
        grouped, kick = hand.groupings(2)

        return new(kick, grouped, game_rules: game_rules) if pairs?(grouped)
      end

      def self.pairs?(grouped)
        grouped && grouped.length == 2
      end
    end
  end
end
