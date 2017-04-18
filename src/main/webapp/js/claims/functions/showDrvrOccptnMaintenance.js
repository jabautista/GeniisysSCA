/**
 * Shows Table Maintenance Driver Occupation page
 * Module: GICLS511 - Table Maintenance Driver Occupation 
 * @author Fons Ellarina 
 * @date 08.29.2013
 */
function showDrvrOccptnMaintenance(){
	try{
		new Ajax.Request(contextPath + "/GICLDrvrOccptnController", {
			evalScript : true,
		    parameters : {action : "showDrvrOccptnMaintenance",			    			
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
					showErrorMessage("showDrvrOccptnMaintenance - onComplete : ", e);
				}								
			} 
		});
	}catch(e){
		showErrorMessage("showDrvrOccptnMaintenance : ", e); 
	}	
}