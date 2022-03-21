class Comment < ApplicationRecord
  belongs_to :post

  scope :available, -> { where(status: 'open') }
end
