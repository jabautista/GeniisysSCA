function showSUOptions(){
	var lineCd = getLineCd($F("policyLineCd"));
	//if ("SU" != $F("policyLineCd")){
	if ("SU" != lineCd){ //robert
		$("docType").childElements().each(function (o) {
			if ((o.value == "ACK") || (o.value == "AOJ") || (o.value == "INDEMNITY") || (o.value == "POLICY_SU")){
				//o.hide();
				hideOption(o);
			}
		});
	} else {
		$("docType").childElements().each(function (o) {
			if (o.value == "POLICY"){
				//o.hide();
				hideOption(o);
			}
		});
		$("btnAddtlInfoSU").show();
	}
}