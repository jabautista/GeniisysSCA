function showMcEvalLoa(){
	try{
		genericObjOverlay = Overlay.show(contextPath+"/GICLEvalLoaController", { 
			urlContent: true,
			urlParameters: {action : "getMcEvalLoaTGLst",
							evalId: selectedMcEvalObj.evalId,
							ajax : "1"},
			title: "Letter of Authority",							
		    height: 555,
		    width: 860,
		    draggable: true
		});	
	}catch(e){
		showErrorMessage("showMcEvalLoa",e);
	}
}