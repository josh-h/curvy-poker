# frozen_string_literal: true

module CurvyPoker
  module Ranking
    class FullHouseRank < Rank
      extend XOfAKind
      @category_rank = 5

      def self.evaluate(hand, game_rules)
        high_cards, kick = same_rank(3, hand, game_rules)
        new(kick, high_cards, game_rules: game_rules) if high_cards && kick[0] == kick[1]
      end
    end
  end
end
