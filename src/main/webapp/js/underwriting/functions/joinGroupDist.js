//belle 09092011
function joinGroupDist(tableGrid){
	var objArray = [];
	var rows = tableGrid.geniisysRows;
	var checkedPeril = tableGrid.getModifiedRows();
	var currCd = checkedPeril.filter(function(obj){return obj.groupTag == true;})[0].currencyCd;
	var groupItemGrp = checkedPeril.filter(function(obj){return obj.groupTag == true;})[0].itemGrp;	// shan 08.06.2014
		
	for(var i=0; i<rows.length; i++){
		if (rows[i].currencyCd == currCd && rows[i].itemGrp == groupItemGrp){	// added itemGrp to show item groups with same bill group: shan 08.06.2014
			var distSeqNo = rows[i].distSeqNo;
			if (objArray.toString().indexOf(distSeqNo) == -1) objArray.push(distSeqNo);
		}
	}
	showDistrGrpLOV("GIUWS018-Join", "Join Group?", objArray.sort(), 340, tableGrid);
}