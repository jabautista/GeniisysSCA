function endRedistributionTransaction() {
	new Ajax.Request(contextPath + "/GIUWPolDistController?action=endRedistributionTransaction", {
		method: "GET",
		evalScripts: true,
		asynchronous: false,
		onComplete: function(response) {
			
		}
	});
}