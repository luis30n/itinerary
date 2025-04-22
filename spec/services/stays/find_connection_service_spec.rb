# frozen_string_literal: true

require 'spec_helper'

module Stays
  RSpec.describe FindConnectionService do
    subject(:find_connection_service) do
      described_class.new(stay:, candidate_connections:)
    end

    let(:stay) do
      Stay.new(
        location: 'SVQ',
        arrival_date: Date.parse('2023-10-01'),
        departure_date: Date.parse('2023-10-02'),
        type: 'hotel'
      )
    end
    let(:same_arrival_date_stay) do
      Stay.new(
        location: 'SVQ',
        arrival_date: Date.parse('2023-10-01'),
        departure_date: Date.parse('2023-10-02'),
        type: 'hotel'
      )
    end
    let(:another_location_connection) do
      Stay.new(
        location: 'BCN',
        arrival_date: Date.parse('2023-10-02'),
        departure_date: Date.parse('2023-10-03'),
        type: 'hotel'
      )
    end
    let(:expected_connection) do
      Stay.new(
        location: 'SVQ',
        arrival_date: Date.parse('2023-10-02'),
        departure_date: Date.parse('2023-10-03'),
        type: 'hotel'
      )
    end

    let(:candidate_connections) do
      [
        same_arrival_date_stay,
        another_location_connection,
        expected_connection
      ]
    end

    describe '#call' do
      context 'when a connection is found' do
        it 'returns the expected connection' do
          expect(find_connection_service.call).to eq(expected_connection)
        end
      end

      context 'when no connection is found' do
        let(:candidate_connections) do
          [
            same_arrival_date_stay,
            another_location_connection
          ]
        end

        it 'returns nil' do
          expect(find_connection_service.call).to be_nil
        end
      end
    end
  end
end
