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
	
	'addFields': function()
	{
		for (var index = 0; index < arguments.length; ++index) {
			this.addField(arguments[index])
		}
	},
	
	'addField': function(field)
	{
		// Set default properties.
		//field = Object.extend({
			//'type': 'string'
		//}, field);
		
		// Push the field on the fields array.
		fields.push(field);		
	},
	
	'getComparisonFieldData': function(field)
	{
		console.log(field)
		var data = this.getComparisonData();
		console.log(data)
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
