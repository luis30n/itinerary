# frozen_string_literal: true

require 'spec_helper'

RSpec.describe StayParser do
  subject(:stay_parser) { described_class.new(line:) }

  describe '#parse!' do
    context 'when the segment is valid' do
      let(:line) { 'SEGMENT: Hotel BCN 2023-01-05 -> 2023-01-10' }

      it 'parses the segment correctly', :aggregate_failures do
        stay = stay_parser.parse!

        expect(stay.location).to eq('BCN')
        expect(stay.arrival_date).to eq(Date.parse('2023-01-05'))
        expect(stay.departure_date).to eq(Date.parse('2023-01-10'))
        expect(stay.type).to eq('hotel')
      end
    end

    context 'when the segment line is malformed' do
      context 'when the location is missing' do
        let(:line) { 'SEGMENT: Hotel 2023-01-05 -> 2023-01-10' }

        it 'raises an error when the location is missing' do
          expect { stay_parser.parse! }.to raise_error(StayParser::ParsingError, /Location not found/)
        end
      end

      context 'when the arrival date is missing' do
        let(:line) { 'SEGMENT: Hotel BCN -> 2023-01-10' }

        it 'raises an error' do
          expect { stay_parser.parse! }.to raise_error(StayParser::ParsingError, /Arrival date not found/)
        end
      end

      context 'when the departure date is missing' do
        let(:line) { 'SEGMENT: Hotel BCN 2023-01-05 ->' }

        it 'raises an error' do
          expect { stay_parser.parse! }.to raise_error(StayParser::ParsingError, /Departure date not found/)
        end
      end

      context 'when the segment type is invalid' do
        let(:line) { 'SEGMENT: Flight MAD 2023-02-15 -> 2023-02-17' }

        it 'raises an error' do
          expect { stay_parser.parse! }.to raise_error(
            StayParser::ParsingError,
            /Invalid segment type/
          )
        end
      end
    end
  end
end
