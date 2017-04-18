//showEditor that prompts the user to accept changes to the edited text
//used in policy/endt warranties and clauses
function showEditor2(textId, charLimit, confirmTitle, confirmMsg, setToDefault, onChangeFunc) {
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
	$("textarea1").observe("keyup", function () {
		if ($(textId).hasClassName("allCaps")) $("textarea1").value = $("textarea1").value.toUpperCase(); //niknok 3.13.12
		limitText(this, charLimit);
	});
	
	var editorChangeTag = 0;
	$("textarea1").observe("change", function () {
		editorChangeTag = 1;
	});
	
	try {
		$("btnSubmitText").stopObserving("click");
		$("btnSubmitText").observe("click", function () {
			hideEditor(textId);
			if(editorChangeTag == 1) {
				if(confirmMsg == null && confirmTitle == null) {
					$(textId).value = $("textarea1").value;
					onChangeFunc();
				} else {
					showConfirmBox(confirmTitle, confirmMsg, "Yes", "No", function() {
						$(textId).value = $("textarea1").value;
						//(changeTagElement == "" ? "" : $(changeTagElement).checked = true);  //used only in warranties and clauses
						onChangeFunc();
					}, /*(defaultValue == "" ? "" : function(){
						$(textId).value = defaultValue;
						})*/
						function() {setToDefault(); }
					);
				}
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
		showErrorMessage("showEditor2", e);
	} 
}