function deleteJSONObject(obj) {
	try {
		var itemNo = (obj != null ? obj.itemNo : $F("itemNo"));
		$$("div#itemTable div[name='row']").each(function(row){		
			//if (row.hasClassName("selectedRow") || row.down("label", 0).innerHTML == itemNo) {
			if (row.getAttribute("item") == itemNo) { // andrew - 11.08.2010 - remove the hasClassName("selectedRow") condition. Causing deletion even if not selected in add/delete item 
				Effect.Fade(row, {
					duration: .2,
					afterFinish: function () {
						var delObj = (obj != null ? obj : setEndtItemObj());
						itemNo = $F("itemNo");	// mark jm 10.05.2010 added this line to get the itemNo for cascade delete
						addDeletedJSONObject(getItemObjects(), delObj);	// mark jm 10.05.2010 replaced objEndtMNItems to getItemObjects	
						row.remove();
						if (objUWParList.lineCd == objLineCds.MH){ //conditions added by BJGA / line differences
							deletePolicyDedObj();
							updateDeleteDiscountVariables();
						} else {
							cascadeDeleteOnSubPages(itemNo);	// mark jm 10.05.2010 added for deleting child records	
						}
						setItemForm(null);				
						checkIfToResizeTable("parItemTableContainer", "row");
						checkTableIfEmpty("row", "itemTable");
					}
				});
			}
		});
	} catch (e) {
		showErrorMessage("deleteJSONObject", e);
	}
}