function hideAllGroupedItemPerilOptions(){
	$("cPerilCd").childElements().each(function (o) {
		hideOption(o);
	});
}