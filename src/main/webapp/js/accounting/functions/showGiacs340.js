/**General Ledger Control Account Maintenance*
 * Created by   : Gzelle
 * Date Created : 10-27-2015
 * Remarks      : KB#132 - Accounting - AP/AR Enhancement
 * */
function showGiacs340(){
	new Ajax.Request(contextPath + "/GIACGlAccountTypesController", {
	    parameters : {
	    	action : "showGiacs340"
	    	},
	    onCreate: showNotice("Retrieving General Ledger Control Account Maintenance, Please wait..."),
		onComplete : function(response){
			try {
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} catch(e){
				showErrorMessage("showGiacs340 - onComplete : ", e);
			}								
		} 
	});
}