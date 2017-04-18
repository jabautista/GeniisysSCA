/**
 * Removes class selected row of a tableGrid row given its coordinates
 * @author Veronica V. Raymundo
 * @param tableGrid
 * @param x
 * @param y
 */
function removeTableGridRowClassSelectedRow(tableGrid, x, y){
	var id = tableGrid._mtgId;
	$('mtgRow'+id+'_'+y).removeClassName('selectedRow');
	removeTableGridCellClassSelectedRow(tableGrid);
}