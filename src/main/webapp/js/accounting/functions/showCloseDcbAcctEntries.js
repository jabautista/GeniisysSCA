// dren 08.03.2015 : SR 0017729 - For Adding Accounting Entries
function showCloseDcbAcctEntries() {
	new Ajax.Updater("dcbMainDiv", contextPath 
			+ "/GIACAcctEntriesController?action=showAcctEntriesTableGrid", {
		parameters : {
			gaccTranId : objACGlobal.gaccTranId,
			dcbFlag : "Y"
		},
		asynchronous : false,
		evalScripts : true,
		onCreate : function() {
			showNotice("Loading Accounting Entries. Please Wait...</br> "
					+ contextPath);
		},
		onComplete : function() {
			hideNotice("");
		}
	});
}		