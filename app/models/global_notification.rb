# == Schema Information
#
# Table name: push_conditions
#
#  id                  :integer          not null, primary key
#  skin_type           :string(255)
#  hair_type           :string(255)
#  minimum_temperature :integer
#  maximum_temperature :integer
#  minimum_humidity    :integer
#  maximum_humidity    :integer
#  time_of_a_day       :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  amazon_tags         :string(255)
#  type                :string(255)
#

class GlobalNotification < PushCondition
  serialize :country_codes
  serialize :skin_type
  serialize :hair_type

  has_one :push_text, dependent: :destroy, foreign_key: :push_condition_id

  accepts_nested_attributes_for :push_text

  MENU_ITEMS = %w(home profile locations blog shopping\ cart favorites)
  HAIR_TYPE_OPTIONS = %w(straight wavy curly coily)
  SKIN_TYPE_OPTIONS = %w(normal dry oily combination)
  STATUSES = %w(draft pending sent)

  validates :status, inclusion: { in: STATUSES }

  scope :pending, -> { where(status: 'pending') }

  before_save :update_match_users_count

  # TODO create a uniq method for this 3 attributes

  def skin_type=(values)
    write_attribute :skin_type, values.reject!(&:blank?)
  end

  def hair_type=(values)
    write_attribute :hair_type, values.reject!(&:blank?)
  end

  def country_codes=(values)
    write_attribute :country_codes, values.reject!(&:blank?)
  end

  def country_names
    self.country_codes.map do |country_code|
      country = ISO3166::Country[country_code]
      country.translations[I18n.locale.to_s] || country.name
    end if self.country_codes
  end

  def match_users
    users = User.with_location
    users = users.where(country: self.country_codes) unless self.country_codes.blank?
    users = users.where(hair_type: self.hair_type) unless self.hair_type.blank?
    users = users.where(skin_type: self.skin_type) unless self.skin_type.blank?
    users
  end

  def update_sent!
    self.status = 'sent'
    self.save
  end

  def unique_message(user)
    # retrives all the messages sent to the user from this condition
    sent_push_text = push_texts.sent_to_user(user)

    # if we do NOT find a sent_push_text
    if sent_push_text.blank?
      # mark it as sent
      self.push_text.users << user

      # replace the user variable
      result = self.push_text.try(:text)
      result = result % { user: user.first_name } if result
    end
    result
  end

  private
  def update_match_users_count
    self.match_users_count = self.match_users.count
  end
end
