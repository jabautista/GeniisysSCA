/** Shows Batch Printing
 * Module: GIPIS170 - Batch Printing
 * @author Kenneth L. 08.22.2013
 */
function showBatchPrinting(){
	try {
		new Ajax.Request(contextPath+"/BatchPrintingController",{
			parameters:{action: "showBatchPrinting"},
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Loading Batch Printing, please wait...");
			},
			onComplete: function (response){
				hideNotice("");
				$("mainContents").update(response.responseText);
				Effect.Appear($("mainContents").down("div", 0), {
					duration: .001
				});
			}
		});
	} catch (e){
		showErrorMessage("showBatchPrinting", e);
	}
}