function userRemoveCurrentLinesFromAvailable() {
	var tranCd = getSelectedRowIdInTable("transactionSelect1", "row");
	var issCd = getSelectedRowIdInTable("issSourcesSelect1", "row");

	var newCurUserLines = curUserLines.curUserLines.findAll(function (o) {
		if (tranCd == o.tranCd && issCd == o.issCd) {
			return o;
		}
	});
	
	clearDiv("lineSelect1");
	newCurUserLines.each(function (l) {
		$("lineSelect1").insert({bottom: '<div id="row'+l.lineCd+'" tranCd="'+l.tranCd+'" userId="'+l.userID+'" issCd="'+l.issCd+'" name="row" class="smallTableRow"><input type="hidden" name="lineCds" value="'+l.lineCd+'" /><label>'+l.lineName+'</label></div>'});
	});
	
	userCreateLinesTable();
}