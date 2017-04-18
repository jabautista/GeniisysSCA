function showDcbAcctEntries(dcbFlag) {
	new Ajax.Updater("transBasicInfoSubpage", contextPath
			+ "/GIACAcctEntriesController?action=showAcctEntries", {
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