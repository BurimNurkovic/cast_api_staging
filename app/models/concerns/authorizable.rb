module Authorizable
  extend ActiveSupport::Concern

  included do

    before_create :generate_token

    def regenerate_token!
      generate_token
      save!
    end

    private

    def self.random_token
      SecureRandom.hex
    end

    def generate_token
      begin
        self.auth_token = User.random_token
      end while self.class.exists?(auth_token: auth_token)
    end
  end
end
