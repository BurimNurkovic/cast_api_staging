require 'spec_helper'

vcr_options = {
  match_requests_on: [VCR.request_matchers.uri_without_param(:Timestamp,:Signature,:SignatureMethod,:SignatureVersion,:Version)],
  cassette_name: 'CastProductSearchService/new_method',
  # record: :new_episodes
}

describe CastProductSearchService, vcr: vcr_options do
  cassette_name = 'CastProductSearchService/call'
  describe '#call', vcr: vcr_options.merge(cassette_name: cassette_name) do
    let(:user) { FactoryGirl.create(:amazon_user) }


    context 'with first level results', vcr: vcr_options.merge(cassette_name: cassette_name + '/with_first_level_results' ) do

      let(:service) {
        CastProductSearchService.call(
          user: user, hair_item_page: 1, skin_item_page: 1,
          hair_keywords: %w(windy dry), skin_keywords: %w(dry Hydrat))
      }

      it { expect(service).to be_a Hash }
      it { expect(service.keys).to match_array([:hair, :skin]) }
    end

    context 'with second level results', vcr: vcr_options.merge(cassette_name: cassette_name + '/with_first_level_results' ) do

      let(:service) {
        CastProductSearchService.call(
          user: user, hair_item_page: 1, skin_item_page: 1,
          hair_keywords: %w(windy dry), skin_keywords: %w(dry Hydrat))
      }

      it { expect(service).to be_a Hash }
      it { expect(service.keys).to match_array([:hair, :skin]) }
    end

  end
end
