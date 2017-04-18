function checkIfEditAllowed(){
	var isAllowed = false;	
	//this function is created for checking if user is allowed to edit a record
	new Ajax.Request(contextPath+"/GIISUserMaintenanceController?action=checkIfUserAllowedForEdit", {
			method: "POST",
			parameters: {
				//userId: getUserIdParameter(), --rmanalad 4.12.2011
				userId: userId, // ++ rmanalad 4.12.2011
				moduleName: "GIISS006B"
			},
			evalScripts: true,
			asynchronous: false,
			onSuccess: function (response){
				if (checkErrorOnResponse(response)){
					if (response.responseText == "Y"){
						isAllowed = true;
					} 
				}
			}
	});

	return isAllowed;
}