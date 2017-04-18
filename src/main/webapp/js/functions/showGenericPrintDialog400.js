/**
 * @author joms diago
 * @param title - title of dialog
 * 		  onPrintFunc - function to be executed when print button is pressed
 * 		  onLoadFunc - is optional function to be called upon loading the page - added by nok
 * 	      showFileOption - to show file option (pdf/excel) | valid value : true / false
 *        remarks - for print dialog with height more than 400, to avoid 
 */
function showGenericPrintDialog400(title, onPrintFunc, onLoadFunc, showFileOption, onCancelFunc){
	overlayGenericPrintDialog = Overlay.show(contextPath+"/GIISController", {
		urlContent : true,
		urlParameters: {action : "showGenericPrintDialog",
						showFileOption : showFileOption},
	    title: title,
	    height: 450,
	    width: 380,
	    draggable: true
	});
	
	overlayGenericPrintDialog.onPrint = onPrintFunc;
	overlayGenericPrintDialog.onLoad  = nvl(onLoadFunc,null);
	overlayGenericPrintDialog.onCancel = function(){
		onCancelFunc != null ? onCancelFunc() : false;
	}; 
}