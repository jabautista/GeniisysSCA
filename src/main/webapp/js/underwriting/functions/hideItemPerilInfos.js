function hideItemPerilInfos(){
	$$("div[name='itemPerilMotherDiv']").each(function(i){i.hide();});
	$$("div[name='row2'").each(function(row){
		row.hide();
	});
	$("perilGroupExists").value = "N";
}