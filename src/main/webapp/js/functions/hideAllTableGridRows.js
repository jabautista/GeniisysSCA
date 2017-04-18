/**
 * Hides all rows of the tableGrid
 * @author Veronica V. Raymundo
 * @param tableGrid
 */
function hideAllTableGridRows(tableGrid){
	$$('.mtgRow'+tableGrid._mtgId).each(function(row){
        row.removeClassName('focus');
        row.removeClassName('selectedRow');
        row.hide();
    });
	$$('.mtgC'+tableGrid._mtgId).each(function(row){
        row.removeClassName('focus');
        row.removeClassName('selectedRow');
    });
}