/**
 * Show text editor intended to update remarks for Package Par Listing
 * @author 		  Veronica V. Raymundo
 * 				  January 7, 2011
 * @param		  title - 		title of the text editor,
 *				  textId - 		input text,
 *				  charLimit - 	maximum characters allowed,
 *				  label - 		id of the label to be updated,
 *				  truncateNo - 	no. of characters for truncation of label
 *				  id - 			equals to the packParId				
 */

function showParRemarksEditor(title, textId, charLimit, label, truncateNo, id){
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
	$("overlayTextEditorTitle").update(title);
	
	// limits the character in the text area
	$("textarea1").observe("keyup", function () {
		limitText(this, charLimit);
	});
			
	try {
		$("btnSubmitText").stopObserving("click");
		$("btnSubmitText").observe("click", function () {
			$(textId).value = $("textarea1").value;
			hideEditor(textId);
			changeTag = 1;
			for(var i=0; i<objUWParList.jsonArray.length; i++){
				if(id == objUWParList.jsonArray[i].packParId){
					objUWParList.jsonArray[i].remarks = changeSingleAndDoubleQuotes2($(textId).value);
					objUWParList.jsonArray[i].recordStatus = 1;
					$(label).innerHTML = $(textId).value == null || $(textId).value == "" ? "-" : $(textId).value.truncate(truncateNo, '...');
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
	} catch (e) {
		showErrorMessage("showParRemarksEditor", e);
	}
}