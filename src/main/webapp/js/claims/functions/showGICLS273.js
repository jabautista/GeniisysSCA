/**
 * Module: GICLS273
 * @author Gzelle  
 * @date 07172014
 */
function showGICLS273(){
	try{ 
		new Ajax.Request(contextPath+"/GICLClaimsController", {
			method: "GET",
			parameters: {
				action : "showGICLS273"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate: function (){
				showNotice("Loading Ex-Gratia Claims Inquiry, please wait...");
			},
			onComplete: function (response)	{
				hideNotice("");
				$("dynamicDiv").update(response.responseText);
			}
		});		
	}catch(e){
		showErrorMessage("showGIISS074",e);
	}	
}