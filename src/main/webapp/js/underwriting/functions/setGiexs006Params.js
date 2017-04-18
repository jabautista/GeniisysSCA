function setGiexs006Params(){
	var action = "";		
	var controller = "";
	if(objGiexs006.giexs006Report == "RENEWAL NOTICE"){
		action = "getRenewalNoticePolicyId";
		giexs006ReportName = "RENEW";
		controller = "/GIEXExpiryController";
		objGiexs006.renewFlag = 2;
		objGiexs006.reqRenewalNo = "Y";
		policyId = dspPolicyId;
	}else if(objGiexs006.giexs006Report == "PACKAGE RENEWAL NOTICE"){
		action = "getPackPolicyId";
		giexs006ReportName = "RENEW_PACK";
		controller = "/GIEXPackExpiryController";
		objGiexs006.renewFlag = 2;
		objGiexs006.reqRenewalNo = "M";
		policyId = dspPackPolicyId;
	}else if(objGiexs006.giexs006Report == "NON-RENEWAL NOTICE"){
		action = "getRenewalNoticePolicyId";
		giexs006ReportName = "NON_RENEW";
		controller = "/GIEXExpiryController";
		objGiexs006.renewFlag = 1;
		objGiexs006.reqRenewalNo = "N";
		policyId = dspPolicyId;
	}else if(objGiexs006.giexs006Report == "PACKAGE NON-RENEWAL NOTICE"){
		action = "getPackPolicyId";
		giexs006ReportName = "NON_RENEW_PK";
		controller = "/GIEXPackExpiryController";
		objGiexs006.renewFlag = 1;
		objGiexs006.reqRenewalNo = "N";
		policyId = dspPackPolicyId;
	}
	
	if($("batch").checked){
		getRenewalNoticePolicyId(action, giexs006ReportName, controller);	
	}else{
		printRenewalNotice(policyId, giexs006ReportName);
		
			//added by Gzelle 05202015 SR3705
		if(objGiexs006.dialog == "info"){
			overlayExpiryReportInfoDialog.close();
		}else if(objGiexs006.dialog == "renewal"){
			overlayExpiryReportRenewalDialog.close();
		}else if(objGiexs006.dialog == "reason"){
			overlayExpiryReportReasonDialog.close();
		}	//end
		
		if ("SCREEN" == $F("selDestination")) {
			showMultiPdfReport(reports);
			reports = [];
		}
	}
}