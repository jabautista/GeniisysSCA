function transferLeft(list1, list2, listClass, newDivName) {
	var tranCd = getSelectedRowIdInTable("transactionSelect1", "row");
	
	$$("div#" + list2 + " div[name='row']").each(function(o) {
		if (o.hasClassName("selectedRow")) {
			//o.down("input", 0).writeAttribute("name", newDivName);
			o.childNodes[0].writeAttribute("name", newDivName);
			o.removeClassName("selectedRow");
			$(list1).insert({bottom : o});
			if (list1.toUpperCase().include("TRANSACTION")) {
				tTransactions.tTransactions = tTransactions.tTransactions.findAll(function (a) {
					if (!(a.tranCd == o.down("input", 0).value)) {
						return a;
					}
				});
				
				grpModules.grpModules = grpModules.grpModules.findAll(function (m) {
					if (tranCd != m.tranCd) {
						return m;
					}
				});
				
				grpIssSources.grpIssSources = grpIssSources.grpIssSources.findAll(function (i) {
					if (tranCd != i.tranCd) {
						return i;
					}
				});
				
				curLines.curLines = curLines.curLines.findAll(function (l) {
					if (tranCd != l.tranCd) {
						return l;
					}
				});
				
				returnRows("moduleSelect", "moduleSelect1");
				returnRows("issSourcesSelect", "issSourcesSelect1");
				returnRows("lineSelect", "lineSelect1");
				//createIssTable();
				//createLinesTable();
			} else if (list1.toUpperCase().include("MODULE")) {
				var mId = o.down("input", 0).value;
				grpModules.grpModules = grpModules.grpModules.findAll(function (a) {
					if (!(a.moduleId == mId && a.tranCd == tranCd)) {
						return a;
					}
				});
			} else if (list1.toUpperCase().include("SOURCE")) {
				var issCd = o.down("input", 0).value;
				grpIssSources.grpIssSources = grpIssSources.grpIssSources.findAll(function (a) {
					if (!(a.issCd == issCd && a.tranCd == tranCd)) {
						return a;
					}
				});
				
				curLines.curLines = curLines.curLines.findAll(function (l) {
					if (tranCd != l.tranCd) {
						return l;
					}
				});
				
				returnRows("lineSelect", "lineSelect1");
				//createLinesTable();
				clearDiv("lineSelect1");
			} else if (list1.toUpperCase().include("LINE")) {
				//var lineCd = o.down("input", 0).value;
				var i = o.parentNode.childNodes.length - 1;
				var lineCd = o.parentNode.childNodes[i].childNodes[0].value;
				var issCd = getSelectedRowIdInTable("issSourcesSelect1", "row");
				curLines.curLines = curLines.curLines.findAll(function (a) {
					if (!(a.lineCd == lineCd && a.tranCd == tranCd && a.issCd == issCd)) {
						return a;
					}
				});
			}
		}
	});
	
	$$("div#" + list1 + " div[name='row']").invoke("stopObserving");
	
	initializeTable(listClass, "row", "", "");
	sortList(list1);
}