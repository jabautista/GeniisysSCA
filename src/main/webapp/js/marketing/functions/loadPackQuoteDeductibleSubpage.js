/**
 * Loads the deductible information sub-page
 * for Package Quotation Information
 */

function loadPackQuoteDeductibleSubpage(){
	new Ajax.Updater("deductibleInformationMotherDiv", 
		contextPath + "/GIPIQuotationDeductiblesController?action=getQuoteDeductiblesForPackQuotation&packQuoteId=" + objMKGlobal.packQuoteId,{
		asynchronous : true,
		evalScripts : true,
		method : "GET",
		onComplete:	function(response){
			hideNotice();
			if(!checkErrorOnResponse(response)){
				showMessageBox(response.responseText, imgMessage.ERROR);
			}
		}
	});
}