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

class Blogentry < ActiveRecord::Base
  enum status: [ :draft, :published ]
  enum blog_type: [ :text, :video, :url ]

  validates :status, presence: true
  validates :blog_type, presence: true
  validates :title, presence: true
  validates :text, presence: { if: :text? }
  validates :image, presence: { if: :text? }
  validates :video_url, presence: { if: :video? }
  validates :url, url: { allow_blank: true }

  before_save :do_video, if: :video?

  has_attached_file :image, styles: {
    thumb: '156x124^',
    medium: '558x444^'
  }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  default_scope { where(is_deleted: false) }

  def destroy
    self.is_deleted = true
    save(validate: false)
  end

  private
  def do_video
    if m = video_url.match(/\?v=(?<code>[\w-]+)/)
      data = Youtube.get_info m[:code]
      image_url = data['items'][0]['snippet']['thumbnails']['standard']['url']
      self.image = open(image_url, { ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE })
      self.text = data['items'][0]['snippet']['description'] if text.blank?
    end
    # raise 'ok'
  end
end
