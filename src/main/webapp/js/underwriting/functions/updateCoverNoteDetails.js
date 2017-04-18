function updateCoverNoteDetails(noOfDays, updCNDetailsSw){
	new Ajax.Request(contextPath+"/GIPIParInformationController",{
		method: "POST",
		parameters:{
			action: "updateCoverNoteDetails",
			parId: $("globalParId").value,
			noOfDays: noOfDays,
			updCNDetailsSw: updCNDetailsSw
		},
		onCreate: function(){
			setCursor("wait");
		},
		onComplete: function(response){
			setCursor("default");
			if(!checkErrorOnResponse(response)){
				showMessageBox(response.responseText, imgMessage.ERROR);
			}
		}
	});
}