# frozen_string_literal: true

RSpec.describe CurvyPoker::Hand do
  context 'when dealing a new hand' do
    context '#new' do
      it 'handles string argument' do
        expect(hand('AATTK')).to be_a CurvyPoker::Hand
      end

      it 'handles array argument' do
        expect(hand(%w[A A T T K])).to be_a CurvyPoker::Hand
      end
    end
  
    context 'when illegal cards are used' do
      it 'raises an error' do
        expect { hand('by01z') }.to raise_error(ArgumentError)
      end

      it 'provides an error message' do
        expect { hand('b2344') }.to raise_error('bad card: ["b"]')
      end
    end

    it 'is immutable' do
      original_cards = '232AQ'
      cards = original_cards.dup
      hand = CurvyPoker::Hand.new cards

      cards[1] = 'A' # give ourselves a better hand
      expect(hand.cards).to eq(hand(original_cards).cards)

      # Try from the accessor
      expect { hand.cards[1] = 'A' }.to raise_error(FrozenError)
    end
  end

  context '#wildcard?' do
    example 'returns false when the hand has no wildcards' do
      expect(hand('23456').wildcard?).to be false
    end

    example 'returns number of wildcards' do
      expect(hand('2*4*6').wildcard?).to be 2
    end
  end

  context '#grouping to group pairs, trips, quads together' do
    example 'returns an array of matching groups followed by unmatching cards' do
      expect(hand('AATK2').groupings(2)).to eq [['A'], %w[T K 2]]
    end

    example 'has two pairs' do
      expect(hand('AATKT').groupings(2)).to eq [%w[A T], %w[K]]
    end

    context 'when it cannot make a group' do
      example 'returns false' do
        expect(hand('2A23T').groupings(3)).to be false
      end

      example 'does not make use of wildcards' do
        expect(hand('2A23*').groupings(3)).to be false
      end
    end
  end
end
