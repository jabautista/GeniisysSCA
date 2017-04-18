/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	10.06.2011	mark jm			create an itmperl grouped object
 */
function setItmperlGroupedObj() {
	try {
		var newObj = new Object();

		newObj.parId 			= (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId);
		newObj.itemNo 			= $F("itemNo");
		newObj.groupedItemNo	= $F("groupedItemNo");
		newObj.groupedItemTitle	= changeSingleAndDoubleQuotes2($F("groupedItemTitle"));
		newObj.lineCd			= objUWParList.lineCd; //$F("cLineCd");
		newObj.perilCd			= $F("cPerilCd");
		newObj.recFlag			= $F("cRecFlag");
		newObj.premRt			= $F("cPremRt");
		newObj.tsiAmt			= $F("cTsiAmt");
		newObj.premAmt			= $F("cPremAmt");
		newObj.annTsiAmt		= $F("cAnnTsiAmt");
		newObj.annPremAmt		= $F("cAnnPremAmt");
		newObj.aggregateSw		= $("cAggregateSw").checked ? "Y" : "N";
		if($F("cNoOfDays") == "" || $F("cBaseAmt") == ""){
			newObj.noOfDays			= "";
			newObj.baseAmt			= "";
		}else{
			newObj.noOfDays			= $F("cNoOfDays");
			newObj.baseAmt			= $F("cBaseAmt");
		}
		newObj.riCommRate		= $F("cRiCommRt");
		newObj.riCommAmt		= $F("cRiCommAmt");
		newObj.perilName		= escapeHTML2($F("cPerilName"));	
		newObj.perilType		= $F("cPerilType");
		newObj.wcSw				= $F("cWcSw");
		newObj.bascPerlCd				= $F("cBascPerlCd");
		
		
		return newObj;
	} catch(e) {
		showErrorMessage("setItmperlGroupedObj", e);
	}
}