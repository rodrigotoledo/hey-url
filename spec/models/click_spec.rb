# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Click, type: :model do
  describe 'associations' do
    it { should belong_to(:url).class_name('Url') }
  end

  describe 'validations' do
    it { is_expected.not_to validate_presence_of(:browser).allow_nil }
    it { is_expected.not_to validate_presence_of(:platform).allow_nil }
  end
end
