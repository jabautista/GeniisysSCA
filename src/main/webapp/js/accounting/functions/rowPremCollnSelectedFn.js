function rowPremCollnSelectedFn(row) {
	var selectedPremCollnDtls = getObjectFromArrayOfObjects(objAC.jsonDirectPremCollnsDtls, 
													        "gaccTranId issCd premSeqNo instNo tranType",
													        objACGlobal.gaccTranId + 
													        row.down("label",2).innerHTML + // issCd/Issource
									 				        row.down("label",3).innerHTML + // premSeqNo/billCmNo
									 				        row.down("label",4).innerHTML + // instNo
									 				        row.down("label",1).innerHTML); // tranType
	if (selectedPremCollnDtls) {
		$("tranType").value 			= selectedPremCollnDtls.tranType;
		$("tranSource").value 			= selectedPremCollnDtls.issCd;
		$("billCmNo").value 			= selectedPremCollnDtls.premSeqNo;
		$("instNo").value 				= selectedPremCollnDtls.instNo;
		$("premCollectionAmt").value 	= formatCurrency(selectedPremCollnDtls.collAmt);
		$("assdName").value 			= unescapeHTML2(nvl(selectedPremCollnDtls.assdName,"")); //added by steven 10/22/2012
		$("polEndtNo").value			= selectedPremCollnDtls.policyNo;
		$("particulars").value 			= unescapeHTML2(nvl(selectedPremCollnDtls.particulars,""));//changed by steven 10/25/2012 from: changeBackDividerChar  to: unescapeHTML2
		$("directPremAmt").value 		= formatCurrency(selectedPremCollnDtls.premAmt);
		$("taxAmt").value 				= formatCurrency(selectedPremCollnDtls.taxAmt);
		
		//fireEvent($("dummyInstNo"), "click");
		
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
		//objAC.selectedRecord.maxCollAmt			= parseFloat(selectedPremCollnDtls.collAmt) + parseFloat(selectedPremCollnDtls.balanceAmtDue);
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
		objAC.selectedRecord.isSaved				= nvl(selectedPremCollnDtls.isSaved, null);
		if (objAC.defCurrency == objAC.selectedRecord.currCd){
			disableButton("btnForeignCurrency");
			//enableButton("btnForeignCurrency");
		}else{
			enableButton("btnForeignCurrency");
			//disableButton("btnForeignCurrency");
		}
		
		$("btnAdd").value = "Update";
		
		//objAC.currentRecord
		if (objAC.selectedRecord.recordStatus!=null || objAC.selectedRecord.recordStatus!=undefined ||
				objAC.selectedRecord.recordStatus=="") {
			enableButton("btnDelete");
			enableButton("btnAdd");
			makeRecordEditable("gdpcRecord");
			
			if(selectedPremCollnDtls.tranType == 2 || selectedPremCollnDtls.tranType == 4) {
				$("premCollectionAmt").readOnly = true;
			} else {
				if (objAC.selectedRecord.isSaved == "Y") {
					$("premCollectionAmt").readOnly = true;
					//disableButton("btnAdd");
				} else {
					$("premCollectionAmt").readOnly = false;
					//enableButton("btnAdd");
				}
			}

		} else {
			enableButton("btnDelete");
			//disableButton("btnAdd");
			//makeRecordReadOnly("gdpcRecord");
			//$("premCollectionAmt").disabled = false;
			if (objAC.selectedRecord.isSaved == "Y") {
				$("premCollectionAmt").readOnly = true;
				//disableButton("btnAdd");
			} else {
				$("premCollectionAmt").readOnly = false;
				//enableButton("btnAdd");
			}
		}	
	}
	//$("oscmBillCmNo").hide();
	//$("oscmInstNo").hide();
	 // added by alfie 11.26.2010
	hideTaxCollections($("taxCollectionTable"), 
				 	   $("taxCollectionListContainer"));
		   
	showTaxCollectionsOfSelected($("taxCollectionTable"), 
			 					 $("taxCollectionListContainer"),
			 					 objACGlobal.gaccTranId + 
			 					 selectedPremCollnDtls.issCd +
			 					 // row.down("input",1).value +
			 					 selectedPremCollnDtls.premSeqNo +
			 					 selectedPremCollnDtls.instNo +
			 					 // row.down("input", 2).value +
			 					 selectedPremCollnDtls.tranType);
			 					 // row.down("input", 0).value);
	
	displayTotalTaxAmount(getTotalTaxAmount(objACGlobal.gaccTranId + 
											// row.down("input",1).value +
				 							selectedPremCollnDtls.issCd +
				 							// row.down("input", 2).value +
				 							selectedPremCollnDtls.premSeqNo +
				 							selectedPremCollnDtls.instNo +
				 							selectedPremCollnDtls.tranType));
				 							// row.down("input", 0).value));
		
	checkTableIfEmpty2("taxRow", "taxCollectionTable");
	checkIfToResizeTable2("taxCollectionListContainer", "taxRow");

	//if (selectedPremCollnDtls.recordStatus!=null || selectedPremCollnDtls.recordStatus!=undefined){
		objAC.currentRecord = selectedPremCollnDtls;
	//}
	
	enableDisableFieldsGiacs007(); //Added by Tonio May 13, 2011 to disable objects when orFlag is not equal to N
	
	$("tranType").disable();
	$("tranSource").disable();
	$("billCmNo").readOnly = true;
	$("oscmBillCmNo").setStyle({display: 'none'});
	
	$("instNo").readOnly = true;
	$("oscmInstNo").setStyle({display: 'none'});
}