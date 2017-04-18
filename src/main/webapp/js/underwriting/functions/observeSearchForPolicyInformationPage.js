/**
 * Description - getting the list of Polices (endt seq no 0)
 * 			     based on the filled text-fields
 * created by  - mosesBC
 */
function observeSearchForPolicyInformationPage(){
	showOverlayContent(contextPath+"/GIPIPolbasicController?action=getPolicyInformationFirstPage&pageNo=1"
		+"&lineCd="+$F("txtLineCd")
		+"&sublineCd="+$F("txtSublineCd")
		+"&issCd="+$F("txtIssCd")
		+"&issueYy="+$F("txtIssueYy")
		+"&polSeqNo="+$F("txtPolSeqNo")
		+"&renewNo="+$F("txtRenewNo")
		+"&refPolNo="+$F("txtRefPolNo")
		+"&nbtLineCd="+$F("txtNbtLineCd")
		+"&nbtIssCd="+$F("txtNbtIssCd")
		+"&nbtParYy="+$F("txtNbtParYy") 
		+"&nbtParSeqNo="+$F("txtNbtParSeqNo") 
		+"&nbtQuoteSeqNo="+$F("txtNbtQuoteSeqNo"), 
		"Policy List", "", 125, 20, 10);
}