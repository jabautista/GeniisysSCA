/*
 * created by gab - 08.12.2015
 *  show editor in an overlay with horizontal scroll
 */
function showEditor5(textId, charLimit, readonly) {
	var zIndex = Windows.maxZIndex + 100001;
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
	document.getElementById("textarea1").wrap = 'off';
	
	$("textarea1").value = $(textId).value;	
	$("textarea1").focus();
	$("overlayTextEditorTitle").update("Text Editor");
	
	if(readonly != undefined && readonly == 'true'){ 
		$("textarea1").writeAttribute("readonly");
	}else{
		$("textarea1").removeAttribute("readonly");
	}
	
	$("textarea1").observe("keydown", function(){
		if(this.value.length <= charLimit){
			this.setAttribute("lastValue", this.value);
		}		
	});
	
	$("textarea1").observe("keyup", function () {
		if ($(textId).hasClassName("allCaps")) $("textarea1").value = $("textarea1").value.toUpperCase(); 
		if (this.value.length > charLimit) {
			this.value = this.getAttribute("lastValue");
			this.blur();
	    	showMessageBox('You have exceeded the maximum number of allowed characters ('+charLimit+') for this field.', imgMessage.INFO);
	    	return false;
	    }
	});
		
	try {
		$("btnSubmitText").stopObserving("click");
		$("btnSubmitText").observe("click", function () {
			$(textId).value = $("textarea1").value;
			ojbGlobalTextArea.origValue = $(textId).value;
			hideEditor(textId);
			if(readonly != undefined && readonly == 'true'){
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
		showErrorMessage("showEditor5", e);
	}
}