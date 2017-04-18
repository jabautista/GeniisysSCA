/*	Modified by		: mark jm 09.27.2010
 * 	Modification	: Added if condition to handle which line details should be supplied
 */
function setItemForm(obj) {
	try {		
		$("itemNo").value 			= (obj == null ? "" : obj.itemNo);
		$("itemTitle").value 		= (obj == null ? "" : unescapeHTML2(obj.itemTitle));
    	$("itemGrp").value 			= (obj == null ? "" : obj.itemGrp);			
		$("itemDesc").value 		= (obj == null ? "" : unescapeHTML2(nvl(obj.itemDesc, "")));
		$("itemDesc2").value 		= (obj == null ? "" : unescapeHTML2(nvl(obj.itemDesc2, "")));
    	$("tsiAmt").value 			= (obj == null ? "" : formatCurrency(nvl(obj.tsiAmt, "")));
    	$("premAmt").value 			= (obj == null ? "" : formatCurrency(nvl(obj.premAmt, "")));
    	$("annPremAmt").value 		= (obj == null ? "" : formatCurrency(nvl(obj.annPremAmt, "")));
    	$("annTsiAmt").value 		= (obj == null ? "" : formatCurrency(nvl(obj.annTsiAmt, "")));		
		$("recFlag").value 			= (obj == null ? "A" : nvl(obj.recFlag, "A"));	
		$("currency").value 		= (obj == null ? "1" : nvl(obj.currencyCd, ""));
		$("rate").value 			= (obj == null ? formatToNineDecimal("1") : formatToNineDecimal(nvl(obj.currencyRt, "")));			
		$("groupCd").value 			= (obj == null ? "0" : nvl(obj.groupCd, ""));
		$("packLineCd").value 		= (obj == null ? "" : nvl(obj.packLineCd, ""));
		$("packSublineCd").value 	= (obj == null ? "" : nvl(obj.packSublineCd, ""));
		$("otherInfo").value 		= (obj == null ? "" : unescapeHTML2(nvl(obj.otherInfo, "")));
		$("region").value 			= (obj == null ? "" : nvl(obj.regionCd, ""));
		
		$("btnAddItem").value = (obj == null ? "Add" : (obj.includeAddl != null) ? "Add" : "Update");
		(obj == null ? disableButton($("btnDeleteItem")) : (obj.includeAddl != null) ? disableButton($("btnDeleteItem")) : enableButton($("btnDeleteItem")));
		(obj == null ? disableWItemButtons() : (obj.includeAddl != null) ? disableWItemButtons() : enableWItemButtons());
		(obj == null ? $("itemNo").removeAttribute("readonly") : $("itemNo").writeAttribute("readonly", "readonly"));
		
		/*
		$("btnAddItem").value = (obj == null ? "Add" : "Update");
		(obj == null ? disableButton($("btnDeleteItem")) : enableButton($("btnDeleteItem")));
		(obj == null ? disableWItemButtons() : enableWItemButtons());		
		(obj == null ? $("itemNo").removeAttribute("readonly") : $("itemNo").writeAttribute("readonly", "readonly"));		
		*/

		var lineCd = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"));
		
		if(objUWGlobal.lineCd == objLineCds.MN || objUWGlobal.menuLineCd == objLineCds.MN){
			var bool = (obj == null ? false : (obj.includeAddl != null || obj.includeAddl != undefined) ? ((obj.includeAddl) ? true : false) : true);
			
			if (bool) {
				supplyEndtMNAdditionalInfo(obj);
			} else {
				supplyEndtMNAdditionalInfo(null);
			}
			
			setRequiredFields(obj == null ? false : ($("recFlag").value == "A" ? true : false));
		} else if(objUWGlobal.lineCd == objLineCds.CA || objUWGlobal.menuLineCd == objLineCds.CA){
			supplyEndtCasualtyAdditionalInfo(obj);
			objFormVariables[0].varOldCurrencyCd = $F("currency");
		} else if(objUWGlobal.lineCd == objLineCds.MH || objUWGlobal.menuLineCd == objLineCds.MH){
			supplyEndtMarineHullAdditionalInfo(obj);
			setRecFlagDependentFields();
			objFormMiscVariables[0].miscLastCurrIndex = $("currency").selectedIndex;
			objFormMiscVariables[0].miscLastRateValue = $F("rate");
		}
	} catch (e) {
		showErrorMessage("setItemForm", e);
	}
}