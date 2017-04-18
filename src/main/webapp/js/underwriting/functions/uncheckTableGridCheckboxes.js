/**
 * Uncheck all the check boxes of the tableGrid given 
 * the check boxes columnName.
 * @param tableGrid
 * @param columnName
 * 
 */
function uncheckTableGridCheckboxes(tableGrid, columnName){
	var rows = tableGrid.rows;
	var columnIndex = tableGrid.getColumnIndex(columnName);
	for(var i=0; i<rows.length; i++){
		$("mtgInput"+tableGrid._mtgId+"_"+columnIndex+","+i).checked = false;
		$("mtgIC"+tableGrid._mtgId+"_"+columnIndex+","+i).removeClassName('modifiedCell');
	}
	tableGrid.unselectRows;
}