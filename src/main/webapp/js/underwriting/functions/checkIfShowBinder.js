function checkIfShowBinder(){
	if ("Y" != $F("policyDsDtlExist")){
		$("docType").childElements().each(function (o) {
			if (o.value == "BINDER"){
				//o.hide();
				hideOption(o);
			}
		});
	}
}