class QuestionsController < ApplicationController
  include AuthorizeableResource

  expose :question, scope: -> { Question.with_attached_files }
  expose :questions, ->{ Question.all }
  expose :answer, ->{ question.answers.new }

  before_action :authenticate_user!, except: [:index, :show]
  before_action -> { authorize_author_for!(question) }, only: [:update, :destroy]

  def create
    question.author = current_user
    if question.save
      flash[:success] = t('.flash_messages.question.created')
      redirect_to questions_path
    else
      render :new
    end
  end

  def update
    if question.update(question_params)
      redirect_to question
    else
      render :edit
    end
  end

  def destroy
    question.destroy
    redirect_to questions_path
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end
end
