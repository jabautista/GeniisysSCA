// filter modules and issue sources by transaction selected
function filterModulesIssSourcesByTranCd() {
	var tranCd = getSelectedRowIdInTable("transactionSelect1", "row");
	var issCd = getSelectedRowIdInTable("issSourcesSelect1", "row");
	var userGrp = nvl($F("userGrpId"), $F("userGrp"));

	var newGrpIssSources = grpIssSources.grpIssSources.findAll(function (o) {
		if (tranCd == o.tranCd && userGrp == o.userGrp) {
			return o;
		}
	});
	
	var newGrpModules = grpModules.grpModules.findAll(function (o) {
		if (tranCd == o.tranCd && userGrp == o.userGrp) {
			return o;
		}
	});
	
	clearDiv("issSourcesSelect1");
	newGrpIssSources.each(function (o) {
		$("issSourcesSelect1").insert({bottom: '<div id="row'+o.issCd+'" name="row" tranCd="'+o.tranCd+'" userGrp="'+o.userGrp+'" class="smallTableRow"><input type="hidden" name="issCds" value="'+o.issCd+'" /><label>'+o.issName+'</label></div>'});
	});
	
	clearDiv("moduleSelect1");
	newGrpModules.each(function (m) {
		$("moduleSelect1").insert({bottom: '<div id="row'+m.moduleId+'" name="row" tranCd="'+m.tranCd+'" userGrp="'+m.userGrp+'" class="smallTableRow"><input type="hidden" name="moduleIds" value="'+m.moduleId+'" /><label>'+m.moduleDesc+'</label></div>'});
	});
	
	clearDiv("lineSelect1");
	
	createIssTable();
	createModulesTable();
	createLinesTable();
}