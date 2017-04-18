/**
 * Observe Overlay LOV filter
 * @author Jerome Orio
 */
function observeOverlayLovFilter(id, objArray){
	try{
		var lov = objArray;
		$("filterTextLOV").observe("keyup", function (evt)	{
			if (evt.keyCode == objKeyCode.ESC){
				$("filterTextLOV").clear();
				$$("div#lovListingDiv div[name='"+id+"LovRow']").each(function (div)	{
					div.show();
				});
			}else{
				var text = replaceSpecialCharsInFilterText($("filterTextLOV").value.strip());
				if ("" != text)	{
					$$("div#lovListingDiv div[name='"+id+"LovRow']").each(function (div) {
						div.removeClassName("selectedRow");
						if (div.getAttribute("val").toUpperCase().include(text.toUpperCase())) {
							div.show();
						}else{
							div.hide();
						}	
					});
				}else{
					$$("div#lovListingDiv div[name='"+id+"LovRow']").each(function (div)	{
						div.removeClassName("selectedRow");
						div.show();
					});
				}
			}
		});
	}catch(e){
		showErrorMessage("observeOverlayLovFilter", e);
	}
}	