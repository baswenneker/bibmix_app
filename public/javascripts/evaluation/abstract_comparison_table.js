var AbstractComparisonTable = Class.create();

AbstractComparisonTable.prototype = (function(){
// Private variables.	
var fields = [];

// Public variables/methods.
return {	
	
	'initialize': function(){},
	
	'addField': function(field)
	{
		// Set default properties.
		field = Object.extend({
			'type': 'string'
		}, field);
		
		// Push the field on the fields array.
		fields.push(field);		
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
