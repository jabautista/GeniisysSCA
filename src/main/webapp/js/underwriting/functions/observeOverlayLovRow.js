/**
 * Observe Overlay for LOV Row
 * @author Jerome Orio
 */
function observeOverlayLovRow(id){
	try{
		$$("div#lovListingDiv div[name="+id+"LovRow]").each(function(newDiv){
			loadRowMouseOverMouseOutObserver(newDiv);
			newDiv.observe("click", function(){
				newDiv.toggleClassName("selectedRow");
				if (newDiv.hasClassName("selectedRow")){
					$$("div#lovListingDiv div[name="+id+"LovRow]").each(function(r){
						if (newDiv.getAttribute("id") != r.getAttribute("id")){
							r.removeClassName("selectedRow");
						}
					});
				}
			});	
		});
	}catch(e){
		showErrorMessage("observeOverlayLovRow", e);
	}
}