# frozen_string_literal: true

class StayParser
  LOCATION_REGEX        = /[A-Za-z]{3}/
  ARRIVAL_DATE_REGEX    = /\d{4}-\d{2}-\d{2}/
  DEPARTURE_DATE_REGEX  = /->\s*\d{4}-\d{2}-\d{2}/

  class ParsingError < StandardError; end

  attr_reader :line

  def initialize(line:)
    @line = line
  end

  def parse!
    Stay.new(
      type:,
      location:,
      arrival_date:,
      departure_date:
    )
  end

  private

  def location
    match = line.match(/SEGMENT:\s*\w+\s(#{LOCATION_REGEX.source})/)
    raise ParsingError, "Location not found in: #{line}" unless match

    match[1].upcase
  end

  def arrival_date
    match = line.match(/#{LOCATION_REGEX.source}\s+(#{ARRIVAL_DATE_REGEX.source})/)
    raise ParsingError, "Arrival date not found in: #{line}" unless match

    Date.parse(match[1])
  end

  def departure_date
    match = line.match(/#{ARRIVAL_DATE_REGEX.source}\s*->\s*(#{ARRIVAL_DATE_REGEX.source})/)
    raise ParsingError, "Departure date not found in: #{line}" unless match

    Date.parse(match[1])
  end

  def type
    match = line.match(/SEGMENT:\s*(\w+)/)
    raise ParsingError, "Segment type not found in: #{line}" unless match

    segment_type = match[1].downcase
    raise ParsingError, "Invalid segment type #{segment_type} in: #{line}" unless Stay::TYPES.include?(segment_type)

    segment_type
  end
end
