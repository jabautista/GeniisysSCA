function checkIfRepairDetIsEditable(){
	try{
		if(variablesObj.giclRepairHdrAllowUpdate == "N"){
			disableSearch("dspLossDescIcon");
			disableInputField("actualTinsmithAmt");
			disableInputField("actualPaintingAmt");
			disableInputField("actualTotalAmt");
			$("withVat").disabled = "disabled";
			disableButton("btnAddRepairDet");
			disableButton("btnDeleteRepairDet");
			disableSearch("dspCompanyTypeIcon");
			disableSearch("dspCompanyIcon");
			disableButton("btnSaveRepairDtl");
			$("tinsmithType").disable();
			$("paintingsRepairCd").disable();
			$("tinsmithRepairCd").disable();
		}
	}catch(e){
		showErrorMessage("checkIfReplaceDetIsEditable",e);
	}
}