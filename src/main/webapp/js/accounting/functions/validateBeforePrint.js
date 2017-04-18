function validateBeforePrint(funcName, isSelectedAll, allRowsToPrint, rowsToPrint) {
	if (isSelectedAll && allRowsToPrint.length > 1) {
		var isBreak = false;
		showConfirmBox(
				"GenIISys",
				"Continue printing collection letter(s)?",
				"Yes",
				"No",
				function() {
					// getParamsToPrint();
					// saveCollectionLetter(funcName);
					getParamsToPrint(isSelectedAll, allRowsToPrint, rowsToPrint);
					prepareCollectionLetterParams(funcName, isSelectedAll, allRowsToPrint, rowsToPrint);
					// prepareCollectionLetterParams(funcName);
				}, function() {
					isBreak = true;
				}, "");
		if (isBreak)
			return false;
	} else {
		if (rowsToPrint.length > 0) {
			showWaitingMessageBox("There are " + rowsToPrint.length + " record(s) to be printed.", "I", function() {
				// getParamsToPrint();
				// saveCollectionLetter(funcName);
				getParamsToPrint(isSelectedAll, allRowsToPrint, rowsToPrint);
				prepareCollectionLetterParams(funcName, isSelectedAll, allRowsToPrint, rowsToPrint);
				// prepareCollectionLetterParams(funcName);
			});
		} else {
			// getParamsToPrint(); // get muna ung selected before saving
			// saveCollectionLetter(funcName);
			getParamsToPrint(isSelectedAll, allRowsToPrint, rowsToPrint);
			prepareCollectionLetterParams(funcName, isSelectedAll, allRowsToPrint, rowsToPrint);
			// prepareCollectionLetterParams(funcName);
		}
	}
}