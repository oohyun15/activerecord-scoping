require 'rails_helper'

describe 'ActiveRecord', type: :model do
  it 'returns expected query' do
    expected_query = <<-SQL.squish
      SELECT `posts`.* FROM `posts` LEFT OUTER JOIN `comments` ON `comments`.`post_id` = `posts`.`id` WHERE (`posts`.`status` = 'open' OR `comments`.`status` = 'open')
    SQL

    expect(Post.scope1.to_sql).to eq expected_query
    expect(Post.scope2.to_sql).to eq expected_query
  end

  context 'with where clause' do
    it "doesn't return expected query if where clause exists before scope" do
      expected_query = <<-SQL.squish
        SELECT `posts`.* FROM `posts` LEFT OUTER JOIN `comments` ON `comments`.`post_id` = `posts`.`id` WHERE `posts`.`type` = 'Post::Normal' AND (`posts`.`status` = 'open' OR `comments`.`status` = 'open')
      SQL

      expect(Post.where(type: 'Post::Normal').scope1.to_sql).to eq expected_query
      expect(Post.where(type: 'Post::Normal').scope2.to_sql).to eq expected_query # SELECT `posts`.* FROM `posts` LEFT OUTER JOIN `comments` ON `comments`.`post_id` = `posts`.`id` WHERE (`posts`.`type` = 'Post::Normal' AND `posts`.`status` = 'open' OR `comments`.`status` = 'open')

      # same queries
      # expect(Post::Normal.scope1.to_sql).to eq expected_query
      # expect(Post::Normal.scope2.to_sql).not_to eq expected_query # error
    end

    it 'returns expected query if where clause exists after scope' do
      expected_query = <<-SQL.squish
      SELECT `posts`.* FROM `posts` LEFT OUTER JOIN `comments` ON `comments`.`post_id` = `posts`.`id` WHERE (`posts`.`status` = 'open' OR `comments`.`status` = 'open') AND `posts`.`type` = 'Post::Normal'
      SQL

      expect(Post.scope1.where(type: 'Post::Normal').to_sql).to eq expected_query
      expect(Post.scope2.where(type: 'Post::Normal').to_sql).to eq expected_query
    end
  end
end
