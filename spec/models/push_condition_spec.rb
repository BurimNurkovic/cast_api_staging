# == Schema Information
#
# Table name: push_conditions
#
#  id                  :integer          not null, primary key
#  skin_type           :string(255)
#  hair_type           :string(255)
#  minimum_temperature :integer
#  maximum_temperature :integer
#  minimum_humidity    :integer
#  maximum_humidity    :integer
#  time_of_a_day       :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  amazon_tags         :string(255)
#  type                :string(255)
#

require 'spec_helper'

describe PushCondition do
  describe '#unique_message' do
    let(:user) { FactoryGirl.create(:amazon_user) }
    let(:push_condition) { FactoryGirl.create(:push_condition) }

    around(:example) do |example|
      expect(Delayed::Job.count).to eq(0)
      example.run
      expect(Delayed::Job.count).to eq(0)
    end

    before do
      push_condition.push_texts.create([{ text: 'first note' }, { text: 'second note' }])
      expect_any_instance_of(PushText).to receive_message_chain("delay.delete_user") { true }
      @push_messages = 3.times.map { push_condition.send :unique_message, user }
    end

    it { expect(@push_messages).to match_array ['first note', 'second note', nil] }
  end
end
