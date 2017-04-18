/**
 * @author andrew robes
 * @param title - title of dialog
 * 		  onPrintFunc - function to be executed when print button is pressed
 * 		  onLoadFunc - is optional function to be called upon loading the page - added by nok
 * 	      showFileOption - to show file option (pdf/excel) | valid value : true / false
 * 		   	
 */
function showGenericPrintDialog(title, onPrintFunc, onLoadFunc, showFileOption, onCancelFunc){
	overlayGenericPrintDialog = Overlay.show(contextPath+"/GIISController", {
		urlContent : true,
		urlParameters: {action : "showGenericPrintDialog",
						showFileOption : showFileOption},
	    title: title,
	    height: (showFileOption ? 175 : 150),
	    width: 380,
	    draggable: true,
	    onEscape : function(){
	    	onCancelFunc != null ? onCancelFunc() : false;
	    }
	});
	
	overlayGenericPrintDialog.onPrint = onPrintFunc;
	overlayGenericPrintDialog.onLoad  = nvl(onLoadFunc,null);
	overlayGenericPrintDialog.onCancel = function(){
		onCancelFunc != null ? onCancelFunc() : false;
	}; 
}