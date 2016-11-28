require 'spec_helper'

vcr_options = {
  match_requests_on: [VCR.request_matchers.uri_without_param(:Timestamp,:Signature)],
  # record: :new_episodes
}

RSpec.describe Favorite, type: :model do
  subject(:favorite) { FactoryGirl.build(:favorite) }

  context 'validations and relationships' do
    it { should validate_presence_of(:amazon_id) }
    it { should validate_presence_of(:user_id) }
    it { should belong_to(:user) }

    it 'validates uniqueness of amazon_id' do
      FactoryGirl.create(:favorite, amazon_id: 'fav1')
      favorite = FactoryGirl.build(:favorite, amazon_id: 'fav1')
      expect { favorite.save }.not_to change{ Favorite.count }
      expect(favorite.errors.messages).to include(:amazon_id => ["has already been taken"])
    end

  end

  describe '#update_advert_info', vcr: vcr_options do
    context 'with availablity' do
      before do
        favorite.amazon_id = 'B0173TK56O'
        favorite.update_advert_info
      end
      it 'fill the object with data' do
        expect(favorite.advert_title).to include('Pantene Pro-V Smooth and')
        expect(favorite.advert_vendor).to eq('Pantene')
        expect(favorite.advert_image_url).to eq('http://ecx.images-amazon.com/images/I/41xqQ89lofL.jpg')
        expect(favorite.advert_price_amount).to eq(3881)
        expect(favorite.advert_price_currency).to eq('USD')
        expect(favorite.advert_price_formatted).to eq('$38.81')
      end
    end

    context 'without availablity' do
      before do
        favorite.amazon_id = 'B001THQ4FI'
        favorite.update_advert_info
      end
      it 'fill the object with data' do
        expect(favorite.advert_title).to eq('Steven Victor Md Miracle Instant Corrective Serum, 0.5-Ounce')
        expect(favorite.advert_vendor).to eq("Steven Victor MD")
        expect(favorite.advert_image_url).to eq('http://ecx.images-amazon.com/images/I/31H9gS6GYJL.jpg')
        expect(favorite.advert_price_amount).to be_nil
        expect(favorite.advert_price_currency).to be_nil
        expect(favorite.advert_price_formatted).to be_nil
      end
    end

    context 'not available' do
      before do
        favorite.amazon_id = 'B008MAGW3Y'
        favorite.update_advert_info
      end
      it 'fill the object with data' do
        expect(favorite.advert_title).to include('Curly Magic Curl Stimulator, 18 oz')
        expect(favorite.advert_price_amount).to be_nil
      end
    end

    context 'with long values' do
      before do
        favorite.amazon_id = 'B00L1KFQKC'
        favorite.update_advert_info
      end
      it 'will be valid' do
        expect(favorite.save).to be_truthy
        expect(favorite).to be_valid
      end
    end
  end

  describe '#public_attributes' do
    it 'returns public attributes' do
      expect(favorite.public_attributes.keys).to include(*['id', 'amazon_id', 'advert_title', 'advert_vendor', 'advert_image_url', 'advert_price_formatted'])
    end

    it 'do not return private attributes' do
      expect(favorite.public_attributes.keys).not_to include(*['advert_price_currency', 'advert_price_currency', 'user_id', 'created_at', 'updated_at', 'user_id'])
    end
  end

end
