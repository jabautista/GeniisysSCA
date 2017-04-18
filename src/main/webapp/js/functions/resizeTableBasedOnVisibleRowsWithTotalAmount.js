/**
 * 	Resize table based on visible rows (with total amount)
 *  @param tableId - id of the table
 *  @param tableListing - id of the listing
 */

function resizeTableBasedOnVisibleRowsWithTotalAmount(tableId, tableListing){
	try{
		var exist = ($$("div#" + tableListing + " div:not([style='display: none;'])")).length;
				
		if (exist > 5) {
			$(tableId).setStyle("height: 217px;");
			$(tableId).down("div",0).setStyle("padding-right: 20px;");
			$(tableListing).setStyle("height: 155px; overflow-y: auto;");
		} else if (exist == 0) {
			$(tableListing).setStyle("height: 31px;");
			$(tableId).down("div",0).setStyle("padding-right: 0px");
		} else {
			var tableHeight = ((exist + 2) * 31);
			var tableRowHeight = (exist * 31);
			
			if(tableHeight == 0) {	tableHeight = 62;	}
			
			$(tableListing).setStyle("height: " + tableRowHeight +"px; overflow: hidden;");
			$(tableId).setStyle("height: " + tableHeight +"px; overflow: hidden;");
			$(tableId).down("div",0).setStyle("padding-right: 0px");
		}		
		
		(exist == 0) ? Effect.Fade($(tableId), { duration : .001	}) : Effect.Appear($(tableId), {	duration : .001	});
	}catch(e){
		showErrorMessage("resizeTableBasedOnVisibleRowsWithTotalAmount", e);
	}
}