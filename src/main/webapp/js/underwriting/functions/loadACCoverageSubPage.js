// == grouped items coverage ==
function loadACCoverageSubPage(objArr, grpItemNo) {
	try {
		var listingTable = $("coverageListing");
		objArr = objArr.filter(function(obj) {return nvl(obj.recordStatues, 0) != -1 && obj.groupedItemNo == grpItemNo;});
		for(var i=0; i<objArr.length; i++) {
		//	if(objArr[i].groupedItemNo == grpItemNo && objArr[i] != null) {
				var content = prepareGrpCoverageInfo(objArr[i]);
				var newDiv = new Element("div");
				newDiv.setAttribute("id", "cvgRow"+objArr[i].itemNo+objArr[i].groupedItemNo);
				newDiv.setAttribute("name", "cvgRow");
				newDiv.setAttribute("item", objArr[i].itemNo);
				newDiv.setAttribute("grpItemNo", objArr[i].groupedItemNo);
				newDiv.addClassName("tableRow");

				newDiv.update(content);
				listingTable.insert({bottom:newDiv});
				loadRowMouseOverMouseOutObserver(newDiv);	

				clickGrpCover(objArr[i], newDiv);
		//	}
		}
		checkIfToResizeTable("coverageListing", "cvgRow");
		checkTableIfEmpty("cvgRow", "coverageTable");
	} catch(e) {
		showErrorMessage("loadACCoverageSubPage", e);
	}
}