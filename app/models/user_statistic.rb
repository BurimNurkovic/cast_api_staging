class UserStatistic
  def self.grouped_by_attributes
    results = {}
    %w(age hair_type skin_type postal_town).each do |user_attribute|
      responses = User.where.not(user_attribute.to_sym => nil).group(user_attribute).reorder(user_attribute).distinct.count
      responses = responses.map {|key, value| { question: key, users_count: value } }.sort_by { |hsh| hsh[:users_count] }
      results[user_attribute] = responses
    end
    results
  end
end
