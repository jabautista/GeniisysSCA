/**
 * Shows Engineering Principal/Contractor Maintenance
 * @author Kris Felipe
 * @date 12.4.2013 
 */
function showGiiss068(){
	try{
		new Ajax.Request(contextPath + "/GIISEngPrincipalController", {
			parameters : { action : "showGiiss068"},
			onCreate : function(){showNotice("Retrieving Engineering Principal/Contractor Maintenance, please wait...");},
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	}catch(e){
		showErrorMessage("showGiiss068",e);
	}
}