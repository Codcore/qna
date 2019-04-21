class QuestionsController < ApplicationController

  def index
    @questions = Question.all
  end

  def show; end

  def new; end

  def create
    @question = Question.create(question_params)
    if @question.persisted?
      redirect_to question
    else
      redirect_to action: :new
    end
  end

  def edit; end

  def update
    if question.update(question_params)
      redirect_to question
    else
      redirect_to edit_question_path(question)
    end
  end

  def destroy
    question.destroy
    redirect_to question_path
  end

  private

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
