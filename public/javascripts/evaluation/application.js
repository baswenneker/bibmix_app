var Evaluation = {

	'init': function()
	{
		//console.log('test');
		alert("asd");
		this.loadEvaluationSet();
	},
	
	'loadEvaluationSet': function()
	{
		new Ajax.Request('/evaluation/evaluation_set_js', 
			{
				method: 'get',
				onSuccess: function(transport) {
					console.log(arguments)
				}
			}
		);		
	}
};

document.observe("dom:loaded", Evaluation.init);
