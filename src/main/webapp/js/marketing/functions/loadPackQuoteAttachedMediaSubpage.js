/**
 * Loads the attached media sub-page  
 * for Package Quotation Information
 */

function loadPackQuoteAttachedMediaSubpage(){
	new Ajax.Updater("attachedMediaMotherDiv", 
		contextPath + "/FileUploadController",{
		method : "GET",
		asynchronous : true,
		evalScripts : true,
		parameters: {
			action : "showAttachedMediaPageForPackQuotation",
			packQuoteId : objMKGlobal.packQuoteId
		},
		onCreate: function(){
			showNotice("Processing information, please wait...");
		},
		onComplete:	function(response){
			hideNotice();
			if(checkErrorOnResponse(response)){
				Effect.Appear($("attachedMediaMotherDiv").down("div", 0), {
					duration: .5
				});
			}else{
				showMessageBox(response.responseText, imgMessage.ERROR);
			}
		}
	});
}