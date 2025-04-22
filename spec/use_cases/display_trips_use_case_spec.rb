# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DisplayTripsUseCase do
  subject(:display_trips_use_case) { described_class.new(file_path:, based_at:) }

  let(:file_path) { 'path_to_file.txt' }
  let(:based_at) { 'BCN' }

  describe '#call' do
    let(:lines) { ['Reservation', 'SEGMENT: Flight ROM 2023-04-07 12:00 -> MAD 13:30'] }
    let(:load_segments_service_mock) { instance_double(LoadSegmentsService, call: segments) }
    let(:detect_trips_service_mock) { instance_double(DetectTripsService, call: trips) }
    let(:segments) do
      SegmentCollection.new(
        stays: [],
        transports: []
      )
    end
    let(:trip_serializer_mock) { instance_double(TripSerializer, serialize: '') }
    let(:trip) { Trip.new(segments: [], origin: 'BCN') }
    let(:trips) { [trip] }

    before do
      allow(File).to receive(:readlines).with(file_path).and_return(lines)
      allow(LoadSegmentsService).to receive(:new).with(lines:).and_return(load_segments_service_mock)
      allow(DetectTripsService).to receive(:new).with(
        based_at:,
        stays: segments.stays,
        transports: segments.transports
      ).and_return(detect_trips_service_mock)
      allow(TripSerializer).to receive(:new).with(trip:).and_return(trip_serializer_mock)
    end

    it 'reads the lines from the file' do
      display_trips_use_case.call

      expect(File).to have_received(:readlines).with(file_path)
    end

    it 'loads the segments', :aggregate_failures do
      display_trips_use_case.call

      expect(LoadSegmentsService).to have_received(:new).with(lines:)
      expect(load_segments_service_mock).to have_received(:call)
    end

    it 'detects the trips' do
      display_trips_use_case.call

      expect(DetectTripsService).to have_received(:new).with(
        stays: segments.stays, transports: segments.transports, based_at:
      )
    end

    it 'serializes the trips', :aggregate_failures do
      display_trips_use_case.call

      expect(TripSerializer).to have_received(:new).with(trip:)
      expect(trip_serializer_mock).to have_received(:serialize)
    end
  end
end
