# frozen_string_literal: true

class DisplayTripsUseCase
  private attr_reader :file_path, :based_at

  def initialize(file_path:, based_at:)
    @file_path = file_path
    @based_at = based_at&.upcase
  end

  def call
    trips.sort_by(&:start_date).each do |trip|
      puts TripSerializer.new(trip:).serialize
      puts "\n"
    end
  end

  private

  def trips
    DetectTripsService.new(
      stays: segment_collection.stays,
      transports: segment_collection.transports,
      based_at:
    ).call
  end

  def segment_collection
    @segment_collection ||= LoadSegmentsService.new(lines:).call
  end

  def lines
    File.readlines(file_path).map(&:strip)
  rescue StandardError
    []
  end
end
