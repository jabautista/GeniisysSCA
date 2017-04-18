/**
 * @author rey
 * @date 06.09.2011
 * @param obj
 */
function supplyClmCasualtyItem(obj){
	try{
		objCLMItem.selected 			= obj == null ? {} :obj;
		objCLMItem.selItemIndex			= obj == null ? null :objCLMItem.selItemIndex;
		objCLMItem.selItemNo 			= obj == null ? null :unescapeHTML2(String(nvl(obj[itemGrid.getColumnIndex('itemNo')],"")));
		$("txtItemNo").value 			= obj == null ? null :unescapeHTML2(String(nvl(obj[itemGrid.getColumnIndex('itemNo')],"")));
		$("txtItemTitle").value  		= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('itemTitle')],""));
		$("txtItemDesc").value  		= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('itemDesc')],""));
		$("txtGrpCd").value				= obj == null ? null :unescapeHTML2(String(nvl(obj[itemGrid.getColumnIndex('groupedItemNo')],"")));
		$("txtDspGrpDesc").value		= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('groupedItemTitle')],""));
		$("txtItemDesc2").value			= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('itemDesc2')],""));
		$("txtCurrencyCd").value		= obj == null ? null :unescapeHTML2(String(nvl(obj[itemGrid.getColumnIndex('currencyCd')],"")));
		$("txtDspCurrencyDesc").value	= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('currencyDesc')],""));
		$("txtProperty").value			= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('propertyNoType')],""));
		$("txtPropertyNo").value		= obj == null ? null :unescapeHTML2(String(nvl(obj[itemGrid.getColumnIndex('propertyNo')],"")));
		$("txtCurencyRate").value		= obj == null ? null :unescapeHTML2(String(nvl(formatToNineDecimal(obj[itemGrid.getColumnIndex('currencyRate')]),"")));
		$("txtLocation").value			= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('location')],""));
		$("txtSecHazCd").value			= obj == null ? null :unescapeHTML2(String(nvl(obj[itemGrid.getColumnIndex('sectionOrHazardCd')],"")));
		$("txtConveyance").value		= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('conveyanceInfo')],""));
		$("txtSecHazInfo").value		= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('sectionOrHazardInfo')],""));
		$("txtInterestPrems").value		= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('interestOnPremises')],""));
		$("txtAmtCov").value			= obj == null ? null :unescapeHTML2(String(nvl(formatCurrency(obj[itemGrid.getColumnIndex('amountCoverage')]),"")));
		$("txtLimLiablty").value		= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('limitOfLiability')],""));
		$("txtCapacityCd").value		= obj == null ? null :unescapeHTML2(String(nvl(obj[itemGrid.getColumnIndex('capacityCd')],""))); 
		$("txtPosition").value			= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('position')],""));

		getPersonnelList(nvl($F("txtItemNo"),""), "0");
		getAddtlInfos(obj);
	}
	catch(e){
		showErrorMessage("supplyClmCasualtyItem",e);
	}
}