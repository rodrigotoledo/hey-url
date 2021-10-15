# frozen_string_literal: true

require 'rails_helper'
require 'webdrivers'

# WebDrivers Gem
# https://github.com/titusfortner/webdrivers
#
# Official Guides about System Testing
# https://api.rubyonrails.org/v5.2/classes/ActionDispatch/SystemTestCase.html

RSpec.describe 'Short Urls', type: :system do
  let(:google_url) { create(:url, original_url: 'https://www.google.com') }

  before do
    driven_by :selenium, using: :chrome
  end

  describe 'generate graphical info' do
    before do
      google_url.update_attribute(:short_url, 'ABCDE')
      visit root_path
      click_link(href: visit_path(google_url.short_url))
    end

    it 'increments clicks for URL' do
      expect(google_url.clicks.count).to eq(1)
    end

    it 'have platform info' do
      expect(google_url.clicks.first.platform).not_to be_empty
    end

    it 'have browser info' do
      expect(google_url.clicks.first.browser).not_to be_empty
    end
  end

  describe 'have error to try generate graphical info' do
    before do
      visit visit_path('asdsadasdasdsa')
    end

    it 'render invalid page with 404 code' do
      expect(page).to have_text("The page you were looking for doesn't exist.")
    end
  end
end
