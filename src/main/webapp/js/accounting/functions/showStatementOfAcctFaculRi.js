/**
 * Gzelle 07.19.2013 GIACS121 SOA - Facultative RI
 */
function showStatementOfAcctFaculRi() {
	new Ajax.Request(
			contextPath + "/GIACReinsuranceReportsController",
			{
				evalScripts : true,
				asynchronous : false,
				method : "POST",
				parameters : {
					action : "showStatementOfAcctFaculRi"
				},
				onCreate : function() {
					showNotice("Loading Statement of Account - Facultative RI, please wait...");
				},
				onComplete : function(response) {
					hideNotice();
					if (checkErrorOnResponse(response)) {
						$("dynamicDiv").update(response.responseText);
					}
				}
			});
}