ActiveAdmin.register ProductSearchLog do
  menu parent: 'System'

  controller do
    actions :all, :except => [:edit, :destroy]
  end

  index do
    # selectable_column
    id_column
    actions
    column :status
    column 'Level', :search_level
    column 'Page', :current_page
    column(:created_at) {|log| log.created_at.strftime('%m/%d %H:%M:%S') }
    column 'Type', :search_type
    column :keywords
    column(:pages) {|log| log.search_results.try(:[], :total_pages) }
    column(:user) {|log| link_to(truncate(log.user.try(:full_name), length: 15), admin_user_path(log.user)) if log.user }
    column 'Products', :products_count
  end

  show do |log|
    attributes_table  do
      row :status
      row :user
      row :search_type
      row :search_level
      row :keywords
      row :current_page
      row :products_count
      row :created_at
      row :updated_at
      row :request_params
      row(:amazon_scratchpad) {|log| link_to('Simulate search', log.scratchpad_url, target: :blank) }

      panel "Found Products" do
        table_for log.search_results[:products] do
          column(:images) { |product| (link_to(image_tag(product[:image_thumb_url]), product[:image_full_url], target: :blank)) if product }
          column(:id) { |product| (link_to(product[:id], "http://www.amazon.com/gp/product/#{product[:id]}", target: :blank)) if product }
          column :price
          column :title
          column :manufacturer
        end
      end

    end

    attributes_table do
      row(:error_messages) {|log| log.search_results.try(:[], :error) }
    end

    attributes_table do
      row(:response_body) {|log| log.response_body }
    end
  end
end
