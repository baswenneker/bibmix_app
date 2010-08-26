class CreateEvalReferences < ActiveRecord::Migration
  def self.up
    create_table :eval_references do |t|
      t.string :referencetype
      t.string :address
      t.text :annotate
      t.text :author
      t.text :booktitle
      t.string :chapter
      t.string :crossref
      t.string :edition
      t.text :editor
      t.string :howpublished
      t.string :institution
      t.string :journal
      t.string :key
      t.string :month
      t.string :note
      t.string :number
      t.string :organization
      t.string :pages
      t.string :publisher
      t.string :school
      t.string :series
      t.text :title
      t.string :type
      t.string :volume
      t.string :year

      t.timestamps
    end
  end

  def self.down
    drop_table :eval_references
  end
end
