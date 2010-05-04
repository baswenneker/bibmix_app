var AbstractRecord = Class.create();

AbstractRecord.prototype = (function(){
// Private variables.	
var fields = [], data = null;

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
