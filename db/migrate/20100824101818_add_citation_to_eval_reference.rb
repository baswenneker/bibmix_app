class AddCitationToEvalReference < ActiveRecord::Migration
  def self.up
  	add_column "eval_references", "citation", :text
  end

  def self.down
  	remove_column "eval_references", "citation"
  end
end
