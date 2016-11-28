ActiveAdmin.register Response do
  menu parent: 'Profile'
  permit_params :user_id, :question_id, :answer_id, :order_by
  filter :user
  filter :question
  filter :answer

  index do
    selectable_column
    id_column
    column :user
    column :question
    column :answer
    column :order_by
  end

  csv do
    column :id
    column(:user) { |response| response.try(:user).try(:full_name) }
    column(:question) { |response| response.try(:question).try(:text) }
    column(:answer) { |response| response.try(:answer).try(:text) }
  end
end
