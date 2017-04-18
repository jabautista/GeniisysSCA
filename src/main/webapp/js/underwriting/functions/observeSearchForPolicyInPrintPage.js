function observeSearchForPolicyInPrintPage(){
	if (intFieldsAreNotNan()){
		/*
		showOverlayContent(contextPath+"/GIPIPolbasicController?action=getPolicyListing&pageNo=1"
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
				"Select Policy", "", 125, 20, 10);
		*/
		/*showOverlayContent2(contextPath+"/GIPIPolbasicController?action=getPolicyListing&pageNo=1"
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
				"Select Policy", 800, "");*/ // replaced by: Nica
		try{
			overlayReprintPolicyListing = 
				Overlay.show(contextPath + "/GIPIPolbasicController", {
					urlContent : true,
					urlParameters: {
						action : "getPolicyTableGridListing",
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
				    draggable : true,
				    showNotice: true, //marco - 06.25.2013
				    noticeMessage: "Getting list, please wait..."
				}); 
		}catch(e){
			showErrorMessage("observeSearchForPolicyInPrintPage", e);
		}
	}
}