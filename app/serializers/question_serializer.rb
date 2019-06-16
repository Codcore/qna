class QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :body, :created_at, :updated_at, :short_title, :files

  has_many :commentaries
  has_many :links

  belongs_to :author


  def short_title
    object.title.truncate(11)
  end

  def files
    Question.with_attached_files.find(object.id).files.collect { |file| url_for(file) }
  end
end