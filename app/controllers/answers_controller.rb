class AnswersController < ApplicationController
  include AuthorizeableController

  expose :answer
  expose :question, find: ->(id=:question_id, scope){ scope.find(id) }

  before_action :authenticate_user!, except: [:show]
  before_action -> { authorize_author_for!(answer) }, only: [:update, :destroy]

  def create
    answer.author = current_user
    answer.question = question
    if answer.save
      redirect_to answer.question
    else
      render 'questions/show'
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to question_path(answer.question)
    else
      render :edit
    end
  end

  def destroy
    answer.destroy
    redirect_to answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:title, :body)
  end

  def authorize_author_for!(resource)
    render template: 'errors/401_error', status: :unauthorized unless resource.authorized?(current_user)
  end
end
