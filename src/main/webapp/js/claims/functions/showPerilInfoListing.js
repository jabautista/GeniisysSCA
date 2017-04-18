function showPerilInfoListing(claimId, lineCd, prelim){
	try {
		new Ajax.Updater("groDivPeril", contextPath+"/GICLReserveSetupController?action=getPerilInformation",{
			method:"POST",
			evalScripts: true,
			parameters: {claimId: claimId,
				lineCd: lineCd,
				prelim: prelim},
				onComplete: function(response) {
					hideNotice();
				}
		});
	} catch(e){
		showErrorMessage("showPerilInfoListing", e);
	}
}