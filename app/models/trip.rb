# frozen_string_literal: true

class Trip
  attr_reader :origin, :segments

  def initialize(origin:, segments:)
    @origin = origin
    @segments = segments
  end

  def start_date
    segments.first&.start_date
  end

  def stays
    segments.select(&:stay?)
  end

  def transports
    segments.select(&:transport?)
  end

  def destination
    stays.first&.location || transports.last&.destination
  end
end
