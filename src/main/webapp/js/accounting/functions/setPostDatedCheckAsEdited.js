function setPostDatedCheckAsEdited(editedRow) {
	var modifiedRows = postDatedChecksTableGrid.getModifiedRows();
	var exists = false;
	for ( var x = 0; x < modifiedRows.length; x++) {
		if (modifiedRows[x].divCtrId == editedRow.divCtrId) {
			modifiedRows.splice(x, 1);
			exists = true;
		}
	}
	if (!exists) {
		postDatedChecksTableGrid.modifiedRows.push(editedRow);
	}
}