ActiveAdmin.register GlobalNotification do
  menu parent: 'Notifications'
  config.comments = false

  permit_params :time_of_a_day, :status, :menu_item, skin_type: [], hair_type: [], country_codes: [], push_text_attributes: [:id, :text, :_destroy]

  index do
    selectable_column
    id_column
    column :menu_item
    column :status
    column :match_users_count
    column(:skin_type) { |notification| notification.skin_type.join(', ') }
    column(:hair_type) { |notification| notification.hair_type.join(', ') }
    column(:countries) { |notification| truncate notification.country_names.try(:join, ', ').to_s, length: 50 }
    column(:push_message) { |notification| truncate notification.try(:push_text).try(:text), length: 15  }
    column :time_of_a_day
    actions
  end

  filter :skin_type, as: :select, collection: GlobalNotification::SKIN_TYPE_OPTIONS
  filter :hair_type, as: :select, collection: GlobalNotification::HAIR_TYPE_OPTIONS
  filter :time_of_a_day

  form do |f|
    f.inputs 'Push note details' do
      f.input :status, as: :select, collection: GlobalNotification::STATUSES
      f.input :menu_item, as: :select, collection: GlobalNotification::MENU_ITEMS
      f.input :skin_type, as: :select, collection: GlobalNotification::SKIN_TYPE_OPTIONS,
        input_html: { multiple: true }
      f.input :hair_type, as: :select, collection: GlobalNotification::HAIR_TYPE_OPTIONS,
        input_html: { multiple: true }
      f.input :time_of_a_day, as: :select, collection: ['now', '09', '18']
      f.input :country_codes, as: :country,  priority_countries: %w(US GB), input_html: { multiple: true, size: 15 }

      f.inputs "Push message", for: [:push_text, f.object.push_text || PushText.new] do |ff|
        ff.input :text, hint: "Example: Hey %{user}, how's your hair looking today?"
      end

    end
    f.actions
  end

  show do
    # default_main_content
    attributes_table do
      row :status
      row :menu_item
      row :match_users_count
      row(:skin_type) { |notification| notification.skin_type.join(', ') }
      row(:hair_type) { |notification| notification.hair_type.join(', ') }
      row :time_of_a_day
      row(:countries) { |notification| notification.country_names.try(:join, ', ') }
      row :created_at
      row :updated_at
    end

    panel 'Push Text' do
      table_for global_notification.push_text do
        column :text
      end
    end
  end
end
