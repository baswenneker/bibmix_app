require 'test_helper'
require 'bibmix'

class EvalReferenceTest < ActiveSupport::TestCase
  
  def _test_stats
  	EvalReference.new.calcstats
  end
  
  def test_run
  	File.open("#{File.dirname(__FILE__)}/flux-cim-cs.txt") do |f| 
			
			line_no = 0
			bugs = 0
			while citation = f.readline do 
				citation = citation.strip
				ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
	    	citation = ic.iconv(citation << ' ')[0..-2]
				
				if !EvalReference.exists?(:referencetype => "parsed", :citation => citation)
					extracted_citation_metadata = Bibmix::Parscit.new.parse_citation(citation)		
					
					reference = Bibmix::ParscitMetadataProcessor.process_metadata(extracted_citation_metadata)
					pref = EvalReference.new
					pref.from_bibmix_reference(reference)
					pref.referencetype = 'parsed'
					pref.save
				end
				
				if !EvalReference.exists?(:referencetype => "enriched", :citation => citation)
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
					
					clone = eref.clone
					clone.referencetype = 'expert'
					clone.save
					puts "saved #{citation}"
				end
				
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
