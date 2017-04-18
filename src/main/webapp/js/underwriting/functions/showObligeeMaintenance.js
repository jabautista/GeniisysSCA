/**
 * Shows Obligee Maintenance
 * Module: GIISS017 - Obligee Maintenance
 * @author Marie Kris Felipe
 * */
function showObligeeMaintenance(){
	new Ajax.Request(contextPath+"/GIISObligeeController", {
		parameters: {action : "getObligeeListMaintenance", 
					 refresh : 1},
		onCreate : showNotice("Loading Obligee table, please wait..."),
		onComplete : function(response){
			try {
				hideNotice();
				if(checkErrorOnResponse(response)){
					if(objUW.fromMenu == "obligee"){
						$("mainContents").update(response.responseText);
					} else if(objUW.fromMenu == "bondPolicyData"){
						$("parInfoMenu").hide();
						$("parInfoMenu").disabled = true;
						$("parInfoDiv").hide();
						$("parInfoDiv").disabled = true;
						if($("ObligeeMaintenanceTableGridDiv") != null){
							$("ObligeeMaintenanceTableGridDiv").remove();
						}
						
						$("mainContents").insert({bottom : response.responseText});
					}
				}
			} catch(e){
				showErrorMessage("showObligeeMaintenance - onComplete", e);
			}
		}
	});
	//updateMainContentsDiv("/GIISObligeeController?action=getObligeeListMaintenance&refresh=1", "Loading Obligee table, please wait...");
}