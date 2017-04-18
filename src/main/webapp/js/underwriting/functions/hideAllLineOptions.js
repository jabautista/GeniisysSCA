function hideAllLineOptions(){
	$("linecd").childElements().each(function(o){
		o.hide(); o.disabled = true;
	});
}