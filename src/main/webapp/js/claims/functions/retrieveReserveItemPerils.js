function retrieveReserveItemPerils(){
	var targetDiv = "itemInformationTableGridSectionDiv";
	try{
		new Ajax.Updater(targetDiv, contextPath + "/GICLClaimReserveController",{
			method : "POST",
			parameters:{
				action: "getItemPerilGrid",
				claimId: nvl(objCLMGlobal.claimId, 0),
				ajax : "1"
			},
			evalScripts: true,
			asynchronous: false,
			onCreate: function(){
				$(targetDiv).hide();
			},
			onComplete: function(){
				$(targetDiv).show();
			}
		});
	}catch(e){
		showErrorMessage("retrieveLossExpTax", e);
	}
}