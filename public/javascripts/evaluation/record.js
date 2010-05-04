var Record = Class.create();
Record.prototype = Object.extend(new AbstractRecord(), {
	'initialize': function(data)
	{
		this.setupFields();
		this.fill(data);
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
	}
});
