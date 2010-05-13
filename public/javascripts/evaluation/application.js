var Evaluation = {
	
	'references': null,
	
	'referencePointer': 0,
	
	'defaultParser': 'parscit',
	
	/**
	 * Evaluation application initialization function.
	 */
	'init': function()
	{
		this.initForm();
		this.loadComparisonTable();
	},
	
	'initForm': function()
	{
		
		var parser = null;
		if($('radio-parscit').checked){
			parser = 'parscit';			
		}else if($('radio-freecite').checked){
			parser = 'freecite';
		}else{
			parser = this.defaultParser;
			$('radio-'+parser).checked = 'checked';
		}
	},
	
	'loadComparisonTable': function()
	{
		var value = $('citation-id').getValue();
		if(!value){
			alert('No citation id found!');
			return;			
		}

		new RecordComparisonTable(value, $('comparison-table-container'));
	},
	
	/**
	 * Loads the evaluation set from the server and stores it in this.references.
	 */
	'loadEvaluationSet': function()
	{
		
		new Ajax.Request('/citations', 
			{
				method: 'get',
				requestHeaders: {Accept:'application/jsonrequest'},
				onFail: function(){ alert('Could not retrieve evaluation set.'); },
				onSuccess: function(transport) { 
					this.references = transport.responseJSON;
					this.setCurrentItem(this.references[this.referencePointer]);
				}.bind(this)
			}
		);
	},
	
	'setCurrentItem': function(item)
	{
		this.currentItem = item.citation;
		this.loadComparisonTable(this.currentItem); 
	},
	
	'loadComparisonTable2': function(item)
	{
		this.currentTable = new RecordComparisonTable(item, $('comparison-table-container'));
	},
	
	'eval': function(citationIsOk)
	{
		
		Form.request($('evaluation-form'),{
			//method: 'get',
			//parameters: { evaluation:citationIsOk },
			onFail: function(){ alert('Could not send evaluation.'); },
			onSuccess: function(transport) {
				if(this.references.length < this.referencePointer){
					alert('Finished evaluation');
				}else{
					this.setCurrentItem(this.references[++this.referencePointer]);						
				}
			}.bind(this)
		});
		
		/*new Ajax.Request('/evaluations/new', 
			{
				method: 'post',
				parameters: {
					'evaluator': $('evaluator').getValue(),
					'citation_id': this.currentTable.item.id,
					'evaluation': citationIsOk
				},
				onFail: function(){ alert('Could not send evaluation.'); },
				onSuccess: function(transport) {
					if(this.references.length < this.referencePointer){
						alert('Finished evaluation');
					}else{
						this.setCurrentItem(this.references[++this.referencePointer]);						
					}
				}.bind(this)
			}
		);*/
	}
};

document.observe("dom:loaded", Evaluation.init.bind(Evaluation));
