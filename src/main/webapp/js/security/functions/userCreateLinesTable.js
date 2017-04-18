function userCreateLinesTable() {
	clearDiv("lineSelect");
	var ids = $$("div#lineSelect1 div[name='row']").pluck("id");
	
	userLines.userLines.each(function (l) {
		if (!ids.include("row"+l.lineCd)) {
			$("lineSelect").insert({bottom: '<div id="row'+l.lineCd+'" name="row" class="smallTableRow"><input type="hidden" name="lineCds" value="'+l.lineCd+'" /><label>'+l.lineName+'</label></div>'});
		}
	});
	
	initializeTable("lineDiv", "row", "", "");
	initializeTable("lineDiv1", "row", "", "");
}