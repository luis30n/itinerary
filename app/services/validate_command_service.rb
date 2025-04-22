# frozen_string_literal: true

class ValidateCommandService
  MISSING_FILE_PATH_ERROR = 'File path is not defined'
  INVALID_FILE_PATH = 'File not found in the provided path'
  MISSING_BASED_AT_ERROR = 'BASED env var is not defined'
  INVALID_BASED_AT = 'BASED env var must be a three-letter word'

  private attr_reader :file_path, :based_at

  def initialize(file_path:, based_at:)
    @file_path = file_path
    @based_at = based_at
  end

  def valid?
    errors.empty?
  end

  def errors
    @errors ||= [].tap do |temp_errors|
      temp_errors << validate_file_path
      temp_errors << validate_based_at
    end.compact
  end

  private

  def validate_file_path
    return MISSING_FILE_PATH_ERROR if !file_path || file_path == ''

    INVALID_FILE_PATH unless File.exist?(file_path)
  end

  def validate_based_at
    return MISSING_BASED_AT_ERROR unless based_at

    INVALID_BASED_AT unless based_at.match?(/^[A-Z]{3}$/)
  end
end
