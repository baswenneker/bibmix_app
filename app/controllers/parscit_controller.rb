require 'tempfile'
require 'bibmix'

class ParscitController < ApplicationController
  
  def show
  	citation = params[:citation]
  	
  	@parscit_record_yaml = 'Please make a request.'
  	@enhanced_record_yaml = ''
		if citation

			# First parse the citation with parscit.
			hash = parseWithParsCit(citation)
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
    end
 end
 
private
	def parseWithParsCit(str)
		if str.nil? || str.eql?("")
      raise 'Citation string is nil or empty'
    end
    
    parscit_dir = "/home/bas/Documents/parscit-100401"
    parscit_cmd = "#{parscit_dir}/bin/parseRefStrings.pl"
    
    # Convert the passed string to UTF-8, this prevents possible
    # seg faults in parseRefStrings.pl.
    ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
    valid_string = ic.iconv(str << ' ')[0..-2]
    
    # The ParsCit executable only reads from file so create a
    # temporary file an fill it with the citation string.
    tmp = Tempfile.new("parscit_parser_tmp")
    tmp.binmode
    tmp.puts(valid_string)
    tmp.close()
      
    xml = `perl "#{parscit_cmd}" "#{tmp.path()}"`    
    hsh = Hash.from_xml(xml)
    
    citation = hsh['algorithm']['citationList']['citation']
    
    tmp.unlink
    
    if citation.is_a?(Hash)
      citation
    elsif citation.is_a?(Array) && citation.length
      citation[0]
    else
      raise "Invalid citation datatype or no citations found (ln=#{citation.length})"
    end 
	end

end