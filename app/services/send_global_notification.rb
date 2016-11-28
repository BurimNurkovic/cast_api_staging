class SendGlobalNotification
  def self.call(*args)
    new(*args).call
  end

  include Virtus.model

  attribute :user, User
  attribute :notification, GlobalNotification

  attribute :push_message, String, writer: :private
  attribute :menu_item, String

  def call
    self.user = user
    self.notification = notification
    select_push_message
    send_push_note
  end

  private

  def select_push_message
    self.push_message = self.notification.unique_message self.user
    self.menu_item = self.notification.menu_item
  end

  def send_push_note
    if push_message
      Sns.send_push_to_user user: user, alert: push_message, amazon_tags: nil, menu_item: menu_item
    end
  end
end
