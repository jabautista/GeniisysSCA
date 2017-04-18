/**
 * Calls the Direct Claim Payments subpage
 * 
 * @author rencela GIACS017
 * @version 1.0
 */
function showDirectClaimPayments() {
	// var action = databaseName == "GEN10G" ? "showDirectClaimPayts" :
	// "showDirectClaimPayments";
	var action = "showDirectClaimPayts";
	new Ajax.Updater(
			"transBasicInfoSubpage",
			contextPath + "/GIACDirectClaimPaymentController?action=" + action
					+ "&ajaxModal=1&gaccTranId=" + objACGlobal.gaccTranId,
			{
				method : "POST",
				postBody : Form.serialize("itemInformationForm"),
				asynchronous : true,
				evalScripts : true,
				onCreate : function() {
					showNotice("Loading Direct Claim Payments Information. Please wait...");
				},
				onComplete : function() {
					hideNotice("");
				}
			});
}