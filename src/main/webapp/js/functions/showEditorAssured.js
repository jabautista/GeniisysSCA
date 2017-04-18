function showEditorAssured(textId, charLimit, readonly) {
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
	
	// andrew - 03.02.2011 - added this 'if' block
	if(readonly != undefined && readonly == 'true'){ 
		$("textarea1").writeAttribute("readonly");
	}
	
	// apply textLimit
	$("textarea1").observe("keyup", function () {
		limitText(this, charLimit);
	});
		
	try {
		$("btnSubmitText").stopObserving("click");
		$("btnSubmitText").observe("click", function () {
			$(textId).value = $("textarea1").value;
			$(textId).focus();
			hideEditor(textId);
			fireEvent($(textId), "keyup");
			fireEvent($(textId), "change");
		});
		
		$("btnCancelText").stopObserving("click");
		$("btnCancelText").observe("click", function () {
			hideEditor(textId);
		});
		
		$("closeEditor").stopObserving("click");
		$("closeEditor").observe("click", function () {
		hideEditor(textId);
		});
		
		$(textId).scrollTop = 1;
	} catch (e) {
		showErrorMessage("showEditor", e);
	}
}