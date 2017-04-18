function enableDisableGenerateLoaBtn(){
	var objArray = loaTableGrid.getModifiedRows();
	objArray = objArray.filter(function(obj){return nvl(obj.loaNo, "") == "" && obj.generateTag == true;});
	
	if(objArray.length > 0){
		enableButton("btnGenerateLOA");
	}else{
		disableButton("btnGenerateLOA");
	}
}