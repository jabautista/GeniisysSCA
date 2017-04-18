function showLossExpEvalNumList(){
	if(objCurrGICLItemPeril == null){
		showMessageBox("Please select an item first.", "I");
		return false;
	}else{
		getLeEvalReportLOV();
	}
}