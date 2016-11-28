# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  email               :string(255)      default(""), not null
#  encrypted_password  :string(255)      default(""), not null
#  sign_in_count       :integer          default(0), not null
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string(255)
#  last_sign_in_ip     :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  first_name          :string(255)
#  last_name           :string(255)
#  age                 :string(255)
#  hair_type           :string(255)
#  skin_type           :string(255)
#  latitude            :float
#  longitude           :float
#  auth_token          :string(255)
#  installation_id     :string(255)
#  facebook_id         :string(255)
#  amazon_id           :string(255)
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  postal_town         :string(255)
#  country             :string(255)
#  endpoint_arn        :string(255)
#

class User < ActiveRecord::Base
  include Authorizable
  devise :database_authenticatable, :trackable, :validatable

  has_and_belongs_to_many :push_texts
  has_many :favorites, dependent: :destroy
  has_many :responses
  has_many :locations
  has_many :shopping_carts
  has_many :product_search_logs

  before_save -> { email.try(:downcase!) }, if: :email_changed?
  before_save :check_endpoint
  before_create :set_address

  scope :with_location, -> { where.not(latitude: ['', nil], longitude: ['', nil]) }

  validates :first_name, :last_name, :email, :age, :hair_type, :skin_type, :latitude, :longitude, :amazon_id,
            :installation_id, presence: true

  validates :age, inclusion: { in: %w(18-24 25-34 35-44 45-54 54+) }

  validates :hair_type, inclusion: { in: %w(straight wavy curly coily 1 2a 2b 2c 3a 3b 3c 4a 4b 4c) }
  validates :skin_type, inclusion: { in: %w(normal dry oily combination) }

  validates :facebook_id, uniqueness: true, allow_blank: true
  validates :amazon_id, uniqueness: true, allow_blank: true

  paperclip_options = { }
  paperclip_options.merge!(storage: :s3, s3_credentials: Proc.new{|a| a.instance.s3_credentials }) if Rails.env.production?

  has_attached_file :avatar, paperclip_options
  validates_attachment_content_type :avatar, content_type: %w(image/jpg image/jpeg image/png)

  def full_name
    "#{ first_name } #{ last_name }"
  end

  def set_address
    begin
      url = "http://maps.googleapis.com/maps/api/geocode/json?language=en&latlng=#{ latitude }%2C#{ longitude }&sensor=false"
      response = HTTParty.get url
      JSON.parse(response.body)['results'].first['address_components'].each do |c|
        # self.postal_town = c['long_name'] if c['types'].include? 'postal_town'
        self.postal_town = c['long_name'] if c['types'].include? 'administrative_area_level_2'
        self.postal_town = c['long_name'] if c['types'].include? 'administrative_area_level_1'
        self.country = c['short_name'] if c['types'].include? 'country'
        self.postal_code = c['short_name'] if c['types'].include? 'postal_code'
      end
      true
    rescue => e
      Rails.logger.error e.message
      true
    end
  end

  def password_required? # devise helper method override
    return false if facebook_id || amazon_id
    super
  end

  def s3_credentials
    { bucket: ENV['S3_BUCKET'], access_key_id: ENV['S3_ACCESS_KEY_ID'], secret_access_key: ENV['S3_SECRET_ACCESS_KEY'] }
  end

  def check_endpoint
    self.endpoint_arn = nil if installation_id_changed?
  end

  def favorites_attributes
    self.favorites.map {|favorite| favorite.public_attributes }
  end

  def favorite_brands
    Rails.cache.fetch("UserFavoriteBrands/#{self.id}", expires_in: 1.day) do
      question_ids = ENV['FAVORITE_BRANDS_QUESTIONS'].split('|')
      self.responses.where(question_id: question_ids).map(&:answer_text)
    end
  end

  def finish_shopping_cart!
    current_shopping_cart = self.shopping_carts.where(status: 'new').first
    current_shopping_cart.finish! if current_shopping_cart
  end
end
