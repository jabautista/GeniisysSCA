function showMcEvalReplaceDetails(){
	try{
		var height = objCLMGlobal.callingForm == "GICLS260" ? 320 : 450; // bonok :: 11.08.2013
		genericObjOverlay = Overlay.show(contextPath+"/GICLReplaceController", { 
			urlContent: true,
			urlParameters: {action : "getMcEvalReplaceListing",
							evalId: selectedMcEvalObj.evalId,
							ajax : "1"},
			title: "Replace Details",							
		    height: height,
		    width: 900,
		    draggable: true 
		});	
	}catch(e){
		showErrorMessage("shoeMcEvalReplaceDetails",e);
	}
}