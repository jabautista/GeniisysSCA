function transferAllRight(list1, list2, listClass, newDivName, callback) {
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
				$(list2).insert( { bottom : o });
				if (list1.toUpperCase().include("TRANSACTION")) {
					//Effect.Appear("transferMessage", {duration: .2});

					tTransactions.tTransactions.push({"tranCd" : o.down("input",0).value, "tranDesc" : o.down("label", 0).innerHTML});
					
					// add all modules, default behavior
					
					/*var filteredTranModules = tModules.tModules.findAll(function (m) {
						if (o.down("input",0).value == m.tranCd) {
							return m;
						}
					});*/
					
					tModules.tModules.each(function (m) {
						if (o.down("input",0).value == m.tranCd) {
							grpModules.grpModules.push({"moduleId"   : m.moduleId,
														"moduleDesc" : m.moduleDesc,
														"tranCd" 	 : m.tranCd,
														"userGrp" 	 : $F("userGrp")
													   });
						}
					});
					
					//Effect.Fade("transferMessage", {duration: .2});
				} else if (list1.toUpperCase().include("MODULE")) {
					grpModules.grpModules.push({"moduleId"   : o.down("input", 0).value,
												"moduleDesc" : o.down("label", 0).innerHTML,
												"tranCd" 	 : tranCd,
												"userGrp" 	 : $F("userGrp")
											   });
				} else if (list1.toUpperCase().include("SOURCE")) {
					grpIssSources.grpIssSources.push({"issCd"   : o.down("input", 0).value,
						  							  "issName" : o.down("label", 0).innerHTML,
						  							  "tranCd" 	: tranCd,
						  							  "userGrp" : $F("userGrp")
				   		 							 });
				} else if (list1.toUpperCase().include("LINE")) {
					var i = o.parentNode.childNodes.length - 1;
					curLines.curLines.push({"lineCd"   : /* o.down("input", 0).value */ o.parentNode.childNodes[i].childNodes[0].value,
											"lineName" : /* o.down("label", 0).innerHTML */ o.parentNode.childNodes[i].childNodes[1].innerHTML,
											"tranCd"   : tranCd,
											"userGrp"  : $F("userGrp"),
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
		
		sortList(list2);
	}
}