function showMcEvalCsl(){
	try{
		genericObjOverlay = Overlay.show(contextPath+"/GICLEvalCslController", { 
			urlContent: true,
			urlParameters: {action : "getMcEvalCslTGList",
							evalId: selectedMcEvalObj.evalId,
							ajax : "1"},
			title: "Cash Settlement Confirmation",							
		    height: 630,
		    width: 900,
		    draggable: true 
		});	
	}catch (e) {
		showErrorMessage("showMcEvalCsl",e);
	}
}