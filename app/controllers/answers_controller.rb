class AnswersController < ApplicationController
  include AuthorizeableController

  expose :answer
  expose :question, find: ->(id=:question_id, scope){ scope.find(id) }

  before_action :authenticate_user!, except: [:show]
  before_action -> { authorize_author_for!(answer) }, only: [:update, :destroy]

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

  private

  def answer_params
    params.require(:answer).permit(:title, :body)
  end
end
