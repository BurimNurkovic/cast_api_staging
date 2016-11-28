require 'spec_helper'

vcr_options = {
  match_requests_on: [VCR.request_matchers.uri_without_param(:Timestamp,:Signature,:SignatureMethod,:SignatureVersion,:Version,:Keywords)],
  # record: :new_episodes
}

describe Api::V1::ProductsController do
  describe 'list products' do
    let!(:user) { FactoryGirl.create(:amazon_user) }
    cassette_name = 'Api_V1_ProductsController/list_products/with_results'

    context 'with results', vcr: vcr_options.merge(cassette_name: cassette_name) do

      before do
        allow_any_instance_of(Api::V1::ProductsController).to receive(:create_hair_keyword_array).and_return(%w(frizz polish))
        allow_any_instance_of(Api::V1::ProductsController).to receive(:create_skin_keyword_array).and_return(%w(Humidity shine))

        get '/api/v1/products', { link: '/q/zmw:00000.1.83779', hair_item_page: 1, skin_item_page: 1, auth_token: user.auth_token }
      end

      it { expect(response).to be_success }

      describe 'returned object' do
        let(:result_json) { result(response) }
        it { expect(result_json.keys).to match_array(%w(hair skin)) }

        %w(hair skin).each do |search_attr|
          let(:search_json) { result_json[search_attr] }

          it "has current_page total_pages and products nodes at #{search_attr} node" do
            expect(search_json.keys).to match_array(%w(current_page total_pages total_results products))
            expect(search_json['current_page']).to be_eql('1')
            expect(search_json['total_pages'].to_i).to be > 0
          end

          describe "products at #{search_attr} node" do
            it { expect(search_json['products']).to be_a Array }
            it { expect(search_json['products'].size).to be > 0 }

            it { expect(search_json['products'][0].keys).to match_array(%w(id manufacturer title image_full_url image_thumb_url price)) }

            %w(id manufacturer title image_full_url image_thumb_url price).each do |product_attr|
              describe "#{product_attr} attr" do
                it { expect(search_json['products'][0][product_attr]).not_to be_blank }
              end
            end
          end
        end
      end

    end

    cassette_name = 'Api_V1_ProductsController/list_products/without_results'

    context 'without results', vcr: vcr_options.merge(cassette_name: cassette_name) do
      before do
        allow_any_instance_of(Api::V1::ProductsController).to receive(:create_hair_keyword_array).and_return([''])
        allow_any_instance_of(Api::V1::ProductsController).to receive(:create_skin_keyword_array).and_return([''])

        user.update_columns(skin_type: 'TdYByoIALL', hair_type: 'Y4awtFSQtV')

        get '/api/v1/products', { link: '/q/zmw:00000.1.83779', hair_item_page: 1, skin_item_page: 1, auth_token: user.auth_token }
      end

      it { expect(response).to be_success }

      describe 'returned object' do
        let(:result_json) { result(response) }
        it { expect(result_json.keys).to match_array(%w(hair skin)) }

        %w(hair skin).each do |search_attr|
          let(:search_json) { result_json[search_attr] }

          it "has errors at #{search_attr} node" do
            expect(search_json.keys).to match_array(%w(error))
            expect(search_json['error']).to match_array(["True", "We did not find any matches for your request."])
          end

          describe "products at #{search_attr} node" do
            it { expect(search_json['products']).to be_nil }
          end
        end
      end
    end

  end

  def result(response)
    JSON.parse(response.body)
  end
end
