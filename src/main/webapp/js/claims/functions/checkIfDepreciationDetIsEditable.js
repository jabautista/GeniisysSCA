function checkIfDepreciationDetIsEditable(){
	try{
		if(variablesObj.masterDepreciationBlkMasterAllowUpdate == "N"){
			disableInputField("dedRt");
			disableButton("btnApplyDepreciation");
			disableButton("btnSaveDepreciation");
			disableSearch("dspCompanyTypeIcon");
			disableSearch("dspCompanyIcon");
			
		}
	}catch(e){
		showErrorMessage("checkIfDepreciationDetIsEditable",e);
	}
}