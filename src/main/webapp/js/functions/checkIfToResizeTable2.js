// andrew 06.29.2010
// resizes the table according to visible rows
// parameters: tableId - id of the div container
//			   rowName - name of the div used as row
function checkIfToResizeTable2(tableId, rowName) {
	var rowCount = 0;
	
	$$("div[name='"+rowName+"']").each(function(row){
		if(row.getStyle("display") != "none"){
			rowCount++;
		}
	});
	
    if (rowCount >= 5) {
     	$(tableId).setStyle("height: 155px; overflow-y: auto;");
    } else if (rowCount == 0) {
     	$(tableId).setStyle("height: 31px;");
    } else {
    	var tableHeight = rowCount*31;
    	if(tableHeight == 0){
    		tableHeight = 31;
    	}
    	$(tableId).setStyle("height: " + tableHeight +"px; overflow: hidden;"); 
	}   
}