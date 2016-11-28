class Youtube
  include HTTParty

  def self.get_info code
    begin
      url = "https://www.googleapis.com/youtube/v3/videos?id=#{ code }&part=snippet,statistics,contentDetails&fields=items(id,snippet,statistics,contentDetails)&key=#{ ENV['YOUTUBE_APIKEY']}"
      # p url
      response = HTTParty.get(url, verify: false)
      JSON.parse(response.body)
    rescue => e
      Rails.logger e.message
    end
  end
end