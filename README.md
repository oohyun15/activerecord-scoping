## Quick Start
```bash
  $ bundle install
  $ RAILS_ENV=test bundle exec rake db:create db:migrate
  $ bundle exec rspec
```

## Abnormal ActiveRecord query
### test class
``` ruby
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

  class Comment < ApplicationRecord
    belongs_to :post
  end
```

### queries
```ruby
  Post.where(id: [1, 2, 3]).scope1.to_sql
  => "SELECT `posts`.* FROM `posts` LEFT OUTER JOIN `comments` ON `comments`.`post_id` = `posts`.`id` WHERE `posts`.`id` IN (1, 2, 3) AND (`posts`.`status` = 'open' OR `comments`.`status` = 'open')"

  Post.where(id: [1, 2, 3]).scope2.to_sql
  => "SELECT `posts`.* FROM `posts` LEFT OUTER JOIN `comments` ON `comments`.`post_id` = `posts`.`id` WHERE (`posts`.`id` IN (1, 2, 3) AND `posts`.`status` = 'open' OR `comments`.`status` = 'open')" # bracket changed. different result against first's result.

  Post.where(id: [1, 2, 3]).merge(Post.scope2).to_sql
  => "SELECT `posts`.* FROM `posts` LEFT OUTER JOIN `comments` ON `comments`.`post_id` = `posts`.`id` WHERE `posts`.`id` IN (1, 2, 3) AND (`posts`.`status` = 'open' OR `comments`.`status` = 'open')" # same as first query

  Post.scope2.where(id: [1, 2, 3]).to_sql
  => "SELECT `posts`.* FROM `posts` LEFT OUTER JOIN `comments` ON `comments`.`post_id` = `posts`.`id` WHERE (`posts`.`status` = 'open' OR `comments`.`status` = 'open') AND `posts`.`id` IN (1, 2, 3)" # query changed, but same as first's result
```
