function showMcEvalVATDetails(){
	try{
		var height = objCLMGlobal.callingForm == "GICLS260" ? 320 : 450; // bonok :: 11.08.2013
		genericObjOverlay = Overlay.show(contextPath+"/GICLEvalVatController", { 
			urlContent: true,
			urlParameters: {action : "getMcEvalVatListing",
							evalId: selectedMcEvalObj.evalId,
							ajax : "1"},
			title: "VAT Details",							
		    height: height,
		    width: 900,
		    draggable: true 
		});	
	}catch(e){
		showErrorMessage("showMcEvalVATDetails",e);
	}
}