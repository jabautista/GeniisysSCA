/**
 * Loads selected policy for endt
 * @author andrew
 * @date 05.09.2011
 * @param row - selected policy
 */
function loadSelected2(row) {
	try{
		var parId = (objUWGlobal.packParId != null ? objUWGlobal.packParId : $F("globalParId"));
		var lineCd = row.lineCd;
		var issCd = row.issCd;
		var sublineCd = row.sublineCd;
		var polSeqNo = row.polSeqNo;
		var issueYy = row.issueYy;
		var renewNo = row.renewNo;
		var assdNo = row.assdNo;
	    var riCd = row.riCd;
	   
		if(sublineCd == "" || polSeqNo == "") {
		showMessageBox("Please select a Valid Policy", "info");
		}  else {	
				$("polSublineCd").value = unescapeHTML2(sublineCd);		//unescapeHTML2 added by shan RSIC SR-13508
				$("polPolSeqNo").value = polSeqNo.toPaddedString(7);
				$("polIssueYy").value = issueYy;
				$("polRenewNo").value = renewNo.toPaddedString(2);
		}
		
	}catch(e){
		showErrorMessage("loadSelected2", e);
	}	
}