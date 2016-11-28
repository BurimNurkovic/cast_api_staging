ActiveAdmin.register Favorite do
  menu parent: 'Profile'

  permit_params :amazon_id, :user_id

  index do
    selectable_column
    id_column
    column "Image" do |favorite|
      link_to(image_tag(favorite.advert_image_url, size: '50x50'), favorite.advert_image_url, target: :blank)
    end
    column :amazon_id
    column :advert_title
    column :advert_vendor
    column :advert_price_formatted
    actions
  end

  form do |f|
    f.inputs nil do
      f.input :user
      f.input :amazon_id
    end
    f.actions
  end
end
