/** Check if user has access to GIPIS162
 * Module: GIPIS162 - Enter Booking Details
 * @author Shan Bati 02.19.2013
 */
function checkUserAccessGipis162(){
	try{
		new Ajax.Request(contextPath+"/GIISUserController",{
			parameters: {
				action : "checkUserAccessGipis162",
				moduleId : "GIPIS162"
			},
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response) {
				if(response.responseText == 1){
					showUpdatePolicyBookingTag();
				}else{
					showMessageBox("You are not allowed to access this module.", "E");
				}
			}
		});
	}catch(e){
		showErrorMessage("checkUserAccessGipis162", e);
	}
}