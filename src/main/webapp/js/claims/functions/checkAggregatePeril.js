function checkAggregatePeril(){
	try{
		new Ajax.Request(contextPath+"/GICLItemPerilController", { 
			method: "POST",
			parameters:{
				action:      "checkAggPeril",
				aggregateSw: objCLMItem.newPeril.aggregateSw,          
				lineCd: 	 objCLMGlobal.lineCd,
				sublineCd: 	 objCLMGlobal.sublineCd,
				polIssCd: 	 objCLMGlobal.policyIssueCode,
				issueYy: 	 objCLMGlobal.issueYy,
				polSeqNo: 	 objCLMGlobal.policySequenceNo,
				renewNo: 	 objCLMGlobal.renewNo,  
				polEffDate:  objCLMGlobal.strPolicyEffectivityDate2,
				expiryDate:  objCLMGlobal.strExpiryDate2,
				lossDate: 	 objCLMGlobal.strLossDate2,
				itemNo:		 $F("txtItemNo"),
				groupedItemNo: $F("txtGrpItemNo"),  
				perilCd:   	 objCLMItem.perilCd,           
				noOfDays:    objCLMItem.newPeril.noOfDays,        
				annTsiAmt: 	 objCLMItem.newPeril.annTsiAmt
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)) {
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
					if (res.aggPeril == 'Y'){
						showMessageBox("Aggregate Peril is still in progress and cannot be used until existing aggregate peril is closed.", imgMessage.INFO);				
						return false;
					}else {
						objCLMItem.newPeril.allowTsiAmt = nvl(res.allowTsiAmt,"") == "" ? "" :formatCurrency(res.allowTsiAmt);
						$("txtDspPerilName").value = unescapeHTML2(objCLMItem.newPeril.dspPerilName);
						$("txtDspLossCatDes").value = unescapeHTML2(objCLMItem.newPeril.dspLossCatDes);
						$("txtAnnTsiAmt").value = nvl(res.annTsiAmt,"") == "" ? "" :formatCurrency(res.annTsiAmt);
						$("txtNoOfDays").value = res.noOfDays;
						$("txtDspPerilName").focus();
					}
				}
			}
		});
		
	}catch(e){
		showErrorMessage("checkAggregatePeril", e);
	}
}