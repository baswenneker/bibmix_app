class Evaluation < ActiveRecord::Base
  belongs_to :evaluator
  belongs_to :evaluation_citation
end
