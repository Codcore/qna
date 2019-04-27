class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :check_authorized, only: [:update, :destroy]

  expose :question
  expose :questions, ->{ Question.all }
  expose :answer, ->{ question.answers.new }

  def create
    question.user = current_user
    if question.save
      flash[:success] = t('.flash_messages.question.created')
      redirect_to questions_path
    else
      flash[:validation_error] = question.errors.full_messages.join('|')
      redirect_to action: :new
    end
  end

  def update
    if question.update(question_params)
      redirect_to question
    else
      flash[:validation_error] = question.errors.full_messages.join('|')
      redirect_to action: :edit
    end
  end

  def destroy
    question.destroy
    redirect_to questions_path
  end

  private

  def check_authorized
    return render :show, status: :unauthorized unless authorized_user?
  end

  def authorized_user?
    current_user == question.user
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
