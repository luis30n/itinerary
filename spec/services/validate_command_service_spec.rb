# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ValidateCommandService do
  subject(:validate_command_service) { described_class.new(file_path:, based_at:) }

  let(:file_path) { 'path_to_file.txt' }
  let(:based_at) { 'BCN' }

  describe '#valid?' do
    context 'when file_path and based_at are valid' do
      it 'returns true' do
        expect(validate_command_service.valid?).to be true
      end
    end

    context 'when file_path is nil' do
      let(:file_path) { nil }

      it 'returns false' do
        expect(validate_command_service.valid?).to be false
      end
    end

    context 'when file_path is empty' do
      let(:file_path) { '' }

      it 'returns false' do
        expect(validate_command_service.valid?).to be false
      end
    end

    context 'when based_at is nil' do
      let(:based_at) { nil }

      it 'returns false' do
        expect(validate_command_service.valid?).to be false
      end
    end

    context 'when based_at is not a three-letter word' do
      let(:based_at) { 'bc' }

      it 'returns false' do
        expect(validate_command_service.valid?).to be false
      end
    end
  end

  describe '#errors' do
    context 'when file_path and based_at are valid' do
      it 'returns true' do
        expect(validate_command_service.errors).to eq([])
      end
    end

    context 'when file_path is nil' do
      let(:file_path) { nil }

      it 'returns an error message' do
        expect(validate_command_service.errors).to include(ValidateCommandService::MISSING_FILE_PATH_ERROR)
      end
    end

    context 'when file_path is empty' do
      let(:file_path) { '' }

      it 'returns an error message' do
        expect(validate_command_service.errors).to include(ValidateCommandService::MISSING_FILE_PATH_ERROR)
      end
    end

    context 'when based_at is nil' do
      let(:based_at) { nil }

      it 'returns an error message' do
        expect(validate_command_service.errors).to include(ValidateCommandService::MISSING_BASED_AT_ERROR)
      end
    end

    context 'when based_at is not a three-letter word' do
      let(:based_at) { 'bc' }

      it 'returns an error message' do
        expect(validate_command_service.errors).to include(ValidateCommandService::INVALID_BASED_AT)
      end
    end
  end
end
