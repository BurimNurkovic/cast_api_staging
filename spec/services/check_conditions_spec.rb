#require 'spec_helper'
#
#describe CheckConditions, vcr: true do
#  describe '#call' do
#    let!(:user) { FactoryGirl.create(:user) }
#
#    before do
#      correct_params = { skin_type: 'normal', time_of_a_day: '9am', minimum_temperature: 60, maximum_temperature: 80,
#                         minimum_humidity: 60, maximum_humidity: 70, note: 'correct selection' }
#      PushCondition.create(correct_params)
#      PushCondition.create(correct_params.dup.update(time_of_a_day: '9am', note: 'wrong selection'))
#      PushCondition.create(correct_params.dup.update(minimum_temperature: 80, maximum_temperature: 100, note: 'wrong selection'))
#      PushCondition.create(correct_params.dup.update(minimum_humidity: 30, maximum_humidity: 40, note: 'wrong selection'))
#    end
#
#    it do
#      expect(ParseClient).to receive(:send_push_to_user).with(recipient_id: user.id, alert: 'correct selection')
#      CheckConditions.call(user: User.first, time_of_a_day: '9am')
#    end
#  end
#end
