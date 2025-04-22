# frozen_string_literal: true

module Transports
  class FindConnectionService
    private attr_reader :transport, :candidate_connections
    MAX_DAYS_DIFFERENCE = 1.0

    def initialize(transport:, candidate_connections:)
      @transport = transport
      @candidate_connections = candidate_connections
    end

    def call
      candidate_connections.find do |candidate|
        candidate.origin == transport.destination &&
          departs_less_than_24_hours_after_arrival?(candidate)
      end
    end

    private

    def departs_less_than_24_hours_after_arrival?(candidate)
      candidate.departure_at > transport.arrival_at &&
        (candidate.departure_at - transport.arrival_at).to_f < MAX_DAYS_DIFFERENCE
    end
  end
end
