function userTransferAllLeft(list1, list2, listClass, newDivName) {
	var tranCd = getSelectedRowIdInTable("transactionSelect1", "row");
	
	$$("div#" + list2 + " div[name='row']").each(function(o) {
		if (o.getStyle("display") != "none") {
			//o.down("input", 0).writeAttribute("name", newDivName);
			o.childNodes[0].writeAttribute("name", newDivName);
			o.removeClassName("selectedRow");
			$(list1).insert( { bottom : o });
			if (list1.toUpperCase().include("TRANSACTION")) {
				curUserTransactions.curUserTransactions = curUserTransactions.curUserTransactions.findAll(function (a) {
					if (!(a.tranCd == o.down("input", 0).value)) {
						return a;
					}
				});
				
				curUserModules.curUserModules = curUserModules.curUserModules.findAll(function (m) {
					if (tranCd != m.tranCd) {
						return m;
					}
				});
				
				curUserIssSources.curUserIssSources = curUserIssSources.curUserIssSources.findAll(function (i) {
					if (tranCd != i.tranCd) {
						return i;
					}
				});
				
				curUserLines.curUserLines = curUserLines.curUserLines.findAll(function (l) {
					if (tranCd != l.tranCd) {
						return l;
					}
				});
				
				returnRows("moduleSelect", "moduleSelect1");
				returnRows("issSourcesSelect", "issSourcesSelect1");
				returnRows("lineSelect", "lineSelect1");
				//userCreateIssTable();
				//userCreateLinesTable();
			} else if (list1.toUpperCase().include("MODULE")) {
				var mId = o.down("input", 0).value;
				curUserModules.curUserModules = curUserModules.curUserModules.findAll(function (a) {
					if (!(a.moduleId == mId && a.tranCd == tranCd)) {
						return a;
					}
				});
			} else if (list1.toUpperCase().include("SOURCE")) {
				var issCd = o.down("input", 0).value;
				curUserIssSources.curUserIssSources = curUserIssSources.curUserIssSources.findAll(function (a) {
					if (!(a.issCd == issCd && a.tranCd == tranCd)) {
						return a;
					}
				});
				
				curUserLines.curUserLines = curUserLines.curUserLines.findAll(function (a) {
					if (!(a.tranCd == tranCd && a.issCd == issCd)) {
						return a;
					}
				});
				
				returnRows("lineSelect", "lineSelect1");
				//userCreateLinesTable();
			} else if (list1.toUpperCase().include("LINE")) {
				//var lineCd = o.down("input", 0).value;
				var i = o.parentNode.childNodes.length - 1;
				var lineCd = o.parentNode.childNodes[i].childNodes[0].value;
				var issCd = getSelectedRowIdInTable("issSourcesSelect1", "row");
				curUserLines.curUserLines = curUserLines.curUserLines.findAll(function (a) {
					if (!(a.lineCd == lineCd && a.tranCd == tranCd && a.issCd == issCd)) {
						return a;
					}
				});
			}
		}
	});
	
	$$("div#" + list1 + " div[name='row']").invoke("stopObserving");
	
	initializeTable(listClass, "row", "", "");
	
	userSortList(list1);
}