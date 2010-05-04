var RecordComparisonTable = Class.create(AbstractComparisonTable, {
	'initialize': function($super, item, container)
	{
		$super(item, container);
		this.setupFields();
		this.loadComparisonData();
	},
	
	'loadComparisonData': function(item)
	{
		item = item || this.item;
		console.log(item)
		new Ajax.Request('/parscit/show', 
			{	
				method: 'post',
				parameters: {
					citation: item.ref
				},
				requestHeaders: {Accept:'application/jsonrequest'},
				onFail: function(){ alert('Could not retrieve comparison data.'); },
				onSuccess: function(transport) { 
					this.setComparisonData(transport.responseJSON); 
				}.bind(this)
			}
		);	
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
