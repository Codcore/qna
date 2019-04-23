class AnswersController < ApplicationController
  expose :answer
  expose :question, find: ->(id, scope){ scope.find(id) }

  def create
    answer.question = question
    if answer.save
      redirect_to answer.question
    else
      flash[:validation_error] = answer.errors.full_messages.join('|')
      redirect_to new_question_answer_path(answer.question)
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to question_path(answer.question)
    else
      flash[:validation_error] = answer.errors.full_messages.join('|')
      redirect_to edit_answer_path(answer)
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
end
