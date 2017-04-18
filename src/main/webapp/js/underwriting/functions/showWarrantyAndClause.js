/**Show Warranty And Clause
 * GIISS034 - Warranties and Clauses Maintenance
 * @author Gzelle 10-19-2012
 */
function showWarrantyAndClause(){
	try{
		new Ajax.Request(contextPath + "/GIISWarrClaController", {
			method: "GET",
			evalScripts:true,
			asynchronous: true,
			parameters: {
				action : "getGIISLine",
				ajax : "1"
			},
			onCreate : function(){
				showNotice("Loading Warranties and Clauses, please wait...");
			},
			onComplete : function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)) {
					$("mainContents").update(response.responseText);
					Effect.Appear($("mainContents").down("div", 0), {
						duration: .001
					});	
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}catch(e){
		showErrorMessage("showWarrantyAndClause", e);
	}
}