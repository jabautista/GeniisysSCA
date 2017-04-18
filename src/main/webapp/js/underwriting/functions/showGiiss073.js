/**
 * Shows Reinsurer Status Maintenance module
 * @author Kris Felipe
 * @date 10.22.2013 
 */
function showGiiss073(){
	try{
		new Ajax.Request(contextPath + "/GIISRiStatusController", {
			parameters : { action : "showGiiss073"},
			onCreate : function(){showNotice("Retrieving Reinsurer Status Maintenance, please wait...");},
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	}catch(e){
		showErrorMessage("showGiiss073",e);
	}
}