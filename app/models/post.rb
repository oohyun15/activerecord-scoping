class Post < ApplicationRecord
  has_many :comments

  scope :available, -> { where(status: 'open') }

  scope :scope1, -> {
    left_joins(:comments)
    .available
    .or(where(comments: { status: 'open' }))
  }

  scope :scope2, -> {
    left_joins(:comments)
    .available
    .or(Comment.available)
  }
end
