var RecordComparisonTable = Class.create(AbstractComparisonTable, {
	'initialize': function($super, citation_id, container)
	{
		$super(citation_id, container);
		$('eval-container').toggleClassName('hidden');
		this.setupFields();
		this.loadComparisonData();
	},
	
	'loadComparisonData': function(citation_id)
	{
		citation_id = citation_id || this.citation_id;

		new Ajax.Request('/citations/parse', 
			{	
				method: 'post',
				parameters: {
					id: citation_id
				},
				requestHeaders: {Accept:'application/jsonrequest'},
				onFail: function(){ alert('Could not retrieve comparison data.'); },
				onSuccess: function(transport) {
					this.setComparisonData(transport.responseJSON);
					this.render();
				}.bind(this)
			}
		);	
	},
	
	'setupFields': function()
	{
		
		this.addFields(
			// Valid bibtex fields
			'title', 'author', 'address', 'annotate', 
			'booktitle', 'chapter', 'crossref',
			'edition', 'editor', 'howpublished',
			'institution', 'journal', 'key',
			'month', 'note', 'number',
			'organization', 'pages', 'publisher',
			'school', 'series', 
			'type', 'volume', 'year',
			// Fields also returned by bibsonomy.
			'entrytype', 'tags', 'intrahash',
			// The complete citation', if any.
			'citation'		
		);
		
	},
	
	'render': function(element)
	{
		element = $(element) || this.container;
		var table = new Element('table',{
			className: 'comparison-table'
		})
		//.insert('<col width="20"/><col width="40"/><col width="40"/>')
		.insert('<tr><th>&nbsp;</th><th>Parsed</th><th>Enhanced</th></tr>');
		
		this.getFields().each(function(field){
			if (['citation', 'intrahash'].indexOf(field) == -1) {
				var fieldData = this.getComparisonFieldData(field);
				if (Object.isString(fieldData[0]) && Object.isString(fieldData[1])) {
					table.insert('<tr>' +
						'<td class="c-td-index">' +
						field +
						'</td>' +
						'<td class="c-td-parsed">' +
						fieldData[0] +
						'</td>' +
						'<td class="c-td-enhanced">' +
						fieldData[1] +
						'</td>' +
					'</tr>');
				} else if (Object.isArray(fieldData[0]) || Object.isArray(fieldData[1])) {
					if (!Object.isArray(fieldData[0])) {
						fieldData[0] = [fieldData[0]];
					} else if (!Object.isArray(fieldData[1])) {
						fieldData[1] = [fieldData[1]];
					}
					
					fieldData[0] = fieldData[0].sort();
					fieldData[1] = fieldData[1].sort();
					var length = Math.max(fieldData[0].length, fieldData[1].length);
					for (var i = 0; i < length; i++) {
						table.insert('<tr>' +
							'<td class="c-td-index">' +
							field +
							'</td>' +
							'<td class="c-td-parsed">' +
							(fieldData[0][i] || '') +
							'</td>' +
							'<td class="c-td-enhanced">' +
							(fieldData[1][i] || '') +
							'</td>' +
						'</tr>');
					}
				}
			}
		}.bind(this));
		
		element.insert(table)
		$('eval-container').toggleClassName('hidden');
	}
});
