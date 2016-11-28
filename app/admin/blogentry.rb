ActiveAdmin.register Blogentry do
  menu label: "Blog"

  permit_params :blog_type, :status, :title, :text, :image, :video_url, :url

  filter :blog_type, as: :select, collection: Blogentry.blog_types
  filter :status, as: :select, collection: Blogentry.statuses
  filter :title
  filter :text

  member_action :preview, method: :get do
    @blogentry = resource
    render action: 'preview', layout: 'application'
  end

  action_item only: :show do
    link_to 'Preview', preview_admin_blogentry_path(blogentry), onclick: 'window.open(this.href, \'mywin\', \'left=50%,top=20px,width=400,height=710,location=0,menubar=0,resizable=0,scrollbars:0,status:0,titlebar:0,toolbar=0\'); return false;'
  end

  action_item only: :show do
    link_to 'New Blogentry', new_admin_blogentry_path
  end

  index do
    selectable_column
    id_column
    column :blog_type
    column :status
    column :title
    column :url
    column :text do |b|
      truncate(b.text, length: 200, escape: false)
    end
    column :image do |b|
      image_tag(b.image.url(:thumb)) if b.image.present?
    end
    column :video_url
    actions defaults: true do |blogentry|
      link_to 'Preview', preview_admin_blogentry_path(blogentry), onclick: 'window.open(this.href, \'mywin\', \'left=50%,top=20px,width=400,height=710,location=0,menubar=0,resizable=0,scrollbars:0,status:0,titlebar:0,toolbar=0\'); return false;'
    end
  end

  form do |f|
    f.inputs nil, multipart: true do
      f.input :blog_type, as: :select, collection: Blogentry.blog_types.map { |s| [s[0].humanize, s[0]] }
      f.input :status, as: :select, collection: Blogentry.statuses.map { |s| [s[0].humanize, s[0]] }
      f.input :title
      f.input :url, label: 'URL', as: :url
      f.input :text, as: :ckeditor
      f.input :image, as: :file, hint: f.object.image.present? ? image_tag(f.object.image.url(:thumb)) : content_tag(:span, 'No image yet')
      # f.input :image, as: :file
      f.input :video_url
    end
    f.actions
  end

  show do
    attributes_table do
      row :blog_type
      row :status
      row :title
      row :url
      row('text') { |b| b.text.html_safe }
      row :image do
        image_tag(blogentry.image.url(:thumb)) if blogentry.image.present?
      end
      row :video_url
    end
    active_admin_comments
  end

end
