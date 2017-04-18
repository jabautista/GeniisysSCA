/**
 * Shows No Claim Listing
 * Module: GICLS026- No Claim
 * @author Robert Virrey
 * @date 12.09.2011
 */
function showNoClaimListing(lineCd){
	new Ajax.Updater("dynamicDiv", contextPath+"/GICLNoClaimController?action=getNoClaimList",{
		method:"GET",
		parameters: {
			lineCd : lineCd
		},
		evalScripts:true,
		asynchronous: true,
		onCreate: showNotice("Loading No Claim Listing, please wait..."),
		onComplete: function () {
			hideNotice("");
			Effect.Appear($("dynamicDiv").down("div", 0), {duration: .001}); 
			setDocumentTitle("Certificate of No Claim Listing");
		}
	});
}