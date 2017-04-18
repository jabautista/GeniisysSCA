function validateAddEvalDeductible(){
	
	if($("txtEvalDedCd").value == ""){
		showMessageBox("Please select deductible.", "E");
		return false;
	}else if($("txtEvalDedCompany").value == ""){
		showMessageBox("Please indicate from what company the deductibles will be applied.", "E");
		return false;
	}else if($("txtEvalDedUnits").value == ""){
		customShowMessageBox("Please enter number of units.", "I", "txtEvalDedUnits");
		return false;
	}else if(parseInt($("txtEvalDedUnits").value) < 1){
		customShowMessageBox("Number of units cannot be zero.", "I", "txtEvalDedUnits");
		$("txtEvalDedUnits").value = 1;
		return false;
	}
	return true;
}