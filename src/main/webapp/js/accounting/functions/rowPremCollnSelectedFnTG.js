//moved from directPremiumCollection2.jsp
function rowPremCollnSelectedFnTG(row) {
	var selectedPremCollnDtls = row;
	if (selectedPremCollnDtls) {
		$("tranType").value 			= selectedPremCollnDtls.tranType;
		$("tranSource").value 			= selectedPremCollnDtls.issCd;
		$("billCmNo").value 			= selectedPremCollnDtls.premSeqNo;
		$("instNo").value 				= parseInt((selectedPremCollnDtls.instNo)).toPaddedString(2); //robert 01.30.2013
		$("premCollectionAmt").value 	= formatCurrency(selectedPremCollnDtls.collAmt);
		$("assdName").value 			= unescapeHTML2(selectedPremCollnDtls.assdName);
		$("polEndtNo").value			= unescapeHTML2(selectedPremCollnDtls.policyNo); //robert
		$("particulars").value 			= unescapeHTML2(selectedPremCollnDtls.particulars);
		$("directPremAmt").value 		= formatCurrency(selectedPremCollnDtls.premAmt);
		$("taxAmt").value 				= formatCurrency(selectedPremCollnDtls.taxAmt);
		
		objAC.selectedRecord = new Object(selectedPremCollnDtls);
		
		objAC.selectedRecord.collAmt				= selectedPremCollnDtls.collAmt;
		objAC.selectedRecord.premAmt				= selectedPremCollnDtls.premAmt;
		objAC.selectedRecord.origCollAmt 			= selectedPremCollnDtls.collAmt;
		objAC.selectedRecord.origPremAmt 			= unformatCurrencyValue(""+ selectedPremCollnDtls.premAmt) + unformatCurrencyValue(""+selectedPremCollnDtls.premBalanceDue);
		objAC.selectedRecord.origTaxAmt 			= selectedPremCollnDtls.taxAmt;
		objAC.selectedRecord.currCd					= selectedPremCollnDtls.currCd; //$F("transCurrCd");//
		objAC.selectedRecord.currRt 				= selectedPremCollnDtls.currRt == undefined ? selectedPremCollnDtls.convRate : selectedPremCollnDtls.currRt;//$F("transCurrRt");//
		objAC.selectedRecord.currShortName 			= "";	
		objAC.selectedRecord.currDesc				= "";
		objAC.selectedRecord.policyId 				= selectedPremCollnDtls.policyId;
		objAC.selectedRecord.lineCd 				= selectedPremCollnDtls.lineCd;
		//objAC.selectedRecord.maxCollAmt				= parseFloat(selectedPremCollnDtls.collAmt) + parseFloat(selectedPremCollnDtls.balanceAmtDue);
		objAC.selectedRecord.maxCollAmt				= selectedPremCollnDtls.maxCollAmt;
		objAC.selectedRecord.balanceAmtDue	 		= selectedPremCollnDtls.balanceAmtDue;
		objAC.selectedRecord.commPaytSw				= selectedPremCollnDtls.commPaytSw;
		objAC.selectedRecord.premVatable			= selectedPremCollnDtls.premVatable;
		objAC.selectedRecord.premVatExempt			= selectedPremCollnDtls.premVatExempt;
		objAC.selectedRecord.premZeroRated			= selectedPremCollnDtls.premZeroRated;
		objAC.selectedRecord.revGaccTranId			= selectedPremCollnDtls.revGaccTranId;
		
		objAC.selectedRecord.paramPremAmt			= selectedPremCollnDtls.paramPremAmt;
		objAC.selectedRecord.prevPremAmt			= selectedPremCollnDtls.prevPremAmt;
		objAC.selectedRecord.prevTaxAmt				= selectedPremCollnDtls.prevTaxAmt;
		
		objAC.selectedRecord.recordStatus			= selectedPremCollnDtls.recordStatus;
		
		//objAC.currentRecord
		if (objAC.selectedRecord.recordStatus == '0' || objAC.selectedRecord.recordStatus == '1') {
			$("btnAdd").value = "Update";
			$("btnAdd").setAttribute("status", "Update");
			enableButton("btnDelete");
			enableButton("btnAdd");
			makeRecordEditable("gdpcRecord");
			if(selectedPremCollnDtls.tranType == 2 || selectedPremCollnDtls.tranType == 4) {
				$("premCollectionAmt").readOnly = true;
			} else {
				$("premCollectionAmt").readOnly = false;
			}
		} else {
			enableButton("btnDelete");
			disableButton("btnAdd");
			$("premCollectionAmt").readOnly = true;
			$("particulars").readOnly = true;
		}
	}
	
	objAC.currentRecord = selectedPremCollnDtls;
	$("tranType").disable();
	//$("tranSource").disable();
	$("billCmNo").readOnly = true;
	//$("oscmBillCmNo").setStyle({display: 'none'});
	disableSearch("oscmBillCmNo");
	$("instNo").readOnly = true;
	//$("oscmInstNo").setStyle({display: 'none'});
	disableSearch("oscmInstNo");
	$("tranSource").readOnly = true;	 // SR-20000 : shan 08.24.2015
	disableSearch("oscmBillIssCd"); // SR-20000 : shan 08.24.2015
}