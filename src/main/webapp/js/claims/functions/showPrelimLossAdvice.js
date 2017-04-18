/**
 * Shows Preliminary Loss Advice
 * Module: GICLS028
 * @author Niknok Orio
 * @date 02.15.2012
 */
function showPrelimLossAdvice(){
	try{
		new Ajax.Updater("basicInformationMainDiv", contextPath + "/GICLAdvsPlaController", {
			parameters: {	
				action: "showPrelimLossAdvice",
				claimId: objCLMGlobal.claimId,
				lineCd : objCLMGlobal.lineCd
			}, 
			asynchronous: false,
			evalScripts: true,
			onCreate : function() {
				showNotice("Loading, please wait...");
			},
			onComplete: function (response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					null;
					objGIPIS100.callingForm = "GICLS028"; // andrew - 04.23.2012 - for view policy information
				}
			}
		});
	}catch(e){
		showErrorMessage("showPrelimLossAdvice", e);
	}
}