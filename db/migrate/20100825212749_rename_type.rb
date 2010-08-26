class RenameType < ActiveRecord::Migration
  def self.up
  	rename_column "eval_references", "type", "mytype"
  end

  def self.down
  	rename_column "eval_references", "mytype", "type"
  end
end
