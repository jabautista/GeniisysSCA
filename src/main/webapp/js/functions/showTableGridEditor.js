/**
 * Shows text editor intended for tableGrid.
 * @author Veronica V. Raymundo
 * @param tableGrid - the tableGrid
 * @param x - x coordinate of the cell to be modified
 * @param y - y coordinate of the cell to be modified
 * @param title - tile to appear on the tableGrid
 * @param charLimit - no. of characters allowed
 * @param readonly - set true if text editor is in readonly mode
 */

function showTableGridEditor(tableGrid, x, y, title, charLimit, readonly){
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
	
	tableGrid.keys.releaseKeys();
	$("textarea1").value = unescapeHTML2(tableGrid.getValueAt(x,y)); // andrew - 02.09.2012 - added unescapeHTML2	
	$("textarea1").focus();
	$("overlayTextEditorTitle").update(title);
	
	if(readonly != undefined && readonly == true){ 
		$("textarea1").writeAttribute("readonly");
		$("btnSubmitText").hide();
		$("btnCancelText").hide();
	}
	
	var origValue =  $F("textarea1"); //added by steven 07.29.2013
	$("textarea1").observe("keyup", function () {
		//limitText(this, charLimit);
		origValue = limitText2(this, charLimit, origValue); //changed by steven 07.29.2013
	});
	
	try {
		$("btnSubmitText").stopObserving("click");
		$("btnSubmitText").observe("click", function () {
			tableGrid.setValueAt(unescapeHTML2($("textarea1").value), x, y); // steven - 07.04.2012 - added unescapeHTML2	
			hideTableGridEditor(tableGrid, x, y);
		});
		
		$("btnCancelText").stopObserving("click");
		$("btnCancelText").observe("click", function () {
			hideTableGridEditor(tableGrid, x, y);
		});
		
		$("closeEditor").stopObserving("click");
		$("closeEditor").observe("click", function () {
			hideTableGridEditor(tableGrid, x, y);
		});
	} catch (e) {
		showErrorMessage("showTableGridEditor", e);
	}
}