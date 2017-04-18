function addRecord(obj) {
	changeTag = 1;
	var objArray = eval('[{}]');
	var jsonNewDirectPremCollns = new Object();
	
	if(obj==null || obj==undefined) {
		jsonNewDirectPremCollns = prepareGDCPRecord();
	} else {
		jsonNewDirectPremCollns = obj;
	}
	
	var newPremCollnRowId = objACGlobal.gaccTranId + 
							jsonNewDirectPremCollns.issCd + jsonNewDirectPremCollns.premSeqNo +
							jsonNewDirectPremCollns.instNo + jsonNewDirectPremCollns.tranType;
	
	if ($("btnAdd").value=="Update") {  //hindi na ata na nagagamit :)
		var oldPremCollnRowId = objACGlobal.gaccTranId + objAC.selectedRecord.issCd + objAC.selectedRecord.premSeqNo +
								objAC.selectedRecord.instNo + objAC.selectedRecord.tranType;
		$$("div[name='rowPremColln']").each(function(row){
			if (row.hasClassName("selectedRow")) {
				
				var objFilteredArr;
				objFilteredArr = 
					objAC.jsonDirectPremCollnsDtls.filter(
						function(obj){
							return obj.gaccTranId+ 
								    obj.issCd +
								    obj.premSeqNo +
								    obj.instNo +
								    obj.tranType != oldPremCollnRowId;
								
						});

				objAC.jsonDirectPremCollnsDtls = null;
				objAC.jsonDirectPremCollnsDtls = objFilteredArr;
				

				/*objFilteredArr2 = 
					objAC.jsonDirectPremCollnsDtls.filter(
						function(obj){
							return newPremCollnRowId != oldPremCollnRowId;
								
						});

				objAC.jsonDirectPremCollnsDtls = null;
				objAC.jsonDirectPremCollnsDtls = objFilteredArr2;*/
				
				row.removeClassName("selectedRow");
				Effect.Fade(row, {
					duration: .2,
					afterFinish: function ()	{
						hideTaxCollections($("taxCollectionTable"),
			 		           $("taxCollectionListContainer"));
					    removeFromTaxCollectionsTable(objACGlobal.gaccTranId +
		     					  					  row.down("label",2).innerHTML +
			                     					  row.down("label", 3).innerHTML + 
				                     				  row.down("label", 4).innerHTML +
				                     				  row.down("label", 1).innerHTML);
						row.remove();
					}
				});
			}
		});
	}
	
	if (getObjectFromArrayOfObjects(objAC.jsonLoadDirectPremCollnsDtls, 
								    "gaccTranId issCd premSeqNo instNo tranType",
				    				newPremCollnRowId)==null) {
		jsonNewDirectPremCollns.recordStatus	= 0;
		objAC.jsonDirectPremCollnsDtls.push(jsonNewDirectPremCollns);
	} else {
		/*
		var jsonReplacementRecord = getObjectFromArrayOfObjects(objAC.jsonDirectPremCollnsDtls, "gaccTranId issCd premSeqNo instNo tranType",
									newPremCollnRowId);
		objAC.jsonDirectPremCollnsDtls.splice(jsonReplacementRecord.index, 1, jsonReplacementRecord);
		jsonReplacementRecord.recordStatus = 2;
		*/
	}

	objArray.splice(0, 1, jsonNewDirectPremCollns);
	createDivTableRows(objArray, "premiumCollectionList", "rowPremColln", "rowPremColln", "gaccTranId issCd premSeqNo instNo tranType",prepareDirectPremCollnInfo);
	addRecordEffects("rowPremColln", rowPremCollnSelectedFn, rowPremCollnDeselectedFn, "newRecord", "rowPremColln"+newPremCollnRowId);
	checkTableIfEmpty("rowPremColln", "directPremiumCollectionTable");
	checkIfToResizeTable("premiumCollectionList", "rowPremColln");
	checkIfToResizeTable2("premiumCollectionList", "rowPremColln");
	objAC.formChanged = 'Y';
	if(obj==null) resetFormValues();
	computeTotals();

	objAC.formChanged = "Y";
	createDivTableRows(objAC.jsonTaxCollnsNew, "taxCollectionListContainer", "taxRow", "taxRow", "b160IssCd b160PremSeqNo transactionType instNo b160TaxCd",prepareTaxCollectionsInfo);

	for (var i=0; i<objAC.jsonTaxCollnsNew.length; i++) {
		addRecordEffects("taxRow",null,null, "newRecord", "taxRow"+objAC.jsonTaxCollnsNew[i].b160IssCd + objAC.jsonTaxCollnsNew[i].b160PremSeqNo + objAC.jsonTaxCollnsNew[i].transactionType + 
															+ objAC.jsonTaxCollnsNew[i].instNo + objAC.jsonTaxCollnsNew[i].b160TaxCd);
	}
	
	hideTaxCollections($("taxCollectionTable"), $("taxCollectionListContainer"));
}