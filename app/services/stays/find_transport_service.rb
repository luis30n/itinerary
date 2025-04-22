# frozen_string_literal: true

module Stays
  class FindTransportService
    private attr_reader :stay, :candidate_transports

    def initialize(stay:, candidate_transports:)
      @stay = stay
      @candidate_transports = candidate_transports
    end

    def call
      candidate_transports.find do |transport|
        transport.origin == stay.location &&
          transport.start_date == stay.departure_date
      end
    end
  end
end
