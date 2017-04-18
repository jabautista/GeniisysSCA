function showPayeeDetailsListing(claimId, adviceId){
	try {
		new Ajax.Updater("groDivPayee", contextPath+"/GICLReserveSetupController?action=getPayeeDetails",{
			method:"POST",
			evalScripts: true,
			parameters: {claimId: claimId,
						 adviceId: adviceId},
			onComplete: function(response) {
				hideNotice();
			}
		});
	} catch(e){
		showErrorMessage("showPayeeDetailsListing", e);
	}
}