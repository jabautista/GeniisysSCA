/**
 * Shows View Exposures Per PA Enrollees Page
 * @author Kris Felipe
 * @date 09.13.2013
 * 
 */
function showExposuresPerPAEnrollees(){
	new Ajax.Request(contextPath+"/GIPIPolbasicController",{
		method: "POST",
		parameters: {
			action : "showViewExposuresPerPAEnrollees"
		},
		evalScripts: true,
		asynchronous: true,
		onCreate: function(){
			showNotice("Loading View Exposures Per PA Enrollees page, please wait...");
		},
		onComplete: function (response) {
			hideNotice();
			if (checkErrorOnResponse(response)){
				$("dynamicDiv").update(response.responseText);
			}
		}
	});
}