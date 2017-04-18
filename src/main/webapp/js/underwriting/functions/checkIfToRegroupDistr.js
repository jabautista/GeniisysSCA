/**
 * Check if the regrouping process will destroy the sequential ordering
 * of the group numbers.  If yes, regrouping fails.
 * @param tableGrid
 * 
 */

function checkIfToRegroupDistr(tableGrid){
	var checkedItems = tableGrid.getModifiedRows();
	var objArray = tableGrid.geniisysRows;
	var regroupSw = true;
	
	function showDistrErrorMsg(){
		showMessageBox('The selected record(s) cannot be grouped into one   ' +
 	   	       		   'as such will violate the sequential ordering of the ' +
                       'group numbers.  Please try another set of records. ', imgMessage.ERROR);
	}
	
	if(checkIfSingleRecExists(objArray)){
		regroupSw = false;
		tableGrid.modifiedRows = [];
		return false;
	}
	
	for(var i=0; i<checkedItems.length; i++){
		var groupNo = checkedItems[i].distSeqNo;
		if(checkedItems[i].groupTag == true){
			//if(countItemsPerGroup(objArray, groupNo) == 1){ // modified by jhing for batch soln to FULLWEB SIT SR0003785, SR0003784, SR0003783, SR0003721, SR0003712, SR0003451, SR0003720, SR0002871
			if(countItemsPerGroup2(tableGrid, groupNo) == 1){	// jhing 12.05.2014 new code 			
				regroupSw = false;
				showDistrErrorMsg();
				tableGrid.modifiedRows = [];
				//added by jhing 12.05.2014 
				newGroupTag = 0 ; 
				joinGroupTag = 0 ; 
				changedCheckedTag = 0 ;  
				return false;
		//	}else if(countItemsPerGroup(objArray, groupNo) == countItemsPerGroup(checkedItems, groupNo)){ // commented by jhing 12.05.2014 for batch soln to FULLWEB SIT SR0003785, SR0003784, SR0003783, SR0003721, SR0003712, SR0003451, SR0003720, SR0002871
			}else if(countItemsPerGroup2(tableGrid, groupNo) == countItemsPerGroup(checkedItems, groupNo)){ // jhing 12.05.2014 new code 
				regroupSw = false;
				showDistrErrorMsg();
				tableGrid.modifiedRows = [];
				// added by jhing 12.05.2014 
				newGroupTag = 0 ; 
				joinGroupTag = 0 ; 
				changedCheckedTag = 0 ; 
				return false;
			}
		}
	}
	return regroupSw;
}