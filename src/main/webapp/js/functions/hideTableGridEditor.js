/**
 * Hide tableGrid textEditor
 * @author Veronica V. Raymundo
 * @param tableGrid - the tableGrid
 * @param x - the x coordinate of the cell
 * @param y - the y coordinate of the cell
 * 
 */
function hideTableGridEditor(tableGrid, x, y){
	try {
		Effect.Fade("textareaContentHolder", {
			duration: .001,
			afterFinish: function () {
				Effect.Fade("textareaOpaqueOverlay", {
					duration: .001
				});
				var cell = tableGrid.keys.getCellFromCoords(x, y);
				tableGrid.keys.setFocus(cell);
				tableGrid.keys.captureKeys();
			}
		});
	} catch (e) {
		showErrorMessage("hideTableGridEditor", e);
	}
}