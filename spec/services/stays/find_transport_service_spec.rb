# frozen_string_literal: true

require 'spec_helper'

module Stays
  RSpec.describe FindTransportService do
    subject(:find_transport_service) do
      described_class.new(stay:, candidate_transports:)
    end

    let(:stay) do
      Stay.new(
        location: 'SVQ',
        arrival_date: Date.parse('2023-10-01'),
        departure_date: Date.parse('2023-10-02'),
        type: 'hotel'
      )
    end

    let(:expected_transport) do
      Transport.new(
        origin: 'SVQ',
        destination: 'MAD',
        departure_at: Date.parse('2023-10-02'),
        arrival_at: Date.parse('2023-10-02'),
        type: 'flight'
      )
    end
    let(:another_origin_transport) do
      Transport.new(
        origin: 'MAD',
        destination: 'SVQ',
        departure_at: DateTime.new(2023, 10, 2, 12, 0, 0),
        arrival_at: DateTime.new(2023, 10, 2, 14, 0, 0),
        type: 'train'
      )
    end
    let(:another_departure_date_transport) do
      Transport.new(
        origin: 'SVQ',
        destination: 'MAD',
        departure_at: DateTime.new(2023, 10, 3, 12, 0, 0),
        arrival_at: DateTime.new(2023, 10, 3, 14, 0, 0),
        type: 'flight'
      )
    end

    let(:candidate_transports) do
      [
        expected_transport,
        another_origin_transport,
        another_departure_date_transport
      ]
    end

    describe '#call' do
      context 'when a transport is found' do
        it 'returns the expected transport' do
          expect(find_transport_service.call).to eq(expected_transport)
        end
      end

      context 'when no connection is found' do
        let(:candidate_transports) { [another_origin_transport, another_departure_date_transport] }

        it 'returns nil' do
          expect(find_transport_service.call).to be_nil
        end
      end
    end
  end
end
