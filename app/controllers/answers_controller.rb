class AnswersController < ApplicationController
  include AuthorizeableController

  expose :answer
  expose :question, find: ->(id=:question_id, scope){ scope.find(id) }

  before_action :authenticate_user!, except: [:show]
  before_action -> { authorize_author_for!(answer) }, only: [:update, :destroy ]
  before_action -> { authorize_author_for!(answer.question) }, only: [:best_solution]

  def create
    answer.author = current_user
    answer.question = question
    answer.save
  end

  def update
    answer.update(answer_params)
  end

  def destroy
    if params[:purge_attachment_id]
      @file = answer.files.find_by_id(params[:purge_attachment_id])
      @file.purge
      render 'delete_attachment.js.erb'
    else
      answer.destroy
    end
  end

  def best_solution
    answer.best_solution!
  end

  private

  def answer_params
    params.require(:answer).permit(:title, :body, files: [])
  end
end
