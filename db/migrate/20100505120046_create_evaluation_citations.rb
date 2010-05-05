class CreateEvaluationCitations < ActiveRecord::Migration
  def self.up
    create_table :evaluation_citations do |t|
      t.text :citation

      t.timestamps
    end
  end

  def self.down
    drop_table :evaluation_citations
  end
end
