class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :commentaries, :created_at, :updated_at, :files, :links

  belongs_to :author
  belongs_to :question
  has_many :links
  has_many :files

  def files
    Answer.with_attached_files.find(object.id).files.collect { |file| url_for(file) }
  end
end
