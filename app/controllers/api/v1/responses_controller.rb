class Api::V1::ResponsesController < Api::V1::BaseController
  before_action :authorize

  def index
    render json: Response.joins(:question).where(user: current_user).order('questions.order_by', :order_by)
  end

  def create
    responses = []
    # - Fix the controller of responses with a dirty method together with the response validation.
    # This strategy was used to don't break the previous app builds

    answer_ids = params["responses"].map {|response| response["answers"].map {|answer| answer["answer_id"]} if response["answers"] }.compact.flatten

    params[:responses].each do |resp|
      Response.where({ user: current_user, question_id: resp[:question_id] }).destroy_all

      answer_ids.each do |answer_id|
        response = Response.new({
          user: current_user,
          question_id: resp[:question_id],
          answer_id: answer_id,
          order_by: 0
          })
        responses.push response if response.save
      end unless answer_ids.blank?
    end
    render json: responses
  end

  def update
    create
  end
end
