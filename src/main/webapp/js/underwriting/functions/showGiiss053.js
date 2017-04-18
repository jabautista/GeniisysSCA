/**
 * Shows Flood Zone Maintenance Page
 * @module GIISS053 - Flood Zone Maintenance
 * @author mariekris
 */
function showGiiss053(){
	try{
		new Ajax.Request(contextPath + "/GIISFloodZoneController", {
			parameters : { action : "showGiiss053"},
			onCreate : function(){showNotice("Retrieving Flood Zone Maintenance, please wait...");},
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	}catch(e){
		showErrorMessage("showGiiss053",e);
	}	
}