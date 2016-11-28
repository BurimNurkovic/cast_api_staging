module ParseClient
  # reload!; ParseClient.send_push_to_user({ user: User.find(168), alert: 'test', amazon_tags: 'tag1, tag2, tag3' })
  def self.send_push_to_user(user:, alert:, amazon_tags:)
  end
    # we cannot use parse, we have to update this with other platform

    # amazon_tags = amazon_tags.split(', ') if amazon_tags
    # push = Parse::Push.new({alert: alert, amazon_tags: amazon_tags }, "user_#{recipient_id}")
    # push.type = recipient_id.length == 64 ? 'ios' : 'android'
    # push.save
end
