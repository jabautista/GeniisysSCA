function loadGroupedBen(objArr, grpItemNo) {
	try {
		var listingTable = $("gBeneficiaryListing");
		objArr = objArr.filter(function(obj) {return nvl(obj.recordStatus, 0) != -1 && obj.groupedItemNo == grpItemNo;});
		for(var i=0; i<objArr.length; i++) {
		//	if(grpItemNo != null && objArr[i].groupedItemNo == grpItemNo ) {
				var content = prepareGroupedBen(objArr[i]);
				var newDiv = new Element("div");
				newDiv.setAttribute("id", "gBenRow"+grpItemNo+objArr[i].beneficiaryNo);
				newDiv.setAttribute("name", "gBenRow");
				newDiv.setAttribute("item", objArr[i].itemNo);
				newDiv.setAttribute("grpItemNo", objArr[i].groupedItemNo);
				newDiv.addClassName("tableRow");
				newDiv.update(content);
				listingTable.insert({bottom:newDiv});
				loadRowMouseOverMouseOutObserver(newDiv);

				clickGrpBen(objArr[i], newDiv);
		//	}
		}
		checkIfToResizeTable("gBeneficiaryListing", "gBenRow");
		checkTableIfEmpty("gBenRow", "gBeneficiaryTable");
	} catch(e) {
		showErrorMessage("loadGroupedBen", e);
	}
}