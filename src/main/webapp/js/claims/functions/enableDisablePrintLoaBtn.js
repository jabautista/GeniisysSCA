function enableDisablePrintLoaBtn(){
	var objArray = loaTableGrid.getModifiedRows();
	objArray = objArray.filter(function(obj){return nvl(obj.loaNo, "") != "" && obj.printTag == true;});
	
	if(objArray.length > 0){
		enableButton("btnPrintLOA");
	}else{
		disableButton("btnPrintLOA");
	}
}