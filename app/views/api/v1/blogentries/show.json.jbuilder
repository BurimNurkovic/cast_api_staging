json.extract! @blogentry, :blog_type, :text, :url, :video_url
json.image_medium @blogentry.image.url(:medium)
