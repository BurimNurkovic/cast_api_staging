# == Schema Information
#
# Table name: blogentries
#
#  id                 :integer          not null, primary key
#  blog_type          :integer
#  title              :string(255)
#  text               :text
#  video_url          :string(255)
#  is_deleted         :boolean          default(FALSE), not null
#  status             :integer
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  url                :string(255)
#

class BlogentrySerializer < ActiveModel::Serializer
  attributes :id, :url, :blog_type, :title, :text, :video_url, :image_thumb, :image_medium

  def url
    api_v1_blogentry_url(object)
  end

  def image_thumb
    object.image.url(:thumb)
  end

  def image_medium
    object.image.url(:medium)
  end
end
