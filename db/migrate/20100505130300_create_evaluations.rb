class CreateEvaluations < ActiveRecord::Migration
  def self.up
    create_table :evaluations do |t|
      t.references :evaluator
      t.references :evaluation_citation
      t.string :parser
      t.string :process
      t.boolean :result
      t.string :note

      t.timestamps
    end
  end

  def self.down
    drop_table :evaluations
  end
end
