var overlayBatch;

function startBatchCsrApproval(){
	overlayBatch = Overlay.show(contextPath+"/GICLBatchCsrController", { 
				urlContent: true,
				urlParameters: {action : "showBatchCSRApprovalOverlay",
								ajax : "1"},
			    height: 130,
			    width: 500,
			    draggable: true
	});
}