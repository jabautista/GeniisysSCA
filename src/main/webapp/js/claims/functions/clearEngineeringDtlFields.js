function clearEngineeringDtlFields() {
	objCLMItem.selected 			= {};
	objCLMItem.selItemIndex			= null;
	objCLMItem.selItemNo			= null;
	$("txtItemNo").value			= "";
	$("txtItemTitle").value		= "";
	$("txtItemDesc").value			= "";
	$("txtItemDesc2").value			= "";
	$("txtCurrencyCd").value		= "";
	$("txtDspCurrDesc").value		= "";
	$("txtDspRegion").value			= "";
	$("txtCurrencyRate").value		= "";
	$("txtDspProvince").value		= "";
	
	getAddtlInfos(null);
}