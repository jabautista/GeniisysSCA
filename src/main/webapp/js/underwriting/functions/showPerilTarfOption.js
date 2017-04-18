function showPerilTarfOption(perilCd){
	if ("none" != document.getElementById("firePerilDetailsDiv").style.display){
		$("selPerilTarfCd").selectedIndex = 0;
		$("selPerilTarfCd").childElements().each(function(o){
			hideOption(o);
			if (o.getAttribute("perilCd") == perilCd){
				showOption(o);
			}
		});
	}
}