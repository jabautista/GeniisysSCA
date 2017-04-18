/** Marine Cargo item info functions */

function populateAviationFields(obj){
	try{
		objCLMItem.selected 		= obj == null ? {} :obj;
		objCLMItem.selItemIndex		= obj == null ? null :objCLMItem.selItemIndex;
		$("txtItemNo").value  		= obj == null ? null :unescapeHTML2(String(obj[itemGrid.getColumnIndex('itemNo')]));
		$("txtItemTitle").value  	= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('itemTitle')]);
		$("txtItemDesc").value  	= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('itemDesc')]);
		$("txtItemDesc2").value  	= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('itemDesc2')]);
		$("txtCurrencyCd").value 	= obj == null ? null :unescapeHTML2(String(obj[itemGrid.getColumnIndex('currencyCd')])); 
		$("txtDspCurrencyDesc").value = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('dspCurrencyDesc')]);
		$("txtCurrencyRate").value  = obj == null ? null :unescapeHTML2(formatToNthDecimal(obj[itemGrid.getColumnIndex('currencyRate')],9));
		$("txtDspCurrencyDesc").value = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('dspCurrencyDesc')]);
		$("txtDspAirType").value  = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('dspAirType')]);
		$("txtDspRcpNo").value  = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('dspRcpNo')]);
		$("txtTotalFlyTime").value  = obj == null ? null :obj[itemGrid.getColumnIndex('totalFlyTime')];
		$("txtPrevUtilHrs").value 	= obj == null ? null :obj[itemGrid.getColumnIndex('prevUtilHrs')];
		$("txtEstUtilHrs").value 	= obj == null ? null :obj[itemGrid.getColumnIndex('estUtilHrs')];
		$("txtQualification").value  = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('qualification')]);
		$("txtGeogLimit").value  = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('geogLimit')]);
		$("txtVesselName").value  = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('dspVesselName')]);
		$("txtPurpose").value  = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('purpose')]);
		$("txtDeductText").value  = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('deductText')]);
		
		getAddtlInfos(obj);
	
	}catch(e){
		showErrorMessage("populateAviationFields",e);
	}	
}