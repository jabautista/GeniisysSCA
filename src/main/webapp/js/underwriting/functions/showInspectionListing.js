function showInspectionListing(){
	try {
		//showInspectionReport(); //temporary
		updateMainContentsDiv("/GIPIInspectionReportController?action=showInspectionListing",
				  "Loading Inspection Report, please wait...",
				  function(){},[]);		
//		new Ajax.Updater("underwritingDiv", contextPath+"/GIPIInspectionReportController?action=showInspectionListing",{
//			asynchronous: false,
//			evalScripts: true,
//			onCreate: function (){
//				
//			},
//			onComplete: function (){
//			
//			}
//		});
	} catch (e){
		showErrorMessage("showInspectionListing", e);
	}
}