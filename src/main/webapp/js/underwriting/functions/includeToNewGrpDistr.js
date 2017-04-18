/**
 * Updates the distSeqNo of the tableGrid rows that has 
 * been selected upon satisfying condition for regrouping.  
 * @param tableGrid - the tableGrid to be updated
 * 
 */

function includeToNewGrpDistr(tableGrid){
	if(checkIfToRegroupDistr(tableGrid)){
		var items = tableGrid.getModifiedRows();
		var objArray = tableGrid.geniisysRows;
		var nextGrpNo = getNextGrpNo(objArray);
		for(var i=0; i<items.length; i++){
			if(items[i].groupTag == true){
				tableGrid.setValueAt(nextGrpNo, tableGrid.getColumnIndex('distSeqNo'), items[i].divCtrId, true);
				$("mtgIC"+tableGrid._mtgId+"_"+tableGrid.getColumnIndex('distSeqNo')+","+items[i].divCtrId).removeClassName('modifiedCell');
				objArray[items[i].divCtrId].distSeqNo = nextGrpNo;
				objArray[items[i].divCtrId].recordStatus = 1;
			}
		}
		tableGrid.modifiedRows = [];
	}
	uncheckTableGridCheckboxes(tableGrid, "groupTag");
	disableButton("btnNewGrp");
	disableButton("btnJoinGrp");
}