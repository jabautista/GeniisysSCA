/**
 * Shows Invoice Information Page
 * @author Kris Felipe
 * @date 09.09.2013
 * 
 */
function showViewInvoiceInformationPage(){
	new Ajax.Request(contextPath+"/GIPIInvoiceController",{
		method: "POST",
		parameters: {
			action : "showViewInvoiceInformation"
		},
		evalScripts: true,
		asynchronous: true,
		onCreate: function(){
			showNotice("Loading View Invoice Information page, please wait...");
		},
		onComplete: function (response) {
			hideNotice();
			if (checkErrorOnResponse(response)){
				$("dynamicDiv").update(response.responseText);
			}
		}
	});
}