function setValuesForWTaxAdvTagNetTag(){
	var wTax   = $("hidWTax").value;
	var advTag = $("hidAdvTag").value;
	var netTag = $("hidNetTag").value;
	var taxType = $("selTaxType").value;
	 
	if(wTax == "Y" && netTag == "Y" && advTag == "Y"){
		if(taxType == "W"){
			$("hidWTax").value = "N";
			$("hidNetTag").value = "Y";
			$("hidAdvTag").value = "N";
		}
	}else{
		if(taxType == "W"){
			$("hidNetTag").value = "Y";
		}else{
			$("hidNetTag").value = "N";
		}
	}
}