/**
 * Prepares RI Outstanding Acceptance Report
 * Module: GIRIS051 - Generate RI Reports (Outstanding tab)
 * @author shan 01.30.2013
*/
function prepareOARDate(){
	var reportId = "";
	var title = "";
	
	if(objRiReports.oar.acceptRG == "Report"){
		reportId = "GIRIR101";
		title = "Outstanding Acceptances Report";
	}else if(objRiReports.oar.acceptRG == "Letter"){
		reportId = "GIRIR037";
		title = "GIRIR037";
	}
	
	var content = contextPath+"/UWReinsuranceReportPrintController?action=printUWRiOutAcceptReport&reportId="+reportId+"&lineCd="+
				  objRiReports.oar.line_cd_accept+"&riCd="+objRiReports.oar.ri_cd_accept+"&oarPrintDate="+objRiReports.oar.oar_print_date
				  +"&moreThan="+objRiReports.oar.more_than+"&lessThan="+objRiReports.oar.less_than+"&dateSw="+objRiReports.oar.date_sw+
				  "&noOfCopies="+objRiReports.oar.no_of_copies+"&printerName="+objRiReports.oar.printer_name+"&destination="+
				  objRiReports.oar.dest;
	
	objRiReports.oar.reports.push({reportUrl: content, reportTitle: title});
	printUWRiOutstandingReports();
}