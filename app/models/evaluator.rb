class Evaluator < ActiveRecord::Base
	has_many :evaluations
	
	def to_s
		self.email
	end
end
