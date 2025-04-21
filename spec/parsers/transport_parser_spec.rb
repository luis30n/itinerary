# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TransportParser do
  subject(:transport_parser) { described_class.new(line:) }

  describe '#parse!' do
    context 'when the segment is valid' do
      let(:line) { 'SEGMENT: Train MAD 2023-02-17 17:00 -> SVQ 19:30' }

      it 'parses the segment correctly', :aggregate_failures do
        transport = transport_parser.parse!

        expect(transport.origin).to eq('MAD')
        expect(transport.destination).to eq('SVQ')
        expect(transport.departure_at).to eq(DateTime.parse('2023-02-17 17:00'))
        expect(transport.arrival_at).to eq(DateTime.parse('2023-02-17 19:30'))
        expect(transport.type).to eq('train')
      end
    end

    context 'when the segment line is malformed' do
      context 'when the origin is missing' do
        let(:line) { 'SEGMENT: Train 2023-02-17 17:00 -> SVQ 19:30' }

        it 'raises an error when the origin is missing' do
          expect { transport_parser.parse! }.to raise_error(TransportParser::ParsingError, /Origin not found/)
        end
      end

      context 'when the destination is missing' do
        let(:line) { 'SEGMENT: Train MAD 2023-02-17 17:00 -> 19:30' }

        it 'raises an error when the destination is missing' do
          expect { transport_parser.parse! }.to raise_error(TransportParser::ParsingError, /Destination not found/)
        end
      end

      context 'when the departure at is missing' do
        let(:line) { 'SEGMENT: Train MAD 2023-02-17 -> SVQ 19:30' }

        it 'raises an error when the departure at is missing' do
          expect { transport_parser.parse! }.to raise_error(TransportParser::ParsingError, /Departure at not found/)
        end
      end

      context 'when the arrival at is missing' do
        let(:line) { 'SEGMENT: Train MAD 2023-02-17 17:00 -> SVQ' }

        it 'raises an error when the arrival time is missing' do
          expect { transport_parser.parse! }.to raise_error(TransportParser::ParsingError, /Arrival at not found/)
        end
      end

      context 'when the segment type is invalid' do
        let(:line) { 'SEGMENT: Plane MAD 2023-02-15 15:00 -> SVQ 17:30' }

        it 'raises an error when the segment type is invalid' do
          expect { transport_parser.parse! }.to raise_error(
            TransportParser::ParsingError,
            /Invalid segment type/
          )
        end
      end
    end
  end
end
