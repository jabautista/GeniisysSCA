//moved from directPremiumCollection2.jsp
function rowPremCollnDeselectedFnTG() {
	$("btnAdd").value = "Add";
	$("btnAdd").setAttribute("status", "Add");
	disableButton("btnDelete");
	enableButton("btnAdd"); 
	makeRecordEditable("gdpcRecord");
	resetGDCPFormValues();
	// added by alfie 11.26.2010
	objAC.currentRecord = {};
	
	$("tranType").enable();
	//$("tranSource").enable();
	$("tranSource").readOnly = false;	 // SR-20000 : shan 08.24.2015
	$("tranSource").clear();	 // SR-20000 : shan 08.24.2015
	enableSearch("oscmBillIssCd"); // SR-20000 : shan 08.24.2015
	$("billCmNo").readOnly = false;
	//$("oscmBillCmNo").setStyle({display: 'block'});
	enableSearch("oscmBillCmNo");
	$("premCollectionAmt").readOnly = true;
	
	$("instNo").readOnly = false;
	//$("oscmInstNo").setStyle({display: 'block'});
	enableSearch("oscmInstNo");
	objAC.selectedRecord = new Object();
	//enableDisableFieldsGiacs007();
	//$("oscmBillCmNo").show();
	//$("oscmInstNo").show();
}