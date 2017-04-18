/* shan 10.07.2013 
 * for Update Manual Policy / Invoice / Acceptance Number
 */
function showGIUTS025(){
	try{
		new Ajax.Request(contextPath + "/UpdateUtilitiesController", {
			parameters : {action : "showGIUTS025"},
			onCreate : showNotice("Loading Update Manual Policy / Invoice / Acceptance Number, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	}catch(e){
		showErrorMessage("showGIUTS025", e);
	}
}