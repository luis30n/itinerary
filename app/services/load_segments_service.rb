# frozen_string_literal: true

class LoadSegmentsService
  SUPPORTED_SEGMENT_TYPES = (Transport::TYPES + Stay::TYPES).freeze
  SEGMENT_LINE_PREFIX = 'SEGMENT:'

  class FileNotFoundError < StandardError; end
  class UnsupportedSegmentError < StandardError; end

  Segments = Struct.new(:stays, :transports, keyword_init: true)

  private attr_reader :lines
  private attr_accessor :segments

  def initialize(lines:)
    @lines = lines
    @segments = Segments.new(stays: [], transports: [])
  end

  def call
    lines.each do |line|
      next unless line.start_with?(SEGMENT_LINE_PREFIX)

      segment_type = detect_segment_type(line)
      unless SUPPORTED_SEGMENT_TYPES.include?(segment_type)
        raise UnsupportedSegmentError,
              "Unsupported segment type: #{segment_type}"
      end

      load_transport(line) if Transport::TYPES.include?(segment_type)
      load_stay(line) if Stay::TYPES.include?(segment_type)
    end

    segments
  end

  private

  def detect_segment_type(line)
    match = line.match(/#{SEGMENT_LINE_PREFIX}\s*(\w+)/)
    match ? match[1].downcase : nil
  end

  def load_transport(line)
    transport = TransportParser.new(line:).parse!
    segments.transports << transport
  end

  def load_stay(line)
    stay = StayParser.new(line:).parse!
    segments.stays << stay
  end
end
