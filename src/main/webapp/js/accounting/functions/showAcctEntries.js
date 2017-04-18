// added 11/30/2010 for acct entries
function showAcctEntries() {
	new Ajax.Updater("transBasicInfoSubpage", contextPath
			+ "/GIACAcctEntriesController?action=showAcctEntriesTableGrid", {
		parameters : {
			gaccTranId : objACGlobal.gaccTranId,
			dcbFlag : "N"
		},
		asynchronous : false,
		evalScripts : true,
		onCreate : function() {
			showNotice("Loading Accounting Entries. Please Wait...</br> "
					+ contextPath);
		},
		onComplete : function() {
			hideNotice("");
			/*
			 * $$("div[name='subMenuDiv']").each(function(row){ row.hide(); });
			 * $$("div.tabComponents1 a").each(function(a){ if(a.id ==
			 * "acctEntries") {
			 * $("acctEntries").up("li").addClassName("selectedTab1"); }else{
			 * a.up("li").removeClassName("selectedTab1"); } });
			 */
		}
	});
}