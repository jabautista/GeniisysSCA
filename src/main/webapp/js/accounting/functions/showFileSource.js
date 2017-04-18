/**
* Shows File Source Maintenance
* @author Kenneth L.
* @date 8.16.2013
* 
*/
function showFileSource(){
	try{
		new Ajax.Request(contextPath + "/GIACFileSourceController",{
			parameters : {
				action : "showFileSource",
				refresh : 1},
			onCreate: function(){
				showNotice("Loading File Source Maintenance, please wait...");
			},
			onComplete : function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showFileSource", e);
	}
}