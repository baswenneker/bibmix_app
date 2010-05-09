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
