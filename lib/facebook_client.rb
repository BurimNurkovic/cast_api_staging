class FacebookClient
  def initialize(token)
    @graph = Koala::Facebook::API.new(token)
  end

  def id
    @graph.get_object('me')
  end

  def friends_ids
    friends.map { |friend| friend['id'] }
  end

  def get_avatar(type)
    @graph.get_picture(profile['id'], type: type)
  end

  private
  def friends
    @graph.get_connections('me', 'friends')
  end
end
