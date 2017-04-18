/**
 * Removes highlight of a tableGrid cell on focus
 * @author Veronica V. Raymundo  
 * @param tableGrid
 */
function removeTableGridCellClassSelectedRow(tableGrid){
	var id = tableGrid._mtgId;
	var coor = tableGrid.getCurrentPosition();
	var x = coor[0];
	var y = coor[1];
	if($('mtgC'+id+'_'+x+','+ y) != null){
		$('mtgC'+id+'_'+x+','+ y).removeClassName('selectedRow');
	}
}