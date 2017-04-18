function showApplyDedDialogBox(canvas){
	try{	
		applyDedOverlay = Overlay.show(contextPath+"/GICLEvalDeductiblesController", { 
			urlContent: true,
			urlParameters: {action : "showApplyDedDialogBox",
				            canvas : canvas,
				            evalId: selectedMcEvalObj.evalId},
			title: "ALERT",							
		    height: 140,
		    width: 265,
		    draggable: true 
		});	
	}catch(e){
		showErrorMessage("showApplyDedDialogBox",e);
	}
}