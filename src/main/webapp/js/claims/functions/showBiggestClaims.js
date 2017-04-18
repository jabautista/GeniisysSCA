/**
 * Show Biggest Claims - GICLS220
 * @author jomsdiago
 * 07.18.2013
 */
function showBiggestClaims(){
	try {
		new Ajax.Request(contextPath + "/GICLBiggestClaimsController",{
			method: "POST",
			parameters: {
				action : "showBiggestClaims"
			},
			evalScripts: true,
			asynchronous: true,
			onCreate: function (){
				showNotice("Loading Biggest Claims, please wait...");
			},
			onComplete : function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	} catch (e){
		showErrorMessage("showBiggestClaims",e);
	}
}