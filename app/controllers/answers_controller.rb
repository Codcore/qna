class AnswersController < ApplicationController
  include AuthorizeableResource
  include Voted

  expose :answer
  expose :question, find: ->(id=:question_id, scope){ scope.find(id) }

  before_action :authenticate_user!, except: [:show]
  before_action -> { authorize_author_for!(answer) }, only: [:update, :destroy ]
  before_action -> { authorize_author_for!(answer.question) }, only: [:best_solution]
  after_action :publish_answer, only: [:create]

  def create
    answer.author = current_user
    answer.question = question
    answer.save
  end

  def update
    answer.update(answer_params)
  end

  def destroy
    answer.destroy
  end

  def best_solution
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
