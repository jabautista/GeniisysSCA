function deleteAssuredTG(assdNo) {
	new Ajax.Request(contextPath+"/GIISAssuredController?action=checkAssuredDependencies&assdNo="+assdNo, {
		asynchronous: true,
		evalScripts: true,
		onCreate: showNotice("Checking assured dependencies, please wait..."),
		onComplete: function (response) {
			if (response.responseText.stripTags().trim().blank()) {
				new Ajax.Request(contextPath+"/GIISAssuredController?action=deleteGiisAssured&assdNo="+assdNo, {
					asynchronous: true,
					evalScripts: true,
					onCreate: showNotice("Deleting, please wait..."),
					onComplete: function (response1) {
						hideNotice();
						if (checkErrorOnResponse(response1)) {
							showMessageBox("Record Deleted.");
							showAssuredListingTableGrid();
							//$("row"+$F("assuredNo")).remove();
							positionPageDiv();
						} 
					}
				});
			} else {
				showMessageBox(response.responseText, imgMessage.ERROR);
				return false;
			}
		}
	});
}