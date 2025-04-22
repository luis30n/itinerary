# frozen_string_literal: true

class DetectTripsService
  attr_reader :stays, :transports, :based_at, :base_transports
  attr_accessor :candidate_transports, :candidate_stays

  def initialize(stays:, transports:, based_at:)
    @stays = stays.sort_by(&:start_date)
    @transports = transports.sort_by(&:start_date)
    @based_at = based_at
    @base_transports, @candidate_transports = transports.partition { |t| t.origin == based_at }
    @candidate_stays = stays.dup
  end

  def call
    base_transports.map { |transport| build_trip(transport) }
  end

  private

  def build_trip(transport)
    trip = Trip.new(segments: [transport])

    next_segment = transport

    while candidate_transports.any? || candidate_stays.any?
      next_segment = find_next_segment(next_segment)
      break unless next_segment

      trip.segments << next_segment

      break if next_segment.segment_kind == :transport && final_transport?(next_segment)
    end

    trip
  end

  def find_next_segment(current_segment)
    case current_segment.segment_kind
    when :stay
      find_stay_connection(current_segment) || find_transport_after_stay(current_segment)
    when :transport
      find_transport_connection(current_segment) || find_stay_after_transport(current_segment)
    end
  end

  def final_transport?(transport)
    return false unless transport

    transport.destination == based_at
  end

  def find_transport_after_stay(stay)
    transport = Stays::FindTransportService.new(
      stay:, candidate_transports:
    ).call

    return unless transport

    candidate_transports.delete(transport)
  end

  def find_stay_after_transport(transport)
    stay = Transports::FindStayService.new(
      transport:, candidate_stays:
    ).call

    return unless stay

    candidate_stays.delete(stay)
  end

  def find_stay_connection(stay)
    connection = Stays::FindConnectionService.new(
      stay:, candidate_connections: candidate_stays
    ).call

    return unless connection

    candidate_stays.delete(connection)
  end

  def find_transport_connection(transport)
    connection = Transports::FindConnectionService.new(
      transport:, candidate_connections: candidate_transports
    ).call

    return unless connection

    candidate_transports.delete(connection)
  end
end
