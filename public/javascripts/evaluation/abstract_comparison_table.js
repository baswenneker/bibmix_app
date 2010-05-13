var AbstractComparisonTable = Class.create();

AbstractComparisonTable.prototype = (function(){
// Private variables.	
var fields = [], comparisonData = null;

// Public variables/methods.
return {	
	
	'container': null,
	'item': null,
	
	'initialize': function(citation_id, container)
	{
		this.citation_id = citation_id;		
		this.container = $(container);
		this.container.innerHTML  = '';		
	},
	
	'addFields': function()
	{
		for (var index = 0; index < arguments.length; ++index) {
			this.addField(arguments[index])
		}
	},
	
	'addField': function(field)
	{
		// Push the field on the fields array.
		if (fields.indexOf(field) === -1) {
			fields.push(field);
		}		
	},
	
	'getComparisonFieldData': function(field)
	{
		var data = this.getComparisonData();
		var parsed = data['parsed'][field]||'';
		var enhanced = data['enhanced'][field]||'';
		return [parsed, enhanced];
	},
	
	'setComparisonData': function(newComparisonData)
	{
		comparisonData = newComparisonData;		
	},
	
	'getComparisonData': function()
	{
		return comparisonData;		
	},
	
	'setFields': function(newFields)
	{
		fields = newFields;		
	},
	
	'getFields': function()
	{
		return fields;		
	}
};
})();
