//Kenneth L. 09.11.2013
function getMotorCarInquiryRecords(){
	objUWGlobal.callingForm = null;
	new Ajax.Updater("dynamicDiv", contextPath+"/GIPIPolbasicController?action=getMotorCarInquiryRecords",{
		method: "POST",
		evalScripts: true,
		asynchronous: false,
		onCreate: showNotice("Loading Motor Car Policy, please wait..."),
		onComplete: function () {
			hideNotice();
		}
	});
}