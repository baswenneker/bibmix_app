class AddState < ActiveRecord::Migration
   def self.up
  	add_column "eval_references", "status", :string
  end

  def self.down
  	remove_column "eval_references", "status"
  end
end
