/**
 * Shows Report Parameter Maintenance
 * Module: GIISS119 - Report Parameter Maintenance
 * @author Ildefonso Ellarina Jr
 * */
function showReportParameterMaintenance(){
	try{ 
		new Ajax.Request(contextPath+"/GIISReportParameterController", {
			method: "GET",
			parameters: {
				action : "getReportParameterList"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function (response)	{
				hideNotice("");
				$("mainContents").update(response.responseText);
				Effect.Appear($("mainContents").down("div", 0), {
					duration: .001
				});
			}
		});		
	}catch(e){
		showErrorMessage("showReportParameterMaintenance",e);
	}	
}