function hideAllItemPerilOptions(){
	$("perilCd").childElements().each(function (o) {
		hideOption(o);
	});
}