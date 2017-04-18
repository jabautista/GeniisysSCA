function showMcEvalDeductibleDetails(){
	try{
		var height = objCLMGlobal.callingForm == "GICLS260" ? 370 : 500; // bonok :: 11.08.2013
		genericObjOverlay = Overlay.show(contextPath+"/GICLEvalDeductiblesController", { 
			urlContent: true,
			urlParameters: {action : "showEvalDeductibleDetails"},
			title: "Deductible Details",							
		    height: height,
		    width: 900,
		    draggable: true 
		});	
	}catch(e){
		showErrorMessage("showMcEvalDeductibleDetails",e);
	}
}