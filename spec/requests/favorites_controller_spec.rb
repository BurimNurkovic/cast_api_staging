require 'spec_helper'

vcr_options = {
  match_requests_on: [VCR.request_matchers.uri_without_param(:Timestamp,:Signature)],
  # record: :new_episodes
}

describe Api::V1::FavoritesController do
  context 'when user logs in by email' do
    let!(:user) { FactoryGirl.create(:amazon_user) }

    context 'when adds favorites', vcr: vcr_options do
      before do
        Favorite.set_callback(:create, :before, :update_advert_info)
        post '/api/v1/favorites', { amazon_ids: %w(B0173TK56O), auth_token: user.auth_token }
      end

      it 'returns a filled object' do
        expect(response).to be_success
        favorite = result(response)['favorites'][0]
        expect(favorite['amazon_id']).to be_eql('B0173TK56O')
        expect(favorite['advert_title']).to be_eql('Pantene Pro-V Smooth and Sleek Conditioner 32 fl oz (Pack of 4)')
        expect(favorite['advert_image_url']).to be_eql('http://ecx.images-amazon.com/images/I/41xqQ89lofL.jpg')
        expect(favorite['advert_vendor']).to be_eql('Pantene')
        expect(favorite['advert_price_formatted']).to be_eql('$38.81')

      end

    end

    context 'with data' do
      before do
        %w(fav1 fav2 fav3).each do |amazon_id|
          FactoryGirl.create(:favorite, amazon_id: amazon_id, user: user)
        end
      end

      context 'when gets favorites' do
        before { get 'api/v1/favorites', { auth_token: user.auth_token } }

        it { expect(response).to be_success }
        it { expect(result(response)['amazon_ids'].sort).to match(%w(fav1 fav2 fav3))}
        it { expect(result(response)['favorites'][0].keys).to match_array(Favorite::PUBLIC_ATTRIBUTES)}
      end

      context 'when deletes favorites' do
        before { delete '/api/v1/favorites/delete_collection', { amazon_ids: %w(fav1 fav3), auth_token: user.auth_token } }

        it { expect(response).to be_success }
        it { expect(result(response)['amazon_ids'].sort).to match(%w(fav2)) }

        it do
          get 'api/v1/favorites', { auth_token: user.auth_token }
          expect(response).to be_success
          expect(result(response)['amazon_ids'].sort).to match(%w(fav2))
        end
      end

    end

    describe 'errors responses' do

      context 'without user' do
        before do
          Favorite.set_callback(:create, :before, :update_advert_info)
          post '/api/v1/favorites', { amazon_ids: %w(B0173TK56O), auth_token: nil }
        end

        it 'rejects the request' do
          expect(response).to_not be_success
          expect(response.status).to eq 401
        end
      end

      context 'with duplicated amazon_id' do
        before do
          FactoryGirl.create(:favorite, amazon_id: 'fav1', user: user)
        end

        it 'receives an error' do
          post '/api/v1/favorites', { amazon_ids: %w(fav1), auth_token: user.auth_token }
          expect(response).to_not be_success
          expect(response.status).to eq 422
        end
      end

    end

  end

  def result(response)
    JSON.parse(response.body)
  end
end
