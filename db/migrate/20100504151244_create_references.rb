class CreateReferences < ActiveRecord::Migration
  def self.up
    create_table :references do |t|
      t.text :citation
      t.text :authors
      t.text :title
      t.integer :year
      t.text :publisher
      t.text :location
      t.text :booktitle
      t.text :journal
      t.text :pages
      t.text :volume
      t.text :number
      t.text :institution
      t.text :editor
      t.text :note
      t.text :author

      t.timestamps
    end
  end

  def self.down
    drop_table :references
  end
end
