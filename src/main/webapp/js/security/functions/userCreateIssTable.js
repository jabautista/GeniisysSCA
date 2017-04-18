function userCreateIssTable() {
	clearDiv("issSourcesSelect");
	var ids = $$("div#issSourcesSelect1 div[name='row']").pluck("id");
	userIssSources.userIssSources.each(function (o) {
		if (!ids.include("row"+o.issCd)) {
			$("issSourcesSelect").insert({bottom: '<div id="row'+o.issCd+'" name="row" class="smallTableRow"><input type="hidden" name="issCds" value="'+o.issCd+'" /><label>'+o.issName+'</label></div>'});
		}
	});
	
	initializeTable("issSourcesDiv", "row", "", "");
	initializeTable("issSourcesDiv1", "row", "", userRemoveCurrentLinesFromAvailable);
}