//created by: Jerome Orio
//show only options not existing in a table row
//show also the option of the current option selected
//parameter: name of select list
//parameter: name of table row
//parameter: row no value
//parameter: value of current option you want to show (optional)
//filter with condition
function filterLOV(lovName,rowName,rowNo,currentCd,attr,pkValue){
	showListing($(lovName));
	$$("div[name='"+rowName+"']").each(function(row){
		if (row.getAttribute(attr) == pkValue){
			var cd = row.down("input", rowNo).value;
			for(var i = 1; i < $(lovName).options.length; i++){ 
				if (cd == $(lovName).options[i].value){
					$(lovName).options[i].hide();
					$(lovName).options[i].disabled = true;
				}
			}
		}
	});

	if (currentCd != ""){
		for(var i = 1; i < $(lovName).options.length; i++){ 
			if (currentCd == $(lovName).options[i].value){
				$(lovName).options[i].show();
				$(lovName).options[i].disabled = false;
			}
		}
	}
}