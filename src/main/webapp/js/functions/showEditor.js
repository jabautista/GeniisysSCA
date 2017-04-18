// show editor in an overlay haha!
// parameters: textId - id of the original text area where the text to edit would come from
// whofeih - 07.02.2010
/*
 * modified by andrew - 03.02.2011
 * added 'readonly' parameter 
 */
function showEditor(textId, charLimit, readonly) {
	var zIndex = Windows.maxZIndex + 100001;//Windows.maxZIndex + 2000001; //nok 11.14.11 para sa lage nasa top
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
	$("overlayTextEditorTitle").update("Text Editor");
	
	// andrew - 03.02.2011 - added this 'if' block
	if(readonly != undefined && readonly == 'true'){ 
		$("textarea1").writeAttribute("readonly");
	}else{ // added else to remove the attribute readOnly if readOnly parameter is undefined - Nica 07.23.2012
		$("textarea1").removeAttribute("readonly");
	}
	
	// mark jm 11.18.2011 save last valid value of the element
	$("textarea1").observe("keydown", function(){
		if(this.value.length <= charLimit){
			this.setAttribute("lastValue", this.value);
		}		
	});
	
	// apply textLimit
	$("textarea1").observe("keyup", function () {
		if ($(textId).hasClassName("allCaps")) $("textarea1").value = $("textarea1").value.toUpperCase(); //niknok 3.13.12
		// mark jm 11.18.2011 replace limit text. last input should not be allowed if the length exceeds the limit
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
			ojbGlobalTextArea.origValue = $(textId).value;
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