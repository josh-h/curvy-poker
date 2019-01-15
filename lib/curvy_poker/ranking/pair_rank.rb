# frozen_string_literal: true

module CurvyPoker
  module Ranking
    class PairRank < Rank
      extend XOfAKind
      @category_rank = 1

      def self.evaluate(hand, game_rules)
        high_cards, kick = same_rank(2, hand, game_rules)
        new(kick, high_cards, game_rules: game_rules) if high_cards
      end
    end
  end
end
