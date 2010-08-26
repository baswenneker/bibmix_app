class EvalReference < ActiveRecord::Base
	
	def get_reference_attrs
		attrs = attribute_names
		
		attrs.delete('id')
		attrs.delete('referencetype')
		attrs.delete('citation')
		attrs.delete('created_at')
		attrs.delete('updated_at')
		
		attrs
	end
	
	def type=(t)
		self.mytype = t
	end
	
	def type
		self.mytype
	end
	
	def from_bibmix_reference(reference)
		
		attribute_names.each do |attr|
			
			val = reference.get(attr, nil)
			if !val.nil? && val.kind_of?(Array)
				val = val.join(' and ')
			end
			
			self[attr] = val
		end
		
		self.mytype = reference.type
	end
	
	def calcstats
		
		parsed = EvalReference.all(:conditions => {:referencetype => 'parsed'})
		
		attrs = get_reference_attrs
		
		result = {}
		attrs.each do |attr|
			result[attr] = 0			
		end
		count = 0
		parsed.each do |p|
			enriched = EvalReference.find(:first, :conditions => {:referencetype => 'enriched', :citation => p.citation})
			expert = EvalReference.find(:first, :conditions => {:referencetype => 'expert', :citation => p.citation})
			
			attrs.each do |attr|
								
				correct = !(enriched.has_attr(attr)^p.has_attr(attr)) && enriched[attr] == p[attr]
				

				if correct
					result[attr] += 1
				end
				
			end		
			count += 1
		end
		
		puts count
		attrs.each do |attr|
			cl = (result[attr].to_f/count)
			puts "#{attr}:\t\t #{cl}"			
		end
		
		
	end
	
	def has_attr(attr)
		!self[attr].nil? && !self[attr].empty?
	end
	
	def to_s
		"<EvalReference(#{self.citation})>"
	end
	
end
