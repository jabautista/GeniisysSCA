/**
 * Add class selected row to a tableGrid row given its coordinates 
 * @author Veronica V. Raymundo
 * @param tableGrid
 * @param x - x coordinate
 * @param y - y coordinate
 * 
 **/
function addTableGridRowClassSelectedRow(tableGrid, x, y){
	tableGrid.unselectRows();
	tableGrid.selectRow(y);
}