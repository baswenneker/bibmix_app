var AbstractComparisonTable = Class.create();

AbstractComparisonTable.prototype = (function(){
// Private variables.	
var fields = [], comparisonData = null;

// Public variables/methods.
return {	
	
	'container': null,
	'item': null,
	
	'initialize': function(item, container)
	{
		this.item = item;		
		this.container = $(container);			
	},
	
	'addField': function(field)
	{
		// Set default properties.
		field = Object.extend({
			'type': 'string'
		}, field);
		
		// Push the field on the fields array.
		fields.push(field);		
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
