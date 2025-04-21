# frozen_string_literal: true

class TransportParser
  LOCATION_REGEX = /[A-Za-z]{3}/
  TIME_REGEXP = /\d{2}:\d{2}/
  DATE_REGEXP = /\d{4}-\d{2}-\d{2}/

  class ParsingError < StandardError; end

  attr_reader :line

  def initialize(line:)
    @line = line
  end

  def parse!
    Transport.new(
      type:,
      origin:,
      departure_at:,
      destination:,
      arrival_at:
    )
  end

  private

  def type
    match = line.match(/SEGMENT:\s*(\w+)/)
    raise ParsingError, "Segment type not found in: #{line}" unless match

    segment_type = match[1].downcase
    unless Transport::TYPES.include?(segment_type)
      raise ParsingError,
            "Invalid segment type #{segment_type} in: #{line}"
    end

    segment_type
  end

  def origin
    match = line.match(/SEGMENT:\s*\w+\s+(#{LOCATION_REGEX.source})/)
    raise ParsingError, "Origin not found in: #{line}" unless match

    match[1].upcase
  end

  def destination
    match = line.match(/#{TIME_REGEXP.source}\s*->\s*(#{LOCATION_REGEX.source}).*/)
    raise ParsingError, "Destination not found in: #{line}" unless match

    match[1].upcase
  end

  def date
    @date ||= begin
      match = line.match(/(#{DATE_REGEXP})/)
      raise ParsingError, "Date not found in: #{line}" unless match

      match[0]
    end
  end

  def departure_at
    match = line.match(/#{DATE_REGEXP.source}\s+(#{TIME_REGEXP.source})/)
    raise ParsingError, "Departure at not found in: #{line}" unless match

    DateTime.parse("#{date} #{match[1]}")
  end

  def arrival_at
    match = line.match(/->\s*#{LOCATION_REGEX.source}\s+(#{TIME_REGEXP.source})/)
    raise ParsingError, "Arrival at not found in: #{line}" unless match

    DateTime.parse("#{date} #{match[1]}")
  end
end
