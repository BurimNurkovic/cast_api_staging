namespace :user do
  desc 'Update postal town and country for all users'
  task update_address: :environment do
    User.all.each do |user|
      user.set_address
      user.save(validate: false)
      sleep(1)
    end
  end

end
