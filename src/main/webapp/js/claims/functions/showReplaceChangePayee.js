function showReplaceChangePayee(){
	try{
		changePayeeOverlay = Overlay.show(contextPath+"/GICLReplaceController", { 
			urlContent: true,
			urlParameters: {action : "getReplacePayeeListing",
							evalId: selectedMcEvalObj.evalId,
							ajax : "1"},
			title: "Change Payment Payee",							
		    height: 500,
		    width: 600,
		    draggable: true 
		});	
	}catch(e){
		showErrorMessage("showReplaceChangePayee",e);
	}
}