function setENInfoPageAccordingToSubline(subline){
	
	$("weeksLbl").hide();
	$("weeksTesting").hide();
	$("constructFromSpan").hide();
	$("consLbl").hide();
	$("constructToSpan").hide();
	$("mainFromLbl").hide();
	$("mainFromSpan").hide();
	$("mainToLbl").hide();
	$("mainToSpan").hide();
	$("principalInfoDiv").hide();
	$("contractorInfoDiv").hide();
	$("mbiPolNo").hide();
	$("timeExcess").hide();
	$("sublineCdParam").value  = subline;
	
	if(subline == "CONTRACTOR_ALL_RISK" || subline == "CONTRACTORS_ALL_RISK") {
		document.getElementById("titleLbl").innerHTML = 'Title of Contract';
		document.getElementById("siteLbl").innerHTML = 'Location of Contract Site';
		document.getElementById("weeksLbl").innerHTML = 'Construction Period From';
		document.getElementById("mainFromLbl").innerHTML = 'Maintenance Period From';
		$("weeksLbl").show();
		$("constructFromSpan").show();
		$("consLbl").show();
		$("constructToSpan").show();
		$("mainFromLbl").show();
		$("mainFromSpan").show();
		$("mainToLbl").show();
		$("mainToSpan").show();
		$("principalInfoDiv").show();
		$("contractorInfoDiv").show();
		if($("constructFrom").value == "") {
			var inceptDate = objMKGlobal.packQuoteId != null ? objCurrPackQuote.inceptDate : objGIPIQuote.inceptDate;
			$("constructFrom").value = inceptDate;
		}
		if($("constructTo").value == "") {
			var expiryDate = objMKGlobal.packQuoteId != null ? objCurrPackQuote.expiryDate : objGIPIQuote.expiryDate;
			$("constructTo").value = expiryDate;
		}
	
	} else if (subline == "ERECTION_ALL_RISK") {
		document.getElementById("titleLbl").innerHTML = 'Project';
		document.getElementById("siteLbl").innerHTML = 'Site of Erection';
		document.getElementById("weeksLbl").innerHTML = 'Weeks Testing/Commissioning';
		$("weeksLbl").show();
		$("weeksTesting").show();
		$("principalInfoDiv").show();
		$("contractorInfoDiv").show();
	
	} else if (subline == "MACHINERY_LOSS_OF_PROFIT") {
		document.getElementById("titleLbl").innerHTML = 'Nature of Business';
		document.getElementById("siteLbl").innerHTML = 'The Premises';
		document.getElementById("weeksLbl").innerHTML = 'MBI Policy No';
		document.getElementById("mainFromLbl").innerHTML = 'Time Excess';
		$("weeksLbl").show();
		$("mainFromLbl").show();
		$("mbiPolNo").show();
		$("timeExcess").show();
	
	} else if (subline == "MACHINERY_BREAKDOWN_INSURANCE") {
		document.getElementById("titleLbl").innerHTML = 'Nature of Business';
		document.getElementById("siteLbl").innerHTML = 'Work Site';
	
	} else if (subline == "DETERIORATION_OF_STOCKS") {
		document.getElementById("titleLbl").innerHTML = 'Description';
		document.getElementById("siteLbl").innerHTML = 'Location of Refrigeration Plant';
	
	} else if (subline == "BOILER_AND_PRESSURE_VESSEL" || subline == "ELECTRONIC_EQUIPMENT") {
		document.getElementById("titleLbl").innerHTML = 'Description';
		document.getElementById("siteLbl").innerHTML = 'The Premises';
	
	} else if (subline == "PRINCIPAL_CONTROL_POLICY") {
		document.getElementById("titleLbl").innerHTML = 'Description';
		document.getElementById("siteLbl").innerHTML = 'Territorial Limits';
	} else {
		document.getElementById("titleLbl").innerHTML = 'Title';
		document.getElementById("siteLbl").innerHTML = 'Location';
	}
}