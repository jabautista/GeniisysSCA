/** 
 * Inquiry and View Quotation Status 
 */
function viewQuotationStatus() {
	new Ajax.Updater("mainContents", contextPath + "/GIPIQuotationController",
	{	parameters : {
		action : "viewQuotationStatus",
		moduleId : "GIIMM004"
		},
		method : "GET",
		asynchronous : true,
		evalScripts : true,
		onCreate : function() {
			//showNotice("Loading table, please wait...");
		}/*,
		onComplete : function() {
			hideNotice("");
			Effect.Appear($("viewQuotationStatusDiv"), {
				duration : .001
			});
		}*/
	});
}