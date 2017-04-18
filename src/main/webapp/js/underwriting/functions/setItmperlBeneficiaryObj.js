/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	10.05.2011	mark jm			create an itmperl beneficiary object
 */
function setItmperlBeneficiaryObj() {
	try {
		var newObj = new Object();
		
		newObj.parId			= (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId);
		newObj.itemNo			= $F("itemNo");
		newObj.groupedItemNo	= $F("groupedItemNo");
		newObj.beneficiaryNo	= $F("bBeneficiaryNo");
		newObj.lineCd			= objUWParList.lineCd;
		newObj.perilCd			= $F("bpPerilCd");
		newObj.recFlag			= objUWParList.parType == "P" ? "C" : null;
		newObj.premRt			= null;
		newObj.tsiAmt			= $F("bpTsiAmt");
		newObj.premAmt			= null;
		newObj.annTsiAmt		= null;
		newObj.annPremAmt		= null;
		newObj.perilName		= $F("bpPerilName");
		
		return newObj;
	} catch(e) {
		showErrorMessage("setItmperlBeneficiaryObj", e);
	}
}