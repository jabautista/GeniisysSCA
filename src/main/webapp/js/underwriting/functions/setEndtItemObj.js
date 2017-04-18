/*	Created by 	: mark jm 09.29.2010
 * 	Description	: separate item information from details
 */
function setEndtItemObj(){
	try{
		var newObj = new Object();

		newObj.parId 			= (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")); 
		newObj.itemNo 			= $F("itemNo");
		newObj.itemTitle 		= escapeHTML2($F("itemTitle")); //replace by steven 07.06.2012: from changeSingleAndDoubleQuotes2 to escapeHTML2
		newObj.itemGrp 			= $F("itemGrp");
		newObj.itemDesc 		= escapeHTML2($F("itemDesc"));
		newObj.itemDesc2 		= escapeHTML2($F("itemDesc2"));
		newObj.tsiAmt 			= "0.00"; //($("tsiAmt").value != "" ? $("tsiAmt").value : "0.00"); //"0.00";
		newObj.premAmt 			= "0.00"; //($("premAmt").value != "" ? $("premAmt").value : "0.00"); //"0.00";
		newObj.annPremAmt 		= "0.00"; //($("annPremAmt").value != "" ? $("annPremAmt").value : "0.00"); //"0.00";
		newObj.annTsiAmt 		= "0.00"; //($("annTsiAmt").value !="" ? $("annTsiAmt").value : "0.00"); //"0.00";
		newObj.recFlag 			= ($F("recFlag") == "" ? 'A' : $F("recFlag"));
		newObj.groupCd 			= ($F("groupCd") == "" ? null : $F("groupCd"));
		newObj.currencyCd 		= ($F("currency") == "" ? null : $F("currency"));
		newObj.currencyDesc		= $("currency").options[$("currency").selectedIndex].text;
		newObj.currencyRt		= $F("rate");
		newObj.packLineCd 		= $F("packLineCd");
		newObj.packSublineCd 	= $F("packSublineCd");
		newObj.otherInfo 		= escapeHTML2($F("otherInfo"));
		newObj.regionCd 		= ($F("region") == "" ? null : $F("region"));
		
		var lineCd = getLineCd();
		
		if(lineCd == "MC"){			
			newObj = setMCItemObject(newObj);
		} else if(lineCd == "FI"){
			newObj = setFIItemObject(newObj);
		} else if(lineCd == "MN"){
			newObj = setMNItemObject(newObj); //setEndtMNItemObject(newObj);
		} else if(lineCd == "CA"){
			newObj = setEndtCAItemObject(newObj);
		} else if(lineCd == "MH"){
			newObj = setEndtMHItemObject(newObj);
		} else if(lineCd == "AH"){
			newObj = setACItemObject(newObj);
		}
		return newObj;
	}catch(e){
		showErrorMessage("setEndtItemObj", e);
		//showMessageBox("setEndtItemObj : " + e.message);
	}	
}