/*
 * Created by	: Jerome Orio
 * Date			: December 14, 2010
 * Description 	: Generate sequence number for a particular property based from the database max value(max value + 1)
 * Parameters	: tableGrid - Your tableGrid
 * 				: propertyName - name of property/column id on your table grid
 */
function generateTableGridSequenceNo2(tableGrid, propertyName){
	var rows = tableGrid.geniisysRows; //all existing rows on database
	var nos = "";
	for(var a=0; a<rows.length; a++){
		nos = nos+rows[a][propertyName]+" ";
	}

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