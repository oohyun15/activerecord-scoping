class Post < ApplicationRecord
  has_many :comments

  scope :scope1, -> {
    left_joins(:comments)
    .where(status: 'open')
    .or(where(comments: { status: 'open' }))
  }

  scope :scope2, -> {
    left_joins(:comments)
    .where(status: 'open')
    .or(Comment.where(status: 'open'))
  }
end
