/**
 * View Quotation Status on Table Grid
 * @author rey
 * @date 07-11-2011
 */
function viewQuotationStatus2() {
	new Ajax.Updater("mainContents", contextPath + "/GIPIQuotationController",
	{	parameters : {
		action : "viewQuotationStatusListing",
		moduleId : "GIIMM004"
		},
		method : "GET",
		asynchronous : true,
		evalScripts : true,
		onCreate : function() {
		}
	});
}