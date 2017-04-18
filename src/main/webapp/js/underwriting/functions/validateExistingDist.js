function validateExistingDist(){
	new Ajax.Request(contextPath + "/GIUWPolDistController", {
		method: "GET",
		parameters: {
			action : "validateExistingDist",
			policyId: objGIPIPolbasicPolDistV1.policyId,
			distNo: objGIPIPolbasicPolDistV1.distNo
		},
		onCreate: function(){
			showNotice("Validating record, please wait...");
		},
		onComplete: function(response){
			hideNotice();
			if(checkErrorOnResponse(response)){
				var res = JSON.parse(response.responseText);
				if(nvl(res.enableBtnSw, "N") == "N"){
					disableButton("btnCreateMissingRec");
				}else{
					enableButton("btnCreateMissingRec");
				}
			}else{
				showMessageBox(response.responseText, "E");
			}
		}
	});
}