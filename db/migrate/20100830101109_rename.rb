class Rename < ActiveRecord::Migration
  def self.up
  	rename_column "eval_references", "annotate", "annote"
  end

  def self.down
  	rename_column "eval_references", "annote", "annotate"
  end
end
