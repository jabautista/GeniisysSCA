/*	Created by		: mark jm
 * 	Date Created	: 08.20.2010
 * 	Description		: Adjust table layout in subpages/popups
 * 	Parameter		: tableName - name of the div where the table is located
 * 					: tableRow - name of the div that holds the record list
 * 					: rowName - name of the div that acts as row
 */

function checkPopupsTable(tableName, tableRow, rowName){
	//var exist = $$("div#"+tableName+" div[name='"+rowName+"']").size();
	var exist = 0;
	
	$$("div#" + tableName + " div[name='" + rowName + "']").each(
		function(row){
			if(row.style.display != 'none'){
				exist = exist + 1;
			}
		}
	);
	
	if (exist > 5) {
		$(tableName).setStyle("height: 217px;");
		$(tableName).down("div",0).setStyle("padding-right: 20px;");
     	$(tableRow).setStyle("height: 155px; overflow-y: auto;");
    } else if (exist == 0) {
     	$(tableRow).setStyle("height: 31px;");
     	$(tableName).down("div",0).setStyle("padding-right: 0px");
    } else {
    	var tableHeight = ((exist + 1) * 31) + 31;
    	var tableRowHeight = (exist * 31);
    	if(tableHeight == 0) {
    		tableHeight = 31;
    	}
    	$(tableRow).setStyle("height: " + tableRowHeight +"px; overflow: hidden;");
    	$(tableName).setStyle("height: " + tableHeight +"px; overflow: hidden;");
    	$(tableName).down("div",0).setStyle("padding-right: 0px");
	}
	
	if (exist == 0) {
		Effect.Fade(tableName, {
			duration: .001
		});
	} else {
		Effect.Appear(tableName, {
			duration: .001
		});
	}
}