class CreateCitations < ActiveRecord::Migration
  def self.up
    create_table :citations do |t|
      t.text :citation

      t.timestamps
    end
  end

  def self.down
    drop_table :citations
  end
end
