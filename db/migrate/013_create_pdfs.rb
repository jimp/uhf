class CreatePdfs < ActiveRecord::Migration
  def self.up
    create_table :pdfs do |t|
      
      # t.integer :parent_id
      t.integer :size
      t.string :content_type
      t.string :filename
      t.integer :page
      t.integer :language
      # t.binary :data

      t.timestamps
    end
  end

  def self.down
    drop_table :pdfs
  end
end
