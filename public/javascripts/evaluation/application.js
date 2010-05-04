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
		var x = new Ajax.Request('/evaluation/evaluation_set_js', 
			{
				method: 'get',
				onFail: function(){ alert('Could not retrieve evaluation set.'); },
				onSuccess: function(transport) { this.references = transport.responseJSON; }.bind(this)
			}
		);
	},
	
	
};

document.observe("dom:loaded", Evaluation.init.bind(Evaluation));
