/**
 * Loads the mortgagee information sub-page  
 * for Package Quotation Information
 */

function loadPackQuoteMortgageeSubpage(){
	new Ajax.Updater("mortgageeInformationMotherDiv", 
		contextPath + "/GIPIQuotationMortgageeController",{
		method : "GET",
		asynchronous : true,
		evalScripts : true,
		parameters: {
			action : "getQuoteMortgageeForPackQuotationInfo",
			packQuoteId : objMKGlobal.packQuoteId,
			issCd : objMKGlobal.issCd
		},
		onCreate: function(){
			showNotice("Processing information, please wait...");
		},
		onComplete:	function(response){
			hideNotice();
			if(checkErrorOnResponse(response)){
				Effect.Appear($("mortgageeInformationMotherDiv").down("div", 0), {
					duration: .5
				});
			}else{
				showMessageBox(response.responseText, imgMessage.ERROR);
			}
		}
	});
}