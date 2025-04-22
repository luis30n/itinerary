# frozen_string_literal: true

class Trip
  attr_reader :segments

  def initialize(segments:)
    @segments = segments
  end
end
