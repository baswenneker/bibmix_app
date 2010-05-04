var Evaluation = {
	
	'references': null,
	
	/**
	 * Evaluation application initialization function.
	 */
	'init': function()
	{
		this.loadEvaluationSet();
	},
	
	/**
	 * Loads the evaluation set from the server and stores it in this.references.
	 */
	'loadEvaluationSet': function()
	{
		new Ajax.Request('/evaluation/evaluation_set_js', 
			{
				method: 'get',
				onFail: function(){ alert('Could not retrieve evaluation set.'); },
				onSuccess: function(transport) { 
					this.references = transport.responseJSON;
					this.loadComparisonTable(this.references.first()); 
				}.bind(this)
			}
		);
	},
	
	'loadComparisonTable': function(item)
	{
		new RecordComparisonTable(item, $('comparison-table-container'));
	}	
};

document.observe("dom:loaded", Evaluation.init.bind(Evaluation));
