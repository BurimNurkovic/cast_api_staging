class FacebookGraph
  def initialize(token)
    @graph = Koala::Facebook::API.new(token)
  end

  def id
    @graph.get_object('me')['id']
  end
end
