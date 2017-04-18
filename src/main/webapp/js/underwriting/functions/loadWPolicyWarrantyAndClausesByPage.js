//mrobes 01.07.10 fill WPolicy - Warranties and Clauses table
function loadWPolicyWarrantyAndClausesByPage(pageNo)	{
	try	{
		new Ajax.Updater("wcDiv", contextPath+"/GIPIWPolicyWarrantyAndClauseController", {
			method: "GET",
			parameters: {globalParId:  $F("globalParId"),
						 globalLineCd: $F("globalLineCd"),
			  			 action: 	   "goToPage",
						 pageNo: 	   pageNo,
						 ajax: 		   "1"},
			evalScripts: true,
			asynchronous: true,
			onCreate: showLoading("wcDiv", "Loading list, please wait...", "30px;"),
			onComplete: function () {
				//checkTableIfEmpty("row", "wcDiv");
			}
		});
	} catch (e)	{
		showErrorMessage("loadWPolicyWarrantyAndClausesByPage", e);
	}
}