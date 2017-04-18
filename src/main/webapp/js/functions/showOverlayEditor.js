/**
 * Shows the overlay editor
 * @author andrew robes
 * @date 08.18.2011
 * @param textId - id of textarea
 * 		  charLimit - character limit/length
 * 		  [readonly] - if readonly ('true'/'false')
 */
function showOverlayEditor(textId, charLimit, readonly, onChangeFunc) {
	funcHolder.onChangeFunc = onChangeFunc; // Udel - 4.13.2012 - Added optional param onChangeFunc, to be executed when editor is changed. 
	overlayEditor = Overlay.show(contextPath+"/GIISController", {
						urlContent : true,
						urlParameters: {action : "showOverlayEditor",
										textId : textId,
										initialValue : escapeHTML2($(textId) != null ? $F(textId) : ""),
										charLimit : charLimit,
										readonly : readonly,
										onChangeFunc : onChangeFunc},
					    title: "Text Editor",
					    height: 350,
					    width: 600,
					    draggable: true
					});
}