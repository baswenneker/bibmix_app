class EvaluationCitationsController < ApplicationController
  # GET /evaluation_citations
  # GET /evaluation_citations.xml
  def index
    @evaluation_citations = EvaluationCitation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @evaluation_citations }
    end
  end

  # GET /evaluation_citations/1
  # GET /evaluation_citations/1.xml
  def show
    @evaluation_citation = EvaluationCitation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @evaluation_citation }
    end
  end

  # GET /evaluation_citations/new
  # GET /evaluation_citations/new.xml
  def new
    @evaluation_citation = EvaluationCitation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @evaluation_citation }
    end
  end

  # GET /evaluation_citations/1/edit
  def edit
    @evaluation_citation = EvaluationCitation.find(params[:id])
  end

  # POST /evaluation_citations
  # POST /evaluation_citations.xml
  def create
    @evaluation_citation = EvaluationCitation.new(params[:evaluation_citation])

    respond_to do |format|
      if @evaluation_citation.save
        flash[:notice] = 'EvaluationCitation was successfully created.'
        format.html { redirect_to(@evaluation_citation) }
        format.xml  { render :xml => @evaluation_citation, :status => :created, :location => @evaluation_citation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @evaluation_citation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /evaluation_citations/1
  # PUT /evaluation_citations/1.xml
  def update
    @evaluation_citation = EvaluationCitation.find(params[:id])

    respond_to do |format|
      if @evaluation_citation.update_attributes(params[:evaluation_citation])
        flash[:notice] = 'EvaluationCitation was successfully updated.'
        format.html { redirect_to(@evaluation_citation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @evaluation_citation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /evaluation_citations/1
  # DELETE /evaluation_citations/1.xml
  def destroy
    @evaluation_citation = EvaluationCitation.find(params[:id])
    @evaluation_citation.destroy

    respond_to do |format|
      format.html { redirect_to(evaluation_citations_url) }
      format.xml  { head :ok }
    end
  end
end
