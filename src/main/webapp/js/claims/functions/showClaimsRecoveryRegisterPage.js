/** Shows Claims Recovery Register Page
 * Module: GICLS201 - Claims Recovery Register 
 * @author Shan Bati 03.14.2013
 */
function showClaimsRecoveryRegisterPage(){
	try{
		new Ajax.Updater("dynamicDiv", contextPath+"/GICLClaimsRecoveryRegisterController?action=showClaimsRecoveryRegisterPage", {
			method: "GET",
			parameters: { },
			asynchronous: true,
			evalScripts: true,
			onCreate: function() {
				showNotice("Loading, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
			}
		});
	}catch(e){
		showErrorMessage("showClaimsRecoveryRegisterPage", e);
	}
}