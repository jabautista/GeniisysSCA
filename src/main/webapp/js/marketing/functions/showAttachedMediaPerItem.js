function showAttachedMediaPerItem(){
	var selectedItem = getSelectedRowId("itemRow");
	
	if($("itemNo") != null && $("mediaItemNo") != null ){
		$("itemNo").value = selectedItem;
		$("mediaItemNo").value = selectedItem;
	}
	
	if($("btnUploadMedia") != null && $("btnUploadMedia") != null){
		enableButton("btnUploadMedia"); 				
		disableButton("btnDeleteMedia");
	}
	
	$$("div[name='rowMedia']").each(function(row) {
		row.hide();
		row.removeClassName("selectedRow");
		if(row.getAttribute("itemNo") == selectedItem){
			row.show();
		}
	});
	
	if($("mediaUploaded") != null){
		checkMediaUploadedSize();
	}
}