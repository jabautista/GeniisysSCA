function showAllLineOptions(){
	$("linecd").childElements().each(function(o){
		o.show(); o.disabled = false;
	});
}