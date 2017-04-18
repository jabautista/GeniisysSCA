/*	Created by 	: mark jm 01.04.2011
 * 	Description	: another version of setEndtItemObj for Par
 */
function setParItemObj(){
	try{
		var newObj = new setItemObj();
		var lineCd = getLineCd();		
		/*
		newObj.parId 			= (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
		newObj.itemNo 			= $F("itemNo");
		newObj.itemTitle 		= changeSingleAndDoubleQuotes2($F("itemTitle"));
		newObj.itemGrp 			= $F("itemGrp").empty() ? null : $F("itemGrp");
		newObj.itemDesc 		= changeSingleAndDoubleQuotes2($F("itemDesc"));
		newObj.itemDesc2 		= changeSingleAndDoubleQuotes2($F("itemDesc2"));
		newObj.tsiAmt 			= $F("tsiAmt").empty() ? null : $F("tsiAmt");
		newObj.premAmt 			= $F("premAmt").empty() ? null : $F("premAmt");
		newObj.annPremAmt 		= $F("annPremAmt").empty() ? null : $F("annPremAmt");
		newObj.annTsiAmt 		= $F("annTsiAmt").empty() ? null : $F("annTsiAmt");
		newObj.recFlag 			= ($F("pageName") == "packagePolicyItems") ? null : ($F("recFlag") == "" ? 'A' : $F("recFlag"));
		newObj.groupCd 			= ($F("groupCd") == "" ? null : $F("groupCd"));
		newObj.currencyCd 		= ($F("currency") == "" ? null : $F("currency"));
		newObj.currencyDesc		= $("currency").options[$("currency").selectedIndex].text;
		newObj.currencyRt		= $F("rate");
		newObj.coverageCd		= $F("coverage") == "" ? null : $F("coverage");
		newObj.surchargeSw		= ($F("pageName") == "packagePolicyItems") ? null : $("surchargeSw").checked ? "Y" : "N";
		newObj.discountSw		= ($F("pageName") == "packagePolicyItems") ? null : $("discountSw").checked ? "Y" : "N";
		newObj.packLineCd 		= $F("packLineCd");
		newObj.packSublineCd 	= $F("packSublineCd");
		newObj.otherInfo 		= changeSingleAndDoubleQuotes2($F("otherInfo"));
		newObj.regionCd 		= ($F("region") == "" ? null : $F("region"));
		newObj.fromDate			= $F("dateFormatted") == "Y" ? $F("fromDate") : $F("fromDate").empty() ? (objUWGlobal.packParId != null ? objGIPIWPolbas.inceptDate : $F("globalInceptDate")) : $F("fromDate");
		newObj.toDate			= $F("dateFormatted") == "Y" ? $F("toDate") : $F("toDate").empty() ? (objUWGlobal.packParId != null ? objGIPIWPolbas.expiryDate : $F("globalExpiryDate")) : $F("toDate");		
		newObj.riskNo			= ($F("riskNo") == "" ? null : $F("riskNo"));
		newObj.riskItemNo		= ($F("riskItemNo") == "" ? null : $F("riskItemNo"));
		newObj.dateFormatted	= "Y";		
		*/
		if(lineCd == "MC"){
			newObj = setMCItemObject(newObj);
		}else if(lineCd == "FI"){				
			newObj.fromDate = $F("fromDate").empty() ? null : newObj.fromDate;
			newObj.toDate = $F("toDate").empty() ? null : newObj.toDate;
			newObj = setFIItemObject(newObj);
		}else if(lineCd == "AC") {
			newObj.fromDate = $F("fromDate").empty() ? null : newObj.fromDate;
			newObj.toDate = $F("toDate").empty() ? null : newObj.toDate;

			newObj.isSaved = "1"; // 1 not saved, else - saved
			
			newObj.prorateFlag 		= nvl($("accidentProrateFlag"), "") == "" ? null : 
				(nvl($F("accidentProrateFlag"), "") == "" ? null : $F("accidentProrateFlag"));
			newObj.compSw 			= nvl($("accidentCompSw"), "") == "" ? null : 
								(nvl($F("accidentCompSw"), "") == "" ? null : $F("accidentCompSw"));
			/*	newObj.shortRtPercent 	= nvl($("accidentShortRatePercent"), "") == "" ? null : 
								(nvl($F("accidentShortRatePercent"),"")=="" ? null : $F("accidentShortRatePercent"));*/
			newObj.shortRtPercent 	= (nvl($F("accidentShortRatePercent"),"")=="" ? null : $F("accidentShortRatePercent"));
			
			newObj = setACItemObject(newObj);
		}else if(lineCd == "CA" || lineCd == "LI"){
			newObj.fromDate = null;
			newObj.toDate = null;
			newObj = setCAItemObject(newObj);
		}else if(lineCd == "AV"){
			newObj = setAVItemObject(newObj);
		}else if(lineCd == "MH") {
			newObj = setMHItemObject(newObj);
		}else if(lineCd == "MN"){
			newObj = setMNItemObject(newObj);
		}else if(lineCd == "EN"){
			newObj.fromDate = null;
			newObj.toDate = null;
		}
		//	$("additionalItemInformation").setAttribute("changeTagAttr", "true");
				
		return newObj;
	}catch(e){
		showErrorMessage("setParItemObj", e);
	}	
}