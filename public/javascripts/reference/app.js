var App = {
	citationBox: null,
	queryBtn: null,
	resultBox: null,
	queryExecutionTimer: null,
	
	init: function(){
		this.citationBox = $('citation');
		this.queryBtn = $('queryBtn');
		this.resultBox = $('result');
		this.table = $('record-table');
		this.initEvents();
	},
	
	initEvents: function(){
		this.citationBox.addEvent('keydown', this.delayedQuery.bind(this));
		this.queryBtn.addEvent('click', this.query.bind(this))		
	},
	
	delayedQuery: function(){
		if (this.getCitation().length < 20) {
			this.queryBtn.set('disabled', false);
			return;
		}
		
		var delay = 2000;	
		return (function(){
			if(this.queryExecutionTimer){
				clearTimeout(this.queryExecutionTimer);
			}
			this.queryExecutionTimer = setTimeout(App.query.bind(this), delay);
		}.bind(this))()
	},
	
	getCitation: function(){
		return this.citationBox.get('value')||'';
	},
	
	query: function(){
		clearTimeout(this.queryExecutionTimer);
		this.queryBtn.set('disabled', true);
		
		var citation = this.getCitation();
		
		new Request.JSON({
			url: '/reference/create/',
			data: {citation:citation},
			onSuccess: this.showResult.bind(this)
		}).send();
	},
	
	getBlacklist: function(){
		return ['tags','intrahash','merged','citation', 'id', 'created_at', 'updated_at'];	
	},
	
	showResult: function(json){
		if(json.error){
			alert("An error occured:\n"+ json.error);
		} else {
			console.log(json)
			
			this.queryBtn.set('disabled', false);
			var ref = json.reference.reference;
//			this.resultBox.set('text', ref.citation).addClass('has-result');
			var blacklist = this.getBlacklist();
			var reference = $H(ref);
			var bib = $H(json.bibsonomy);
//			reference.each(function(value, key){
//				if(!blacklist.contains(key)){
//					var annotatedHtml = this.resultBox.get('html').replace(value, '<span class="{className}" title="{className}">{value}</span>'.substitute({
//						'value': (value+'').replace('  ', ' ').trim(),
//						'className': key
//					}));
//					this.resultBox.set('html', annotatedHtml);
//				}
//			}.bind(this));
			this.showTable([reference,bib], this.table, blacklist);
//			this.showTable(bib, $('bib-table-wrapper'));
		}
	},
	
	showTable: function(rows, target, blacklist){
		var tr = [];
		blacklist = blacklist||[];
		
		RecordFields.each(function(field){
			if (!blacklist.contains(field)) {
				
				var val1 = rows[0].get(field);
				var val2 = rows[1].get(field);
				
				if($type(val1) == 'array'){
					val1 = val1.join(', ');					
				}
				if($type(val2) == 'array'){
					val2 = val2.join(', ');					
				}
				
				tr.push(new Element('tr').adopt(new Element('td', {
					'class': 'header-td',
					'text': field
				}), new Element('td', {
					//'class': field,
					'html': val1
				}), new Element('td', {
					//'class': field,
					'html': val2
				})))
			}
		});
		
		
//		$H(reference).each(function(value, key){
//			if (value != null && !blacklist.contains(key)) {
//				if (key == 'tags'){
//					var tmp = [];
//					$H(value).each(function(v, k){
//						tmp.push('<a href="' + k + '">' + v + '</a>');
//					});
//					value = tmp;
//				}
//				
//				if($type(value) == 'array'){
//					value = value.join(', ');					
//				}
//				
//				tr.push(new Element('tr').adopt(
//					new Element('td', {
//						'text': key
//					}),
//					new Element('td', {
//						'class': key,
//						'html': value
//					})
//				))
//			}			
//		});
		 
		target.empty().adopt(new Element('table',{
			'cellspacing': 0,
			'width': '100%'
		}).adopt(
			new Element('col',{
				'width': 100
			}),
			new Element('col',{
				'width': '*'
			}),
			tr
		));		
	}
};



window.addEvent('domready', App.init.bind(App));
