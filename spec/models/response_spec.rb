require 'spec_helper'

RSpec.describe Response, type: :model do
  describe 'validations' do
    describe 'only_answer_belongs_question' do
      let(:question1) { FactoryGirl.create(:question_with_answers, answers_count: 1) }
      let(:question2) { FactoryGirl.create(:question_with_answers, answers_count: 1) }

      it 'do not accept answers from other questions' do
        response = Response.new(question: question1, answer: question2.answers.first)
        expect { response.save }.not_to change{ Response.count }
        expect(response.errors.messages).to include(answer: ['do not belongs to the selected question'])
      end

      it 'accept answers from the related question' do
        response = Response.new(question: question1, answer: question1.answers.first)
        expect { response.save }.to change{ Response.count }
        expect(response.errors.messages).not_to include(answer: ['do not belongs to the selected question'])
      end
    end
  end
end
