/**
 * Description: Get GICLS254 (Claim History - From Inquiry Menu)
 * @author Cherrie 12.13.2012
 * */
function showClmHistory(){
	try{
		new Ajax.Request(contextPath+"/GICLClaimsController", {
			parameters: {
				action : "showClmHistory",
				module: "GICLS254"
			},
			onCreate: showNotice("Loading, please wait..."),
			onComplete: function(response){ 
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			}
		});	
	}catch(e){
		showErrorMessage("showClmHistory", e);
	}
}