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
        SELECT `posts`.* FROM `posts` LEFT OUTER JOIN `comments` ON `comments`.`post_id` = `posts`.`id` WHERE `posts`.`id` IN (1, 2, 3) AND (`posts`.`status` = 'open' OR `comments`.`status` = 'open')
      SQL

      expect(Post.where(id: [1 , 2, 3]).scope1.to_sql).to eq expected_query
      expect(Post.where(id: [1 , 2, 3]).scope2.to_sql).to eq expected_query
    end

    it 'returns expected query if where clause exists after scope' do
      expected_query = <<-SQL.squish
        SELECT `posts`.* FROM `posts` LEFT OUTER JOIN `comments` ON `comments`.`post_id` = `posts`.`id` WHERE (`posts`.`status` = 'open' OR `comments`.`status` = 'open') AND `posts`.`id` IN (1, 2, 3)
      SQL

      expect(Post.scope1.where(id: [1 , 2, 3]).to_sql).to eq expected_query
      expect(Post.scope2.where(id: [1 , 2, 3]).to_sql).to eq expected_query
    end
  end
end
