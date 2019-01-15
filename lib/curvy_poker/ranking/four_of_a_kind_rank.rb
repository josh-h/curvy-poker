# frozen_string_literal: true

module CurvyPoker
  module Ranking
    class FourOfAKindRank < Rank
      extend XOfAKind
      @category_rank = 6

      def self.evaluate(hand, game_rules)
        high_cards, kick = same_rank(4, hand, game_rules)
        new(kick, high_cards, game_rules: game_rules) if high_cards
      end
    end
  end
end
