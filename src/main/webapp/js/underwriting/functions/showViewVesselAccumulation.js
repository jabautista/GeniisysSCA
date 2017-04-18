/**
 *  @author Steven Ramirez
 *  @date 09.06.2013
 *  @description Shows the GIPIS109/View Vessel Accumulation.
 */
function showViewVesselAccumulation() {
	try{
		new Ajax.Request(contextPath+"/GIPIPolbasicController",{
			method: "POST",
			parameters : {action : "showViewVesselAccumulation"},
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
		showErrorMessage("showViewVesselAccumulation", e);
	}
}