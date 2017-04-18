//created by: Jerome Orio
//to count all rows within the table
//parameter: tableId = id of the table
//			 rowName = row name within the table
//			 attr    = attribute name needed to compare with the pkValue
//			 pkValue = primary key value	
function getRowCountInTable(tableId,rowName,attr,pkValue){
	var rowCount = 0;
	$$("div#"+tableId+" div[name='"+rowName+"']").each(function(row){						
		if (row.getAttribute(attr) == pkValue){
			rowCount++;
		}	
	});
	return rowCount;
}