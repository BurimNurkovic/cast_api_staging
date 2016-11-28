require 'spec_helper'

vcr_options = {
  match_requests_on: [VCR.request_matchers.uri_without_param(:Timestamp,:Signature,:SignatureMethod,:SignatureVersion,:Version)],
  cassette_name: 'AmazonEcommerce/AmazonProductSearch/new_method',
  # record: :new_episodes
}

describe CastProductSearch, vcr: vcr_options do
  cassette_name = 'AmazonEcommerce/AmazonProductSearch/search'
  describe '#search' do
    context 'with results', vcr: vcr_options.merge(cassette_name: cassette_name + '/with_results' ) do

      context 'for hair' do
        let(:search_products) { CastProductSearch.new.search(keywords: 'curly hair', search_type: 'hair') }

        describe 'response_attributes' do
          describe 'hair attribute' do
            describe 'total_pages' do
              it { expect(search_products[:total_pages]).to be_eql '5916' }
            end

            describe 'products' do
              let(:products) { search_products[:products] }
              it { expect(products).to be_a Array }
              it { expect(products).to have(6).items }
            end
          end
        end
      end

      context 'for skin' do
        let(:search_products) { CastProductSearch.new.search(keywords: 'oily skin') }

        describe 'response_attributes' do
          describe 'skin attribute' do
            describe 'total_pages' do
              it { expect(search_products[:total_pages]).to be_eql '3102' }
            end

            describe 'products' do
              let(:products) { search_products[:products] }
              it { expect(products).to be_a Array }
              it { expect(products).to have(10).items }
            end
          end
        end
      end
    end

    context 'without results', vcr: vcr_options.merge(cassette_name: cassette_name + '/without_results') do
      let(:search_products) { CastProductSearch.new.search(keywords: 's9df0s98fs9dfs', search_type: 'hair') }

      describe 'response_attributes' do
        it { expect(search_products.keys).to match_array([:error]) }

        describe 'error response' do
          it { expect(search_products[:error]).to be_a Array }
          it { expect(search_products[:error]).to match_array(['True', 'We did not find any matches for your request.']) }
        end
      end
    end

    context 'with errors', vcr: vcr_options.merge(cassette_name: cassette_name + '/with_errors') do

      let(:search_products) { CastProductSearch.new.search(keywords: 'curly hair', search_type: 'hair', current_page: 11) }

      describe 'response_attributes' do
        it { expect(search_products.keys).to match_array([:error]) }

        describe 'error response' do
          it { expect(search_products[:error]).to be_a Array }
          it { expect(search_products[:error]).to match_array(['False', 'The value you specified for ItemPage is invalid.  Valid values must be between 1 and 10.']) }
        end
      end

    end
  end
end
