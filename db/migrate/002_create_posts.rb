class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.datetime :published_at
      t.datetime :comments_expire_at
      t.integer :comments_count, :null=>false, :default=>0
      t.timestamps 
    end
    add_index :posts, :published_at
    
    create_table :comments do |t|
      t.integer :post_id, :null=>false
      t.integer :parent_id
      t.text :body, :null=>false
      t.string :name, :null=>false
      t.string :email, :null=>false
      t.string :website
      t.datetime :approved_at
      t.string :ip
      t.string :referrer
      t.string :user_agent
      t.boolean :spam, :default=>false, :null=>false
      t.timestamps
    end
    add_index :comments, :post_id
  end

  def self.down
    drop_table :comments
    drop_table :posts
  end
end
