function showBasicPerilsOnly(){
	$("perilCd").childElements().each(function (o) {
		if (o.getAttribute("perilType") == "B"){
			showOption(o);
		}
	});
}