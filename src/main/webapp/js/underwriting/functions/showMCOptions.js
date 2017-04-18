function showMCOptions(){
	if ("MC" != getLineCd($F("policyLineCd")) && $F("withMc") != "Y"){ //getLineCd added by jeffdojello 06.06.2013
		$("docType").childElements().each(function (o) {
			if ((o.value == "COC") || (o.value == "FLEET TAG")){
				//o.hide();
				hideOption(o);
			}
		});
	}
}