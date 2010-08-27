class EvalReferencesController < ApplicationController
  # GET /eval_references
  # GET /eval_references.xml
  def index
    @eval_references = EvalReference.all(:conditions => {:referencetype => 'expert', :status => '1'}, :order => "status ASC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @eval_references }
    end
  end

  # GET /eval_references/1
  # GET /eval_references/1.xml
  def show
    @eval_reference = EvalReference.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @eval_reference }
    end
  end

  # GET /eval_references/new
  # GET /eval_references/new.xml
  def new
    @eval_reference = EvalReference.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @eval_reference }
    end
  end

  # GET /eval_references/1/edit
  def edit
    @eval_reference = EvalReference.find(params[:id])
    @parsed_reference = EvalReference.first(:conditions => {:referencetype => 'parsed', :citation => @eval_reference.citation})
    @enriched_reference = EvalReference.first(:conditions => {:referencetype => 'enriched', :citation => @eval_reference.citation})
  end

  # POST /eval_references
  # POST /eval_references.xml
  def create
    @eval_reference = EvalReference.new(params[:eval_reference])

    respond_to do |format|
      if @eval_reference.save
        flash[:notice] = 'EvalReference was successfully created.'
        format.html { redirect_to(@eval_reference) }
        format.xml  { render :xml => @eval_reference, :status => :created, :location => @eval_reference }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @eval_reference.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /eval_references/1
  # PUT /eval_references/1.xml
  def update
    @eval_reference = EvalReference.find(params[:id])

    respond_to do |format|
      if @eval_reference.update_attributes(params[:eval_reference])
        flash[:notice] = 'EvalReference was successfully updated.'
        format.html { redirect_to(:action => 'index') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @eval_reference.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /eval_references/1
  # DELETE /eval_references/1.xml
  def destroy
    @eval_reference = EvalReference.find(params[:id])
    @eval_reference.destroy

    respond_to do |format|
      format.html { redirect_to(eval_references_url) }
      format.xml  { head :ok }
    end
  end
end
