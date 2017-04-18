function deleteUpload(uploadMode){
	var id = getGenericId(uploadMode);
	var itemNo = $("itemNo") ? $F("itemNo") :$F("txtItemNo");
	new Ajax.Request("FileController?action=deleteUpload&genericId="+id+"&itemNo="+itemNo, {
		method: "POST",
		postBody: fixTildeProblem(Form.serialize("filesForm").replace(/"/g, "\""))
	});
}