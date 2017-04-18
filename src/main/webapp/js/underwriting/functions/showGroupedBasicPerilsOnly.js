function showGroupedBasicPerilsOnly(){
	$("cPerilCd").childElements().each(function (i) {
		if (i.getAttribute("perilType") == "B"){
			showOption(i);
		}else{
			hideOption(i);
		}
	});
}