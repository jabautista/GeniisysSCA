/**Set changeTag = 1 if any changes is observe in the tableGrid
 * @author Veronica V. Raymundo
 * @param tableGrid - tableGrid to be observe
 * @return
 */

function observeChangeTagInTableGrid(tableGrid){
	if (tableGrid.getModifiedRows().length != 0 || tableGrid.getNewRowsAdded().length != 0 || tableGrid.getDeletedRows().length != 0){
		changeTag = 1;
	}
}