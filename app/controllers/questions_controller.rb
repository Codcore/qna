class QuestionsController < ApplicationController
  include AuthorizeableResource
  include Voted

  expose :question, scope: -> { Question.with_attached_files }
  expose :questions, -> { Question.all }
  expose :answer, -> { question.answers.new }

  before_action :authenticate_user!, except: [:index, :show]
  before_action -> { question.build_reward }, only: [:new]
  before_action :set_question_data_for_client, only: [:show]

  after_action :publish_question, only: [:create]

  def create
    authorize! :create, question
    question.author = current_user
    if question.save
      question.subscribers.push(current_user)
      flash[:success] = t('.flash_messages.question.created')
      redirect_to questions_path
    else
      render :new
    end
  end

  def update
    authorize! :update, question
    if question.update(question_params)
      redirect_to question
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, question
    question.destroy
    redirect_to questions_path
  end

  def subscribe
    authorize! :subscribe, question
    question.subscribers.push(current_user)
  end

  def unsubscribe
    authorize! :unsubscribe, question
    question.subscribers.delete(current_user)
  end

  private

  def set_question_data_for_client
    gon.question_id = question.id
    gon.question_author_id = question.author_id
  end

  def question_params
    params.require(:question).permit(:title, :body, reward_attributes: [:name, :image], files: [], links_attributes: [:name, :url, :id, :_destroy])
  end

  def publish_question
    return if question.errors.any?
    ActionCable.server.broadcast( 'questions', question: question)
  end
end
