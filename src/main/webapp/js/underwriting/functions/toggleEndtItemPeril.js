//mrobes 07.8.10
//Shows the endt item peril of the selected item.
function toggleEndtItemPeril(itemNo, objEndtPerils, objPolPerils) {
	try {
		if($("perilCd") != null){
			$$("div[name='rowEndtPeril']").each(function(row){
				//if(row.down("input", 0).value == itemNo && $("row"+itemNo).hasClassName("selectedRow")){
				if(row.getAttribute("item") == itemNo && $("row"+itemNo).hasClassName("selectedRow")){
					row.removeClassName("selectedRow");
					row.show();			
				} else {
					row.hide();
				}
			});
			
			checkTableIfEmpty2("rowEndtPeril", "endtPerilTable");
			checkIfToResizeTable2("perilTableContainerDiv", "rowEndtPeril");
			setEndtItemAmounts(itemNo, objEndtPerils, objPolPerils);
			toggleEndtPerilDeductibles("", "");
		}
	} catch(e){
		showErrorMessage("toggleEndtItemPeril", e);
	}
}