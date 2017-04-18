function getTaxType(taxType, recordValidated, func){
	try {
		new Ajax.Request(contextPath+"/GIACDirectPremCollnsController?action=taxDefaultValueType", {
			method: "GET",
			parameters: {
				tranId: 		objACGlobal.gaccTranId,	
				tranType: 		taxType,
				tranSource: 	$F("tranSource") == "" ? recordValidated.issCd : $F("tranSource"),
				premSeqNo: 		recordValidated.billCmNo ? recordValidated.billCmNo : $F("billCmNo"),
				instNo: 		recordValidated.instNo 	 ? recordValidated.instNo 	: $F("instNo"),
				fundCd: 		objACGlobal.fundCd,
				taxAmt: 		unformatCurrencyValue(recordValidated.taxAmt),
				//paramPremAmt: 	unformatCurrencyValue(recordValidated.origPremAmt), 
				paramPremAmt: 	recordValidated.premVatable, //mikel 09.03.2015; UCPBGEN SR 20211
				premAmt: 		unformatCurrencyValue(recordValidated.origPremAmt),
				collnAmt: 		unformatCurrencyValue(recordValidated.premCollectionAmt),
				premVatExempt:  recordValidated.premVatExempt,//unformatCurrencyValue(recordValidated.premVatExempt),		
				revTranId:	    recordValidated.revGaccTranId,			
				taxType: 		taxType
			},
			evalScripts: true,
			asynchronous: false,
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var result = response.responseText.toQueryParams();
					objAC.jsonTaxCollnsNew = JSON.parse(result.giacTaxCollnCur);
					/*var rIndex = 0;
					if (objAC.jsonTaxCollnsNewRecordsList) {
						rIndex = objAC.jsonTaxCollnsNewRecordsList.length - 1;
					}
					objAC.jsonTaxCollnsNewRecordsList.splice(rIndex, 0, objAC.jsonTaxCollnsNew);*/
					if(objAC.jsonTaxCollnsNewRecordsList) {
						var createTaxSet = true;
						for(var h=0; h<objAC.jsonTaxCollnsNewRecordsList.length; h++) {
							var tempArr = objAC.jsonTaxCollnsNewRecordsList[h];
							for(var i=0; i<objAC.jsonTaxCollnsNew.length; i++) {
								var exists = false;
								for(var j=0; j<tempArr.length; j++) {
									if(tempArr[j].instNo == objAC.jsonTaxCollnsNew[i].instNo &&
											tempArr[j].b160TaxCd == objAC.jsonTaxCollnsNew[i].b160TaxCd &&
											tempArr[j].b160IssCd == objAC.jsonTaxCollnsNew[i].b160IssCd &&
											tempArr[j].transactionType == objAC.jsonTaxCollnsNew[i].transactionType &&
											tempArr[j].b160PremSeqNo == objAC.jsonTaxCollnsNew[i].b160PremSeqNo) {
										exists = true;
										break;
									}
								}
								if(exists) {
									createTaxSet = false;
									break;
								}
							}
						}
	
						var rIndex = 0;
						if(createTaxSet) {
							if (objAC.jsonTaxCollnsNewRecordsList.length > 0) {
								rIndex = objAC.jsonTaxCollnsNewRecordsList.length - 1;
							}
							objAC.jsonTaxCollnsNewRecordsList.splice(rIndex, 0, objAC.jsonTaxCollnsNew);
						}
					}
					
					objAC.sumGtaxAmt = result.taxAmt;
					
					if(func != null) func(result);
					
				}
			}
		});
	} catch(e) {
		 showMessageBox(e.message);
	}
}