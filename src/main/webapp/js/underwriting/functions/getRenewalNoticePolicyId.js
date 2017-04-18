function getRenewalNoticePolicyId(action, giexs006ReportName, controller){
	
	try{
		new Ajax.Request(contextPath+controller,{
			method: "GET",
			parameters: {
				action	   : action,
				policyId   : policyId,
				frRnSeqNo  : $F("frRnSeqNo"),
				toRnSeqNo  : $F("toRnSeqNo"),
				assdNo     : $F("assuredLOV"),
				intmNo     : $F("intmLOV"),
				issCd      : objGiexs006.issCd,
				sublineCd  : objGiexs006.sublineCd,
				lineCd     : objGiexs006.lineCd,
				startDate  : objGiexs006.startDate,
				endDate    : objGiexs006.endDate,
				noOfCopies : $("txtNoOfCopies").value,
				printerName: $("selPrinter").value,
				renewFlag  : objGiexs006.renewFlag,
				reqRenewalNo : objGiexs006.reqRenewalNo,
				premBalanceOnly : objGiexs006.premBalanceOnly,	//Gzelle 05202015 SR3703
				claimsOnly : objGiexs006.claimsOnly	//Gzelle 05202015 SR3698
				//reqRenewalNo : "Y"
			},
			evalScripts:	true,
			asynchronous:	true,
			onComplete: function(response) {	
				var res = JSON.parse(response.responseText);
				if(res.length == 0){
					showMessageBox("Policy is not existing.", imgMessage.ERROR);
				}else{
					if(objGiexs006.giexs006Report == "PACKAGE RENEWAL NOTICE" || objGiexs006.giexs006Report == "PACKAGE NON-RENEWAL NOTICE"){
						for(var a=0; a<res.length; a++){
							policyList.push(res[a].packPolicyId);//kenneth 11.24.2014
						}
						printRenewalNotice(policyList, giexs006ReportName);//kenneth 11.24.2014
						policyList = [];
					}else{
						for(var a=0; a<res.length; a++){
							policyList.push(res[a].policyId);//kenneth 11.24.2014
						}
						printRenewalNotice(policyList, giexs006ReportName);//kenneth 11.24.2014
						policyList = [];
					}
					if ("SCREEN" == $F("selDestination")) {
						showMultiPdfReport(reports);
						reports = [];
					}
				}
				if(objGiexs006.dialog == "info"){
					overlayExpiryReportInfoDialog.close();
				}else if(objGiexs006.dialog == "renewal"){
					overlayExpiryReportRenewalDialog.close();
				}else if(objGiexs006.dialog == "reason"){
					overlayExpiryReportReasonDialog.close();
				}
				
			}
		});
	}catch(e){
		showErrorMessage("getRenewalNoticePolicyId", e);
	}
}