require 'spec_helper'

vcr_options = {
  match_requests_on: [VCR.request_matchers.uri_without_param(:Timestamp,:Signature,:SignatureMethod,:SignatureVersion,:Version)],
  cassette_name: 'AmazonEcommerce/AmazonProductSearch/new_method',
  # record: :new_episodes
}

describe AmazonEcommerce::AmazonProductSearch, vcr: vcr_options do
  cassette_name = 'AmazonEcommerce/AmazonProductSearch/search'
  describe '#search' do
    context 'with results', vcr: vcr_options.merge(cassette_name: cassette_name + '/with_results' ) do
      let(:search_products) { AmazonEcommerce::AmazonProductSearch.new(search_index: 'Beauty').search(keywords: 'curly hair', current_page: 1) }
      describe 'response_attributes' do

        it { expect(search_products.keys).to match_array([:products, :current_page, :total_pages, :total_results]) }
        describe 'current_page' do
          it { expect(search_products[:current_page]).to be_eql '1' }
        end
        describe 'total_pages' do
          it { expect(search_products[:total_pages]).to be_eql '5916' }
        end

        describe 'products' do
          let(:products) { search_products[:products] }
          it { expect(products).to be_a Array }
          it { expect(products).to have(10).items }

          describe 'attributes' do
            let(:product) { products[0] }
            let(:product_data) {
              {
                id:              'B00KSPUN04',
                price:           '$19.99',
                title:           'Ultra Curl Defining Cream with Argan Oil By Arvazallia for Wavy and Curly Hair',
                manufacturer:    'Arvazallia',
                image_full_url:  'http://ecx.images-amazon.com/images/I/41jrE9RWaUL.jpg',
                image_thumb_url: 'http://ecx.images-amazon.com/images/I/41jrE9RWaUL._SL75_.jpg',
              }
            }

            it { expect(product).to be_a Hash }
            it { expect(product.keys).to match_array(product_data.keys) }

            it 'has product data' do
              product_data.each do |key, value|
                expect(product.try(:[], key)).to be_eql value
              end
            end
          end
        end
      end
    end

    context 'without results', vcr: vcr_options.merge(cassette_name: cassette_name + '/without_results') do
      let(:search_products) {
        AmazonEcommerce::AmazonProductSearch.new(search_index: 'Beauty').search(keywords: 's9df0s98fs9dfs', current_page: 1)
      }

      describe 'response_attributes' do
        it { expect(search_products.keys).to match_array([:error]) }

        describe 'error response' do
          it { expect(search_products[:error]).to be_a Array }
          it { expect(search_products[:error]).to match_array(['True', 'We did not find any matches for your request.']) }
        end
      end
    end

    context 'with errors', vcr: vcr_options.merge(cassette_name: cassette_name + '/with_errors') do
      let(:search_products) {
        AmazonEcommerce::AmazonProductSearch.new(search_index: 'Beauty').search(keywords: 'curly hair', current_page: 11)
      }

      describe 'response_attributes' do
        it { expect(search_products.keys).to match_array([:error]) }

        describe 'error response' do
          it { expect(search_products[:error]).to be_a Array }
          it { expect(search_products[:error]).to match_array(['False', 'The value you specified for ItemPage is invalid.  Valid values must be between 1 and 10.']) }
        end
      end

    end

    context 'with exceptions', vcr: vcr_options.merge(cassette_name: cassette_name + '/with_exceptions') do
      let(:search_products) {
        AmazonEcommerce::AmazonProductSearch.new(search_index: 'Beauty').search(keywords: 'windy dry curly hair', current_page: 1)
      }

      describe 'response_attributes' do
        it { expect(search_products.keys).to match_array([:error]) }

        describe 'error response' do
          it { expect(search_products[:error]).to be_a Array }
          it { expect(search_products[:error]).to match_array(['False', 'Expected(200) <=> Actual(503 Service Unavailable)']) }
        end
      end
    end
  end
end
