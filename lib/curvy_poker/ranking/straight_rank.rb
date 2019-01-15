# frozen_string_literal: true

module CurvyPoker
  module Ranking
    class StraightRank < Rank
      @category_rank = 4

      class AceLowRules < CurvyPoker::Game::PokerGameRules
        @order = {
          'A' => 1,
          '2' => 2,
          '3' => 3,
          '4' => 4,
          '5' => 5,
          '6' => 6,
          '7' => 7,
          '8' => 8,
          '9' => 9,
          'T' => 10,
          'J' => 11,
          'Q' => 12,
          'K' => 13
        }.freeze
      end

      class StraightEvaluator
        attr_reader :straight, :game_rules

        def initialize(hand, game_rules)
          @hand = hand
          @game_rules = game_rules
          reset_state
        end

        def straight?
          has_ace = @cards.include? 'A'
          straight = build_straight
          
          if straight.nil? && has_ace
            @game_rules = AceLowRules.new
            reset_state
            straight = build_straight
          end

          @straight = straight
        end

        def build_straight
          straight_hand = @cards.inject([@cards.shift]) do |partial, card|
            previous = partial.last
            diff = difference(previous, card)

            if diff == 1
              partial << card
            else
              while @wildcards > 0
                @wildcards -= 1

                # Use our wildcard
                previous = game_rules.next_lower(previous)
                partial << previous

                # Check if we can stop using wildcards and use the current card
                if game_rules.next_lower(previous) == card
                  partial << card
                  break
                end
              end
            end

            partial
          end

          # Use any leftover wildcards in the high or low position
          insert_remaining_wildcards(straight_hand)

          straight_hand if straight_hand.length == 5
        end

        private

        def difference(card_a, card_b)
          game_rules.card_value(card_a) - game_rules.card_value(card_b)
        end

        def insert_remaining_wildcards(straight_hand)
          while @wildcards > 0
            high_card = straight_hand.first
            if high_card != game_rules.card_order.last
              straight_hand.unshift game_rules.next_higher(high_card)
            else
              straight_hand.push game_rules.next_lower(straight_hand.last)
            end
            puts "straight_hand is now: #{straight_hand}"
            @wildcards -= 1
          end
        end

        def reset_state
          # #build_straight mutates our state, so reset
          @wildcards = @hand.wildcards
          @cards = game_rules.order_by_high_card @hand.without_wildcards
        end
      end

      def self.evaluate(hand, game_rules)
        evaluator = StraightEvaluator.new(hand, game_rules)

        new(evaluator.straight, game_rules: evaluator.game_rules) if evaluator.straight?
      end
    end
  end
end
