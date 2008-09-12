class PageItems < ActiveRecord::Migration
  def self.up
    add_column :pages, :sub_title, :text
    add_column :pages, :menu_title, :text
  end

  def self.down
    remove_column :pages, :sub_title
    remove_column :pages, :menu_title
  end
end
