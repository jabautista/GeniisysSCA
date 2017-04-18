function getParamsToPrint(isSelectedAll, allRowsToPrint, rowsToPrint) {
	var hasZero = false;
	var myRows = isSelectedAll ? allRowsToPrint : rowsToPrint;

	for ( var y = 0; y < myRows.length; y++) {
		if (((myRows[y].incTag == "Y" || myRows[y].incTag3 == "Y") && parseFloat(myRows[y].balanceAmtDue) == parseFloat(0))
				|| (myRows[y].incTag2 == "Y" && parseFloat(myRows[y].agingBalAmtDue) == parseFloat(0))) {
			showMessageBox("Printing of SOA with Balance Amount Due equal to zero not allowed.", "I");
			hasZero = true;
			break;
		} else if ((myRows[y].incTag == "Y" || myRows[y].incTag3 == "Y")
				&& parseFloat(myRows[y].balanceAmtDue) != parseFloat(0)
				|| (myRows[y].incTag2 == "Y" && parseFloat(myRows[y].agingBalAmtDue) != parseFloat(0))) {
			if (isSelectedAll) {
				allRowsToPrint[y].recordStatus = 1;
			} else {
				rowsToPrint[y].recordStatus = 1;
			}
		}
	}

	if (hasZero) { // rollback to recordStatus = null
		for ( var y = 0; y < myRows.length; y++) {
			if (isSelectedAll) {
				allRowsToPrint[y].recordStatus = null;
			} else {
				rowsToPrint[y].recordStatus = null;
			}
		}
	} else {
		var objParams = new Object();
		objParams.setRows = isSelectedAll ? getModifiedJSONObjects(allRowsToPrint)
				: getModifiedJSONObjects(rowsToPrint);
		var intmNoList = "#";
		var assdNoList = "#";
		var agingIdList = "#";
		// var agingId = "";
		for ( var i = 0; i < objParams.setRows.length; i++) {
			if (objSOA.prevParams.fromButton == "listAll" || objSOA.prevParams.fromButton == "printCollectionLetter") {
				if (objSOA.prevParams.viewType == "A") {
					assdNoList += (objParams.setRows[i].assdNo == null ? "" : objParams.setRows[i].assdNo) + "#";
				} else {
					intmNoList += (objParams.setRows[i].intmNo == null ? "" : objParams.setRows[i].intmNo) + "#";
				}
			} else if (objSOA.prevParams.fromButton == "listAllAging" || objSOA.prevParams.fromButton == "printCollectionLetterAging") {
				if (objParams.setRows[i].agingId != null && agingIdList.search(objParams.setRows[i].agingId) == -1) { // for distinct aging_id
					agingIdList += (objParams.setRows[i].agingId == null ? "" : objParams.setRows[i].agingId) + "#";
				}
				// agingId = objParams.setRows[i].agingId == null ? "" :
				// objParams.setRows[i].agingId;
			}
		}
		if (objSOA.prevParams.viewType == "A" && (objSOA.prevParams.fromButton == "listAll" || objSOA.prevParams.fromButton == "printCollectionLetter")) {
			objSOA.prevParams.assdNoList = assdNoList;
		} else if (objSOA.prevParams.viewType != "A" && (objSOA.prevParams.fromButton == "listAll" || objSOA.prevParams.fromButton == "printCollectionLetter")) {
			objSOA.prevParams.intmNoList = intmNoList;
		}
		if (objSOA.prevParams.fromButton == "listAllAging" || objSOA.prevParams.fromButton == "printCollectionLetterAging") {
			objSOA.prevParams.agingIdList = agingIdList;
		}
		// showMessageBox("assdNoList: "+objSOA.prevParams.assdNoList
		// +"\nintmNoList: "+objSOA.prevParams.intmNoList+"\nagingIdList:
		// "+objSOA.prevParams.agingIdList, "I");
	}
}