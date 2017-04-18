function checkIfGiuwPolicydsRecordsExist(objArray){
	var isExist = true;
	
	for(var i=0; i<objArray.length; i++){
		if(nvl(objArray[i].giuwWpolicydsExist, "Y") == "N" || nvl(objArray[i].giuwWpolicydsDtlExist, "Y") == "N"){
			showMessageBox('There was an error encountered in distribution records, '+
	  	                    'to correct this error please recreate using ' +
	  	                    'Set-Up Groups For Distribution(Item).','I');
			isExist = false;
			break;
		}
	}
	return isExist;
}