# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Stay do
  subject(:stay) do
    described_class.new(
      type: type,
      location: location,
      arrival_date: arrival_date,
      departure_date: departure_date
    )
  end

  let(:type) { 'hotel' }
  let(:location) { 'BCN' }
  let(:arrival_date) { Date.new(2023, 4, 7) }
  let(:departure_date) { Date.new(2023, 4, 10) }

  describe '#initialize' do
    it 'sets the correct attributes', :aggregate_failures do
      expect(stay.type).to eq(type)
      expect(stay.location).to eq(location)
      expect(stay.arrival_date).to eq(arrival_date)
      expect(stay.departure_date).to eq(departure_date)
    end
  end

  describe '#start_date' do
    it 'returns the arrival date' do
      expect(stay.start_date).to eq(arrival_date)
    end
  end

  describe '#stay?' do
    it 'returns true' do
      expect(stay.stay?).to be true
    end
  end

  describe '#transport?' do
    it 'returns false' do
      expect(stay.transport?).to be false
    end
  end
end
