function showPolicyListingForCertPrinting(){
	if (intFieldsAreNotNan()){
		/*showMe(contextPath+"/GIPIPolbasicController?action=getPolicyListingForCertPrinting&pageNo=1"
				+"&lineCd="+$F("txtLineCd")
				+"&sublineCd="+$F("txtSublineCd")
				+"&issCd="+$F("txtIssCd")
				+"&issueYy="+$F("txtIssueYy")
				+"&polSeqNo="+$F("txtPolSeqNo")
				+"&renewNo="+$F("txtRenewNo")
				+"&lineCd2="+$F("txtCLineCd")
				+"&sublineCd2="+$F("txtCSublineCd")
				+"&endtIssCd="+$F("txtCEndtIssCd")
				+"&endtYy="+$F("txtEndtYy")
				+"&endtSeqNo="+$F("txtEndtSeqNo")
				+"&assdName="+$F("assdName"), 
				800);*/ // replace by: Nica 04-26-2012 - to tableGrid Listing
		
		overlayReprintPolicyListing = 
			Overlay.show(contextPath + "/GIPIPolbasicController", {
				urlContent : true,
				urlParameters: {action : "getCertPolicyTableGridListing",
								lineCd : $F("txtLineCd"),
								sublineCd : $F("txtSublineCd"),
								issCd : $F("txtIssCd"),
								issueYy : $F("txtIssueYy"),
								polSeqNo : $F("txtPolSeqNo"),
								renewNo : $F("txtRenewNo"),
								endtLineCd : $F("txtCLineCd"),
								endtSublineCd : $F("txtCSublineCd"),
								endtIssCd : $F("txtCEndtIssCd"),
								endtYy : $F("txtEndtYy"),
								endtSeqNo : $F("txtEndtSeqNo"),
								assdName : $F("assdName"),
								ajax : "1"},
			    title: "Policy Listing",
			    height: 390,
			    width: 850,
			    draggable : true
			});
	}
}