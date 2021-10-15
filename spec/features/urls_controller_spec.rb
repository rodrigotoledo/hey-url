require "rails_helper"

RSpec.feature "URLs controller management", :type => :feature do
  let(:google_url) { create(:url, original_url: 'https://www.google.com') }
  before do
    create_list(:url, 15)
    google_url.update_attribute(:short_url, 'ABCDE')
  end

  describe "User get URLs list" do
    before do
      visit root_path
    end

    scenario 'User will see 10 items' do
      expect(page).to have_text('https://domain', count: 9)
      expect(page).to have_text('https://www.google.com')
    end
  end

  describe 'User get URL info' do
    before do
      visit root_path
    end

    scenario 'User get full information about URL' do
      click_link(href: url_path(google_url.short_url))

      expect(page).to have_text("Stats for #{visit_url(google_url.short_url)}")
      expect(page).to have_text("Created #{google_url.created_at.strftime('%b %d, %Y')}")
      expect(page).to have_text("Original URL: #{google_url.original_url}")
    end

    scenario 'User try access invalid URL' do
      visit url_path('asdadasdasdsada')
      expect(page.status_code).to eq(404)
      expect(page).to have_text("The page you were looking for doesn't exist.")
    end
  end

  describe 'User trying create URL' do
    before do
      visit root_path
    end

    scenario 'User create URL with success' do
      fill_in "url_original_url",	with: "https://facebook.com"
      click_button 'Shorten URL'
    end

    scenario 'User have error trying to create URL' do

    end
  end
end