/**
 * Shows Reports Maintenance module
 * @author Kris Felipe
 * @date 10.31.2013 
 */
function showGiiss090(){
	try{
		new Ajax.Request(contextPath + "/GIISReportsController", {
			parameters : { action : "showGiiss090"},
			onCreate : function(){showNotice("Retrieving Reports Maintenance, please wait...");},
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	}catch(e){
		showErrorMessage("showGiiss090",e);
	}
}