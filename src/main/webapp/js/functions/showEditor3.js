/**
 * showEditor but will delete text when over limit
 * @author marj 06.16.2012
 */
function showEditor3(textId, charLimit, readonly) {
	var zIndex = Windows.maxZIndex + 100001; //Windows.maxZIndex + 2000001; 
	var margin = (screen.width - (610 + (screen.width*.1)))/2;
	Effect.ScrollTo("notice", {duration: .001});
	document.getElementById("textareaOpaqueOverlay").style.left = "0";
	document.getElementById("textareaOpaqueOverlay").style.display = "block";
	document.getElementById("textareaOpaqueOverlay").style.zIndex = zIndex-1; 
	
	document.getElementById("textareaContentHolder").style.zIndex = zIndex; 
	document.getElementById("textareaContentHolder").style.marginLeft = (margin)+"px";
	document.getElementById("textareaContentHolder").style.marginRight = margin+"px";
	document.getElementById("textareaContentHolder").style.top = "150px";
	document.getElementById("textareaContentHolder").style.display = "block";
	document.getElementById("textareaContentHolder").style.width = "600px";
	document.getElementById("textareaContentHolder").innerHTML = $("textareaDiv").innerHTML;
	
	document.getElementById("textarea1").style.fontFamily = textEditorFont;
	document.getElementById("textarea1").style.fontSize = '10px';
	
	$("textarea1").value = $(textId).value;	
	$("textarea1").focus();
	$("overlayTextEditorTitle").update("Text Area Editor");
	
	if(readonly != undefined && readonly == 'true'){ 
		$("textarea1").writeAttribute("readonly");
	}
	
	//checking if over textLimit
	$("textarea1").observe("keyup", function () {
		if ($(textId).hasClassName("allCaps")) $("textarea1").value = $("textarea1").value.toUpperCase(); 
		if (this.value.length > charLimit) {
			this.blur();
	    	showMessageBox('You have exceeded the maximum number of allowed characters ('+charLimit+') for this field.', imgMessage.INFO);
	    	//this.value = "";
	    	$("textId").value = "";
	    	return false;
	    }
	});
		
	try {
		$("btnSubmitText").stopObserving("click");
		$("btnSubmitText").observe("click", function () {
			$(textId).value = $("textarea1").value;
			hideEditor(textId);
			if(readonly != undefined && readonly == 'true'){ //to avoid tagging of changeTag if readOnly
				null;
			}else{
				changeTag = 1;
			}
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