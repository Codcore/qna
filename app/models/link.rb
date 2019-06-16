class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  default_scope { order(id: :asc)}

  validates :name, :url, presence: true
  validates :url, format: { with: URI.regexp }

  def gist?
    host = URI.parse(url).host
    return true if host&.include?('gist.github.com')
    false
  end

  def gist_id
    if gist?
      url.split('/').reject!(&:empty?).last
    end
  end
end
