function addRecordsInPaidList(newRecordsList) {
	try{
		changeTag = 0;
		var objArray = eval('[]');
		for (var index1=0; index1<newRecordsList.length; index1++) { 
			var newPremCollnRowId = objACGlobal.gaccTranId + 
									newRecordsList[index1].issCd + newRecordsList[index1].premSeqNo +
									newRecordsList[index1].instNo + newRecordsList[index1].tranType;
			
			objAC.currentRecord.incTag = "N";
			getIncTagForAdvPremPayts(newRecordsList[index1].issCd, newRecordsList[index1].premSeqNo);
			
			if (getObjectFromArrayOfObjects(objAC.jsonLoadDirectPremCollnsDtls, 
										    "gaccTranId issCd premSeqNo instNo tranType",
						    				newPremCollnRowId)==null) {
				newRecordsList[index1].recordStatus	= 0;
				newRecordsList[index1].maxCollAmt = newRecordsList[index1].collAmt;
				newRecordsList[index1].balanceAmtDue = 0;
	
				objAC.jsonDirectPremCollnsDtls.push(newRecordsList[index1]);
			} else {
				var jsonReplacementRecord = getObjectFromArrayOfObjects(objAC.jsonDirectPremCollnsDtls, "gaccTranId issCd premSeqNo instNo tranType",
											newPremCollnRowId);
				objAC.jsonDirectPremCollnsDtls.splice(jsonReplacementRecord.index, 1, jsonReplacementRecord);
				jsonReplacementRecord.recordStatus = 2;
			}
	
			newRecordsList[index1].gaccTranId = objACGlobal.gaccTranId;
			newRecordsList[index1].incTag = objAC.currentRecord.incTag == "Y" ? "Y" : "N";
			objArray.splice(0, 1, newRecordsList[index1]);
			createDivTableRows(objArray, "premiumCollectionList", "rowPremColln", "rowPremColln", "gaccTranId issCd premSeqNo instNo tranType",prepareDirectPremCollnInfo);
			addRecordEffects("rowPremColln", rowPremCollnSelectedFn, rowPremCollnDeselectedFn, "newRecord", "rowPremColln"+newPremCollnRowId);
			checkTableIfEmpty("rowPremColln", "directPremiumCollectionTable");
			checkIfToResizeTable("premiumCollectionList", "rowPremColln");
			checkIfToResizeTable2("premiumCollectionList", "rowPremColln");
		}
		
		resetFormValues();
		computeTotals();
	
		objAC.formChanged = "Y";
		
		for (var index2=0; index2<objAC.jsonTaxCollnsNewRecordsList.length; index2++) {
			if (objAC.jsonTaxCollnsNewRecordsList[index2].haveCreatedRow==null) {
				createDivTableRows(objAC.jsonTaxCollnsNewRecordsList[index2], "taxCollectionListContainer", "taxRow", "taxRow", "b160IssCd b160PremSeqNo transactionType instNo b160TaxCd",prepareTaxCollectionsInfo);
				objAC.jsonTaxCollnsNewRecordsList[index2].haveCreatedRow = true;
				for (var i=0; i<objAC.jsonTaxCollnsNewRecordsList[index2].length; i++) {
					addRecordEffects("taxRow", null, null, "newRecord", "taxRow"+objAC.jsonTaxCollnsNewRecordsList[index2][i].b160IssCd + objAC.jsonTaxCollnsNewRecordsList[index2][i].b160PremSeqNo + objAC.jsonTaxCollnsNewRecordsList[index2][i].transactionType + 
																		+ objAC.jsonTaxCollnsNewRecordsList[index2][i].instNo + objAC.jsonTaxCollnsNewRecordsList[index2][i].b160TaxCd);
					//objAC.jsonTaxCollnsNew.push(objAC.jsonTaxCollnsNewRecordsList[index2]);
				}
			}
		}
		
		hideTaxCollections($("taxCollectionTable"), $("taxCollectionListContainer"));
	} catch (e) {
		showErrorMessage("addRecordsInPaidList", e);
	}
}