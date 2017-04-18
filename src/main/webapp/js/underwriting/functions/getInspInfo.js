function getInspInfo(object){
	/*
	var selectedRow;
	$$("div[name='row']").each(function (row){
		if (row.hasClassName("selectedRow")){
			selectedRow = row;
		}
	});

	var selectedInspNo = selectedRow.down("label", 0).innerHTML;*/
	/*
	$("inspNo").value = selectedInspNo;
	$("inspector").value = selectedRow.down("label", 1).innerHTML;
	$("txtAssuredName").value = selectedRow.down("label", 2).innerHTML;
	*/
	/*
	$("inspNo").value = selectedInspNo;
	$("inspector").value = selectedRow.down("input", 6).value;
	$("txtAssuredName").value = selectedRow.down("input", 7).value;
	
	$("inspectorCd").value = selectedRow.down("input", 3).value;
	$("txtAssdNo").value = selectedRow.down("input", 4).value;
	$("txtIntmNo").value = selectedRow.down("input", 5).value;*/
	//var status = selectedRow.down("input", 2).value;
	var status = nvl(object.status, "N");
	if (status == "N"){ // modified by: Nica 06.20.2012 - enable inspection report only if the status is new
		$("approvedTag").checked = false;
		$("approvedTag").removeAttribute("disabled");
		$("itemNo2").readOnly = false;
		$("propertyDesc").readOnly = false;
		$("remarks").readOnly = false;
		enableButton("btnAddItem");
		//enableButton("btnDeleteItem");
		$('location', 'location2', 'location3', 'constRmrk', 'occRmrk', 'tsiAmt', 'premRt', 'bndrFrnt', 'left', 'right', 'rear').invoke('removeAttribute', 'readonly');
		$$("table#itemInfoFormTable select").each(function (select){
			select.removeAttribute("disabled");
		});
		enableDate("hrefDateInsp");
	} else {
		$("approvedTag").checked = true;
		$("approvedTag").setAttribute("disabled", "disabled");
		$("itemNo2").readOnly = true;
		$("propertyDesc").readOnly = true;
		$("remarks").readOnly = true;		
		disableButton("btnAddItem");
		disableButton("btnDeleteItem");
		$('location', 'location2', 'location3', 'constRmrk', 'occRmrk', 'tsiAmt', 'premRt', 'bndrFrnt', 'left', 'right', 'rear').invoke('setAttribute', 'readonly', 'readonly');
		$$("table#itemInfoFormTable select").each(function (select){
			select.setAttribute("disabled", "disabled");
		});
		disableDate("hrefDateInsp");
	}
	/*
	$("dateInspected").value = selectedRow.down("input", 1).value;
	$("txtIntmName").value = selectedRow.down("input", 8).value;*/
	
	$("inspNo").value = object.inspNo;
	$("inspector").value = unescapeHTML2(object.inspName);
	//$("txtAssuredName").value = object.assdName;
	$("assuredName").value = unescapeHTML2(object.assdName);
	
	$("inspectorCd").value = object.inspCd;
	//$("txtAssdNo").value = object.assdNo;
	$("assuredNo").value = object.assdNo;
	$("txtIntmNo").value = object.intmNo;
	//marco
	$("dateInspected").value = object.dateInsp == null ? dateFormat(new Date, "mm-dd-yyyy") : dateFormat(object.dateInsp, "mm-dd-yyyy"); //Object.dateInsp before - CC 08.23.2012
	$("txtIntmName").value = unescapeHTML2(object.intmName);
	
	$("approvedBy").value = nvl(object.approvedBy, "") == "" ? "" : object.approvedBy; 
	$("dateApproved").value = nvl(object.dateApproved, "") == "" ? "" : dateFormat(object.dateApproved, "mm-dd-yyyy");
	//added by steven 9.20.2013
	$("remarks").value = unescapeHTML2(object.remarks);
	
	getInspItemInformation(object.inspNo);
}