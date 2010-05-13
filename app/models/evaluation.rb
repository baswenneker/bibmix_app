class Evaluation < ActiveRecord::Base
  belongs_to :evaluator
  belongs_to :citation
  
  def parser 
	  self[:parser]||'parscit' 
	end
end
