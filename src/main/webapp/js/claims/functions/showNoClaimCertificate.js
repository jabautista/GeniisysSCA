/**
 * Shows No Claim Certificate
 * Module: GICLS026- No Claim
 * @author Robert Virrey
 * @date 12.09.2011
 */
function showNoClaimCertificate(){
	new Ajax.Updater("dynamicDiv", contextPath+"/GICLNoClaimController?action=showNoClaimCertificate",{
		method:"GET",
		parameters:{
			noClaimId : objCLMGlobal.noClaimId
		},
		evalScripts:true,
		asynchronous: true,
		onCreate: showNotice("Loading No Claim Certificate, please wait..."),
		onComplete: function () {
			hideNotice("");
			Effect.Appear($("dynamicDiv").down("div", 0), {duration: .001}); 
			setDocumentTitle("Certificate of No Claim");
		}
	});
}