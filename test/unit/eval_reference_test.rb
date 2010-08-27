require 'test_helper'
require 'bibmix'

class EvalReferenceTest < ActiveSupport::TestCase
  
  def test_stats
  	EvalReference.new.calcstats4
  	
#  	addr1 = nil
#  	addr2 = ''
#  	
#  	x1 = !addr1.nil? && !addr1.empty?
#  	x2 = !addr2.nil? && !addr2.empty?
#  	puts x1, x2
  end
  
  def test_new_eval
  	expert_results = EvalReference.all(:conditions => {:referencetype => 'expert', :status => '1'})
  	expert_results.each do |expert|
  		ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
	    	citation = ic.iconv(expert.citation << ' ')[0..-2]
				
						x = Bibmix::Pipeline.instance.execute_pipeline(citation)

					
					eref = EvalReference.new
					eref.from_bibmix_reference(x)
					eref.referencetype = 'enriched'
					eref.save
  	end
  end
  
  def _test_run
  	File.open("#{File.dirname(__FILE__)}/flux-cim-cs.txt") do |f| 
			
			line_no = 0
			bugs = 0
			while citation = f.readline do 
				citation = citation.strip
				ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
	    	citation = ic.iconv(citation << ' ')[0..-2]
				
#				if false && !EvalReference.exists?(:referencetype => "parsed", :citation => citation)
#					extracted_citation_metadata = Bibmix::Parscit.new.parse_citation(citation)		
#					
#					reference = Bibmix::ParscitMetadataProcessor.process_metadata(extracted_citation_metadata)
#					pref = EvalReference.new
#					pref.from_bibmix_reference(reference)
#					pref.referencetype = 'parsed'
#					pref.save
#				end
				
				#if !EvalReference.exists?(:referencetype => "enriched", :citation => citation)
					puts citation
#					begin
						x = Bibmix::Pipeline.instance.execute_pipeline(citation)
#					rescue RuntimeError => e
#						puts e
#						bugs = bugs + 1
#					end
					
					eref = EvalReference.new
					eref.from_bibmix_reference(x)
					eref.referencetype = 'enriched'
					eref.save
					
#					clone = eref.clone
#					clone.referencetype = 'expert'
#					clone.save
					puts "saved #{citation}"
				#end
				
#	 			if line_no == 2
#	 				exit
#	 			end
	 			line_no += 1
			end
			puts "bugs: #{bugs}"
		end
	end
 
 def _test_run_no_save
  	File.open("#{File.dirname(__FILE__)}/test.txt") do |f| 
			
			line_no = 0
			bugs = 0
			while citation = f.readline do 
				citation = citation.strip
				ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
	    	citation = ic.iconv(citation << ' ')[0..-2]
				
				#extracted_citation_metadata = Bibmix::Parscit.new.parse_citation(citation)		
					
					#reference = Bibmix::ParscitMetadataProcessor.process_metadata(extracted_citation_metadata)
				#puts reference.to_yaml
				
#					begin
						x = Bibmix::Pipeline.instance.execute_pipeline(citation)
	puts x.to_yaml
					#puts x.to_yaml
#	 			if line_no == 2
#	 				exit
#	 			end
	 			line_no += 1
			end
			puts "bugs: #{bugs}"
		end
 	end
 
 	protected
 	
 	def x
 		
 	end
end
