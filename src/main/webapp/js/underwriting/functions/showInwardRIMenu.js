/**
 * Shows Inward RI/Broker Outstanding Accounts(GIRIS019)
 * @author Steven 
 * @date 10.21.2013
 * 
 */
function showInwardRIMenu(){
	try {
		new Ajax.Request(contextPath + "/GIRIBinderController", {
			parameters : {
				action : "showInwardRIMenu"
			},
			onCreate : function(){
				showNotice("Loading, please wait...");
			},
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	} catch(e){
		showErrorMessage("showInwardRIMenu: ", e);
	}
}