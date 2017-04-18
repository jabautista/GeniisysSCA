/**
 * Shows Table Maintenance Claim Status page
 * Module: GICLS160 - Table Maintenance Claim Status 
 * @author Fons Ellarina 
 * @date 08.22.2013
 */
function showClaimStatusMaintenance(){
	try{
		new Ajax.Request(contextPath + "/GIISClmStatController", {
			evalScript : true,
		    parameters : {action : "showClaimStatusMaintenance",			    			
    			  dateAsOf: getCurrentDate()
		    },
		    onCreate : showNotice("Loading, please wait..."),
			onComplete : function(response){
				hideNotice();
				try {
					if(checkErrorOnResponse(response)){
						$("dynamicDiv").update(response.responseText);
					}
				} catch(e){
					showErrorMessage("showClaimStatusMaintenance - onComplete : ", e);
				}								
			} 
		});
	}catch(e){
		showErrorMessage("showClaimStatusMaintenance : ", e); 
	}	
}