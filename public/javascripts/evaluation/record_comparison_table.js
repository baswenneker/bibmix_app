var RecordComparisonTable = Class.create(AbstractComparisonTable, {
	'initialize': function(data)
	{
		this.setupFields();
	},
	
	'setupFields': function()
	{
		
		this.addField({
			'name': 'title',
		});
		
		this.addField({
			'name': 'author',
			'type': 'array'
		});
	},
	
	'render': function(element)
	{
		element = $(element);
		table = new Element('table',{
			className: 'test'
			
		});
	}
});
