function printInspectionReport(inspNo){
	Modalbox.show(contextPath+"/GIPIInspectionReportController?action=showPrintModal&ajaxModal=1&inspNo="+inspNo,
			{title: "Print Inspection Report",
			 width: 500});
}