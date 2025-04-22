# frozen_string_literal: true

module Stays
  class FindConnectionService
    private attr_reader :stay, :candidate_connections

    def initialize(stay:, candidate_connections:)
      @stay = stay
      @candidate_connections = candidate_connections
    end

    def call
      candidate_connections.find do |candidate|
        candidate.location == stay.location &&
          candidate.arrival_date == stay.departure_date
      end
    end
  end
end
