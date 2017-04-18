/**
 * @author rey
 * @date 13-12-2011
 */
function viewNoClaimMultiYyPolicyListing(noClaimId){
	new Ajax.Updater("dynamicDiv",contextPath + "/GICLNoClaimMultiYyController?action=showNoClaimMutiYyPolicyList",{
		method: "GET",
		parameters:{
			noClaimId: noClaimId
		},
		asynchronous: false,
		evalScripts: true,
		onCreate : function(){
			showNotice("Loading, please wait...");
		},
		onComplete: function(response){
			hideNotice("");
			setModuleId("GICLS062");
			setDocumentTitle("Certificate of No Claim Multi Year");
			//if ($F("userLevel") == '0'){
			//	showMessageBox($F("accessErrMessage"), imgMessage.ERROR);
				//showClaimListing();
			//}
			//newFormInstance();
		}
	});
}	
/* */