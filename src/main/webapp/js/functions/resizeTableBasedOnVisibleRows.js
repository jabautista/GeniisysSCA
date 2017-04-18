/*	Created by	: mark jm 03.18.2011
 * 	Description	: resize table based on visible rows (no total amount)
 * 	Parameters	: tableId - id of the table
 * 				: tableListing - id of the listing
 */
function resizeTableBasedOnVisibleRows(tableId, tableListing){
	try{
		var exist = ($$("div#" + tableListing + " div:not([style='display: none;'])")).length;
				
		if (exist > 5) {
			$(tableId).setStyle("height: 186px;");
			$(tableId).down("div",0).setStyle("padding-right: 20px;");
			$(tableListing).setStyle("height: 155px; overflow-y: auto;");
		} else if (exist == 0) {
			$(tableListing).setStyle("height: 31px;");
			$(tableId).down("div",0).setStyle("padding-right: 0px");
		} else {
			var tableHeight = ((exist + 1) * 31);
			var tableRowHeight = (exist * 31);
			
			if(tableHeight == 0) {	tableHeight = 31;	}
			
			$(tableListing).setStyle("height: " + tableRowHeight +"px; overflow: hidden;");
			$(tableId).setStyle("height: " + tableHeight +"px; overflow: hidden;");
			$(tableId).down("div",0).setStyle("padding-right: 0px");
		}		
		
		(exist == 0) ? Effect.Fade($(tableId), { duration : .001	}) : Effect.Appear($(tableId), {	duration : .001	});
	}catch(e){
		showErrorMessage("resizeTableBasedOnVisibleRows", e);
	}
}