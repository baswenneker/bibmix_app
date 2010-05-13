class EvaluationsController < ApplicationController
  # GET /evaluations
  # GET /evaluations.xml
  def index
    @evaluations = Evaluation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @evaluations }
    end
  end

  # GET /evaluations/1
  # GET /evaluations/1.xml
  def show
		
		default_evaluator_id = 33078332
		
  	begin
  		@evaluation = Evaluation.find(params[:id], :include => :citation)
  		@citation = @evaluation.citation
  	rescue ActiveRecord::RecordNotFound
  		@evaluation = Evaluation.new
  		if default_evaluator_id
  			evaluator = Evaluator.find(default_evaluator_id)
  		else
  			evaluator = Evaluator.first(:conditions => ['email = "b.wenneker@gmail.com"'])
  		end
  		
  		@citation = find_next_citation(evaluator.id)
  	end
		
		if request.post?
			if default_evaluator_id
  			evaluator = Evaluator.find(default_evaluator_id)
  		else
  			evaluator = Evaluator.first(:conditions => ['email = ?', params[:evaluator]])
  		end

			if evaluator.nil?
				evaluator = Evaluator.create({:email => params[:evaluator]})
			end
			
			@evaluation.evaluator = evaluator
			@evaluation.citation = Citation.find(params[:citation_id])
			@evaluation.note = params[:note]
			@evaluation.result = params[:evaluation]
			@evaluation.parser = params[:parser]
			@evaluation.save
			
			@evaluation = Evaluation.new
			@evaluation.evaluator = evaluator
  		@citation = find_next_citation(evaluator.id)
		end
	
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @evaluation }
    end
  end

  # GET /evaluations/new
  # GET /evaluations/new.xml
  def new
    @evaluation = Evaluation.new
		
		if request.post?
			evaluator = Evaluator.first(:conditions => ['email = ?', params[:evaluator]])
			if evaluator.nil?
				evaluator = Evaluator.create({:email => params[:evaluator]})
			end
			
			@evaluation.evaluator = evaluator
			@evaluation.citation = Citation.find(params[:citation_id])
			@evaluation.result = params[:evaluation]
			@evaluation.parser = params[:parser]
			@evaluation.save
		end
		
    respond_to do |format|
      #format.html # new.html.erb
      format.xml  { render :xml => @evaluation }
    end
  end

  # GET /evaluations/1/edit
  def edit
    @evaluation = Evaluation.find(params[:id])
  end

  # POST /evaluations
  # POST /evaluations.xml
  def create
    @evaluation = Evaluation.new(params[:evaluation])

    respond_to do |format|
      if @evaluation.save
        flash[:notice] = 'Evaluation was successfully created.'
        format.html { redirect_to(@evaluation) }
        format.xml  { render :xml => @evaluation, :status => :created, :location => @evaluation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @evaluation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /evaluations/1
  # PUT /evaluations/1.xml
  def update
    @evaluation = Evaluation.find(params[:id])

    respond_to do |format|
      if @evaluation.update_attributes(params[:evaluation])
        flash[:notice] = 'Evaluation was successfully updated.'
        format.html { redirect_to(@evaluation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @evaluation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /evaluations/1
  # DELETE /evaluations/1.xml
  def destroy
    @evaluation = Evaluation.find(params[:id])
    @evaluation.destroy

    respond_to do |format|
      format.html { redirect_to(evaluations_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  def find_next_citation(evaluator_id=nil)

  	if evaluator_id
  		begin
  			citation = Citation.first(:conditions => ["citations.id not in (SELECT e.citation_id FROM evaluations e WHERE e.evaluator_id = ?)", evaluator_id])
	  		return citation if not citation.nil?
	  	rescue ActiveRecord::RecordNotFound
	  	end 
  	end
  	
  	begin
  		citation = Citation.first(:joins => ',evaluations ', :conditions => ["citations.id not in (SELECT e.citation_id FROM evaluations e)"])
	  	return citation if not citation.nil?
	  rescue ActiveRecord::RecordNotFound
	  end 
  	
  	begin
  		citation = Citation.first()
  		return citation
  	rescue ActiveRecord::RecordNotFound
  	end
  end
end
