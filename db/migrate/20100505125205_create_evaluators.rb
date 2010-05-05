class CreateEvaluators < ActiveRecord::Migration
  def self.up
    create_table :evaluators do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :evaluators
  end
end
