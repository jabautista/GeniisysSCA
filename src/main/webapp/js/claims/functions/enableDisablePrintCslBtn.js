function enableDisablePrintCslBtn(){
	var objArray = cslTableGrid.getModifiedRows();
	objArray = objArray.filter(function(obj){ return nvl(obj.cslNo, "") != "" && obj.printTag == true;});
	if(objArray.length > 0){
		enableButton("btnPrintCSL");
	}else{
		disableButton("btnPrintCSL");
	}
}