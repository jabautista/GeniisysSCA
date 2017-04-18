//	move by		: mark jm 04.20.2011 @UCPBGEN
//	moved from 	: selectPolicyNoTable.jsp
function loadSelected() {
	try{
		var parId = $F("globalParId");
		var lineCd = $F("curLine");
		var issCd = $F("curIss");
		var sublineCd = $F("selectedSubline");
		var polSeqNo = $F("selectedPolSeq");
		var issueYy = $F("selectedIssueYy");
		var renewNo = $F("selectedRenewNo");

		if ($F("isPack") == "Y") {
			parId = objUWGlobal.packParId;
		} else {
			parId = $F("globalParId");
		}
		
		if(sublineCd.blank() || polSeqNo.blank() ) {
			showMessageBox("Please select a Valid Policy", "info");
		}  else {
		//showOverlayContent(contextPath+"/GIPIParInformationController?action=showPolicyNo&parId="+parId+"&lineCd="
			//	+lineCd+"&issCd="+issCd+"&sublineCd="+sublineCd+"&polSeqNo="+polSeqNo+"&issueYy="+issueYy+"&renewNo="+renewNo,
					//   "Policy Number", overlayOnComplete, 370, 150, 20);
					
		var controller = "";
		var action = "";
		if ($F("isPack") == "Y") {
			controller = "GIPIPackParInformationController";
			action = "showPackPolicyNo";
		} else {
			controller = "GIPIParInformationController";
			action = "showPolicyNo";
		}
		
		showOverlayContent2(contextPath+"/"+controller+"?action="+action+"&parId="+parId+"&lineCd="
				+lineCd+"&issCd="+issCd+"&sublineCd="+sublineCd+"&polSeqNo="+polSeqNo+"&issueYy="+issueYy+"&renewNo="+renewNo,
					   "Policy Number", 490, overlayOnComplete);		
		}
	}catch(e){
		showErrorMessage("loadSelected", e);
	}	
}