//check the no of rows inside the container
//if it exceeds the desired number of rows, make the container scrollable
//parameters: 
//tableId: id of the container
//rowName: name of the row
//rowNos: number of rows desired
function resizeTableToRowNum(tableId, rowName, rowNos) {
	if ($$("div#"+tableId+" div[name='"+rowName+"']").size() >= rowNos) {
	  	$(tableId).setStyle("height: "+rowNos*28+"px; overflow-y: auto; width: 103%;");
	  	$(tableId).up("div", 0).setStyle("width: 95%;");
	 } else if ($$("div#"+tableId+" div[name='"+rowName+"']").size() == 0) {
	  	$(tableId).setStyle("height: 20px;");
	 } else {
	 	var tableHeight = $$("div[name='"+rowName+"']").size()*10;
	 	if(tableHeight == 0){
	 		tableHeight = 20;
	 	}
	 	$(tableId).setStyle("height: " + tableHeight +"px; overflow: hidden;");
	 	$(tableId).up("div", 0).setStyle("width: 98%;");
	}
}