function prepareGDCPRecord() {
	var jsonNewDirectPremCollns = new Object();
	try {
		jsonNewDirectPremCollns.tranType 		= $("tranType").options[$("tranType").selectedIndex].value; 	/* var */ /* Value */
		jsonNewDirectPremCollns.issCd 			= $("tranSource").options[$("tranSource").selectedIndex].value; /*
																										 * var
																												 * tranSourceValue
																												 */
		jsonNewDirectPremCollns.premSeqNo 		= $F("billCmNo"); 												// var
																												// bilCmNo
		jsonNewDirectPremCollns.policyNo 		= $F("polEndtNo"); 												// var
																											// polEndtNo
		jsonNewDirectPremCollns.instNo 			= $F("instNo");													// var
																											// instNo
		jsonNewDirectPremCollns.collAmt 		= unformatCurrency("premCollectionAmt");								// var
																														// collAmt
		jsonNewDirectPremCollns.particulars 	= changeDividerChar($F("particulars")); 						// var
																												// particulars
		jsonNewDirectPremCollns.assdNo 			= objAC.currentRecord.assdNo;
		jsonNewDirectPremCollns.assdName 		= $F("assdName"); 												// var
																												// assdName
		jsonNewDirectPremCollns.premAmt 		= unformatCurrency("directPremAmt");											// var
																																// premAmt
		jsonNewDirectPremCollns.taxAmt 			= unformatCurrency("taxAmt");													// var																												// taxAmt
		jsonNewDirectPremCollns.currCd 			= objAC.currentRecord.currCd;										// var																											// currCd;
		jsonNewDirectPremCollns.currRt 		    = objAC.currentRecord.currRt;
		if (objAC.currentRecord.orPrintTag) {
			jsonNewDirectPremCollns.orPrintTag = objAC.currentRecord.orPrintTag;
		} else {
			jsonNewDirectPremCollns.orPrintTag = "N";
		}
		
		jsonNewDirectPremCollns.incTag 			= objAC.currentRecord.incTag == "Y" ? "Y" : "N";
		jsonNewDirectPremCollns.forCurrAmt 		= jsonNewDirectPremCollns.collAmt / jsonNewDirectPremCollns.currRt; 
		jsonNewDirectPremCollns.origPremAmt 	= objAC.currentRecord.origPremAmt;
		jsonNewDirectPremCollns.origTaxAmt 		= objAC.currentRecord.origTaxAmt;
		jsonNewDirectPremCollns.policyId 		= objAC.currentRecord.policyId;
		jsonNewDirectPremCollns.lineCd 			= objAC.currentRecord.lineCd;
		jsonNewDirectPremCollns.gaccTranId 		= objACGlobal.gaccTranId;
		jsonNewDirectPremCollns.maxCollAmt		= objAC.currentRecord.maxCollAmt;
		jsonNewDirectPremCollns.balanceAmtDue   = parseFloat(objAC.currentRecord.maxCollAmt) - unformatCurrencyValue(objAC.currentRecord.collAmt); 
		jsonNewDirectPremCollns.premZeroRated   = objAC.currentRecord.premZeroRated;
		jsonNewDirectPremCollns.premVatable 	= objAC.currentRecord.premVatable;
		jsonNewDirectPremCollns.premVatExempt 	= nvl(objAC.currentRecord.premVatExempt, null) == null ? unformatCurrency("directPremAmt") : objAC.currentRecord.premVatExempt;
		jsonNewDirectPremCollns.revGaccTranId   = objAC.currentRecord.revGaccTranId;
		
		jsonNewDirectPremCollns.paramPremAmt    = nvl(objAC.currentRecord.paramPremAmt, null) == null ? objAC.currentRecord.origPremAmt : objAC.currentRecord.paramPremAmt;
		jsonNewDirectPremCollns.prevPremAmt		= nvl(objAC.currentRecord.prevPremAmt, null) == null ? objAC.currentRecord.origPremAmt : objAC.currentRecord.prevPremAmt;
		jsonNewDirectPremCollns.prevTaxAmt 		= nvl(objAC.currentRecord.prevTaxAmt, null) == null ? objAC.currentRecord.origTaxAmt : objAC.currentRecord.prevTaxAmt;
		
		jsonNewDirectPremCollns.commPaytSw	    = 0;
		jsonNewDirectPremCollns.recordStatus	= 0;
	} catch(e) {
		showErrorMessage("prepareGDCPRecord", e);
	}
	return jsonNewDirectPremCollns;
}