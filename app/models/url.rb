# frozen_string_literal: true

class Url < ApplicationRecord
  before_create :generate_short_url

  private
    def generate_short_url
      require 'securerandom'
      self.short_url = SecureRandom.urlsafe_base64(5).upcase
      while Url.where(short_url: self.short_url).exists?
        return self.generate_short_url
      end
    end
end
