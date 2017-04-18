/**
 * Updates the distSeqNo of the tableGrid rows that has 
 * been selected upon satisfying condition for joining of items.  
 * @param tableGrid - the tableGrid to be updated
 * 
 */

function joinDistrGroups_2 (tableGrid, group){

	if (checkIfJoiningGroupsAllowed_2(tableGrid, group)){
		var items = tableGrid.getModifiedRows();
		var objArray = tableGrid.geniisysRows;
		
		for(var i=0; i<items.length; i++){
			if(items[i].groupTag == true){
				tableGrid.setValueAt(group, tableGrid.getColumnIndex('distSeqNo'), items[i].divCtrId, true);
				$("mtgIC"+tableGrid._mtgId+"_"+tableGrid.getColumnIndex('distSeqNo')+","+items[i].divCtrId).removeClassName('modifiedCell');
				objArray[items[i].divCtrId].distSeqNo = group;
				objArray[items[i].divCtrId].recordStatus = 1;
			}
			joinGroupTag = 1 ; // added by jhing 12.05.2014 
		}
		tableGrid.modifiedRows = [];
	}
	uncheckTableGridCheckboxes(tableGrid, "groupTag");
	disableButton("btnNewGrp");
	disableButton("btnJoinGrp");

}