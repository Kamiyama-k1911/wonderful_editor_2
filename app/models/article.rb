class Article < ApplicationRecord
  enum article_status: { draft: 0, published: 1 }

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :article_likes, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true
end
