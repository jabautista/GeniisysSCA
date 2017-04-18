function rowPremCollnDeselectedFn() {
	resetFormValues();
	$("btnAdd").value = "Add";
	$("btnAdd").setAttribute("status", "Add");
	// added by alfie 11.26.2010
	hideTaxCollections($("taxCollectionTable"), $("taxCollectionListContainer"));
	objAC.currentRecord = {};
	
	if ((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR")  && objAC.tranFlagState != "C"){	
		disableButton("btnDelete");
		enableButton("btnAdd"); 
		makeRecordEditable("gdpcRecord");	
		
		$("tranType").enable();
		$("tranSource").enable();
		$("billCmNo").readOnly = false;
		$("oscmBillCmNo").setStyle({display: 'block'});
		$("premCollectionAmt").readOnly = true;
		
		$("instNo").readOnly = false;
		$("oscmInstNo").setStyle({display: 'block'});
		
		
		//$("oscmBillCmNo").show();
		//$("oscmInstNo").show();
	}
	enableDisableFieldsGiacs007();
}