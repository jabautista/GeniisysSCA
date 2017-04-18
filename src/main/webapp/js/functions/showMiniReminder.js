/**
 * Description : To show mini reminder overlay.
 * Date Created : 08.22.2013
 * @author : J. Diago
 */
function showMiniReminder(){
	try {
		overlayMiniReminder = 
			Overlay.show(contextPath+"/GIPIReminderController", {
				urlContent: true,
				urlParameters: {action    : "showMiniReminder",																
								parId     : ojbMiniReminder.parId,
								claimId   : objCLMGlobal.claimId
				},
			    title: "Mini Reminder",
			    height: 500,
			    width: 800,
			    draggable: true
			});
	} catch (e) {
		showErrorMessage("Mini Reminder Error :" , e);
	}
}