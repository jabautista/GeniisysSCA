/**
 *  @author Steven Ramirez
 *  @date 09.12.2013
 *  @description Shows the GIPIS139/View Intermediary Commission.
 */
function showViewIntermediaryCommission(){
	new Ajax.Request(contextPath+"/GIPIPolbasicController",{
		method: "POST",
		parameters: {
			action : "showViewIntermediaryCommission"
		},
		evalScripts: true,
		asynchronous: true,
		onCreate: function(){
			showNotice("Loading, please wait...");
		},
		onComplete: function (response) {
			hideNotice();
			if (checkErrorOnResponse(response)){
				$("dynamicDiv").update(response.responseText);
			}
		}
	});
}