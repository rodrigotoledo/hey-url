# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'associations' do
    it { should have_many(:clicks).class_name('Click') }
  end

  describe 'validations' do
    before do
      create(:url, original_url: 'http://www.teste.com')
    end

    it { is_expected.not_to validate_presence_of(:original_url).allow_nil }
    it 'should be uniqueness' do
      url = build(:url, original_url: 'http://www.teste.com')
      url.should validate_uniqueness_of(:original_url)
    end
  end
end
