function openWarrantyAndClauseModal(inspNo){
	try{
		Modalbox.show(contextPath+"/GIPIInspectionReportController?action=showInspWarrantyAndClauseModal&ajaxModal=1&inspNo="+inspNo, {
			title: "Warranty",
			width: 700,
			asynchronous:false
		});
	} catch(e){
		showErrorMessage("openWarrantyAndClauseModal", e);
	}
}