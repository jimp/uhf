class MakeContentBlocksPolymorphic < ActiveRecord::Migration
  def self.up
    remove_index :content_blocks, :name=>"index_content_blocks_on_page_id_and_group"
    add_column :content_blocks, :blockable_id, :integer
    add_column :content_blocks, :blockable_type, :string
    ContentBlock.update_all("blockable_id=page_id, blockable_type='Page'")
    remove_column :content_blocks, :page_id
    change_column :content_blocks, :blockable_id, :integer, :null=>false
    change_column :content_blocks, :blockable_type, :string, :null=>false
    add_index :content_blocks, [:blockable_type, :blockable_id, :group], :name=>"index_content_blocks_blockable"
  end

  def self.down
    remove_index :content_blocks, :name=>"index_content_blocks_blockable"
    add_column :content_blocks, :page_id, :integer
    ContentBlock.update_all("page_id=blockable_id")
    remove_column :content_blocks, :blockable_id
    remove_column :content_blocks, :blockable_type
    add_index "content_blocks", ["page_id", "group"], :name => "index_content_blocks_on_page_id_and_group"
  end
end
