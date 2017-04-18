function showFinalPerilInfoListing(claimId, lineCd, adviceId, prelim){
	try {
		new Ajax.Updater("groDivPeril", contextPath+"/GICLReserveSetupController?action=getFinalPerilInformation",{
			method:"POST",
			evalScripts: true,
			parameters: {claimId: claimId,
						 lineCd: lineCd,
						 adviceId: adviceId,
						 prelim: prelim},
			onComplete: function(response) {
				
			}
		});
	} catch(e){
		showErrorMessage("showFinalPerilInfoListing", e);
	}
	
	try {
		new Ajax.Updater("groDivPayee", contextPath+"/GICLReserveSetupController?action=getPayeeDetails",{
			method:"POST",
			evalScripts: true,
			parameters: {claimId: claimId,
						 adviceId: adviceId},
			onComplete: function(response) {
				
			}
		});
	} catch(e){
		showErrorMessage("showPayeeDetailsListing", e);
	}
}