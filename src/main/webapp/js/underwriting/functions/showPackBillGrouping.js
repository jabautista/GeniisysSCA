/**
 * Shows package bill grouping module
 * @author andrew robes
 * @date 10.04.2011
 */
function showPackBillGrouping(){
	try {
		new Ajax.Request(contextPath + "/GIPIParBillGroupingController", {
			method: "GET",
			parameters : {action : "showPackBillGrouping",
						  globalParType:  objUWGlobal.parType,
						  globalPackParNo:objUWGlobal.parNo,
						  globalAssdNo:   objUWGlobal.assdNo,
						  globalAssdName: objUWGlobal.assdName,
						  packParId : objUWGlobal.packParId},
			onCreate: showNotice("Getting Bill Grouping, please wait..."),			  
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("parInfoDiv").update(response.responseText);
				}
			}
			
		});
	} catch (e){
		showErrorMessage("showPackBillGrouping", e);
	}
}