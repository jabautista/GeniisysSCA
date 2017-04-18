function showMcEvalDepreciationDetails(){
	try{
		var height = objCLMGlobal.callingForm == "GICLS260" ? 370 : 500; // bonok :: 11.08.2013
		genericObjOverlay = Overlay.show(contextPath+"/GICLEvalDepDtlController", { 
			urlContent: true,
			urlParameters: {action : "getDepreciationDtl",
							evalId: selectedMcEvalObj.evalId,
							ajax : "1"},
			title: "Depreciation Details",							
		    height: height,
		    width: 860,
		    draggable: true 
		});	
	}catch(e){
		showErrorMessage("showMcEvalDepreciationDetails",e);
	}
}