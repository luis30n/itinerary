# frozen_string_literal: true

require 'spec_helper'

RSpec.describe StaySerializer do
  subject(:serializer) { described_class.new(stay:) }

  let(:stay) do
    Stay.new(
      type: 'hotel',
      location: 'BCN',
      arrival_date: Date.new(2023, 1, 5),
      departure_date: Date.new(2023, 1, 10)
    )
  end

  describe '#serialize' do
    it 'the expected serialized stay' do
      expect(serializer.serialize).to eq(
        'Hotel at BCN on 2023-01-05 to 2023-01-10'
      )
    end
  end
end
