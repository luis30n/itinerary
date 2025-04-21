# frozen_string_literal: true

class Transport
  TYPES = %w[flight train].freeze

  attr_reader :type, :origin, :destination, :arrival_at, :departure_at

  def initialize(type:, origin:, destination:, arrival_at:, departure_at:)
    @type = type
    @origin = origin
    @destination = destination
    @arrival_at = arrival_at
    @departure_at = departure_at
  end
end
