# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DetectTripsService do
  subject(:detect_trips_service) do
    described_class.new(
      stays: stays,
      transports: transports,
      based_at: based_at
    )
  end

  let(:based_at) { 'SVQ' }

  before do
    allow(Transports::FindConnectionService).to receive_message_chain(:new, :call).and_return(nil)
    allow(Stays::FindConnectionService).to receive_message_chain(:new, :call).and_return(nil)
    allow(Transports::FindStayService).to receive_message_chain(:new, :call).and_return(nil)
    allow(Stays::FindTransportService).to receive_message_chain(:new, :call).and_return(nil)
  end

  context 'when there is a complete trip' do
    let(:stays) do
      [
        *expected_trip_stays,
        Stay.new(
          location: 'LAL', arrival_date: Date.new(2022, 10, 6), departure_date: Date.new(2022, 10, 10),
          type: 'hotel'
        )
      ]
    end

    let(:expected_trip_stays) do
      [
        Stay.new(
          location: 'MAD', arrival_date: Date.new(2023, 6, 10), departure_date: Date.new(2023, 6, 15),
          type: 'hotel'
        )
      ]
    end

    let(:transports) do
      [
        *expected_trip_transports,
        Transport.new(
          origin: 'FLO',
          destination: 'LAL',
          departure_at: DateTime.new(2022, 10, 6, 12, 0, 0),
          arrival_at: DateTime.new(2022, 10, 6, 14, 0, 0),
          type: 'train'
        ),
        Transport.new(
          origin: 'MAD',
          destination: 'SVQ',
          departure_at: DateTime.new(2022, 10, 10, 18, 0, 0),
          arrival_at: DateTime.new(2022, 10, 10, 20, 0, 0),
          type: 'flight'
        )
      ]
    end

    let(:expected_trip_transports) do
      [
        Transport.new(
          origin: 'SVQ',
          destination: 'MAD',
          departure_at: DateTime.new(2023, 6, 10, 12, 0, 0),
          arrival_at: DateTime.new(2023, 6, 10, 14, 0, 0),
          type: 'flight'
        ),
        Transport.new(
          origin: 'MAD',
          destination: 'SVQ',
          departure_at: DateTime.new(2023, 6, 15, 18, 0, 0),
          arrival_at: DateTime.new(2023, 6, 15, 20, 0, 0),
          type: 'flight'
        )
      ]
    end

    before do
      allow(Transports::FindStayService).to receive_message_chain(:new, :call).and_return(expected_trip_stays[0], nil)
      allow(Stays::FindTransportService).to receive_message_chain(:new, :call).and_return(
        expected_trip_transports[1], nil
      )
    end

    it 'returns a trip with the correct segments' do
      trips = detect_trips_service.call
      trip = trips.first

      expect(trip.segments).to match_array(expected_trip_stays + expected_trip_transports)
    end
  end

  context 'when only transports are available and no matching stays' do
    let(:stays) { [] }

    let(:transports) do
      [
        Transport.new(
          origin: 'SVQ',
          destination: 'MAD',
          departure_at: DateTime.new(2023, 6, 10, 12, 0, 0),
          arrival_at: DateTime.new(2023, 6, 10, 14, 0, 0),
          type: 'flight'
        )
      ]
    end

    it 'builds the trip with the transports' do
      trips = detect_trips_service.call
      trip = trips.first

      expect(trip.segments).to match_array(transports)
    end
  end

  context 'when there are stays but no transports' do
    let(:stays) do
      [
        Stay.new(
          location: 'MAD',
          arrival_date: Date.new(2023, 6, 10),
          departure_date: Date.new(2023, 6, 15),
          type: 'hotel'
        )
      ]
    end

    let(:transports) { [] }

    it 'does not create a trip' do
      trips = detect_trips_service.call

      expect(trips).to be_empty
    end
  end
end
