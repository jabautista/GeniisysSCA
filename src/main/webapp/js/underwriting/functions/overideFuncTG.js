function overideFuncTG(assdNo){
	//shows login page as modalbox
	overideAssdNo = assdNo;
	//showOverlayContent2(contextPath+"/pages/common/subPages/assured/pop-ups/assuredOverideUser.jsp",
	//		'Overide User', 350, ""); removed by robert 02.11.15 changed to showGenericOverride
	var overideSw = 'Y';
	showGenericOverride("GIISS006B","AU",
		function(ovr, userId, result) {
			if (result == "FALSE") {
				showMessageBox(userId+ " does not have an overriding function for this module.",imgMessage.ERROR);
				return false;
			} else if (result == "TRUE"){
				showMessageForPolicyCheckingTG(overideSw, assdNo);
				maintainAssuredTG("assuredListingTGMainDiv", assdNo);
				ovr.close();
				delete ovr;
			}
		}, function() {
			this.close();
		});
}