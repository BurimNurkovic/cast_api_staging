class Admin::BaseAdminController < ApplicationController
  before_action :auth_admin!

  private
  def auth_admin!
    # https://github.com/plataformatec/devise/blob/v3.4.1/lib/devise/controllers/helpers.rb
    head :unauthorized unless warden.authenticate?(scope: 'admin_user')
  end
end
