function showRiCommIncAndExp() {
	new Ajax.Request(
			contextPath + "/GIACReinsuranceReportsController",
			{
				evalScripts : true,
				asynchronous : false,
				method : "POST",
				parameters : {
					action : "showRiCommIncAndExp"
				},
				onCreate : function() {
					showNotice("Loading RI Commission Income and Expense, please wait...");
				},
				onComplete : function(response) {
					hideNotice();
					if (checkErrorOnResponse(response)) {
						$("dynamicDiv").update(response.responseText);
					}
				}
			});
}