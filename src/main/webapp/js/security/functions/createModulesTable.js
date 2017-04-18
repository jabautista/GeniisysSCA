function createModulesTable() {
	var tranCd = getSelectedRowIdInTable("transactionSelect1", "row");
	var newTModules = tModules.tModules.findAll(function (o) {
		if (tranCd == o.tranCd) {
			return o;
		}
	});
	
	var ids = $$("div#moduleSelect1 div[name='row']").pluck("id");
	
	clearDiv("moduleSelect");
	newTModules.each(function (m) {
		if (!ids.include("row"+m.moduleId)) {
			$("moduleSelect").insert({bottom: '<div id="row'+m.moduleId+'" name="row" tranCd="'+m.tranCd+'" class="smallTableRow"><input type="hidden" name="moduleIds" value="'+m.moduleId+'" /><label>'+m.moduleDesc+'</label></div>'});
		}
	});
	
	/*tModules.tModules.each(function (m) {
		if (!ids.include("row"+m.moduleId)) {
			$("moduleSelect").insert({bottom: '<div id="row'+m.moduleId+'" name="row" class="smallTableRow" tranCd="'+m.tranCd+'"><input type="hidden" name="moduleIds" value="'+m.moduleId+'" /><label>'+m.moduleDesc+'</label></div>'});
		}
	});*/
	
	initializeTable("moduleDiv", "row", "", "");
	initializeTable("moduleDiv1", "row", "", "");
}