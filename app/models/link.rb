class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, http_url: true

  def gist?
    URI::parse(url).host == "gist.github.com"
  end
end
