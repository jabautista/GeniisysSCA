function enableDisableApplyDeductible(){
	var objArr = objGICLEvalDeductiblesArr.filter(function(item){	return nvl(item.recordStatus, 0) != -1; });
	
	if(variablesObj.giclEvalDeductiblesAllowUpdate == "Y" && parseInt(objArr.length) == 0){
	   enableButton("btnApplyDeductibles");
	}else{
		disableButton("btnApplyDeductibles");
	}
}