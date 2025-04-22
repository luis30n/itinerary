# frozen_string_literal: true

class TransportSerializer
  include DateFormatting
  attr_reader :transport

  def initialize(transport:)
    @transport = transport
  end

  def serialize
    [
      "#{transport.type.capitalize} from #{transport.origin} to #{transport.destination} at",
      format_datetime(transport.departure_at),
      'to',
      format_time(transport.arrival_at)
    ].join(' ')
  end
end
