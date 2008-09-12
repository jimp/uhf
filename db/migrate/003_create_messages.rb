class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string :recipients, :null=>false
      t.string :subject, :null=>false
      t.string :from, :null=>false
      t.string :cc
      t.string :bcc
      t.text :body
      t.datetime :sent_on
      t.text :error_message
      t.string :content_type
      t.string :headers
      t.string :ip_address
      t.timestamps 
    end
    add_index :messages, :sent_on
  end

  def self.down
    drop_table :messages
  end
end
