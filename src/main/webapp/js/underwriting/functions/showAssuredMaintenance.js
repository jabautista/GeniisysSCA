function showAssuredMaintenance(assdNo){
	var overideSw = 'N';
	try {
		if (assdNo == "" || assdNo == null) {
			showMessageBox("Please select an assured first.", imgMessage.ERROR);
			return false;
		} else {
			if (checkIfEditAllowed()){
				showMessageForPolicyCheckingTG(overideSw, assdNo); // ++rmanalad 4.12.2011
			} else {
				// modified by andrew - 02.09.2011
				showConfirmBox4('Edit Assured', 'You are not allowed to edit the assured and assured type. Do you wish to override?',
						"Override", "View Details", "Cancel",
						function(){
							parentAssuredDisable = 1;
							overideFuncTG(assdNo);
						}, 
						function(){
							parentAssuredDisable = 0;
							maintainAssuredTG("assuredListingTGMainDiv", assdNo, 'true');
						}, "");
			}
		}
	} catch (e) {
		showErrorMessage("showAssuredMaintenance", e);
	}
}