# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TripSerializer do
  subject(:serializer) { described_class.new(trip:) }

  let(:trip) { instance_double(Trip, destination: 'MAD', segments:) }

  describe '#serialize' do
    let(:transport_segment) do
      instance_double(Transport, transport?: true, stay?: false)
    end

    let(:stay_segment) do
      instance_double(Stay, stay?: true, transport?: false)
    end

    let(:segments) { [transport_segment, stay_segment] }

    let(:transport_serializer) { instance_double(TransportSerializer, serialize: 'Serialized Transport') }
    let(:stay_serializer) { instance_double(StaySerializer, serialize: 'Serialized Stay') }

    before do
      allow(TransportSerializer).to receive(:new).with(transport: transport_segment).and_return(transport_serializer)
      allow(StaySerializer).to receive(:new).with(stay: stay_segment).and_return(stay_serializer)
    end

    it 'serializes the trip and its segments' do
      result = serializer.serialize

      expect(result).to eq(['TRIP to MAD', 'Serialized Transport', 'Serialized Stay'])
    end
  end
end
