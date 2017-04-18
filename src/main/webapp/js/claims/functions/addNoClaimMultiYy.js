/**
 * @author rey
 * @date 20-12-2011
 */
function addNoClaimMultiYy(){
	
	new Ajax.Updater("dynamicDiv",contextPath + "/GICLNoClaimMultiYyController?action=addNoClaimMutiYyPolicyList",{
		method: "GET",
		parameters:{
		},
		asynchronous: false,
		evalScripts: true,
		onCreate : function(){
		},
		onComplete: function(response){
			//$("reloadForm").setStyle({display: 'none'}); // commented out by shan 10.16.2013
			disableButton("cancelNoClaim");		//added by shan 10.16.2013
			getNoClaimMultiYyNo();
		}
	});
}