/**
 * Shows the GIACS408
 * 
 * @author Christian Santos
 * @date 04.24.2013
 */
function showModifyCommInvoicePage() {
	try {
		new Ajax.Request(
				contextPath + "/GIACDisbursementUtilitiesController",
				{
					method : "POST",
					parameters : {
						action : "showModifyCommInvoicePage"
					},
					evalScripts : true,
					asynchronous : true,
					onCreate : function() {
						showNotice("Loading Modify Commission Invoice Page, please wait...");
					},
					onComplete : function(response) {
						hideNotice("");
						$("dynamicDiv").update(response.responseText);
					}
				});
	} catch (e) {
		showErrormessage("showModifyCommInvoice", e);
	}
}