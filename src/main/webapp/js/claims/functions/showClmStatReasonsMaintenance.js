/**
 * Shows Table Maintenance Claim Status Reasons page
 * Module: GICLS170 - Table Maintenance Claim Status Reasons 
 * @author Fons Ellarina 
 * @date 08.23.2013
 */
function showClmStatReasonsMaintenance(){
	try{
		new Ajax.Request(contextPath + "/GICLReasonsController", {
			evalScript : true,
		    parameters : {action : "showClmStatReasonsMaintenance",			    			
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
					showErrorMessage("showClmStatReasonsMaintenance - onComplete : ", e);
				}								
			} 
		});
	}catch(e){
		showErrorMessage("showClmStatReasonsMaintenance : ", e); 
	}	
}