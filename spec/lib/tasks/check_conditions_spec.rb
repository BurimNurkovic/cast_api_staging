require 'spec_helper'
require 'rake'

vcr_options = {
  cassette_name: 'CheckConditions/google_geo_timezone',
  match_requests_on: [VCR.request_matchers.uri_without_param(:timestamp)]
}

CastApi::Application.load_tasks

describe :check_conditions, vcr: vcr_options do
  before {
    Delayed::Worker.delay_jobs = false
    allow(CheckConditions).to receive(:call)
  }
  let!(:users) { FactoryGirl.create_list(:amazon_user, 3) }

  it do
    User.find_each do |user|
      expect(CheckConditions).to receive(:call).with(user: user, time_of_a_day: '9am', type: :skin).once
      expect(CheckConditions).to receive(:call).with(user: user, time_of_a_day: '9am', type: :hair).once
      expect(CheckConditions).to receive(:call).with(user: user, time_of_a_day: '12pm', type: :skin).once
      expect(CheckConditions).to receive(:call).with(user: user, time_of_a_day: '12pm', type: :hair).once
    end
    Rake::Task['check_conditions'].invoke
  end
end
