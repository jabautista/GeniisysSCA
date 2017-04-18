/**
 * @author rey
 * @date 09.12.2011
 */
function showNoClaimMultiYyList(){
	new Ajax.Updater("dynamicDiv",contextPath + "/GICLNoClaimMultiYyController?action=showNoClaimMutiYyList",{
		method: "GET",
		parameters:{
		},
		asynchronous: false,
		evalScripts: true,
		onCreate : function(){
			showNotice("Loading, please wait...");
		},
		onComplete: function(response){
			hideNotice("");
			//if ($F("userLevel") == '0'){
			//	showMessageBox($F("accessErrMessage"), imgMessage.ERROR);
				//showClaimListing();
			//}
			//newFormInstance();
		}
	});
}	