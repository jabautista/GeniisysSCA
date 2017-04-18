function showGIPIS901FirePrintDialog(title){
	try{
		overlayFirePrintDialog = Overlay.show(contextPath+"/GIPIGenerateStatisticalReportsController", {
			urlContent : true,
			urlParameters: {
				action : 	"showGIPIS901FirePrintDialog",
			},
		    title: title,
		    height: 200,
		    width: 400,
		    draggable: true
		});
	}catch(e){
		showErrorMessage("showGIPIS901FirePrintDialog", e);
	}
}