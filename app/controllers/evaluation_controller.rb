require "yaml"
class EvaluationController < ApplicationController
  
  EVALUATION_SET_FILE = "#{File.dirname(__FILE__)}/evaluation/evaluation_set.yml"
  
  def index
  end

  def new
  end

	def evaluation_set_js 		
 		f = File.open(EVALUATION_SET_FILE, 'r')
    references = YAML::load(f)
 		
 		respond_to do |format|  		
  		format.json { 
  			render :json => references
  		}
  	end
 	end
end
