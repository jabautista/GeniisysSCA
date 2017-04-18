function saveAccesorry(){	
	new Ajax.Request(contextPath+"/GIPIWMcAccController?action=saveAccessory", {
		method: "POST",
		/*postBody: Form.serialize("accessoryForm"),*/
		postBody: Form.serialize("itemInformationForm"),
		onCreate: function() {
			showNotice("Saving Accessory Info., please wait...");
		}, 
		asynchronous: false,
		evalScripts: true,
		onComplete: function (response)	{
			if (checkErrorOnResponse(response)) {
				hideNotice(response.responseText);
			}
			//if (response.responseText == "SUCCESS") {
			//	Modalbox.hide();
			//}
		}
	});	
}