class ChangeEvaluationCitationToCitation < ActiveRecord::Migration
  def self.up
  	rename_column :evaluations, :evaluation_citation_id, :citation_id
  end

  def self.down
  	rename_column :evaluations, :citation_id, :evaluation_citation_id
  end
end
