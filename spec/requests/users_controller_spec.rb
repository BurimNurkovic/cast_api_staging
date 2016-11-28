require 'spec_helper'

describe Api::V1::UsersController, vcr: true do
  describe 'POST /api/v1/users' do
    context 'when registers by email' do
      let(:user_params) {
        { 'email' => 'user@example.com',
          'password' => 'test',
          'first_name' => 'John',
          'last_name' => 'Doe',
          'age' => '18-24',
          'hair_type' => 'straight',
          'skin_type' => 'normal',
          'latitude' => 123.25,
          'longitude' => -45.55,
          'installation_id' => 'some_id_1234',
          'amazon_id' => 'amzn1.account.AGCWGSWZA4E5XYQGFUEYNWIQ5LDQ',
          'amazon_session' => 'Atza|IQEBLjAsAhRDnEysxZ1o_T78T-NNOhakFAeLJgIUFM3-0w07wNy9dM41cCE2CUNc6iIwenJ2FbFdMolgVZmNGiPQ3O0uBvhAhjBoh_kzR_87oZLu2Ibjj-yL-pGjHCuBSr3ev9IiRVzeAUOiFpKDK-Tnqi88jgtyDtxAcmwNroIB4rEksaIEWbaay1hN11U4mszmaAdBcl2wt3BEhZ6suniEnPJNIHz9XNYqbRuWpY82olmS1p5Ls4iQQwakGCz1SV0EeUbxM2A7WNyD-PkoFF5cPF09HLzQVtuDDWWuto-HgwGh2xyKg6-8qNw_NwyEVuhAa_R6BsEDp3CZm_XixGVcY5AxcovF3TKNiXTx2102PKU'
        }
      }

      context 'with valid attributes' do
        before do
          # expect(SecureRandom).to receive(:hex).and_return('DQDqhIHyNYOgVtUs2X8P1Q')
          # post '/api/v1/users', user_params
        end

        let(:expectation) {{ 'user' => user_params.except('password').merge('auth_token' => 'DQDqhIHyNYOgVtUs2X8P1Q',
                                                                            'id' => User.last.id, 'facebook_id' => nil,
                                                                            'amazon_id' => nil) }}

        # it { expect(response).to be_success }
        # it { expect(result(response)).to match(expectation) }

        it 'rejects taken emails' do
          # post '/api/v1/users', user_params
          # expect(result(response)['errors']['email']).to match(['has already been taken'])
        end

        it 'uploads avatar' do
          # avatar = Base64.encode64(File.open('spec/fixtures/sample.png').read)
          # user = User.find_by_amazon_id(user_params['amazon_id'])
          # put "/api/v1/users/#{user.id}", {'auth_token' => 'DQDqhIHyNYOgVtUs2X8P1Q', avatar: avatar, filename: 'sample.png', content_type: 'image/png'}
          # expect(response).to be_success
          # user.reload
          # expect(user.avatar_file_name).to eq('sample.png')
          # expect(user.avatar_file_size).to eq(File.open('spec/fixtures/sample.png').size)
          # expect(user.avatar_content_type).to eq('image/png')
        end
      end

      context 'with invalid attributes' do
        context 'with multiple invalid attributes' do
          before do
            # post '/api/v1/users', user_params.merge('email' => 'somethingwrong', 'password' => '12', 'age' => '18-25',
                                                    # 'hair_type' => 'wrong', 'skin_type' => 'also wrong')
          end

          let(:expectation) {
            {
                'errors' =>
                    {
                        'email' => ['is invalid'],
                        'password' => ['is too short (minimum is 4 characters)'],
                        'age' => ['is not included in the list'],
                        'hair_type' => ['is not included in the list'],
                        'skin_type' => ['is not included in the list']
                    }
            }
          }

          # it { expect(response.code).to eq('422') }
          # it { expect(result(response)).to match(expectation) }
        end

        it 'rejects empty email' do
          # post '/api/v1/users', user_params.merge('email' => '')
          # expect(result(response)['errors']['email']).to match(["can't be blank"])
        end

        it 'rejects invalid email' do
          # post '/api/v1/users', user_params.merge('email' => 'somethingwrong')
          # expect(result(response)['errors']['email']).to match(['is invalid'])
        end

        it 'rejects empty password' do
          # post '/api/v1/users', user_params.merge('password' => '')
          # expect(result(response)['errors']['password']).to match(["can't be blank"])
        end

        it 'rejects short password' do
          # post '/api/v1/users', user_params.merge('password' => '12')
          # expect(result(response)['errors']['password']).to match(['is too short (minimum is 4 characters)'])
        end

        it 'rejects long password' do
          # post '/api/v1/users', user_params.merge('password' => 'a' * 129)
          # expect(result(response)['errors']['password']).to match(['is too long (maximum is 128 characters)'])
        end
      end
    end

    context 'when registers by facebook_id' do
      let(:user_params) {
        { 'facebook_id' => '100004866240221',
          'facebook_session' => 'CAACEdEose0cBAJSb8gOYzXZAiYgtmfTLWWztFDJnvd59POTVmZCZA4ZC52DIZBo85HjJHZAGIyZBIzpTEXSUyu1DfKJ0kfF43RGV7oZBxhp9QciJtOg4rOkcwDet4b67gAV6tbOyWrUZA5OP3sA8UzsGJqGfk3Soq4DIX46eScyaptNgUcg5mevVOUDdIiQ5dOKOzAohj42DnLD6xDhJUkXSCyuQgQYRZAmpoZD',
          'email' => 'email@example.com',
          'first_name' => 'John',
          'last_name' => 'Doe',
          'age' => '18-24',
          'hair_type' => 'straight',
          'skin_type' => 'normal',
          'latitude' => 123.25,
          'longitude' => -45.55,
          'installation_id' => 'some_id_1234',
        }
      }

      context 'with valid attributes' do
        before do
          # expect(SecureRandom).to receive(:hex).and_return('DQDqhIHyNYOgVtUs2X8P1Q')
          # post '/api/v1/users', user_params
        end

        let(:expectation) {{ 'user' => user_params.except('password', 'facebook_session').merge('auth_token' => 'DQDqhIHyNYOgVtUs2X8P1Q', 'id' => User.last.id,
                                                                                                'amazon_id' => nil) }}

        # it { expect(response).to be_success }
        # it { expect(result(response)).to match(expectation) }

        it 'rejects taken facebook_id' do
          # post '/api/v1/users', user_params
          # expect(result(response)['errors']['facebook_id']).to match(['already exists'])
        end
      end

      it 'rejects invalid facebook_id' do
        # post '/api/v1/users', user_params.except('facebook_id').merge('facebook_id' => '1234')
        # expect(result(response)['errors']['facebook_id']).to eq(["facebook_session doesn't match with id sent"])
      end

      it 'rejects invalid facebook_session' do
        # post '/api/v1/users', user_params.except('facebook_session').merge('facebook_session' => 'fail')
        # expect(result(response)['errors']['oauth']).to match(['Invalid OAuth access token.'])
      end
    end

    context 'when registers by amazon_id' do
      let(:user_params) {
        { 'amazon_id' => 'amzn1.account.AEM6TWKKDA6W5E6QFXRC7FAWPOOA',
          'amazon_session' => 'Atza|IQEBLjAsAhQYc5IPoacnUZnEO_nKYq3LgQ-pSgIUX6D534_QiXFUdmqVdCnbad7trW0w6712uh3aN7A7hop98MOOtH1hT9ZxD-JSQ7PEHEGxx6WmrCe2ptl0MV9yYWBcgqpQegCIaIvDNEAnAqK-xpJ4PK1VFf7qoJaeBqwuuFd3dslzscSKhEZl0qtFoEm7OLURKDu7rOLvLx4q4FXEdeZbFxrKykz3Dht2MGXnOF5h2y1wdCRF8ux9mNVmoE-MMcQzbiDYMEm_XjP3sJTLOooAQnHOD9qCfwRNkwWlVbAGDcnlDmPUxNPTm1eiz7HRkJ7p2ZAPLIQwqo2BnttcbmvchSvXCQvWQvNGfOTOJO2bzWo',
          'email' => 'email@example.com',
          'first_name' => 'John',
          'last_name' => 'Doe',
          'age' => '18-24',
          'hair_type' => 'straight',
          'skin_type' => 'normal',
          'latitude' => 123.25,
          'longitude' => -45.55,
          'installation_id' => 'some_id_1234',
        }
      }

      context 'with valid attributes' do
        before do
          # expect(SecureRandom).to receive(:hex).and_return('DQDqhIHyNYOgVtUs2X8P1Q')
          # post '/api/v1/users', user_params
        end

        let(:expectation) {{ 'user' => user_params.except('password', 'amazon_session').merge('auth_token' => 'DQDqhIHyNYOgVtUs2X8P1Q', 'id' => User.last.id,
                                                                                              'facebook_id' => nil) }}

        # it { expect(response).to be_success }
        # it { expect(result(response)).to match(expectation.except('amazon_session')) }

        it 'rejects taken amazon_id' do
          # post '/api/v1/users', user_params
          # expect(result(response)['errors']['amazon_id']).to match(['already exists'])
        end
      end

      it 'rejects invalid amazon_id' do
        # post '/api/v1/users', user_params.except('amazon_id').merge('amazon_id' => 'fail')
        # expect(result(response)['errors']['amazon_id']).to eq(["amazon_session doesn't match with id sent"])
      end

      it 'rejects invalid amazon_session' do
        # post '/api/v1/users', user_params.except('amazon_session').merge('amazon_session' => 'fail')
        # expect(result(response)['errors']['amazon_api']).to match(['The request has an invalid parameter : access_token'])
      end
    end

    def result(response)
      JSON.parse(response.body)
    end
  end

  describe 'PUT /api/v1/users' do
    context 'when user registered with email' do
      # let!(:user) { FactoryGirl.create(:user) }
      # let!(:auth_token) { user.auth_token }
      let(:user_params) {
        { 'email' => 'new_email@example.com',
          'password' => 'new_password',
          'first_name' => 'New First Name',
          'last_name' => 'New Last Name',
          'age' => '25-34',
          'hair_type' => 'wavy',
          'skin_type' => 'dry',
          'latitude' => 80.30,
          'longitude' => -30.00,
          'installation_id' => 'some_new_id_1234',
          'facebook_id' => 'new_1234',
          'amazon_id' => 'new_5678',
          # 'auth_token' => user.auth_token
        }
      }

      context 'with valid attributes' do
        let(:expectation) {{
            # 'user' => user_params.merge('id' => user.id).except('password')
        }}

        before do
          # expect(SecureRandom).to_not receive(:hex)
          # put "/api/v1/users/#{user.id}", user_params
        end

        # it { expect(response).to be_success }
        # it { expect(result(response)).to match(expectation) }
        # it { expect(result(response)['user']['auth_token']).to eq(auth_token) }
      end

      context 'with invalid attributes' do
        context 'with multiple invalid attributes' do
          before do
            # put "/api/v1/users/#{user.id}", user_params.merge('email' => 'somethingwrong', 'password' => '12')
          end

          let(:expectation) {
            {
                'errors' =>
                    {
                        'email' => ['is invalid'],
                        'password' => ['is too short (minimum is 4 characters)']
                    }
            }
          }

          # it { expect(response.code).to eq('422') }
          # it { expect(result(response)).to match(expectation) }
        end

        it 'rejects model when email, amazon_id and facebook_id are blank' do
          # put "/api/v1/users/#{user.id}", user_params.merge('email' => '', 'facebook_id' => nil, 'amazon_id' => nil)
          # expect(result(response)['errors']['email']).to match(["can't be blank"])
        end

        it 'rejects invalid email' do
          # put "/api/v1/users/#{user.id}", user_params.merge('email' => 'somethingwrong')
          # expect(result(response)['errors']['email']).to match(['is invalid'])
        end

        it 'rejects empty password when email, amazon_id and facebook_id are blank' do
          # put "/api/v1/users/#{user.id}", user_params.merge('password' => '', 'facebook_id' => nil, 'amazon_id' => nil)
          # expect(result(response)['errors']['password']).to match(["can't be blank"])
        end

        it 'rejects short password' do
          # put "/api/v1/users/#{user.id}", user_params.merge('password' => '12')
          # expect(result(response)['errors']['password']).to match(['is too short (minimum is 4 characters)'])
        end

        it 'rejects long password' do
          # put "/api/v1/users/#{user.id}", user_params.merge('password' => 'a' * 129)
          # expect(result(response)['errors']['password']).to match(['is too long (maximum is 128 characters)'])
        end

        it "doesn't accept wrong API token" do
          # put "/api/v1/users/#{user.id}", user_params.merge('auth_token' => 'wrong_token')
          # expect(response.status).to be(401)
          # expect(response.body).to eq(' ')
        end

        it "doesn't let updating different users model" do
          # another_user = FactoryGirl.create(:user, email: 'diff_mail@example.com')
          # put "/api/v1/users/#{another_user.id}", user_params
          # expect(response.status).to be(401)
          # expect(response.body).to eq(' ')
        end
      end
    end

    def result(response)
      JSON.parse(response.body)
    end
  end
end
