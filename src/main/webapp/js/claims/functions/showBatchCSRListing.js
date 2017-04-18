/***
 * @description Show the Batch CSR listing
 * @author Veronica V. Raymundo
 * 
 */

function showBatchCSRListing(){
	try{
		new Ajax.Updater("dynamicDiv", contextPath + "/GICLBatchCsrController", { 
			method: "GET",
			parameters: {
				action: "getGiclBatchCsrTableGrid",
				moduleId : "GICLS043",
				ajax: "1"
			},
			asynchronous: true,
			evalScripts: true,
			onCreate : function() {
				showNotice("Getting Batch Claim Settlement Request listing, please wait...");
			},
			onComplete: function (response){
				hideNotice("");
			}
		});
	}catch(e){
		showErrorMessage("showBatchCSRListing",e);
	}
}