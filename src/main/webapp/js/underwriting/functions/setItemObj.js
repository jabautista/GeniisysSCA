/*	Created by	: mark jm 03.18.2011
 * 	Description : create the object for item only
 */
function setItemObj(){
	try{
		var objItem = new Object();
		var parId;		
		
		parId = ($F("globalPackParId") > 0) ? ($$("div#packageParPolicyTable .selectedRow"))[0].getAttribute("parId") : $F("globalParId");		

		objItem.parId 			= parId;
		objItem.itemNo 			= new Number($F("itemNo"));
		objItem.itemTitle 		= escapeHTML2($F("itemTitle"));	//replace by steven 07.06.2012: from changeSingleAndDoubleQuotes2 to unescapeHTML2
		objItem.itemGrp 		= $F("itemGrp").empty() ? null : $F("itemGrp");
		objItem.itemDesc 		= escapeHTML2($F("itemDesc"));
		objItem.itemDesc2 		= escapeHTML2($F("itemDesc2"));
		objItem.tsiAmt 			= $F("tsiAmt").empty() ? null : $F("tsiAmt");
		objItem.premAmt 		= $F("premAmt").empty() ? null : $F("premAmt");
		objItem.annPremAmt 		= $F("annPremAmt").empty() ? null : $F("annPremAmt");
		objItem.annTsiAmt 		= $F("annTsiAmt").empty() ? null : $F("annTsiAmt");		
		objItem.recFlag 		= ($F("pageName") == "packagePolicyItems") ? null : ($F("recFlag") == "" ? 'A' : $F("recFlag"));
		objItem.groupCd 		= ($F("groupCd") == "" ? null : $F("groupCd"));
		objItem.currencyCd 		= ($F("currency") == "" ? null : $F("currency"));
		objItem.currencyDesc	= $("currency").options[$("currency").selectedIndex].text;
		objItem.currencyRt		= $F("rate");		
		objItem.coverageCd		= $F("coverage") == "" ? null : $F("coverage");
		objItem.surchargeSw		= ($F("pageName") == "packagePolicyItems") ? null : $("surchargeSw").checked ? "Y" : "N";
		objItem.discountSw		= ($F("pageName") == "packagePolicyItems") ? null : $("discountSw").checked ? "Y" : "N";
		objItem.packLineCd 		= (objUWGlobal.packParId != null && objCurrPackPar != null ? objCurrPackPar.lineCd : $F("packLineCd"));
		objItem.packSublineCd 	= (objUWGlobal.packParId != null && objCurrPackPar != null ? objCurrPackPar.sublineCd : $F("packSublineCd"));		
		objItem.otherInfo 		= escapeHTML2($F("otherInfo"));		
		objItem.regionCd 		= ($F("region") == "" ? null : $F("region"));		
		objItem.fromDate		= $F("dateFormatted") == "Y" ? $F("fromDate") : $F("fromDate").empty() ? ($("globalInceptDate") == null ? null : $F("globalInceptDate")) : $F("fromDate");
		objItem.toDate			= $F("dateFormatted") == "Y" ? $F("toDate") : $F("toDate").empty() ? ($("globalExpiryDate") == null ? null : $F("globalExpiryDate")) : $F("toDate");		
		objItem.riskNo			= ($F("riskNo") == "" ? null : $F("riskNo"));
		objItem.riskItemNo		= ($F("riskItemNo") == "" ? null : $F("riskItemNo"));
		//objItem.paytTerms		= $("accidentPaytTerms") == null ? null : $F("accidentPaytTerms");
		//objItem.packBenCd		= $("accidentPackBenCd") == null ? null : $F("accidentPackBenCd");
		// andrew - 10.05.2011 - replaced null with empty string
		objItem.paytTerms		= $("accidentPaytTerms") == null ? null  : ($F("accidentPaytTerms") == "" ? null : $F("accidentPaytTerms"));
		objItem.packBenCd		= $("accidentPackBenCd") == null ? null : ($F("accidentPackBenCd") == "" ? null : $F("accidentPackBenCd"));
		objItem.dateFormatted	= "Y";		
		
		return objItem;
	}catch(e){
		showErrorMessage("setItemObj", e);
	}
}