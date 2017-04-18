function printPolicy(){
	var id = getSelectedRowId("row");
	if (id.blank()) {
		showMessageBox("Please select a policy first.", imgMessage.ERROR);
		return false;
	} else {
		//window.open(contextPath+"/PrintPolicyController?parId="+id+"&lineName="+$F("globalLineName")+"&action=preview&"+Math.random(), "Print Policy", "location=no,toolbar=no,menubar=no");
		showPdfReport(contextPath+"/PrintPolicyController?parId="+id+"&lineName="+$F("globalLineName")+"&action=preview&"+Math.random(), "Print Policy"); // andrew - 12.12.2011
	}
}