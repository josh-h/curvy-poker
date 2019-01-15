# frozen_string_literal: true

module CurvyPoker
  module Ranking
    class Rank
      include Comparable

      @rankings = []

      class << self
        def add_rank_evaluator(rank, game_rules)
          @game_rules = game_rules
          @rankings << rank
          @rankings = @rankings.uniq
                               .sort_by(&:category_rank)
                               .reverse
          self
        end

        def evaluate(hand, game_rules)
          @rankings.lazy # Stops enumerating after we find the first matching Rank
                   .collect { |rank| rank.evaluate(hand, game_rules) }
                   .find { |rank| rank }
        end

        attr_reader :category_rank
      end

      def initialize(kick, high_card = [], game_rules: nil)
        @high_card = game_rules.order_by_high_card(high_card)
        @kick = game_rules.order_by_high_card(kick)
        @game_rules = game_rules
      end

      def to_s
        self.class
            .to_s
            .slice(/::(?<name>\w*)Rank$/, 'name')
            .upcase
      end

      def <=>(other)
        order = category_rank <=> other.category_rank
        if order.zero?
          # We have the same category of hand, so check the high card
          second_order = compare_card_ranks(high_card, other.high_card)
          if second_order.zero?
            compare_card_ranks(kick, other.kick)
          else
            second_order
          end
        else
          order
        end
      end

      def compare_card_ranks(first, second)
        cards_1 = first.to_enum
        cards_2 = second.to_enum
        order = 0
        loop do
          order = card_value(cards_1.next) <=> card_value(cards_2.next)
          break if order != 0
        end
        order
      end

      def hash
        [category_rank, high_card, kick].hash
      end

      def eql?(other)
        if other.is_a? Rank
          (self <=> other).zero?
        else
          false
        end
      end
      alias == eql?

      protected

      attr_reader :high_card, :kick

      def card_value(card)
        @game_rules.card_value(card)
      end

      def card_order
        @game_rules.card_order
      end

      def category_rank
        self.class.category_rank
      end
    end
  end
end
