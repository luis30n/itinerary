# frozen_string_literal: true

class Transport
  TYPES = %w[flight train].freeze

  attr_reader :type, :origin, :destination, :arrival_at, :departure_at

  def initialize(type:, origin:, destination:, departure_at:, arrival_at:)
    @type = type
    @origin = origin
    @destination = destination
    @departure_at = departure_at
    @arrival_at = arrival_at
  end

  def start_date
    departure_at.to_date
  end

  def stay?
    false
  end

  def transport?
    true
  end
end
