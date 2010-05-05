var Evaluation = {
	
	'references': null,
	
	/**
	 * Evaluation application initialization function.
	 */
	'init': function()
	{
		this.loadEvaluationSet();
		$('citation-request-btn').addEvent('click', function(){
			Evaluation.setCurrentItem({
				'ref': this.innerHTML
			});
		});
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
					try {
						this.setCurrentItem(this.references.first());
					}catch(e){
						console.log(e)
					}
				}.bind(this)
			}
		);
	},
	
	'setCurrentItem': function(item)
	{
		this.currentItem = item;
		$('citation').update(item.ref)
		this.loadComparisonTable(item); 
	},
	
	'loadComparisonTable': function(item)
	{
		new RecordComparisonTable(item, $('comparison-table-container'));
	}
};

document.observe("dom:loaded", Evaluation.init.bind(Evaluation));
