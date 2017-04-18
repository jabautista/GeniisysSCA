/*
 * Created by	: Jerome Orio
 * Date			: December 14, 2010
 * Description 	: Generate unique sequence number for a particular property including all new rows and deleted rows
 * Parameters	: tableGrid - Your tableGrid
 * 				: propertyName - name of property/column id on your table grid
 * 				: maxSeqFromDb - maximum sequence value that not included in current page
 */
function generateTableGridSequenceNo(tableGrid, propertyName, maxSeqFromDb){
	var newRowsAdded = tableGrid.getNewRowsAdded();
	var deletedRows = tableGrid.getDeletedRows();	
	var rows = tableGrid.rows;
	var nos = "";
	for(var a=0; a<rows.length; a++){
		if ($("mtgRow"+tableGrid._mtgId+"_"+a).getStyle('display') != 'none'){
			nos = nos+rows[a][tableGrid.getColumnIndex(propertyName)]+" ";
		}
	}

	for(var a=0; a<newRowsAdded.length; a++){
		nos = nos+newRowsAdded[a][propertyName]+" ";
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