# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 15) do

  create_table "aliases", :force => true do |t|
    t.integer  "page_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "aliases", ["name"], :name => "index_aliases_on_name", :unique => true

  create_table "assets", :force => true do |t|
    t.integer  "parent_id"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "width"
    t.integer  "height"
    t.string   "content_type"
    t.integer  "size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "parent_id"
    t.text     "body",                                :null => false
    t.string   "name",                                :null => false
    t.string   "email",                               :null => false
    t.string   "website"
    t.datetime "approved_at"
    t.string   "ip"
    t.string   "referrer"
    t.string   "user_agent"
    t.boolean  "spam",             :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "commentable_id",                      :null => false
    t.string   "commentable_type",                    :null => false
    t.integer  "created_by"
  end

  add_index "comments", ["commentable_type", "commentable_id"], :name => "index_comments_commentable"

  create_table "content_blocks", :force => true do |t|
    t.string   "group",                         :null => false
    t.text     "text"
    t.integer  "position",       :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "blockable_id",                  :null => false
    t.string   "blockable_type",                :null => false
  end

  add_index "content_blocks", ["blockable_type", "blockable_id", "group"], :name => "index_content_blocks_blockable"

  create_table "events", :force => true do |t|
    t.string   "name",                                          :null => false
    t.text     "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "location_name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.decimal  "lat",           :precision => 15, :scale => 10
    t.decimal  "lng",           :precision => 15, :scale => 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["start_date"], :name => "index_events_on_start_date"
  add_index "events", ["end_date"], :name => "index_events_on_end_date"

  create_table "messages", :force => true do |t|
    t.string   "recipients",    :null => false
    t.string   "subject",       :null => false
    t.string   "from",          :null => false
    t.string   "cc"
    t.string   "bcc"
    t.text     "body"
    t.datetime "sent_on"
    t.text     "error_message"
    t.string   "content_type"
    t.string   "headers"
    t.string   "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["sent_on"], :name => "index_messages_on_sent_on"

  create_table "page_partials", :force => true do |t|
    t.integer  "page_id",    :null => false
    t.integer  "partial_id", :null => false
    t.string   "group",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.integer  "partial_id",                              :null => false
    t.integer  "parent_id"
    t.string   "path",                                    :null => false
    t.text     "title"
    t.string   "link_text"
    t.string   "css_identifier"
    t.text     "description"
    t.integer  "jump_menu_position",   :default => 0,     :null => false
    t.boolean  "include_in_main_menu", :default => false, :null => false
    t.integer  "lft",                                     :null => false
    t.integer  "rgt",                                     :null => false
    t.integer  "lock_version",         :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "show_children",        :default => true,  :null => false
    t.boolean  "show_siblings",        :default => true,  :null => false
    t.boolean  "show_breadcrumbs",     :default => true,  :null => false
    t.text     "sub_title"
    t.text     "menu_title"
  end

  add_index "pages", ["path", "parent_id"], :name => "index_pages_on_path_and_parent_id", :unique => true

  create_table "partials", :force => true do |t|
    t.string   "directory",                  :null => false
    t.string   "name",                       :null => false
    t.string   "description"
    t.string   "thumbnail"
    t.integer  "position",    :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pdfs", :force => true do |t|
    t.integer  "size"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "page"
    t.integer  "language"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "published_at"
    t.datetime "comments_expire_at"
    t.integer  "comments_count",     :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["published_at"], :name => "index_posts_on_published_at"

  create_table "roles", :force => true do |t|
    t.string   "name",                      :null => false
    t.integer  "position",   :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name"], :name => "index_roles_on_name", :unique => true

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "signups", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "role_id"
    t.string   "prefix"
    t.string   "first"
    t.string   "last"
    t.string   "title"
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "last_login_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "time_zone",                               :default => "Etc/UTC"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
