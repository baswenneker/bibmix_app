class Evaluation < ActiveRecord::Base
  belongs_to :evaluator
  belongs_to :citation
end
