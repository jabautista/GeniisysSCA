/**
 * Show Generate Reinsurance Reports page (Tabs)
 * Module: GIRIS051 - Generate Reinsurance Reports
 * @author Shan Bati
 * @date  01.29.2013
 */
function showGenerateRIReportsTabPage(tabAction){
	try{
		new Ajax.Updater("riReportsSubDiv", contextPath+"/GIRIGenerateRIReportsController?action=showGenerateRIReportsPage",{
			method: "GET",
			parameters: {
				tabAction: tabAction
			},
			evalScripts: true,
			asynchronous: true,
			onCreate:  showNotice("Loading, please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					//clears Outstanding tab global variables
					objRiReports.oar.reports = [];	
					objRiReports.oar.acceptRG = null;
					objRiReports.oar.show_alert = false;
					objRiReports.oar.ri_cd_accept = null;
					objRiReports.oar.line_cd_accept = null;
					objRiReports.oar.oar_print_date = null;
					objRiReports.oar.more_than = null;
					objRiReports.oar.less_than = null;
					objRiReports.oar.date_sw = null;
					objRiReports.oar.no_of_copies = null;
					objRiReports.oar.printer_name = null;
					objRiReports.oar.dest = null;
				}
			}
		});
	}catch(e){
		showErrorMessage("showGenerateRIReportsTabPage", e);
	}
}