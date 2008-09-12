class AddPageOptions < ActiveRecord::Migration
  def self.up
    add_column :pages, :show_children, :boolean, :null=>false, :default=>true
    add_column :pages, :show_siblings, :boolean, :null=>false, :default=>true
    add_column :pages, :show_breadcrumbs, :boolean, :null=>false, :default=>true
  end

  def self.down
    remove_column :pages, :show_children
    remove_column :pages, :show_siblings
    remove_column :pages, :show_breadcrumbs
  end
end
