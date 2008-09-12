class MakeCommentPolymorphic < ActiveRecord::Migration
  def self.up
    remove_index :comments, :name=>"index_comments_on_post_id"
    add_column :comments, :commentable_id, :integer
    add_column :comments, :commentable_type, :string
    Comment.update_all("commentable_id=post_id, commentable_type='Page'")
    remove_column :comments, :post_id
    change_column :comments, :commentable_id, :integer, :null=>false
    change_column :comments, :commentable_type, :string, :null=>false
    add_index :comments, [:commentable_type, :commentable_id], :name=>"index_comments_commentable"
    add_column :comments, :created_by, :integer
  end

  def self.down
    remove_index :comments, :name=>"index_comments_commentable"
    add_column :comments, :post_id, :integer
    Comment.update_all("post_id=commentable_id")
    remove_column :comments, :commentable_id
    remove_column :comments, :commentable_type
    add_index "comments", ["post_id"], :name => "index_comments_on_post_id"
    remove_column :comments, :created_by
  end
end
