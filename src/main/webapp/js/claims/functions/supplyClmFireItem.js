/**
 * Supply fire item info
 * 
 * @author Niknok Orio
 * @param obj =
 *            selected giclFireDtl object
 */
function supplyClmFireItem(obj){
	try{
		var msgAlert = obj == null ? null :nvl(unescapeHTML2(String(obj[itemGrid.getColumnIndex('msgAlert')])),null);
		if (msgAlert != null){
			showMessageBox(msgAlert, "E");
			return false;
		}
		objCLMItem.selected 		= obj == null ? {} :obj;
		objCLMItem.selItemIndex		= obj == null ? null :objCLMItem.selItemIndex;
		objCLMItem.selItemNo		= obj == null ? null :unescapeHTML2(String(obj[itemGrid.getColumnIndex('itemNo')]));
		$("txtItemNo").value  		= obj == null ? null :unescapeHTML2(String(obj[itemGrid.getColumnIndex('itemNo')]));
		$("txtItemTitle").value  	= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('itemTitle')]);
		$("txtItemDesc").value  	= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('itemDesc')]);
		$("txtItemDesc2").value  	= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('itemDesc2')]);
		$("txtCurrencyCd").value 	= obj == null ? null :unescapeHTML2(String(obj[itemGrid.getColumnIndex('currencyCd')])); 
		$("txtDspCurrencyDesc").value = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('dspCurrencyDesc')]);
		$("txtCurrencyRate").value  = obj == null ? null :unescapeHTML2(formatToNthDecimal(obj[itemGrid.getColumnIndex('currencyRate')],9));
		$("txtDspTariffZone").value = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('dspTariffZone')]);
		$("txtDspItemType").value  	= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('dspItemType')]);
		$("txtTarfCd").value  		= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('tarfCd')]);
		$("txtDistrictNo").value  	= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('districtNo')]);
		$("txtBlockNo").value  		= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('blockNo')]);
		$("txtLocRisk1").value  	= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('locRisk1')]);
		$("txtLocRisk2").value  	= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('locRisk2')]);
		$("txtLocRisk3").value  	= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('locRisk3')]);
		$("txtDspEqZone").value  	= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('dspEqZone')]);
		$("txtRiskDesc").value  	= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('riskDesc')]);
		$("txtDspTyphoon").value  	= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('dspTyphoon')]);
		$("txtFront").value  		= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('front')]);
		$("txtRight").value  		= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('right')]);
		$("txtLeft").value  		= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('left')]);
		$("txtRear").value  		= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('rear')]);
		$("txtDspFloodZone").value  = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('dspFloodZone')]);
		$("txtAssignee").value  	= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('assignee')]);
		$("txtDspOccupancy").value  = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('dspOccupancy')]);
		$("txtOccupancyRemarks").value  = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('occupancyRemarks')]);
		$("txtDspConstruction").value  	= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('dspConstruction')]);
		$("txtConstructionRemarks").value  	= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('constructionRemarks')]);
		
		getAddtlInfos(obj);
	}catch(e){
		showErrorMessage("supplyClmFireItem",e);
	}		
}