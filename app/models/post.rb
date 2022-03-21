class Post < ApplicationRecord
  scope :available, -> {
    where(type: 'sports').or(where(status: 'open'))
  }
end
