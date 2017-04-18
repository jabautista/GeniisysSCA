function checkMediaUploadedSize() {
	var ctr = 0;
	var selectedItem = getSelectedRowId("itemRow");
	
	$$("div[name='rowMedia']").each(function(row) {
		if(row.getAttribute("itemNo") == selectedItem){
			ctr++;
		}
	});
	
	if (ctr > 3) {
		$("mediaUploaded").setStyle("height: 210px; overflow-y: auto;");
	} else {
		$("mediaUploaded").setStyle("height: " + (parseInt(ctr) * 68) + "px;");
	}
}