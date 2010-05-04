class EvaluationController < ApplicationController
  
  EVALUATION_SET_FILE = "#{File.dirname(__FILE__)}/evaluation/evaluation_set.yml"
  
  def index
 	end
 
 	def evaluation_set 		
 		f = File.open(GOAL_FIXTURE_FILE, 'r')
    references = YAML::load(f)
 		
 		respond_to do |format|  		
  		format.json { 
  			render :json => references
  		}
  	end
 	end

end
