function compareGIPIItemItmperilGIUWS018(){
	var policyId = objGIPIPolbasicPolDistV1.policyId;
	var packPolFlag	= objGIPIPolbasicPolDistV1.packPolFlag == null ? "" : unescapeHTML2(objGIPIPolbasicPolDistV1.packPolFlag);
	var lineCd	= objGIPIPolbasicPolDistV1.lineCd == null ? "" : unescapeHTML2(objGIPIPolbasicPolDistV1.lineCd);

	try {
		new Ajax.Request(contextPath+"/GIUWPolDistFinalController", {
			method: "GET",
			parameters: {
				action:			"compareGIPIItemItmperilGIUWS018",
				policyId : 		policyId,
				packPolFlag : 	packPolFlag,
				lineCd:			lineCd	
			},
			onCreate: function(){
				showNotice("Comparing amounts in item and itmperil tables.");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if(response.responseText == "SUCCESS"){
						if($("btnCreateItems").value == "Recreate Items"){ 
							showConfirmBox("Confirmation", "All pre-existing data associated with this distribution " +
								       "record will be deleted.  Are you sure you want to continue?", "Yes", "No", createItemsGIUWS018, "");
						}else{
							createItemsGIUWS018();
						}
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}catch(e){
		showErrorMessage("compareGIPIItemItmperilGIUWS018", e);
	}
}