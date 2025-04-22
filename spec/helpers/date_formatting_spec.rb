# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DateFormatting do
  class DummyClass
    include DateFormatting
  end

  let(:dummy) { DummyClass.new }
  let(:date) { Date.new(2023, 4, 1) }
  let(:time) { Time.new(2023, 4, 1, 14, 30) }
  let(:datetime) { Time.new(2023, 4, 1, 14, 30) }

  describe '#format_date' do
    it 'formats the date correctly' do
      expect(dummy.format_date(date)).to eq('2023-04-01')
    end
  end

  describe '#format_time' do
    it 'formats the time correctly' do
      expect(dummy.format_time(time)).to eq('14:30')
    end
  end

  describe '#format_datetime' do
    it 'formats the datetime correctly' do
      expect(dummy.format_datetime(datetime)).to eq('2023-04-01 14:30')
    end
  end
end
