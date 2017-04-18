/**
 * Shows Motor Type Maintenance Page
 * Module: GIISS055 - Motor Type Maintenance
 * @author Ildefonso Ellarina Jr
 * */
function showMotorType(){
	try{ 
		new Ajax.Request(contextPath+"/GIISMotorTypeController", {
			method: "GET",
			parameters: {
				action : "showSubline"
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
		showErrorMessage("showMotorType",e);
	}	
}