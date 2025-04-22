# frozen_string_literal: true

class Stay
  TYPES = %w[hotel].freeze

  attr_reader :location, :arrival_date, :departure_date, :type

  def initialize(location:, arrival_date:, departure_date:, type:)
    @location = location
    @arrival_date = arrival_date
    @departure_date = departure_date
    @type = type
  end

  def start_date
    arrival_date
  end

  def stay?
    true
  end

  def transport?
    false
  end
end
