/**
 * Used in GICLS043 to check if required fields has values 
 * @author Veronica V. Raymundo
 */
function checkBatchCsrReqFields(){
	var isBlank = false;
	
	if($F("payeeClass") == ""){
		isBlank = true;
	}else if($F("payee") == ""){
		isBlank = true;
	}else if($F("particulars") == ""){
		isBlank = true;
	}
	return isBlank;
}