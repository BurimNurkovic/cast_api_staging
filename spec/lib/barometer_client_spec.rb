require 'spec_helper'

describe BarometerClient, vcr: { cassette_name: 'BarometerClient/get_weather' } do
  describe '#get_weather' do
    let!(:user) { FactoryGirl.create(:amazon_user) }

    subject { BarometerClient.get_weather(latitude: user.latitude, longitude: user.longitude) }
    let(:expectation) { BarometerClient::CurrentWeather.new('14', 77.0) }

    it { expect(subject.temperature).to eql(expectation.temperature) }
    it { expect(subject.temperature).to eql(57) }
    it { expect(subject.humidity).to eql(expectation.humidity) }
    it { expect(subject.humidity).to eql(77) }
  end
end
