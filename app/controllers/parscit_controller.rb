require 'tempfile'
require 'bibmix'

class ParscitController < ApplicationController
  
  def show
  	citation = params[:citation]
  	
  	@parscit_record_yaml = 'Please make a request.'
  	@enhanced_record_yaml = ''
		if citation

			# First parse the citation with parscit.
			hash = Reference.create_with_parscit(citation).to_hash
			@parscit_record_yaml = hash.to_yaml
			# Convert it to a Bibmix::Record so that it can be merged with data
			# from bibsonomy.
			record = Bibmix::Record.from_hash(hash)
			
			
			# Execute the mixing process.
	  	@enhanced_record = Bibmix::Bibsonomy::MixingProcess.new(record).execute
	  	
			@enhanced_record_yaml = @enhanced_record.to_yaml
		end
	
		respond_to do |format|
      format.html
      format.json { 
  			render :json => {
  				:parsed => record,
  				:enhanced => @enhanced_record
  			}
  		}
    end
 end


end
