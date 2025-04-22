# frozen_string_literal: true

class StaySerializer
  include DateFormatting

  attr_reader :stay

  def initialize(stay:)
    @stay = stay
  end

  def serialize
    [
      "#{stay.type.capitalize} at #{stay.location} on",
      "#{format_date(stay.arrival_date)} to #{format_date(stay.departure_date)}"
    ].join(' ')
  end
end
