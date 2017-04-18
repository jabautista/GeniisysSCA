/**
 * Calls report generator for cover note printing
 * @author Veronica V. Raymundo
 * @return
 */
function showCovernoteReportGenerator(){
	Modalbox.show(contextPath+"/PrintPolicyController?action=showReportGenerator&reportType=coverNote&globalParId="
			+$F("globalParId")+"&globalPackParId="+$F("globalPackParId"), 
		    {title : "Geniisys Reports Generator",
		     width : 400}
	);
}