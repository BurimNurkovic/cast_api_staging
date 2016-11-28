class UpdateUser
  def self.call(*args)
    new(*args).call
  end

  include Virtus.model

  attribute :user_params, Hash
  attribute :id, Integer

  attribute :user, User

  def call
    if this_user?
      if update_user
        updated
      else
        update_failed
      end
    else
      unsuccessful
    end
  end

  private

  def this_user?
    user.id == id.to_i
  end

  def update_user
    if %w(avatar content_type filename).all? { |val| user_params.key?(val) }
      user_params['avatar'] = uploaded_avatar
    end
    user.update_attributes(user_params.except(:auth_token, 'content_type', 'filename'))
  end

  def uploaded_avatar
    tempfile = Tempfile.new('avatar')
    tempfile.binmode
    tempfile.write Base64.decode64(user_params['avatar'])
    tempfile.rewind

    ActionDispatch::Http::UploadedFile.new(
        tempfile: tempfile,
        type: user_params['content_type'],
        filename: user_params['filename']
    )
  end

  def updated
    { success: true, render_arguments: [json: user, status: 200] }
  end

  def update_failed
    { success: true, render_arguments: [json: { errors: user.errors.full_messages }, status: 422] }
  end

  def unsuccessful
    { success: false }
  end
end
