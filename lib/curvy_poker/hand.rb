# frozen_string_literal: true

module CurvyPoker
  class Hand
    # Allowable cards
    CARD_VALUES = %w[2 3 4 5 6 7 8 9 T J Q K A *].freeze

    attr_reader :cards

    def initialize(cards)
      @cards = if cards.respond_to? :chars
                 cards.chars
               else
                 cards.dup
               end
      @cards.freeze

      validate
    end

    def wildcard?
      wildcards.positive? ? wildcards : false
    end

    def wildcards
      @wildcards ||= cards.count '*'
    end

    # Tries to group the cards by the same rank value
    def groupings(count)
      grouped = without_wildcards.group_by { |card| without_wildcards.count(card) }

      if grouped.key? count
        grouping = grouped.delete(count).uniq
        [grouping] << grouped.values.flatten
      else
        false
      end
    end

    # Returns the cards with wildcards removed
    def without_wildcards
      @without_wildcards ||= cards.reject { |card| card == '*' }
    end

    private

    def validate
      bad_cards = cards.reject { |card| CARD_VALUES.include? card }
      raise ArgumentError, "bad card: #{bad_cards}" if bad_cards.any?
    end
  end
end
