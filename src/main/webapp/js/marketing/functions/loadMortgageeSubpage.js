/**
 * Loads the mortgagee subpage and including ALL mortgagees (from ALL items)
 */
function loadMortgageeSubpage(){
	var url = contextPath + "/GIPIQuotationMortgageeController?action=getItemQuoteMortgageeJSON";
	var params = "&quoteId=" + objGIPIQuote.quoteId;
	
	try{
		new Ajax.Updater("mortgageeInformationMotherDiv", url + params, {
			asynchronous : false,
			evalScripts : true,
			method : "GET",
			insertion : "bottom",
			onCreate: function(){
			},
			onComplete:	function(){
				resetTableStyle("mortgageeInformationDiv", "mortgageeListingDiv", "mortgageeRow");
				return true;
			},
			onError: function(){
				return false;
			}
		});
	}catch(e){
		showErrorMessage("loadMortgageeSubpage", e);
		return false;
	}
}