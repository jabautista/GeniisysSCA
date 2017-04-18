function insertPrinterNames(){
	var printerNames = $F("printerNames");
	var printers	 = printerNames.split(",");
	var selectContent = "<option value=''></option>";
	for (var i=0; i<printers.length; i++){
		//selectContent = selectContent + "<option value='"+printers[i].toUpperCase()+"'>"+printers[i].toUpperCase()+"</option>";
		selectContent = selectContent + "<option value='"+printers[i]+"'>"+printers[i]+"</option>";
	}
	$("printerName").update(selectContent);
}