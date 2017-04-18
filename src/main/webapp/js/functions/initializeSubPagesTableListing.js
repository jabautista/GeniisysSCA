/*	Created by	: mark jm 09.06.2010
 * 	Description	: hide all the rows of the table upon initialization
 * 				: used in item information
 * 	Parameters	: tableName - name of table where row is located
 * 				: rowName - name of row used in table
 * 
 */
function initializeSubPagesTableListing(tableName, rowName){	
	$$("div#" + tableName + " div[name='" + rowName + "']").each(
		function(row){
			row.hide();
		});

	Effect.Fade(tableName, {
		duration: .001
	});
}