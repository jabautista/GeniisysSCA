/**
 *  @author Steven Ramirez
 *  @date 09.24.2013
 *  @description Shows the GIPIS111/View Property Floater Accumulation.
 */
function showViewPropertyFloaterAccumulation() {
	try{
		new Ajax.Request(contextPath+"/GIPIPolbasicController",{
			method: "POST",
			parameters : {action : "showViewCasualtyAccumulation"},
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	} catch(e){
		showErrorMessage("showViewPropertyFloaterAccumulation", e);
	}
}