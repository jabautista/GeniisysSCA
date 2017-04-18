/**
 * Check if the process of joining groups  will destroy the sequential 
 * ordering of the group numbers.  If yes, regrouping fails.
 * @param tableGrid
 * 
 */

// created by jhing 12.05.2014 for batch soln to FULLWEB SIT SR0003785, SR0003784, SR0003783, SR0003721, SR0003712, SR0003451, SR0003720, SR0002871
function checkIfJoiningGroupsAllowed_2(tableGrid, selectedGrp){   
	var checkedItems = tableGrid.getModifiedRows();
	var objArray = tableGrid.geniisysRows;
	var joinSw = true;
	var selDistGrps = []; 
	var maxDistSeqNo ; 
	var errExists = 0 ;  

	function showDistrErrorMsg(){
		showMessageBox('The selected record(s) cannot be grouped into one   ' +
 	   	       		   'as such will violate the sequential ordering of the ' +
                       'group numbers.  Please try another set of records. ', imgMessage.ERROR);
	}
	
	
	for (var x = 0 ; x < checkedItems.length ; x++) {
		var distSeqNo = checkedItems[x].distSeqNo;
		if (selDistGrps.toString().indexOf(distSeqNo) == -1) {
			selDistGrps.push(distSeqNo);
		}
	}
	
	selDistGrps.sort(function(a, b){return b-a});  
	maxDistSeqNo = getLastGrpNo2(objArray) ; 
	for ( var j = 0 ; j < selDistGrps.length ; j++){
		var groupNo = selDistGrps[j] ;
		var cntTotalItemPerGrp = countItemsPerGroup2(tableGrid, groupNo) ;
		var cntModifiedRows =  countItemsPerGroup(checkedItems, groupNo) ; 
		
		if (cntTotalItemPerGrp  == cntModifiedRows ) {
			if (( selDistGrps[j] == maxDistSeqNo)  ) {
				if (maxDistSeqNo > 1 ) {
					maxDistSeqNo = maxDistSeqNo - 1 ; 	
				}
			} else {
				errExists = 1; 	
			}
		}	
		
		if (errExists == 1 ){
			break;
		}
	} 
	
	if ( maxDistSeqNo < selectedGrp ){
		errExists = 1; 	
	}
	if ( errExists == 1 ) {
		joinSw = false;
		showDistrErrorMsg();
		tableGrid.modifiedRows = [];
		changedCheckedTag = 0 ; // added by jhing 12.05.2014 
	}
	return joinSw;
}