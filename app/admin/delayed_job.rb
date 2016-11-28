ActiveAdmin.register Delayed::Job do
  menu parent: 'System', label: 'Delayed Job'

  controller do
    actions :all, :except => [:updated, :create, :new, :edit]
  end

  index do
    selectable_column
    id_column
    column :priority
    column :attempts
    column(:error) {|job| job.last_error.try(:match, /.*\n/) }
    column(:handler) do |job|
      job.handler.try(:match, /object: !.*/).to_s.gsub('object: !ruby/','') + ' ' +
      job.handler.try(:match, /method_name: :.*/).to_s.gsub('method_name: :','')
    end
    column :run_at
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :priority
      row :attempts
      row :run_at
      row :failed_at
      row :time_of_a_day
      row :queue
      row(:handler) {|job| simple_format job.handler }
      row(:last_error) {|job| simple_format job.last_error }
      row :created_at
      row :updated_at
      row :locked_at
    end
  end
end
