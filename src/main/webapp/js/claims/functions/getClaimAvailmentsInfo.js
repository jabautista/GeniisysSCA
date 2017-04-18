//belle 02.20.2012
function getClaimAvailmentsInfo(availNoOfDays){
	try{
		new Ajax.Updater("availInfoDiv", contextPath+"/GICLAccidentDtlController",{
			parameters:{
				action:        "getItemClaimAvailments"
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if (checkErrorOnResponse(response)) {
					null;
				}
			}
		});
		
	}catch(e){
		showErrorMessage("getClaimAvailmentsInfo", e);
	}
}