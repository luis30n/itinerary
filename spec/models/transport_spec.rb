# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Transport do
  subject(:transport) do
    described_class.new(
      type: type,
      origin: origin,
      destination: destination,
      departure_at: departure_at,
      arrival_at: arrival_at
    )
  end

  let(:type) { 'flight' }
  let(:origin) { 'SVQ' }
  let(:destination) { 'BCN' }
  let(:departure_at) { DateTime.new(2023, 4, 7, 12, 0) }
  let(:arrival_at) { DateTime.new(2023, 4, 7, 13, 30) }

  describe '#initialize' do
    it 'sets the correct attributes', :aggregate_failures do
      expect(transport.type).to eq(type)
      expect(transport.origin).to eq(origin)
      expect(transport.destination).to eq(destination)
      expect(transport.departure_at).to eq(departure_at)
      expect(transport.arrival_at).to eq(arrival_at)
    end
  end

  describe '#start_date' do
    it 'returns the date of the departure time' do
      expect(transport.start_date).to eq(Date.new(2023, 4, 7))
    end
  end

  describe '#stay?' do
    it 'returns false' do
      expect(transport.stay?).to be false
    end
  end

  describe '#transport?' do
    it 'returns true' do
      expect(transport.transport?).to be true
    end
  end
end
