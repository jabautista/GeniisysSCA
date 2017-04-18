//belle 09062011
function includeToNewGrpDistr2(tableGrid){
	if(checkIfToRegroupDistr(tableGrid)){
		var items = tableGrid.getModifiedRows();
		var objArray = tableGrid.geniisysRows;
		//var maxDistSeqNo = getLastGrpNo2(objArray); // commented out by jhing 12.05.2014 
		var maxDistSeqNo = getLastGrpNo3(tableGrid); // jhing 12.05.2014 new code 
		var lastGrpNo = "";
		var nextGrpNo = "";
		for(var i=0; i<items.length; i++){
			if(items[i].groupTag == true){
				lastGrpNo = maxDistSeqNo;
				nextGrpNo = parseInt(lastGrpNo)+1;
				tableGrid.setValueAt(nextGrpNo, tableGrid.getColumnIndex('distSeqNo'), items[i].divCtrId, true);
				$("mtgIC"+tableGrid._mtgId+"_"+tableGrid.getColumnIndex('distSeqNo')+","+items[i].divCtrId).removeClassName('modifiedCell');
				objArray[items[i].divCtrId].distSeqNo = nextGrpNo;
				objArray[items[i].divCtrId].recordStatus = 1;
			}
			newGroupTag = 1; // added by jhing 12.05.2014 
		}
		tableGrid.modifiedRows = []; 
	}
	uncheckTableGridCheckboxes(tableGrid, "groupTag");
	disableButton("btnNewGrp");
	disableButton("btnJoinGrp");
}