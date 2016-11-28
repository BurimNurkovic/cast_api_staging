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

class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :age, :hair_type, :skin_type, :latitude, :longitude, :auth_token, :installation_id,
             :facebook_id, :amazon_id, :avatar

  def avatar
    if object.avatar.present?
      object.avatar.url
    else
      nil
    end
  end
end
