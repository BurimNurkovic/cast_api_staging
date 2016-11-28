class Admin::ReportsController < Admin::BaseAdminController

  def users_statistics
    statistics = UserStatistic.grouped_by_attributes
    render json: statistics
  end

  def question_with_answers
    questions = Question.includes(:answers).order(:order_by, 'answers.order_by').joins(:responses)
    render json: questions
  end

  def question_responses
    responses = Answer.select('count(responses.id) as value, answers.text as the_cat')
    .joins(:responses)
    .where(question_id: params[:question_id])
    .group('answers.text, answers.order_by')
    .order('answers.order_by')
    data = responses.map do |r|
      { the_cat: r.the_cat, value: r.value }
    end
    render json: data
  end
end
