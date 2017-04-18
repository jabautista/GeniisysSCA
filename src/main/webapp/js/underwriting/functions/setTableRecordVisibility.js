//Set table record visibility
function setTableRecordVisibility(row, selectedItem, div, cd ){		
	var genericTable;
	var deleteDiv = new Element("div");
	var itemNo = row.getAttribute("item");
	var code = row.getAttribute(cd);		
	//var divName = "row" + itemNo + code;
	var divName = row.getAttribute("id");
	
	if(itemNo != selectedItem){			
		genericTable = $(div);
		deleteDiv.setAttribute("id", divName);				
		//genericTable.hide(deleteDiv);			
		$(row.getAttribute("id")).hide();			
	} else{
		genericTable = $(div);
		deleteDiv.setAttribute("id", divName);
		//genericTable.show(deleteDiv);
		$(row.getAttribute("id")).show();
	}
	//checkIfToResizeTable(div, row.getAttribute("name"));		
}