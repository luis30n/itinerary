# frozen_string_literal: true

module Transports
  class FindStayService
    private attr_reader :transport, :candidate_stays

    def initialize(transport:, candidate_stays:)
      @transport = transport
      @candidate_stays = candidate_stays
    end

    def call
      candidate_stays.find do |candidate|
        candidate.location == transport.destination &&
          candidate.arrival_date == transport.arrival_at.to_date
      end
    end
  end
end
