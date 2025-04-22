# frozen_string_literal: true

require 'zeitwerk'

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/../app")
loader.push_dir("#{__dir__}/../app/services")
loader.push_dir("#{__dir__}/../app/models")
loader.push_dir("#{__dir__}/../app/parsers")
loader.push_dir("#{__dir__}/../app/serializers")
loader.push_dir("#{__dir__}/../app/use_cases")
loader.push_dir("#{__dir__}/../app/helpers")
loader.setup
loader.eager_load

require 'date'
