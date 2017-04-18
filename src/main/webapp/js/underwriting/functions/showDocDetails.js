function showDocDetails(){
	$("selectedDocName").value = row.down("input", 3).value;
	$("selectedUserId").value = row.down("input", 4).value;
	$("selectedLastUpdate").value = row.down("input", 5).value;
	$("selectedRemarks").value = row.down("input", 6).value;
}