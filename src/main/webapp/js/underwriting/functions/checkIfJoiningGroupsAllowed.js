/**
 * Check if the process of joining groups  will destroy the sequential 
 * ordering of the group numbers.  If yes, regrouping fails.
 * @param tableGrid
 * 
 */

function checkIfJoiningGroupsAllowed(tableGrid, selectedGrp){ 
	var checkedItems = tableGrid.getModifiedRows();
	var objArray = tableGrid.geniisysRows;
	var lastGrpNo = getLastGrpNo(objArray);
	var joinSw = true;
	
	function showDistrErrorMsg(){
		showMessageBox('The selected record(s) cannot be grouped into one   ' +
 	   	       		   'as such will violate the sequential ordering of the ' +
                       'group numbers.  Please try another set of records. ', imgMessage.ERROR);
	}
	
	if(checkIfSingleRecExists(objArray)){
		regroupSw = false;
		tableGrid.modifiedRows = [];
		changedCheckedTag = 0 ; // added by jhing 12.05.2014 
		return false;
	}
	
	for(var i=0; i<checkedItems.length; i++){
		var groupNo = checkedItems[i].distSeqNo;
		if(checkedItems[i].groupTag == true){
			if(groupNo != selectedGrp && groupNo != lastGrpNo){
				if(countItemsPerGroup(objArray, groupNo) == 1){
					joinSw = false;
					showDistrErrorMsg();
					tableGrid.modifiedRows = [];
					changedCheckedTag = 0 ; // added by jhing 12.05.2014 
					return false;
				}else if(countItemsPerGroup(objArray, groupNo) == countItemsPerGroup(checkedItems, groupNo)){
					joinSw = false;
					showDistrErrorMsg();
					tableGrid.modifiedRows = [];
					changedCheckedTag = 0 ; // added by jhing 12.05.2014 
					return false;
				}
			}
		}
	}
	return joinSw;
}