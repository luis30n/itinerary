# frozen_string_literal: true

class TripSerializer
  attr_reader :trip

  def initialize(trip:)
    @trip = trip
  end

  def serialize
    output = []
    output << "TRIP to #{trip.destination}"
    trip.segments.each do |segment|
      output << serialize_segment(segment)
    end
    output
  end

  private

  def serialize_segment(segment)
    return TransportSerializer.new(transport: segment).serialize if segment.transport?

    StaySerializer.new(stay: segment).serialize if segment.stay?
  end
end
