class Article < ApplicationRecord
  enum status: { draft: "draft", published: "published" }

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :article_likes, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true
end
