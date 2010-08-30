class WebserviceController < ApplicationController
  def index
  	
  	puts request
  	
  	ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
	  citation = ic.iconv(params[:citation] << ' ')[0..-2]
  	
  	x = Bibmix::Pipeline.instance.execute_pipeline(citation)
  	
  	respond_to do |format|
  		format.json  { render :json => {:reference => x } }
  	end
  	
  end

end
