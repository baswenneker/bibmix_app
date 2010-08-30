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
	
	def calc_empty_fields
		
		enriched_results = EvalReference.all(:conditions => { :referencetype => 'enriched'})
		attrs = get_reference_attrs
		x = {}
		attrs.each do |attr|
			x[attr] = 0
		end
		
		enriched_results.each do |enriched|
			attrs.each do |attr|
				x[attr] += 1 if enriched.has_attr(attr)
			end
		end
		
		
		attrs.each do |attr|
			val = ((x[attr].to_f/enriched_results.size)*100).round(1)
			puts "#{attr}\t\t&#{val}"+'\\\\'
		end
	end
	
	def calc_not_parsed_stats
		#:id => 26, 
		expert_results = EvalReference.all(:conditions => { :referencetype => 'expert', :status => '1'})
		
		attrs = get_reference_attrs
		
		tp, fp, tn, fn, weight = {}, {}, {}, {}, {}
		
		
		
		attrs.delete('chapter')
		attrs.delete('school')
		attrs.delete('status')
		attrs.delete('howpublished')
		attrs.delete('edition')
		
		enriched_results = EvalReference.all(:conditions => { :referencetype => 'enriched'})
				
		attrs.each do |attr|
			tp[attr] = 0
			fp[attr] = 0
			tn[attr] = 0
			fn[attr] = 0
			weight[attr] = 0
		end
		
		enriched_results.each do |enriched|
			attrs.each do |attr|
		#		weight[attr] += 1 if enriched.has_attr(attr)
			end
		end
		
		attrs.each do |attr|
			#weight[attr] = ((weight[attr].to_f/enriched_results.size)*100).round(1)
			puts "#{attr}\t\t&#{weight[attr]}"+'\\\\'
		end
		
		c = 0
		expert_results.each do |expert|
			enriched = EvalReference.find(:first, :conditions => {:referencetype => 'enriched', :citation => expert.citation})
			parsed = EvalReference.find(:first, :conditions => {:referencetype => 'parsed', :citation => expert.citation})
			
			# expert.id, enriched.id, enriched.to_yaml, expert.to_yaml
			
			attrs.each do |attr|
				
				#weight[attr] += 1
				# precision
				if enriched.has_attr(attr)
					x = attr
						#
					if enriched[attr] == expert[attr]
						# True positive: Sick people correctly diagnosed as sick
						# TP: gevonden en hetzelfde als expert
						
						if enriched[attr] == parsed[attr]
							
							#puts attr
							next
						end
						
						weight[attr] +=1
						
						tp[attr] += 1
					else
						# False positive: Healthy people incorrectly identified as sick
						# FP: gevonden en niet hetzelfde als expert
						fp[attr] += 1
					end
				else
					
					if !expert.has_attr(attr)
						#tn: niets gevonden en expert ook niet
						tn[attr] += 1
					else
						#fn: niets gevonden maar expert wel
						fn[attr] += 1
					end 
					
				end
				
			end
			
			c += 1
			
		end
		
		
		puts "measure:\t\t Precision\t\tRecall\t\tF"	
		
		afp, afr, aff = 0, 0, 0
		afpw, afrw, affw = 0, 0, 0
		weightsum = 0
		nanat = []
		attrs.each do |attr|
			
			if tp[attr] == 0
				precision = 0.0
			else
				precision = ((tp[attr].to_f/(tp[attr]+fp[attr]))*100).round(1)
			end
			
			if tp[attr] == 0
				recall = 0.0
			else
				recall = ((tp[attr].to_f/(tp[attr]+fn[attr]))*100).round(1)
			end
			
			if precision == 0 or recall == 0
				f = 0.0
			else
				f = ((2*precision*recall)/(precision+recall)).round(1)
			end
			
#			if precision.nan? || recall.nan?
#				nanat << attr
#				next
#			end
			
#			precision = 1 if precision.nan?
#			recall = 1 if recall.nan?
#			f = 1 if f.nan?
			
			afp += precision
			afr += recall
			aff += f
			
			afpw += precision *weight[attr]
			afrw += recall *weight[attr]
			affw += f *weight[attr]
			#puts "#{precision} *#{weight[attr]} = #{precision*weight[attr]} == #{afpw}/#{weightsum} = #{(afpw/weightsum)}",
			weightsum += weight[attr]
			#puts attr
#			precision = (precision*100).round(1)
#			recall = (recall*100).round(1)
#			f = (f*100).round(1)
			puts '\\'+"hline "+ '\\' +"textbf{#{attr.capitalize}} & #{precision} & #{recall} & #{f} & #{((weight[attr].to_f/0.61).round(1))}" + '\\\\'			
		end
		afp = ((afp/(attrs.size-nanat.size))).round(1)
		afr = ((afr/(attrs.size-nanat.size))).round(1)
		aff = ((aff/(attrs.size-nanat.size))).round(1)
		puts "#################################"	
		puts "Totals\t\t #{afp}\t\t#{afr}\t\t#{aff}"
		
		afp = ((afpw/weightsum)).round(1)
		afr = ((afrw/weightsum)).round(1)
		aff = ((affw/weightsum)).round(1)
		puts "#################################"	
		puts "TotalsWeighted\t\t #{afpw}\t\t#{afrw}\t\t#{affw}"	
		puts weightsum
		puts attrs.size, (attrs.size-nanat.size)
		puts nanat.to_yaml
		
		
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
		
		experts = EvalReference.all(:conditions => {:referencetype => 'expert', :status => '1'})
		
		attrs = get_reference_attrs
		
		result = {}
		precision = {}
		attrs.each do |attr|
			result[attr] = 0
			precision[attr] = 0
			recall[attr] = 0
		end
		count = 0
		experts.each do |expert|
			enriched = EvalReference.find(:first, :conditions => {:referencetype => 'enriched', :citation => expert.citation})
			
			
			
			attrs.each do |attr|
								
				if enriched.has_attr(attr)
					precision[attr] += 1
				end
				
				if enriched.has_attr(attr)
					recall[attr] += 1
				end
								
				correct = !(enriched.has_attr(attr)^expert.has_attr(attr))
				
				if expert[attr].nil? || expert[attr].empty?
					correct = enriched[attr].nil? || enriched[attr].empty?
				else
					correct = enriched[attr] == expert[attr]
				end
				

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
	
	def calcstats2
		
		address_relevant = 0
		address_retrieved = 0
		expert_results = EvalReference.all(:conditions => {:referencetype => 'expert', :status => '1'})
		
		attrs = get_reference_attrs
		
		relevant = {}
		retrieved = {}
		retrieved_expert = {}
		attrs.each do |attr|
			relevant[attr] = 0
			retrieved[attr] = 0
			retrieved_expert[attr] = 0
		end
		
		c = 0
		expert_results.each do |expert|
			enriched = EvalReference.find(:first, :conditions => {:referencetype => 'enriched', :citation => expert.citation})
			
			attrs.each do |attr|
				if enriched.has_attr(attr)
					retrieved[attr] += 1
					
					if expert.has_attr(attr) && enriched[attr] == expert[attr] 
						relevant[attr] += 1
					end
				end
				
				
			
			if expert.has_attr(attr)
					retrieved_expert[attr] += 1
			end
			end
			
			c += 1
			#address_retrieved = enriched.has_attr('address')
		end
		
	#	puts address_retrieved, address_relevant, address_relevant/address_retrieved.to_f, address_relevant/c.to_f
		
		puts c
		
		attrs.each do |attr|
			recall = relevant[attr].to_f/retrieved_expert[attr].to_f
			precision = relevant[attr].to_f/retrieved[attr].to_f
			puts "#{attr}:\t\t #{precision}\t\t#{recall}"			
		end
		
	end
	
	def calcstats3
		
		expert_results = EvalReference.all(:conditions => {:referencetype => 'expert', :status => '1'})
		
		attrs = get_reference_attrs
		
		enriched_correct = {}
		enriched_retrieved = {}
		expert_retrieved = {}
		attrs.each do |attr|
			enriched_correct[attr] = 0
			enriched_retrieved[attr] = 0
			expert_retrieved[attr] = 0
		end
		
		c = 0
		expert_results.each do |expert|
			enriched = EvalReference.find(:first, :conditions => {:referencetype => 'enriched', :citation => expert.citation})
			
			attrs.each do |attr|
				# precision
				if enriched.has_attr(attr)
					if enriched[attr] == expert[attr]
						enriched_correct[attr] += 1
					end
					enriched_retrieved[attr] += 1
					
				end
#				correct = false
#				if expert[attr].nil? || expert[attr].empty?
#					correct = enriched[attr].nil? || enriched[attr].empty?
#				else
#					correct = enriched[attr] == expert[attr]
#				end
				
#				if correct
#					enriched_correct[attr] += 1
#				end
				
				if expert.has_attr(attr)
					expert_retrieved[attr] += 1
				end
			end
			
			c += 1
			
		end
		
		
		attrs.each do |attr|
			
			precision = enriched_correct[attr]/c.to_f
			recall = enriched_correct[attr]/expert_retrieved[attr].to_f
			puts "#{attr}:\t\t #{precision}\t\t#{recall}"			
		end
		
	end
	
	def calcstats4
		
		expert_results = EvalReference.all(:conditions => {:referencetype => 'expert', :status => '1'})
		
		attrs = get_reference_attrs
		
		tp, fp, tn, fn = {}, {}, {}, {}
		
		attrs.each do |attr|
			tp[attr] = 0
			fp[attr] = 0
			tn[attr] = 0
			fn[attr] = 0
		end
		
		c = 0
		expert_results.each do |expert|
			enriched = EvalReference.find(:first, :conditions => {:referencetype => 'enriched', :citation => expert.citation})
			
			attrs.each do |attr|
				# precision
				if enriched.has_attr(attr)
					if enriched[attr] == expert[attr]
						# True positive: Sick people correctly diagnosed as sick
						# TP: gevonden en hetzelfde als expert
						tp[attr] += 1
					else
						# False positive: Healthy people incorrectly identified as sick
						# FP: gevonden en niet hetzelfde als expert
						fp[attr] += 1
					end
				else
					
					if !expert.has_attr(attr)
						#tn: niets gevonden en expert ook niet
						tn[attr] += 1
					else
						#fn: niets gevonden maar expert wel
						fn[attr] += 1
					end 
					
				end
				
				#False negative: Sick people incorrectly identified as healthy.
								

#				correct = false
#				if expert[attr].nil? || expert[attr].empty?
#					correct = enriched[attr].nil? || enriched[attr].empty?
#				else
#					correct = enriched[attr] == expert[attr]
#				end
				
#				if correct
#					enriched_correct[attr] += 1
#				end
				
#				if expert.has_attr(attr)
#					expert_retrieved[attr] += 1
#				end
			end
			
			c += 1
			
		end
		
		
		puts "measure:\t\t Precision\t\tRecall\t\tF"	
		
		afp, afr, aff = 0, 0, 0
		
		nanat = []
		attrs.each do |attr|
			
			precision = tp[attr].to_f/(tp[attr]+fp[attr])
			recall = tp[attr].to_f/(tp[attr]+fn[attr])
			f = (2*precision*recall)/(precision+recall)
			
			if precision.nan? || recall.nan?
				nanat << attr
				next
			end
			
#			precision = 1 if precision.nan?
#			recall = 1 if recall.nan?
#			f = 1 if f.nan?
			
			afp += precision
			afr += recall
			aff += f
			#puts attr
			precision = (precision*100).round(1)
			recall = (recall*100).round(1)
			f = (f*100).round(1)
			puts "\hline \textbf{#{attr.capitalize}} & #{precision} & #{recall} & #{f} \\"			
		end
		afp = ((afp/(attrs.size-nanat.size))*100).round(1)
		afr = ((afr/(attrs.size-nanat.size))*100).round(1)
		aff = ((aff/(attrs.size-nanat.size))*100).round(1)
		puts "#################################"	
		puts "Totals\t\t #{afp}\t\t#{afr}\t\t#{aff}"		
		puts attrs.size, (attrs.size-nanat.size)
		puts nanat.to_yaml
	end
	
	
	def calcstats5
		
		expert_results = EvalReference.all(:conditions => {:referencetype => 'expert', :status => '1'})
		
		attrs = get_reference_attrs
		
		tp, fp, tn, fn = {}, {}, {}, {}
		
		
		
		m = {}
		
		c = 0
		expert_results.each do |expert|
			enriched = EvalReference.find(:first, :conditions => {:referencetype => 'enriched', :citation => expert.citation})
			
			m[enriched.id] = {}
			attrs.each do |attr|
				m[enriched.id]['tp'] = 0
				m[enriched.id]['fp'] = 0
				m[enriched.id]['tn'] = 0
				m[enriched.id]['fn'] = 0
			end
			
			attrs.each do |attr|
				
				if ['annotate', 'chapter', 'edition', 'howpublished', 'school', 'status'].include?(attr)
					next					
				end
				# precision
				if enriched.has_attr(attr)
					if enriched[attr] == expert[attr]
						# True positive: Sick people correctly diagnosed as sick
						# TP: gevonden en hetzelfde als expert
						m[enriched.id]['tp'] += 1
					else
						# False positive: Healthy people incorrectly identified as sick
						# FP: gevonden en niet hetzelfde als expert
						m[enriched.id]['fp'] += 1
					end
				else
					
					if !expert.has_attr(attr)
						#tn: niets gevonden en expert ook niet
						m[enriched.id]['tn'] += 1
					else
						#fn: niets gevonden maar expert wel
						m[enriched.id]['fn'] += 1
					end 
					
				end
				
			end
			
			c += 1
			
		end
		
		puts m.to_yaml
		
		r = {}
		m.each do |id, h|
			key = (h['fp']).to_s
			if r.key?(key)
				r[key] += 1			
			else
				r[key] = 1
			end
		end
		
		puts r.to_yaml
	end
	
	def calcstats6
		
		expert_results = EvalReference.all(:conditions => {:referencetype => 'expert', :status => '1'})
		
		attrs = get_reference_attrs
		
		tp, fp, tn, fn = {}, {}, {}, {}
		
		
		
		m = []
		
		c = 0
		expert_results.each do |expert|
			enriched = EvalReference.find(:first, :conditions => {:referencetype => 'enriched', :citation => expert.citation})
			parsed = EvalReference.find(:first, :conditions => {:referencetype => 'parsed', :citation => expert.citation})
			
			hasattr = 0
			intersect = 0
			attrs.each do |attr|
				
				if expert.has_attr(attr)
					hasattr += 1
					if expert[attr] == parsed[attr]
						intersect += 1
					end
				end
			end
			
			m << intersect.to_f/hasattr
			
		end
		
		s = m.size
		sum = m.sum
		puts sum/s.to_f
	end
	
#	def calcstats7
#		
#		expert_results = EvalReference.all(:conditions => {:referencetype => 'expert', :status => '1'})
#		
#		attrs = get_reference_attrs
#		m = {}
#		
#		attrs.each do |attr|
#			m[attr] = 0			
#		end
#		c = 0
#		expert_results.each do |expert|
#			enriched = EvalReference.find(:first, :conditions => {:referencetype => 'enriched', :citation => expert.citation})
#			parsed = EvalReference.find(:first, :conditions => {:referencetype => 'parsed', :citation => expert.citation})
#			
#			hasattr = 0
#			intersect = 0
#			attrs.each do |attr|
#				
#				if enriched.has_attr(attr)
#					m[attr] += 1
#					if enriched[attr] == parsed[attr]
#						intersect += 1
#					end
#				end
#			end
#			
#			m << intersect.to_f/hasattr
#			
#		end
#		
#		s = m.size
#		sum = m.sum
#		puts m/s.to_f
#	end
	
	
	def has_attr(attr)
		!self[attr].nil? && !self[attr].empty?
	end
	
	def to_s
		"<EvalReference(#{self.citation})>"
	end
	
end
