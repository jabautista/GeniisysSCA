/*	Created by	: mark jm 02.11.2011
 * 	Description	: another version of show editor (for item info only)
 * 	Parameters	: textId - the source & destination of text
 * 				: charLimit - maximum length to store/display
 */
function showItemEditor(textId, charLimit) {
	var margin = (screen.width - (610 + (screen.width*.1)))/2;
	Effect.ScrollTo("notice", {duration: .001});
	document.getElementById("textareaOpaqueOverlay").style.left = "0";
	document.getElementById("textareaOpaqueOverlay").style.display = "block";
	
	document.getElementById("textareaContentHolder").style.marginLeft = (margin)+"px";
	document.getElementById("textareaContentHolder").style.marginRight = margin+"px";
	document.getElementById("textareaContentHolder").style.top = "150px";
	document.getElementById("textareaContentHolder").style.display = "block";
	document.getElementById("textareaContentHolder").style.width = "600px";
	document.getElementById("textareaContentHolder").innerHTML = $("textareaDiv").innerHTML;
	
	$("textarea1").value = $(textId).value;
	$("textarea1").focus();
	$("overlayTextEditorTitle").update("Textarea Editor");
	
	// apply textLimit
	$("textarea1").observe("keydown", function(){
		if(this.value.length <= charLimit){
			this.setAttribute("lastValue", this.value);
		}		
	});
	
	$("textarea1").observe("keyup", function () {
		//limitText(this, charLimit);
		if (this.value.length > charLimit) {
			this.value = this.getAttribute("lastValue");
	    	//this.value = this.value.substring(0, limitNum);
			this.blur();
	    	showMessageBox('You have exceeded the maximum number of allowed characters ('+charLimit+') for this field.', imgMessage.INFO);
	    	return false;
	    }
	});
		
	try {
		$("btnSubmitText").stopObserving("click");
		$("btnSubmitText").observe("click", function () {
			$(textId).value = $("textarea1").value;
			hideEditor(textId);
			showMessageBox("Click the Add/Update button to apply changes.", imgMessage.INFO);
		});
		
		$("btnCancelText").stopObserving("click");
		$("btnCancelText").observe("click", function () {
			hideEditor(textId);
		});
		
		$("closeEditor").stopObserving("click");
		$("closeEditor").observe("click", function () {
			hideEditor(textId);
		});
	}catch(e){
		showErrorMessage("showItemEditor", e);		
	}
}