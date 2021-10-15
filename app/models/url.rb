# frozen_string_literal: true

class Url < ApplicationRecord
  before_create :generate_short_url
  has_many :clicks
  validates :original_url, uniqueness: true, presence: true

  require 'uri'
  validates_each :original_url do |record, attr, value|
    unless value =~ /\A#{URI::regexp(['http', 'https'])}\z/
      record.errors.add(attr, 'invalid url')
    end
  end

  def generate_click_info(request)
    user_agent = UserAgent.parse(request.env['HTTP_USER_AGENT'])
    click = clicks.build
    click.browser = user_agent.browser
    click.platform = user_agent.platform
    click.save
    touch(:updated_at)
  end

  def daily_clicks
    dates_in_month = (created_at.to_date.beginning_of_month..created_at.to_date.end_of_month).to_a
    dates_in_month.map do |date|
      [
        date.day.to_s,
        Url.where(
          created_at: date.to_time.beginning_of_day..date.to_time.end_of_day,
          short_url: short_url
        ).sum(:clicks_count)
      ]
    end
  end

  private
    def generate_short_url
      require 'securerandom'
      self.short_url = SecureRandom.urlsafe_base64(5).upcase
      while Url.where(short_url: self.short_url).exists?
        return self.generate_short_url
      end
    end
end
