class CreateCommonElements < ActiveRecord::Migration
  class Partial < ActiveRecord::Base;end
  def self.up
    create_table :sessions, :force => true do |t|
      t.string   :session_id
      t.text     :data
      t.datetime :updated_at
    end
    add_index :sessions, [:session_id], :name => :index_sessions_on_session_id
    add_index :sessions, [:updated_at], :name => :index_sessions_on_updated_at

    create_table :roles, :force => true do |t|
      t.string   :name, :null=>false
      t.integer  :position, :null=>false, :default=>0
      t.timestamps
    end
    add_index :roles, [:name], :unique=>true

    create_table :users, :force => true do |t|
      t.integer  :role_id
      t.string   :prefix
      t.string   :first
      t.string   :last
      t.string   :title
      t.string   :login
      t.string   :email
      t.string   :crypted_password, :limit => 40
      t.string   :salt, :limit => 40
      t.datetime :last_login_at
      t.string   :remember_token
      t.datetime :remember_token_expires_at
      t.string   :time_zone, :default => "Etc/UTC"
      t.timestamps
    end
    add_index :users, [:login], :unique=>true
    add_index :users, [:email], :unique=>true

    create_table :partials, :force => true do |t|
      t.string  :directory, :null=>false
      t.string  :name, :null=>false
      t.string  :description
      t.string  :thumbnail
      t.integer :position, :null=>false, :default=>0
      t.timestamps 
    end
    
    create_table :pages, :force => true do |t|
      t.integer  :partial_id, :null=>false
      t.integer  :parent_id
      t.string   :path, :null=>false
      t.text     :title
      t.string   :link_text
      t.string   :css_identifier
      t.text     :description
      t.integer  :jump_menu_position, :default=>0, :null=>false
      t.boolean  :include_in_main_menu, :default=>false, :null=>false
      t.integer  :lft, :null => false
      t.integer  :rgt, :null => false
      t.integer  :lock_version, :default => 0
      t.timestamps
    end
    add_index :pages, [:path, :parent_id], :unique=>true
    
    create_table :page_partials, :force=>true do |t|
      t.integer :page_id, :null=>false
      t.integer :partial_id, :null=>false
      t.string  :group, :null=>false
      t.timestamps
    end

    create_table :aliases, :force => true do |t|
      t.integer :page_id
      t.string  :name
      t.timestamps 
    end
    add_index :aliases, :name, :unique=>true
    
    create_table :content_blocks, :force => true do |t|
      t.integer  :page_id, :null=>false
      t.string   :group, :null=>false
      t.text     :text
      t.integer  :position, :null=>false, :default=>0
      t.timestamps
    end
    add_index :content_blocks, [:page_id, :group]

    create_table :assets, :force => true do |t|
      t.integer  :parent_id
      t.string   :filename
      t.string   :thumbnail
      t.integer  :width
      t.integer  :height
      t.string   :content_type
      t.integer  :size
      t.timestamps
    end
    
    create_table :events, :force => true do |t|
      t.string :name, :null=>false
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.string :location_name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.decimal :lat, :precision => 15, :scale => 10
      t.decimal :lng, :precision => 15, :scale => 10
      t.timestamps
    end
    add_index :events, :start_date
    add_index :events, :end_date    
  end

  def self.down
    drop_table :assets
    drop_table :content_blocks
    drop_table :partials
    drop_table :aliases
    drop_table :pages
    drop_table :users
    drop_table :roles
    drop_table :sessions
    drop_table :events
  end
end
