function enableDisableGenerateCslBtn(){
	var objArray = cslTableGrid.getModifiedRows();
	objArray = objArray.filter(function(obj){ return nvl(obj.cslNo, "") == "" && obj.generateTag == true;});
	if(objArray.length > 0){
		enableButton("btnGenerateCSL");
	}else{
		disableButton("btnGenerateCSL");
	}
}