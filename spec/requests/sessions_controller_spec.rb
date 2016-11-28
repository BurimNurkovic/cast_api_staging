require 'spec_helper'

describe Api::V1::SessionsController, vcr: true do
  describe 'POST /api/v1/sessions' do
    context 'when user logs in by email' do
      # let!(:user) { FactoryGirl.create(:user, email: 'user@example.com') }
      let!(:old_token) { user.auth_token }

      let(:user_params) {{ 'email' => 'user@example.com', 'password' => 'test' }}

      context 'with valid data' do
        before do
          # expect(User).to receive(:random_token).and_return('11ba0dcf83ddded3f8719cc4cde484c9')
          post '/api/v1/sessions', user_params
        end

        # let(:expectation) {
        #   { 'user' =>
        #         { 'id' => user.id,
        #           'email' => 'user@example.com',
        #           'first_name' => 'Sarah',
        #           'last_name' => 'Johns',
        #           'age' => '18-24',
        #           'hair_type' => 'straight',
        #           'skin_type' => 'normal',
        #           'latitude' => 37.8267,
        #           'longitude' => -122.423,
        #           'auth_token' => '11ba0dcf83ddded3f8719cc4cde484c9',
        #           'installation_id' => nil,
        #           'facebook_id' => nil,
        #           'amazon_id' => nil
        #         }
        #   }
        # }

        # it { expect(response).to be_success }
        # it { expect(result(response)).to match(expectation) }
        # it { expect(result(response)['auth_token']).to_not eq(old_token) }
      end

      context 'with invalid data' do
        before { post '/api/v1/sessions', user_params.merge('email' => 'wrong_email') }

        let(:expectation) {{ 'errors' => { 'session' => ['Your email/password pair is incorrect'] } }}

        # it { expect(response.code).to eq('401') }
        # it { expect(result(response)).to match(expectation) }
      end
    end

    context 'when user logs in by facebook' do
      let!(:user) { FactoryGirl.create(:facebook_user) }
      let!(:old_token) { user.auth_token }

      let(:user_params) {{ 'facebook_id' => '100004866240221', 'facebook_session' => 'CAACEdEose0cBAJSb8gOYzXZAiYgtmfTLWWztFDJnvd59POTVmZCZA4ZC52DIZBo85HjJHZAGIyZBIzpTEXSUyu1DfKJ0kfF43RGV7oZBxhp9QciJtOg4rOkcwDet4b67gAV6tbOyWrUZA5OP3sA8UzsGJqGfk3Soq4DIX46eScyaptNgUcg5mevVOUDdIiQ5dOKOzAohj42DnLD6xDhJUkXSCyuQgQYRZAmpoZD' }}

      context 'with valid data' do
        before do
          # expect(User).to receive(:random_token).and_return('11ba0dcf83ddded3f8719cc4cde484c9')
          post '/api/v1/sessions', user_params
        end

        let(:expectation) {
          { 'user' =>
                { 'id' => user.id,
                  'email' => 'test@mail.com',
                  'first_name' => 'Sarah',
                  'last_name' => 'Johns',
                  'age' => '18-24',
                  'hair_type' => 'straight',
                  'skin_type' => 'normal',
                  'latitude' => 37.8267,
                  'longitude' => -122.423,
                  'auth_token' => '11ba0dcf83ddded3f8719cc4cde484c9',
                  'installation_id' => nil,
                  'facebook_id' => '100004866240221',
                  'amazon_id' => nil
                }
          }
        }

        # it { expect(response).to be_success }
        # it { expect(result(response)).to match(expectation) }
        # it { expect(result(response)['auth_token']).to_not eq(old_token) }
      end

      context 'with invalid facebook_id' do
        before { post '/api/v1/sessions', user_params.merge('facebook_id' => 'fail') }

        let(:expectation) {{ 'errors' => { 'facebook_auth' => ['Your facebook_id/facebook_session pair is incorrect'] } }}

        # it { expect(response.code).to eq('401') }
        # it { expect(result(response)).to match(expectation) }
      end

      context 'with invalid facebook_session' do
        before { post '/api/v1/sessions', user_params.merge('facebook_session' => 'fail') }

        let(:expectation) {{ 'errors' => { 'oauth' => 'Invalid OAuth access token.' } }}

        # it { expect(response.code).to eq('401') }
        # it { expect(result(response)).to match(expectation) }
      end
    end

    context 'when user logs in by amazon' do
      let!(:user) { FactoryGirl.create(:amazon_user) }
      let!(:old_token) { user.auth_token }

      let(:user_params) {{ 'amazon_id' => 'amzn1.account.AEM6TWKKDA6W5E6QFXRC7FAWPOOA', 'amazon_session' => 'Atza|IQEBLjAsAhQYc5IPoacnUZnEO_nKYq3LgQ-pSgIUX6D534_QiXFUdmqVdCnbad7trW0w6712uh3aN7A7hop98MOOtH1hT9ZxD-JSQ7PEHEGxx6WmrCe2ptl0MV9yYWBcgqpQegCIaIvDNEAnAqK-xpJ4PK1VFf7qoJaeBqwuuFd3dslzscSKhEZl0qtFoEm7OLURKDu7rOLvLx4q4FXEdeZbFxrKykz3Dht2MGXnOF5h2y1wdCRF8ux9mNVmoE-MMcQzbiDYMEm_XjP3sJTLOooAQnHOD9qCfwRNkwWlVbAGDcnlDmPUxNPTm1eiz7HRkJ7p2ZAPLIQwqo2BnttcbmvchSvXCQvWQvNGfOTOJO2bzWo' }}

      context 'with valid data' do
        before do
          # expect(User).to receive(:random_token).and_return('11ba0dcf83ddded3f8719cc4cde484c9')
          post '/api/v1/sessions', user_params
        end

        let(:expectation) {
          { 'user' =>
                { 'id' => user.id,
                  'email' => 'test@mail.com',
                  'first_name' => 'Sarah',
                  'last_name' => 'Johns',
                  'age' => '18-24',
                  'hair_type' => 'straight',
                  'skin_type' => 'normal',
                  'latitude' => 37.8267,
                  'longitude' => -122.423,
                  'auth_token' => '11ba0dcf83ddded3f8719cc4cde484c9',
                  'installation_id' => nil,
                  'amazon_id' => 'amzn1.account.AEM6TWKKDA6W5E6QFXRC7FAWPOOA',
                  'facebook_id' => nil
                }
          }
        }

        # it { expect(response).to be_success }
        # it { expect(result(response)).to match(expectation) }
        # it { expect(result(response)['auth_token']).to_not eq(old_token) }
      end

      context 'with invalid amazon_id' do
        before { post '/api/v1/sessions', user_params.merge('amazon_id' => 'fail') }

        let(:expectation) {{ 'errors' => { 'amazon_auth' => ['Your amazon_id/amazon_session pair is incorrect'] } }}

        # it { expect(response.code).to eq('401') }
        # it { expect(result(response)).to match(expectation) }
      end

      context 'with invalid amazon_session' do
        before { post '/api/v1/sessions', user_params.merge('amazon_session' => 'fail') }

        let(:expectation) {{ 'errors' => { 'oauth' => 'The request has an invalid parameter : access_token' } }}

        # it { expect(response.code).to eq('401') }
        # it { expect(result(response)).to match(expectation) }
      end
    end
  end

  def result(response)
    JSON.parse(response.body)
  end
end
