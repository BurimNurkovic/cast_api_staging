ActiveAdmin.register User do
  menu priority: 2
  permit_params :email, :first_name, :last_name, :hair_type, :skin_type, :latitude, :longitude, :postal_town, :installation_id, :endpoint_arn, :postal_code

  index do
    selectable_column
    id_column
    column "Favorites" do |user|
      link_to('Favorites', admin_favorites_path('q[user_id_eq]': user.id))
    end
    column "Avatar" do |user|
      link_to(image_tag(user.avatar.url, size: '100x100'), user.avatar.url) if user.avatar.exists?
    end
    column :email
    column :first_name
    column :last_name
    column :age
    column :hair_type
    column :skin_type
    column :latitude
    column :longitude
    column :postal_town
    column :postal_code
    column :country
    column :installation_id
    column :created_at
    actions
  end

  form do |f|
    f.inputs nil, multipart: true do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :hair_type
      f.input :skin_type
      f.input :latitude
      f.input :longitude
      f.input :postal_town
      f.input :postal_code
      f.input :installation_id
      f.input :endpoint_arn
    end
    f.actions
  end


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end


end
