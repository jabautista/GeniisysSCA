/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	09.07.2011	mark jm			set main item form (tablegrid version)
 */
function setMainItemFormTG(obj){
	try{		
		var lineCd = getLineCd();

		$("itemNo").value 			= (obj == null ? (/*$F("globalParType")*/objUWParList.parType == "E" ? "" : getNextItemNoFromObj()) : obj.itemNo);		
		$("itemTitle").value 		= (obj == null ? "" : unescapeHTML2(obj.itemTitle));		
		$("itemDesc").value 		= (obj == null ? "" : unescapeHTML2(nvl(obj.itemDesc, "")));
		$("itemDesc2").value 		= (obj == null ? "" : unescapeHTML2(nvl(obj.itemDesc2, "")));    	
		$("currency").value 		= (obj == null ? objFormParameters.paramDefaultCurrency : nvl(obj.currencyCd, ""));
		$("rate").value 			= (obj == null ? /*formatToNineDecimal("1")*/"" : formatToNineDecimal(nvl(obj.currencyRt, "")));
		$("itemGrp").value			= (obj == null ? "" : (obj.itemGrp == undefined ? "" : obj.itemGrp)); // andrew - 04.26.2011 - added undefined condtion for endt item
		$("groupCd").value 			= (obj == null ? "" : nvl(obj.groupCd, ""));
		$("region").value 			= (obj == null ? nvl(objFormParameters.paramDefaultRegion, "") : nvl(obj.regionCd, ""));
		$("coverage").value			= (obj == null ? nvl(objFormParameters.paramDfltCoverage, "") : nvl(obj.coverageCd, ""));
		$("otherInfo").value		= (obj == null ? "" : unescapeHTML2(nvl(obj.otherInfo, "")));		
		$("tsiAmt").value			= (obj == null ? "" : obj.tsiAmt);
		$("premAmt").value			= (obj == null ? "" : obj.premAmt);
		$("annTsiAmt").value		= (obj == null ? "" : obj.annTsiAmt);
		$("annPremAmt").value		= (obj == null ? "" : obj.annPremAmt);		
		$("fromDate").value			= (obj == null ? "" : obj.fromDate == null ? "" : nvl(obj.dateFormatted, "N") == "N" ? dateFormat(obj.fromDate, "mm-dd-yyyy") : obj.fromDate);
		$("toDate").value			= (obj == null ? "" : obj.toDate == null ? "" : nvl(obj.dateFormatted, "N") == "N" ? dateFormat(obj.toDate, "mm-dd-yyyy") : obj.toDate);
		$("riskNo").value			= (obj == null ? (lineCd == "FI" ? "1" : "") : obj.riskNo);
		$("riskItemNo").value		= (obj == null ? "" : obj.riskItemNo);
		$("surchargeSw").checked	= (obj == null ? false : obj.surchargeSw == "Y" ? true : false);
		$("discountSw").checked		= (obj == null ? false : obj.discountSw == "Y" ? true : false);
		$("dateFormatted").value	= (obj == null ? "N" : (nvl(obj.dateFormatted, "N") == "N" ? "N" : obj.dateFormatted));
		$("recFlag").value 			= (obj == null ? "" : obj.recFlag);
		$("packLineCd").value		= (obj == null ? "" : obj.packLineCd); // added by andrew - 03.29.2011 - added for package
		$("packSublineCd").value	= (obj == null ? "" : obj.packSublineCd); // added by andrew - 03.29.2011 - added for package
		
		var varIsEndtItem = isEndtItem(); // andrew - 02.25.2011 added this variable to determine if item is endt or not
		$("btnAddItem").value = (obj == null || varIsEndtItem ? "Add" : (obj.includeAddl != null) ? "Add" : "Update");
		(obj == null || varIsEndtItem ? disableButton($("btnDeleteItem")) : (obj.includeAddl != null) ? disableButton($("btnDeleteItem")) : enableButton($("btnDeleteItem")));
		
	}catch(e){
		showErrorMessage("setMainItemFormTG", e);
	}
}