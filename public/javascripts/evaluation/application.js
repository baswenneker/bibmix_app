var Evaluation = {
	
	'references': null,
	
	'referencePointer': 0,
	
	/**
	 * Evaluation application initialization function.
	 */
	'init': function()
	{
		this.loadEvaluationSet();
		this.initEvents();
	},
	
	'initEvents': function()
	{
		
		$('citation-request-btn').observe('click', function(){
			Evaluation.setCurrentItem({
				citation: {
					'ref': this.innerHTML
				}
			});
		});
		
		$('eval-ok').observe('click', function(){
			this.eval(true);
		}.bind(this));
		
		$('eval-not-ok').observe('click', function(){
			this.eval(false);
		}.bind(this));
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
		$('citation').update(this.currentItem.citation);
		this.loadComparisonTable(this.currentItem); 
	},
	
	'loadComparisonTable': function(item)
	{
		this.currentTable = new RecordComparisonTable(item, $('comparison-table-container'));
	},
	
	'eval': function(citationIsOk)
	{
		
		new Ajax.Request('/evaluations/new', 
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
		);
	}
};

document.observe("dom:loaded", Evaluation.init.bind(Evaluation));
