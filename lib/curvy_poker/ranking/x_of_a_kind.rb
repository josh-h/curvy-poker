# frozen_string_literal: true

module CurvyPoker
  module Ranking
    module XOfAKind
      def same_rank(group_required, hand, game_rules)
        wildcards = hand.wildcards

        while wildcards >= 0
          high_cards, kick = hand.groupings(group_required)

          if high_cards
            # The lower grouping that we just matched on may have several high cards
            # only take only the highest and move the rest to the kick

            sorted_high_cards = game_rules.order_by_high_card(high_cards)
            high_card = sorted_high_cards.shift
            high_cards = [high_card]

            kick = remove_high_card(hand.without_wildcards, high_card)

            return high_cards, kick
          else
            group_required -= 1
            wildcards -= 1
          end
        end

        false
      end

      def remove_high_card(cards, high_card)
        cards.reject { |card| card == high_card }
      end
    end
  end
end
