/**
 *  @author Steven Ramirez
 *  @date 09.02.2013
 *  @description Shows the GIPIS047/Update Bond Policy.
 */
function showUpdateBondPolicy() {
	try{
		new Ajax.Request(contextPath+"/UpdateUtilitiesController",{
			method: "POST",
			parameters : {action : "showUpdateBondPolicy"},
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	} catch(e){
		showErrorMessage("showUpdateBondPolicy", e);
	}
}