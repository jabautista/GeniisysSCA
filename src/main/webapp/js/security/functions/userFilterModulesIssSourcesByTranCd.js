// filter modules and issue sources by transaction selected
function userFilterModulesIssSourcesByTranCd() {
	var tranCd = getSelectedRowIdInTable("transactionSelect1", "row");
	var issCd = getSelectedRowIdInTable("issSourcesSelect1", "row");
	var userId = $F("userId");

	var newCurUserIssSources = curUserIssSources.curUserIssSources.findAll(function (o) {
		if (tranCd == o.tranCd && userId == o.userID) {
			return o;
		}
	});
	
	var newCurUserModules = curUserModules.curUserModules.findAll(function (o) {
		if (tranCd == o.tranCd && userId == o.userID) {
			return o;
		}
	});
	
	clearDiv("issSourcesSelect1");
	newCurUserIssSources.each(function (o) {
		$("issSourcesSelect1").insert({bottom: '<div id="row'+o.issCd+'" name="row" tranCd="'+o.tranCd+'" userId="'+o.userID+'" class="smallTableRow"><input type="hidden" name="issCds" value="'+o.issCd+'" /><label>'+o.issName+'</label></div>'});
	});
	
	clearDiv("moduleSelect1");
	newCurUserModules.each(function (m) {
		$("moduleSelect1").insert({bottom: '<div id="row'+m.moduleId+'" name="row" tranCd="'+m.tranCd+'" userId="'+m.userID+'" class="smallTableRow"><input type="hidden" name="moduleIds" value="'+m.moduleId+'" /><label>'+m.moduleDesc+'</label></div>'});
	});
	
	clearDiv("lineSelect1");
	
	userCreateIssTable();
	userCreateModulesTable();
	userCreateLinesTable();
}