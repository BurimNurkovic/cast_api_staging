class Sns
  # reload!; Sns.send_push_to_user(user: User.find(213), alert: 'Test two', amazon_tags: 'wavy hair')
  def self.send_push_to_user(user:, alert:, amazon_tags:, menu_item: 'home')
    sns = AWS::SNS::Client.new

    if user.endpoint_arn.blank?
      arn = user.installation_id.length == 64 ? ENV['APN_IOS'] : ENV['APN_GCM']
      endpoint = sns.create_platform_endpoint(
        platform_application_arn: arn,
        token: user.installation_id,
        attributes: { 'UserId' => user.id.to_s }
      )
      user.endpoint_arn = endpoint[:endpoint_arn]
      user.save
    end

    if user.installation_id.length == 64
      message =  '{
        "APNS": "{ \"aps\": { \"alert\": \"' + alert + '\", \"menu-item\": \"' + menu_item + '\" } }"
      }'
      sns.publish target_arn: user.endpoint_arn, message: message, message_structure: 'json'
    else
      message = '{
        "GCM": "{ \"data\": { \"message\": \"' + alert + '\", \"menu-item\": \"' + menu_item + '\" } }"
      }'
      sns.publish target_arn: user.endpoint_arn, message: message, message_structure: 'json'
    end
  end
end
