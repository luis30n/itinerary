# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Display itinerary from command line' do
  def run_script(based_at:, input_file:)
    command = "BASED=#{based_at} bundle exec ruby main.rb #{input_file}"
    `#{command}`
  end

  def expected_output(file)
    File.read(File.join(__dir__, '..', 'fixtures', file)).strip
  end

  context 'when input file is input.txt' do
    it 'produces the correct output with BASED=SVQ' do
      result = run_script(based_at: 'SVQ', input_file: 'input.txt')

      expect(result.strip).to eq(expected_output('expected_output.txt'))
    end

    it 'produces a different output with BASED=BCN' do
      result = run_script(based_at: 'BCN', input_file: 'input.txt')

      expect(result.strip).not_to eq(expected_output('expected_output.txt'))
    end
  end

  context 'when input file is complex_input.txt' do
    it 'produces the correct output with BASED=MAD' do
      result = run_script(based_at: 'MAD', input_file: 'complex_input.txt')

      expect(result.strip).to eq(expected_output('expected_complex_output.txt'))
    end

    it 'produces a different output with BASED=SVQ' do
      result = run_script(based_at: 'SVQ', input_file: 'complex_input.txt')

      expect(result.strip).not_to eq(expected_output('expected_complex_output.txt'))
    end
  end
end
