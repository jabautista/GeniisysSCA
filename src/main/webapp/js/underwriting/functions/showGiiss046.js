/**
 * Shows Hull Type Maintenance Page
 * Module: GIISS046 - Hull Type Maintenance
 * @author Kenneth Mark Labrador
 * */
function showGiiss046(){
	try{ 
		new Ajax.Request(contextPath+"/GIISHullTypeController", {
			parameters: {
				action : "showGiiss046"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function (response)	{
				hideNotice();
				$("mainContents").update(response.responseText);
			}
		});		
	}catch(e){
		showErrorMessage("showGiiss046",e);
	}	
}