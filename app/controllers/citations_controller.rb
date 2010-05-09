require 'bibmix'

class CitationsController < ApplicationController
	
	PARSER_FREECITE = 'freecite'
	PARSER_PARSCIT = 'parscit'
	DEFAULT_PARSER = PARSER_PARSCIT
	
  # GET /citations
  # GET /citations.xml
  def index
    @citations = Citation.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @citations }
      format.xml  { render :xml => @citations }
    end
  end

  # GET /citations/1
  # GET /citations/1.xml
  def show
    @citation = Citation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @citation }
    end
  end

  # GET /citations/new
  # GET /citations/new.xml
  def new
    @citation = Citation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @citation }
    end
  end

  # GET /citations/1/edit
  def edit
    @citation = Citation.find(params[:id])
  end

  # POST /citations
  # POST /citations.xml
  def create
    @citation = Citation.new(params[:citation])

    respond_to do |format|
      if @citation.save
        flash[:notice] = 'Citation was successfully created.'
        format.html { redirect_to(@citation) }
        format.xml  { render :xml => @citation, :status => :created, :location => @citation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @citation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /citations/1
  # PUT /citations/1.xml
  def update
    @citation = Citation.find(params[:id])

    respond_to do |format|
      if @citation.update_attributes(params[:citation])
        flash[:notice] = 'Citation was successfully updated.'
        format.html { redirect_to(@citation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @citation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /citations/1
  # DELETE /citations/1.xml
  def destroy
    @citation = Citation.find(params[:id])
    @citation.destroy

    respond_to do |format|
      format.html { redirect_to(citations_url) }
      format.xml  { head :ok }
    end
  end
  
  def parse
  	citation = params[:citation]
  	parser = params.fetch('parser', DEFAULT_PARSER)
  	
		if citation

			# First parse the citation with parscit.
			if parser == PARSER_PARSCIT
				hash = Reference.create_with_parscit(citation).to_hash
			elsif parser == PARSER_FREECITE
				hash = Reference.create_with_freecite(citation).to_hash
			end
			
			# Convert it to a Bibmix::Record so that it can be merged with data
			# from bibsonomy.
			record = Bibmix::Record.from_hash(hash)
			
			
			# Execute the mixing process.
	  	enhanced_record = Bibmix::Bibsonomy::MixingProcess.new(record).execute
		end
	
		respond_to do |format|
      format.json { 
  			render :json => {
  				:parsed => record,
  				:enhanced => enhanced_record
  			}
  		}
  end
end
