/** Shows Update Policy Booking Tag Page
 * Module: GIPIS162 - Enter Booking Details
 * @author Shan Bati 02.19.2013
 */
function showUpdatePolicyBookingTag(){
	try{
		new Ajax.Updater("mainContents", contextPath+"/UpdateUtilitiesController?refresh=1",{
			method: "GET",
			parameters: {
				action: 	"getGipis162BookingList",
				moduleId:	"GIPIS162"
			},
			asynchronous: true,
			evalScripts: true,
			onCreate: showNotice("Loading, please wait..."),
			onComplete: function(response){
				hideNotice();
			}
		});
	}catch(e){
		showErrorMessage("showUpdatePolicyBookingTag", e);
	}
}