json.blogentries do
  json.array!(@blogentries) do |b|
    json.extract! b, :blog_type, :title, :url
    json.blog_url api_v1_blogentry_url(b)
    json.image_thumb b.image.url(:thumb)
    json.image_medium b.image.url(:medium)
    json.video_url if b.video?
  end
end

json.pagination do
  json.current_page @blogentries.current_page
  json.number_pages @blogentries.total_pages
  json.per_page params[:per].to_i || 25
  json.prev_page api_v1_blogentries_url(page: @blogentries.prev_page, per: params[:per]) if @blogentries.prev_page
  json.next_page api_v1_blogentries_url(page: @blogentries.next_page, per: params[:per]) if @blogentries.next_page
  json.total_entries @blogentries.total_count
  json.page_entries_info page_entries_info(@blogentries)
end
