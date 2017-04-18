function supplyClmEngineeringItem(obj) {
	if (nvl(obj, null) == null) {
		clearEngineeringDtlFields();
		return;
	}

	objCLMItem.selected 			= obj;
	objCLMItem.selItemNo			= unescapeHTML2(String(obj[itemGrid.getColumnIndex('itemNo')]));
	$("txtItemNo").value			= unescapeHTML2(String(nvl(obj[itemGrid.getColumnIndex('itemNo')], "")));
	$("txtItemTitle").value		= unescapeHTML2(nvl(String(obj[itemGrid.getColumnIndex('dspItemTitle')]), "")); //edited by steven 12/03/2012  from:changeSingleAndDoubleQuotes   to:unescapeHTML2
	$("txtItemDesc").value			= unescapeHTML2(nvl(String(obj[itemGrid.getColumnIndex('itemDesc')]), "")); //edited by steven 12/03/2012  from:changeSingleAndDoubleQuotes   to:unescapeHTML2
	$("txtItemDesc2").value			= unescapeHTML2(nvl(String(obj[itemGrid.getColumnIndex('itemDesc2')]), ""));//edited by steven 12/03/2012  from:changeSingleAndDoubleQuotes   to:unescapeHTML2
	$("txtCurrencyCd").value		= nvl(String(obj[itemGrid.getColumnIndex('currencyCd')]), "");
	$("txtDspCurrDesc").value		= unescapeHTML2(nvl(String(obj[itemGrid.getColumnIndex('currDesc')]), "")); //edited by steven 12/03/2012  from:changeSingleAndDoubleQuotes   to:unescapeHTML2
	$("txtDspRegion").value			= unescapeHTML2(nvl(String(obj[itemGrid.getColumnIndex('regionDesc')]), "")); //edited by steven 12/03/2012  from:changeSingleAndDoubleQuotes   to:unescapeHTML2
	$("txtCurrencyRate").value		= (obj[itemGrid.getColumnIndex('currencyRate')] == null) ? "" : formatToNthDecimal(parseFloat(obj[itemGrid.getColumnIndex('currencyRate')]), 9);
	$("txtDspProvince").value		= unescapeHTML2(nvl(String(obj[itemGrid.getColumnIndex('provinceDesc')]), "")); //edited by steven 12/03/2012  from:changeSingleAndDoubleQuotes   to:unescapeHTML2
	
	getAddtlInfos(obj);
}