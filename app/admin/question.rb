ActiveAdmin.register Question do
  menu parent: 'Profile'

  permit_params :text, :question_type, :limit, :order_by, answers_attributes: [ :id, :text, :order_by, :_destroy ]

  filter :question_type, as: :select, collection: Question.question_types
  filter :text

  form do |f|
    f.inputs nil, multipart: true do
      f.input :text
      f.input :question_type, as: :select, collection: Question.question_types.map { |s| [s[0].humanize, s[0]] }
      f.input :order_by
    end
    f.inputs do
      f.has_many :answers, heading: 'Answers', allow_destroy: true do |a|
        a.input :text
        a.input :order_by
      end
    end
    f.actions
  end

end
