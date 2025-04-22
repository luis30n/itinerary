# frozen_string_literal: true

require 'spec_helper'

module Transports
  RSpec.describe FindConnectionService do
    subject(:find_connection_service) do
      described_class.new(transport:, candidate_connections:)
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

    let(:too_early_connection) do
      Transport.new(
        origin: 'BCN',
        destination: 'PAR',
        departure_at: DateTime.parse('2023-10-01 09:00'),
        arrival_at: DateTime.parse('2023-10-01 11:00'),
        type: 'train'
      )
    end

    let(:too_late_connection) do
      Transport.new(
        origin: 'BCN',
        destination: 'PAR',
        departure_at: DateTime.parse('2023-10-02 12:00'),
        arrival_at: DateTime.parse('2023-10-02 16:00'),
        type: 'train'
      )
    end

    let(:wrong_origin_connection) do
      Transport.new(
        origin: 'MAD',
        destination: 'PAR',
        departure_at: DateTime.parse('2023-10-01 12:00'),
        arrival_at: DateTime.parse('2023-10-01 14:00'),
        type: 'train'
      )
    end

    let(:expected_connection) do
      Transport.new(
        origin: 'BCN',
        destination: 'PAR',
        departure_at: DateTime.parse('2023-10-01 12:00'),
        arrival_at: DateTime.parse('2023-10-01 14:00'),
        type: 'train'
      )
    end

    let(:candidate_connections) do
      [
        too_early_connection,
        too_late_connection,
        wrong_origin_connection,
        expected_connection
      ]
    end

    describe '#call' do
      context 'when a valid connection is found' do
        it 'returns the expected connection' do
          expect(find_connection_service.call).to eq(expected_connection)
        end
      end

      context 'when no valid connection is found' do
        let(:candidate_connections) do
          [
            too_early_connection,
            too_late_connection,
            wrong_origin_connection
          ]
        end

        it 'returns nil' do
          expect(find_connection_service.call).to be_nil
        end
      end
    end
  end
end
