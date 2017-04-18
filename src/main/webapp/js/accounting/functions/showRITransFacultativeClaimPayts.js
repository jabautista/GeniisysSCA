/**
 * Show RI Trans Facultative Claim Payts module GIACS018
 * 
 * @author eman
 * @return
 */
function showRITransFacultativeClaimPayts() {
	new Ajax.Updater("transBasicInfoSubpage", contextPath
			+ "/GIACInwClaimPaytsController?action=showFacultativeClaimPayts",
			{
				method : "GET",
				parameters : {
					gaccTranId : objACGlobal.gaccTranId
				},
				asynchronous : true,
				evalScripts : true,
				onCreate : function() {
					showNotice("Loading Facultative Claim Payts...");
				},
				onComplete : function() {
					hideNotice("");
				}
			});
}