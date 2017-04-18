function showPrelimDocsOnFile(claimId){
	docsOnFile = Overlay.show(contextPath+"/GICLReserveSetupController", {
		urlContent : true,
		draggable: true,
		urlParameters: {action: "getDocsOnFile",
			            claimId: claimId},
	    title: "Documents on File",
	    height: 320,
	    width: 450
	});
}