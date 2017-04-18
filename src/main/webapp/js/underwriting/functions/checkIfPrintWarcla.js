function checkIfPrintWarcla(){
	if (nvl($F("vWarcla"),$F("vWarcla3")) != "Y"){
		$("docType").childElements().each(function (o) {
			if (o.value == "WARRANTIES AND CLAUSES"){
				hideOption(o);
			}
		});
	}
} //Dren 02.02.2016 SR-5266