# frozen_string_literal: true

module CurvyPoker
  class Game
    def initialize
      @hands = []
      @ranked_hands = {}

      @game_rules = PokerGameRules.new

      # Add the ranking rules to the game
      rank = CurvyPoker::Ranking::Rank
      rank.descendants
          .each { |child| rank.add_rank_evaluator(child, @game_rules) }
    end

    def showdown
      @hands.each { |hand| @ranked_hands[hand] = Ranking::Rank.evaluate(hand, @game_rules) }

      winning_hands = @hands.group_by { |hand| @ranked_hands[hand] }
                            .max
                            .last
      @hands.clear
      winning_hands
    end

    def deal(hand)
      raise ArgumentError, 'A hand must consist of 5 cards' if hand.cards.length != 5

      rank = Ranking::Rank.evaluate(hand, @game_rules)
      @ranked_hands[hand] = rank
      @hands << hand
      hand
    end

    def rank_hand(hand)
      @ranked_hands[hand]
    end

    class PokerGameRules
      @order = {
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
        'K' => 13,
        'A' => 14, # Only a straight uses Ace low, so refer to StraightRank
      }.freeze

      def self.order
        @order
      end

      def order
        self.class.order
      end

      def order_by_high_card(cards)
        cards.sort_by { |card| order[card] }
             .reverse
      end

      def high_card(cards)
        order_by_high_card(cards).first
      end

      def card_value(card)
        order[card]
      end

      def next_higher(card)
        card_order.at(card_order.index(card) + 1)
      end

      def next_lower(card)
        # raise 'XXX' if keys.index(card) == 0
        # Note: index of -1 wraps to the last position, giving us an A
        # which is the expected behaviour
        card_order.at(card_order.index(card) - 1)
      end

      def card_order
        @card_order ||= order.keys
      end
    end
  end
end
