require 'spec_helper'

describe Api::V1::ResponsesController do

  def self.check_returned_request
    it { expect(response).to be_success }

    it 'creates 3 responses' do
      expect(user.responses.count).to be_eql 3
    end

    describe 'returned object' do
      let(:question_responses) { result(response)['responses'] }
      (0..2).each do |index|
        it "includes response data at index #{index}" do
          question_response = question_responses[index]
          expect(question_response['question_id']).to be_eql(questions[index].id)
          expect(question_response['answer_id']).to be_eql(questions[index].answers[answer_index].id)
          expect(question_response.keys).to match_array(%w(answer_id id order_by question_id))
        end
      end

      it 'has 3 created responses' do
        expect(question_responses.size).to be_eql 3
      end
    end
  end

  context 'with a logged user' do
    let!(:user) { FactoryGirl.create(:amazon_user) }

    let(:questions) { FactoryGirl.create_list(:question_with_answers, 3, answers_count: 3) }

    let(:answer_index) { rand(2) }

    describe 'list of responses' do
      before do
        get '/api/v1/responses', { auth_token: user.auth_token }
      end
      it { expect(response).to be_success }
    end

    describe 'creation of responses' do
      # Spec that use the correct pattern of parameters
      # params = {"responses"=>[
      #   {"question_id"=>"X", "answers"=>[{"answer_id"=>"X"}]},
      #   {"question_id"=>"Y", "answers"=>[{"answer_id"=>"X"}]}
      # ]}
      context 'ordered parameters' do
        before do
          params = "auth_token=#{user.auth_token}"
          @ordered_params = questions.map do |question|
            ["responses[][question_id]=#{question.id}"] <<
            "responses[][answers][][answer_id]=#{question.answers[answer_index].id}"
          end.flatten.join('&')

          post '/api/v1/responses', "#{params}&#{@ordered_params}"
        end

        check_returned_request
      end

      # Spec to solve issue with different parameter order at IOS
      # that was causing issues with the last question
      # Rack::Utils.parse_nested_query
      # params = {"responses"=>[
      #   {"question_id"=>"X", "answers"=>[{"answer_id"=>"Y"}, {"answer_id"=>"Y"}]},
      #   {"question_id"=>"Y"}
      # ]}
      context 'unordered parameters' do
        before do
          params = "auth_token=#{user.auth_token}"
          ordered_params = questions.map do |question|
            ["responses[][answers][][answer_id]=#{question.answers[answer_index].id}"] <<
            "responses[][question_id]=#{question.id}"
          end.flatten.join('&')

          post '/api/v1/responses', "#{params}&#{ordered_params}"
        end

        check_returned_request
      end
    end
  end

  context 'without a logged user' do
    before do
      get '/api/v1/responses', { auth_token: '' }
    end
    it { expect(response).not_to be_success }
  end

  def result(response)
    JSON.parse(response.body)
  end
end
