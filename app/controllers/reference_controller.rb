class ReferenceController < ApplicationController
  
  def create
  	citation = params[:citation]
  	
  	@reference = nil
  	if citation
  		begin
	  		@reference = Reference.create_with_parscit(citation)
	  		
	  		record = Bibmix::Bibsonomy::Record.from_hash(@reference.to_hash)
	  		
	  		titlechain = Bibmix::Bibsonomy::TitleQueryChain.new(Bibmix::Bibsonomy::Chain::STATUS_NOT_MERGED)
		 		authorchain = titlechain.chain(Bibmix::Bibsonomy::AuthorQueryChain.new(Bibmix::Bibsonomy::Chain::STATUS_AUTHOR_NOT_MERGED))
		 		
		 		chainrecord = Bibmix::Bibsonomy::ChainRecord.new(record)
		 		
		 		# execute the chain of actions.
		 		chainrecord = titlechain.execute(chainrecord)
		 		bib = chainrecord.record
		 		
	  	rescue RuntimeError => e
	  		@reference = {:error => e.to_s}
	  	end	  	
  	end
  	
  	@record = Bibmix::Bibsonomy::Record.new.get_attributes
  	  	
  	respond_to do |format|
  		format.html {render :layout => 'application'}
  		format.json { render :json => {
  				:reference => @reference,
  				:bibsonomy => bib
  			}
  		}
  	end
  end
end
