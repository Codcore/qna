class QuestionsController < ApplicationController
  expose :question
  expose :questions, ->{ Question.all }

  def create
    if question.save
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

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
