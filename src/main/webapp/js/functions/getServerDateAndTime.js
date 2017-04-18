function getServerDateAndTime() {
	new Ajax.Updater("dateAndTime", contextPath+"/GIISUserController?action=getServerDateAndTime", {
		evalScripts: true,
		asynchronous: true
	});
}