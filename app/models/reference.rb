class Reference < ActiveRecord::Base
	def self.create_with_parscit(str)
		if str.nil? || str.eql?("")
      raise 'Citation string is nil or empty'
    end
    
    #parscit_dir = "/home/bas/Documents/parscit-100401"
    parscit_dir = "/Users/bas/Documents/parscit-100401"
    parscit_cmd = "#{parscit_dir}/bin/parseRefStrings.pl"
    
    # Convert the passed string to UTF-8, this prevents possible
    # seg faults in parseRefStrings.pl.
    ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
    valid_string = ic.iconv(str << ' ')[0..-2]
    
    # The ParsCit executable only reads from file so create a
    # temporary file and fill it with the citation string.
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
    
		citation.keys.reject {|k| self.column_names.include?(k)}.each {|k|
      citation.delete k
    }
    
    citation['citation'] = str
    citation['parser'] = 'parscit'
		self.create(citation)
	end
	
	def to_hash
		
		block = ['id', 'created_at', 'updated_at', 'author', 'authors', 'parser']
		hash = self.attributes.inject({}) do |result, element|
		  if !block.include?(element.first)
		  	result[element.first] = element.last
		 	end
		 	result
		end
		
		hash['author'] = self.authors['author']
		hash
	end
end
