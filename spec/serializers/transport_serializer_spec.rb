# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TransportSerializer do
  subject(:serializer) { described_class.new(transport:) }
  let(:transport) do
    Transport.new(
      type: 'Flight',
      origin: 'SVQ',
      destination: 'BCN',
      departure_at: DateTime.new(2023, 4, 7, 12, 0, 0),
      arrival_at: DateTime.new(2023, 4, 7, 13, 30, 0)
    )
  end

  describe '#serialize' do
    it 'returns the serialized transport' do
      expect(serializer.serialize).to eq(
        'Flight from SVQ to BCN at 2023-04-07 12:00 to 13:30'
      )
    end
  end
end
