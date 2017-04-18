/*	Move by		: mark jm 09.17.2010
 * 	From		: /underwriting/subPages/mortgageeTable.jsp
 * 	Description	: Show detail records of selected item
 */
function loadRecordsBasedOnSelectedItem(tableName, rowName, attributeName, selectedItem, selectName){
	$$("div#" + tableName + " div[name='" + rowName + "']").each(
		function(row){			
			if(row.getAttribute(attributeName) == selectedItem){					
				row.show();					
				filterLOV(selectName, rowName, 1, "", attributeName, selectedItem);
			}					
		});
}