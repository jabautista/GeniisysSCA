function loadGroupedBenPerils(objArr, grpItemNo, benNo) {
	try {
		var listingTable = $("acBenPerilListing");
		objArr = objArr.filter(function(obj) {return nvl(obj.recordStatus, 0) != -1 && obj.groupedItemNo == grpItemNo && obj.beneficiaryNo == benNo;});
		
		for(var i=0; i<objArr.length; i++) {
		//	if(grpItemNo == objArr[i].groupedItemNo && benNo == objArr[i].beneficiaryNo && objArr[i] != null) {
			var content = prepareGrpBenPeril(objArr[i]);
			var newDiv = new Element("div");
			var bpObj = objArr[i];
			newDiv.setAttribute("id", "benPerlRow"+objArr[i].groupedItemNo+objArr[i].beneficiaryNo);
			newDiv.setAttribute("name", "benPerlRow");
			newDiv.setAttribute("item", objArr[i].itemNo);
			newDiv.setAttribute("grpItemNo", objArr[i].groupedItemNo);
			newDiv.setAttribute("beneficiaryNo", objArr[i].beneficiaryNo);
			newDiv.addClassName("tableRow");
			
			newDiv.update(content);
			listingTable.insert({bottom:newDiv});
			loadRowMouseOverMouseOutObserver(newDiv);
			
			newDiv.observe("click", function() {
				newDiv.toggleClassName("selectedRow");
				if(newDiv.hasClassName("selectedRow")) {
					$$("div#acBenPerilListing div[name='benPerlRow']").each(function(bpr) {
						if(newDiv.getAttribute("id") != bpr.getAttribute("id")) {
							bpr.remove();
						}
					});
					setBenPerilForm(bpObj);
				} else {
					setBenPerilForm(null);
				}
			});
		//	}
		}
		checkIfToResizeTable("acBenPerilListing", "benPerlRow");
		checkTableIfEmpty("benPerlRow", "benPerilTable");
	} catch(e) {
		showErrorMessage("loadGroupedBenPerils", e);
	}
}