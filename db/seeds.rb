# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# text = '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. In ac mauris felis.</p>
# <p>Maecenas bibendum magna et luctus iaculis. Nam metus felis, accumsan sit amet finibus sit amet, malesuada et erat. Mauris in purus at mauris vestibulum semper. Vivamus quis risus finibus, malesuada ante non, lobortis lacus. Nunc eu felis fringilla, interdum metus vel, dapibus nisl.</p>
# <p>Morbi suscipit turpis erat, vel efficitur augue laoreet nec.</p>'
#
# (1..50).each do |n|
#   b = Blogentry.published.text.create({
#     title: "Blogentry_#{ n }",
#     text: text,
#     image: File.new('app/assets/images/technology_small.jpg')
#   })
# end
# Response.delete_all
# Answer.delete_all
# Question.delete_all
# ActiveRecord::Base.connection.reset_pk_sequence!('responses')
# ActiveRecord::Base.connection.reset_pk_sequence!('answers')
# ActiveRecord::Base.connection.reset_pk_sequence!('questions')

q = Question.find_or_create_by({ text: 'Age Group' })
q.update_attributes({ order_by: 0, limit: 1 })
q.select_multi!

a = Answer.find_or_create_by({ question: q, text: 'Under 18' })
a.update_attributes({ order_by: 0 })
a = Answer.find_or_create_by({ question: q, text: '19 – 29' })
a.update_attributes({ order_by: 1 })
a = Answer.find_or_create_by({ question: q, text: '30 – 39' })
a.update_attributes({ order_by: 2 })
a = Answer.find_or_create_by({ question: q, text: '40 – 49' })
a.update_attributes({ order_by: 3 })
a = Answer.find_or_create_by({ question: q, text: '50 – 59' })
a.update_attributes({ order_by: 4 })
a = Answer.find_or_create_by({ question: q, text: '60+' })
a.update_attributes({ order_by: 5 })

q = Question.find_or_create_by({ text: 'How many skin care products do you use daily?' })
q.update_attributes({ order_by: 1, limit: 1 })
q.select_multi!

a = Answer.find_or_create_by({ question: q, text: '1' })
a.update_attributes({ order_by: 0 })
a = Answer.find_or_create_by({ question: q, text: '2-3' })
a.update_attributes({ order_by: 1 })
a = Answer.find_or_create_by({ question: q, text: '4-5' })
a.update_attributes({ order_by: 2 })
a = Answer.find_or_create_by({ question: q, text: '6+' })
a.update_attributes({ order_by: 3 })

q = Question.find_or_create_by({ text: 'How many hair care products do you use daily?' })
q.update_attributes({ order_by: 2, limit: 1 })
q.select_multi!

a = Answer.find_or_create_by({ question: q, text: '1' })
a.update_attributes({ order_by: 0 })
a = Answer.find_or_create_by({ question: q, text: '2-3' })
a.update_attributes({ order_by: 1 })
a = Answer.find_or_create_by({ question: q, text: '4-5' })
a.update_attributes({ order_by: 2 })
a = Answer.find_or_create_by({ question: q, text: '6+' })
a.update_attributes({ order_by: 3 })

q = Question.find_or_create_by({ text: 'What are your major skin concerns?' })
q.update_attributes({ order_by: 3, limit: 3 })
q.select_ordered!

a = Answer.find_or_create_by({ question: q, text: 'Acne' })
a.update_attributes({ order_by: 0 })
a = Answer.find_or_create_by({ question: q, text: 'Uneven skin/spots' })
a.update_attributes({ order_by: 1 })
a = Answer.find_or_create_by({ question: q, text: 'Dryness' })
a.update_attributes({ order_by: 2 })
a = Answer.find_or_create_by({ question: q, text: 'Eye' })
a.update_attributes({ order_by: 3 })
a = Answer.find_or_create_by({ question: q, text: 'Firm/lift' })
a.update_attributes({ order_by: 4 })
a = Answer.find_or_create_by({ question: q, text: 'Lines/wrinkles' })
a.update_attributes({ order_by: 5 })
a = Answer.find_or_create_by({ question: q, text: 'Pores' })
a.update_attributes({ order_by: 6 })
a = Answer.find_or_create_by({ question: q, text: 'Sensitivity' })
a.update_attributes({ order_by: 7 })
a = Answer.find_or_create_by({ question: q, text: 'Sun protection' })
a.update_attributes({ order_by: 8 })

q = Question.find_or_create_by({ text: 'What are you favorite skin care brands?' })
q.update_attributes({ order_by: 4, limit: 0 })
q.select_multi!

q = Question.find_or_create_by({ text: 'What are you favorite hair care brands?' })
q.update_attributes({ order_by: 5, limit: 0 })
q.select_multi!

#Dummy reporting data
user = User.find_by({ email: 'leighton0102@gmail.com' })

Question.all.each do |q|
  q.answers.each do |a|
    rand(10..50).times do |n|
      Response.create(user: user, question: q, answer: a)
    end
  end
end