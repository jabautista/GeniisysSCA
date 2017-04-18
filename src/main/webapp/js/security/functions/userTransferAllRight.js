function userTransferAllRight(list1, list2, listClass, newDivName, callback) {
	var tranCd = getSelectedRowIdInTable("transactionSelect1", "row");
	var issCd = getSelectedRowIdInTable("issSourcesSelect1", "row");

	if (list2.toUpperCase().include("LINE") && "" == issCd) {
		showMessageBox("Please select an issue source first.", imgMessage.ERROR);
		return false;
	} else if ((list2.toUpperCase().include("SOURCE") || list2.toUpperCase().include("MODULE")) && "" == tranCd){
		showMessageBox("Please select a transaction first.", imgMessage.ERROR);
		return false;
	} else {
		$$("div#" + list1 + " div[name='row']").each(function(o) {
			if (o.getStyle("display") != "none") {
				//o.down("input", 0).writeAttribute("name", newDivName + "1");
				o.childNodes[0].writeAttribute("name", newDivName + "1");
				o.removeClassName("selectedRow");
				$(list2).insert({ bottom : o });
				if (list1.toUpperCase().include("TRANSACTION")) {
					curUserTransactions.curUserTransactions.push({"tranCd" : o.down("input",0).value, "tranDesc" : o.down("label", 0).innerHTML});
					
					// default is to assign all modules to a transaction, thus the code below does.
					userModules.userModules.each(function (m) {
						if (o.down("input",0).value == m.tranCd) {
							curUserModules.curUserModules.push({"moduleId"   : m.moduleId,
																"moduleDesc" : m.moduleDesc,
																"tranCd" 	 : m.tranCd,
																"userID" 	 : $F("userId")
															   });
						}
					});
				} else if (list1.toUpperCase().include("MODULE")) {
					curUserModules.curUserModules.push({"moduleId"   : o.down("input", 0).value,
														"moduleDesc" : o.down("label", 0).innerHTML,
														"tranCd" 	 : tranCd,
														"userID" 	 : $F("userId")
													   });
				} else if (list1.toUpperCase().include("SOURCE")) {
					curUserIssSources.curUserIssSources.push({"issCd"   : o.down("input", 0).value,
								  							  "issName" : o.down("label", 0).innerHTML,
								  							  "tranCd" 	: tranCd,
								  							  "userID"  : $F("userId")
						   		 							 });
				} else if (list1.toUpperCase().include("LINE")) {
					var i = o.parentNode.childNodes.length - 1;
					curUserLines.curUserLines.push({"lineCd"   : /* o.down("input", 0).value */ o.parentNode.childNodes[i].childNodes[0].value,
													"lineName" : /* o.down("label", 0).innerHTML */ o.parentNode.childNodes[i].childNodes[1].innerHTML,
													"tranCd"   : tranCd,
													"userID"   : $F("userId"),
													"issCd"    : issCd 
												  });
				}
			}
		});
		
		$$("div#" + list2 + " div[name='row']").invoke("stopObserving");
		
		if ("" != callback) {
			initializeTable(listClass, "row", "", callback);
		} else {
			initializeTable(listClass, "row", "", "");
		}
		
		userSortList(list2);
	}
}