# frozen_string_literal: true

require 'spec_helper'

module Transports
  RSpec.describe FindStayService do
    subject(:find_stay_service) do
      described_class.new(transport:, candidate_stays:)
    end

    let(:transport) do
      Transport.new(
        origin: 'SVQ',
        destination: 'BCN',
        departure_at: DateTime.parse('2023-10-01 08:00'),
        arrival_at: DateTime.parse('2023-10-01 10:00'),
        type: 'train'
      )
    end

    let(:different_arrival_date_stay) do
      Stay.new(
        location: 'BCN',
        arrival_date: Date.parse('2023-10-02'),
        departure_date: Date.parse('2023-10-05'),
        type: 'hotel'
      )
    end

    let(:expected_stay) do
      Stay.new(
        location: 'BCN',
        arrival_date: Date.parse('2023-10-01'),
        departure_date: Date.parse('2023-10-05'),
        type: 'hotel'
      )
    end

    let(:different_location_stay) do
      Stay.new(
        location: 'PAR',
        arrival_date: Date.parse('2023-10-01'),
        departure_date: Date.parse('2023-10-05'),
        type: 'hotel'
      )
    end

    let(:candidate_stays) do
      [
        different_arrival_date_stay,
        expected_stay,
        different_location_stay
      ]
    end

    describe '#call' do
      context 'when a matching stay is found' do
        it 'returns the expected stay' do
          expect(find_stay_service.call).to eq(expected_stay)
        end
      end

      context 'when no matching stay is found' do
        let(:candidate_stays) { [different_arrival_date_stay, different_location_stay] }

        it 'returns nil' do
          expect(find_stay_service.call).to be_nil
        end
      end
    end
  end
end
