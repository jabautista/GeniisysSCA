//created by: Jerome Orio
//to remove all rows within the table
//parameter: tableId = id of the table
//			 rowName = row name within the table
//			 attr    = attribute name needed to compare with the pkValue
//			 pkValue = primary key value	
function removeAllRowInTable(tableId,rowName,attr,pkValue){
	$$("div#"+tableId+" div[name='"+rowName+"']").each(function (a)	{
		if (a.getAttribute(attr) == pkValue){
			a.remove();
		}	
	});
}