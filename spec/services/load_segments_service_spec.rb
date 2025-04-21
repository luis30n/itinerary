# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LoadSegmentsService do
  subject(:load_segments_service) { described_class.new(lines:) }
  let(:lines) do
    [
      'Random line which should be ignored',
      'SEGMENT: Train MAD 2023-02-17 17:00 -> SVQ 19:30',
      'SEGMENT: Hotel SVQ 2023-01-05 -> 2023-01-10',
      'SEGMENT: Flight SVQ 2023-02-18 10:00 -> MAD 12:30'
    ]
  end

  describe '#call' do
    context 'when all lines contain valid segments' do
      it 'includes the first transport segment details' do
        result = load_segments_service.call

        expect(result.transports[0].origin).to eq('MAD')
        expect(result.transports[0].destination).to eq('SVQ')
        expect(result.transports[0].departure_at).to eq(DateTime.parse('2023-02-17 17:00'))
        expect(result.transports[0].arrival_at).to eq(DateTime.parse('2023-02-17 19:30'))
        expect(result.transports[0].type).to eq('train')
      end

      it 'includes the second transport segment details' do
        result = load_segments_service.call

        expect(result.transports[1].origin).to eq('SVQ')
        expect(result.transports[1].destination).to eq('MAD')
        expect(result.transports[1].departure_at).to eq(DateTime.parse('2023-02-18 10:00'))
        expect(result.transports[1].arrival_at).to eq(DateTime.parse('2023-02-18 12:30'))
        expect(result.transports[1].type).to eq('flight')
      end

      it 'returns the stay segment details' do
        result = load_segments_service.call

        expect(result.stays[0].location).to eq('SVQ')
        expect(result.stays[0].arrival_date).to eq(Date.parse('2023-01-05'))
        expect(result.stays[0].departure_date).to eq(Date.parse('2023-01-10'))
        expect(result.stays[0].type).to eq('hotel')
      end
    end

    context 'when there is an invalid  segment' do
      let(:lines) do
        [
          'Random line which should be ignored',
          'SEGMENT: Car MAD 2023-02-17 17:00 -> SVQ 19:30',
          'SEGMENT: Hotel BCN 2023-01-05 -> 2023-01-10',
          'SEGMENT: Train SVQ 2023-02-18 10:00 -> MAD 12:30'
        ]
      end

      it 'raises an UnsupportedSegmentError' do
        expect { load_segments_service.call }.to raise_error(
          LoadSegmentsService::UnsupportedSegmentError,
          'Unsupported segment type: car'
        )
      end
    end
  end
end
