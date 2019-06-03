class AnswersController < ApplicationController
  include AuthorizeableResource
  include Voted

  expose :answer
  expose :question, find: ->(id=:question_id, scope){ scope.find(id) }

  before_action :authenticate_user!, except: [:show]
  after_action :publish_answer, only: [:create]

  authorize_resource

  def create
    authorize! :create, answer
    answer.author = current_user
    answer.question = question
    answer.save
  end

  def update
    authorize! :update, answer
    answer.update(answer_params)
  end

  def destroy
    authorize! :destroy, answer
    answer.destroy
  end

  def best_solution
    authorize! :best_solution, answer
    answer.best_solution!
  end

  private

  def answer_params
    params.require(:answer).permit(:title, :body, files: [], links_attributes: [:name, :url, :id, :_destroy])
  end

  def publish_answer
    return if answer.errors.any?
    ActionCable.server.broadcast("answers_for_question_#{question.id}",
                                 answer: answer,
                                 answer_score: answer.score,
                                 answer_created_at: answer.created_at.strftime('%B %e at %l:%M %p')
    )
  end
end
