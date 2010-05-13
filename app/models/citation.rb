class Citation < ActiveRecord::Base
	has_many :evaluations
	
	def to_s
		self.citation
	end
end
