function checkIfReplaceDetIsEditable(){
	try{
		if(variablesObj.giclReplaceAllowupdate == "N"){
			$("partType").disabled = "disabled";
			disableSearch("dspPartDescIcon");
			disableSearch("dspCompanyTypeIcon");
			disableSearch("dspCompanyIcon");
			disableInputField("baseAmt");	
			disableInputField("noOfUnits");
			disableInputField("partAmt");
			$("replaceDetWithVat").disabled = "disabled";
			disableButton("btnAddReplaceDet");
			disableButton("btnDeleteReplaceDet");
		}
	}catch(e){
		showErrorMessage("checkIfReplaceDetIsEditable",e);
	}
}