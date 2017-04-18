/** End of motor car item info functions */
/**
 * Populates the Marine cargo text fields
 * 
 * @author Irwin Tabisora, 9.29.11
 */

function populateMarineCargoFields(obj){
	try{
		objCLMItem.selected 		= obj == null ? {} :obj;
		objCLMItem.selItemIndex	= obj == null ? null :objCLMItem.selItemIndex;
		$("txtItemNo").value  		= obj == null ? null :unescapeHTML2(String(obj[itemGrid.getColumnIndex('itemNo')]));
		$("txtItemTitle").value  	= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('itemTitle')]);
		$("txtItemDesc").value  	= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('itemDesc')]);
		$("txtItemDesc2").value  	= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('itemDesc2')]);
		$("txtCurrencyCd").value 	= obj == null ? null :unescapeHTML2(String(obj[itemGrid.getColumnIndex('currencyCd')])); 
		$("txtDspCurrencyDesc").value = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('dspCurrencyDesc')]);
		$("txtCurrencyRate").value  = obj == null ? null :unescapeHTML2(formatToNthDecimal(obj[itemGrid.getColumnIndex('currencyRate')],9));
		$("txtDspCurrencyDesc").value = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('dspCurrencyDesc')]);
		$("txtCargoClassDesc").value = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('cargoClassDesc')]);
		$("txtVoyageNo").value = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('voyageNo')]);
		$("txtLcNo").value = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('lcNo')]);
		$("txtBlAwb").value = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('blAwb')]);
		$("txtCargoTypeDesc").value = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('cargoTypeDesc')]);
		$("txtOrigin").value = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('origin')]);
		$("txtEtd").value = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('strEtd')]);
		$("txtDeductText").value = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('deductText')]);
		$("txtEta").value = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('strEta')]);
		$("txtVesselName").value = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('vesselName')]);
		$("textGeogDesc").value = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('geogDesc')]);
		$("txtPackMethod").value = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('packMethod')]);
		$("txtTranshipmentOrigin").value = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('transhipOrigin')]);
		$("txtTranshipmentDestination").value = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('transhipDestination')]);
		$("txtDestn").value = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('destn')]);
		getAddtlInfos(obj);
	}catch(e){
		showErrorMessage("populateMarineCargoFields",e);
	}
	
}