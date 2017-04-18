/** 
 * Load single mortgagee information
 * @author rencela
 * @return
 */
function loadMortgageeInformationAccordion() {
	if(checkPendingRecordChanges()){ // Patrick - added condition for validation - 02.14.2012
		var itemNo = 0;
		$("mortgageeInformationMotherDiv").innerHTML = "";
	
		$$("div[name='itemRow']").each(function(itemRow) {
			itemNo = itemRow.down("input", 0).value;
			$continue;
		});
	
		var url = contextPath + "/GIPIQuotationMortgageeController?action=getItemQuoteMortgagee";
		var params = "&quoteId=" + objGIPIQuote.quoteId	+ "&itemNo=" + itemNo;
		new Ajax.Updater("mortgageeInformationMotherDiv", url + params, {
			asynchronous : true,
			evalScripts : true,
			method : "GET",
			insertion : "bottom",
			onComplete:	function(){
				$("newMortgageeItemNo").value = getSelectedRowId("row");
				enableQuotationMainButtons();
				showAccordionLabelsOnQuotationMain();
			}
		});
	}
}