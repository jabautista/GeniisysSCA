function showLossExpenseHistory(){
	try{
		var div = nvl(fromClaimMenu, "N") == "Y" ? "dynamicDiv" : "basicInformationMainDiv";
		
		new Ajax.Updater(div, contextPath + "/GICLClaimsController?action=showLossExpenseHistory", { 
			method: "GET",
			parameters: {
				claimId : nvl(objCLMGlobal.claimId, 0),
				fromClaimMenu : nvl(fromClaimMenu, "N")
			},
			asynchronous: true,
			evalScripts: true,
			onCreate : function() {
				showNotice("Loading, please wait...");
			},
			onComplete: function (response){
				hideNotice("");
				setModuleId("GICLS030");
				setDocumentTitle("Loss/Expense History");
				if(nvl(fromClaimMenu, "N") == "N"){
					updateClaimParameters();
					getClaimsMenuProperties(true);
				}
				objGIPIS100.callingForm = "GICLS030"; // andrew - 04.23.2012 - for view policy information
			}
		});
	}catch(e){
		showErrorMessage("showLossExpenseHistory", e);
	}
}