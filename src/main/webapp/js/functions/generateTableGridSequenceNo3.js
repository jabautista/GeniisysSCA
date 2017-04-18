/*
 * Created by	: Jerome Orio
 * Date			: December 14, 2010
 * Description 	: Generate sequence number for a particular property including all new rows and deleted rows
 * Parameters	: tableGrid - Your tableGrid
 * 				: propertyName - name of property/column id on your table grid
 * 				: columnCondition - column name for condition
 * 				: columnValue - column value of columnCondition
 */
function generateTableGridSequenceNo3(tableGrid, propertyName, columnCondition, columnValue, maxSeqFromDb){
	var newRowsAdded = tableGrid.getNewRowsAdded();
	var rows = tableGrid.rows;
	var nos = "";
	for(var a=0; a<newRowsAdded.length; a++){
		if (newRowsAdded[a][columnCondition] == columnValue){
			nos = nos+newRowsAdded[a][propertyName]+" ";
		}
	}
	for(var a=0; a<rows.length; a++){
		if (rows[a][tableGrid.getColumnIndex(columnCondition)] == columnValue){
			if ($("mtgRow"+tableGrid._mtgId+"_"+a).getStyle('display') != 'none'){
				nos = nos+rows[a][tableGrid.getColumnIndex(propertyName)]+" ";
			}
		}
	}

	nos = nos+maxSeqFromDb;
	
	var itemNos = nos.trim().split(" ");		
	for(var index=0, len = itemNos.length; index < len; index++){
		for(var elem=0; elem < len; elem++){
			var temp = 0;
			if(parseInt(itemNos[elem]) > parseInt(itemNos[elem+1])){
				temp = itemNos[elem];
				itemNos[elem] = itemNos[elem+1];
				itemNos[elem+1] = temp;
			}
		}			
	}		
	var seq = parseInt(itemNos.last())+1;
	return (isNaN(seq)?1:seq);
}