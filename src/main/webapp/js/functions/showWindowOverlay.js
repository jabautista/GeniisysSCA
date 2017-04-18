/**
 * Shows a window overlay
 * @author andrew robes
 * @date 03.24.2011
 * @param content - content of the window
 * @param title - title of the window
 * @param width - width of the window
 * @param height - height of the window
 * @param onCompleteCallback - function to be executed after ajax request
 */
function showWindowOverlay(content, title, width, height, onCompleteCallback) {	
	try {
		var t = new Date();
		var time = t.getTime();
	    var dialogId = 'modal_dialog_' + time;
	    var contentDiv = new Element("div", {id : "modal_content_"+time});
	    var contentHTML = '<div id="modal_content_'+time+'"></div>';
	    
	    winWorkflow = Overlay.show(contentHTML, {
							id: dialogId,
							title: title,
							width: width,
							height: height,
							draggable: true,
							closable: true
						});
	    
	    new Ajax.Updater("modal_content_"+time, content, {
			evalScripts: true,
			asynchronous: false,
			onComplete: function (response) {			
				if (checkErrorOnResponse(response)) {
					if (onCompleteCallback != "" && onCompleteCallback != null) {
						onCompleteCallback();
					}
				}
			}
		});
	} catch (e){
		showErrorMessage("showWindowOverlay", e);
	}
}