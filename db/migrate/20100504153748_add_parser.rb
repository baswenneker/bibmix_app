class AddParser < ActiveRecord::Migration
  def self.up
  	add_column :references, :parser, :text
  end

  def self.down
  	remove_column :references, :parser
  end
end
