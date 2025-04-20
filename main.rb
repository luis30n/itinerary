require_relative 'config/boot'

SAMPLE_COMMAND = 'BASED=SVQ bundle exec ruby main.rb input.txt'.freeze

file_path = ARGV[0]
based_at = ENV['BASED']&.upcase

def validate_command(file_path, based_at)
  validate_service = ValidateCommandService.new(file_path:, based_at:)
  return if validate_service.valid?

  validate_service.errors.each { |error| puts error }
  puts "\nUsage Example: #{SAMPLE_COMMAND}"
  exit 1
end

validate_command(file_path, based_at)