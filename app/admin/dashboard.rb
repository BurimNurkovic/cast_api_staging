ActiveAdmin.register_page 'Dashboard' do

  menu priority: 1, label: proc{ I18n.t('active_admin.dashboard') }

  content title: proc{ I18n.t('active_admin.dashboard') } do
    div class: 'blank_slate_container', id: 'chart_container' do
      columns do
        column
        column
      end
    end
  end
end
