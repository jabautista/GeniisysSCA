function contValidationCheckForOverdue(result1){
	var daysOverDue = result1[0].daysOverDue;
	var tranType = result1[0].checkInstNoDtls.tranType;
	
	if(tranType == 2 || tranType == 4) {
		objAC.overdueStatusFlag = 'N';
		confirmOverdueOverride();
     	return;
	}
	
	if (objAC.checkPremAging == 'Y') {
	     if(parseFloat(daysOverDue) > parseFloat(objAC.checkBillDueDate)) {
            //var dueDays = parseFloat(daysOverDue) - parseFloat(objAC.checkBillDueDate);
	         objAC.collectionFlag = 'N';
	         objAC.instOverdue = 'Y';
        	 /*showConfirmBox("Premium Collection", "The bill, "+objAC.currentRecord.issCd+"-"
     				+objAC.currentRecord.premSeqNo+"-"+objAC.currentRecord.instNo
				+", is " + daysOverDue + " days overdue. Would you like to continue with the premium collection?", "Yes", "No", */
	         showConfirmBox("Premium Collection", "This bill is " + daysOverDue + " days overdue. Would you like to continue with the premium collection?", "Yes", "No", 
									function () {
        		 						if(objAC.overdueOverride == 1) {
        		 							objAC.overdueStatusFlag = 'N';
        		 							confirmOverdueOverride();
        		 						} else {
        		 							validateUserFunction('AO', 'GIACS007', 'overdue', result1);
        		 						}
	        		 					//}	
        		 					}, function () {
        		 						inValidateOverridePayt();
        		 					});
	     } else {
	    	 objAC.overdueStatusFlag = 'N';
	    	 confirmOverdueOverride();
	     }
	  
	} else {
		//showMessageBox('No data found in GIAC_PARAMETERS for parameter CHECK_PREMIUM_AGING.'); //marco - replaced - 01.14.2014
		confirmOverdueOverride();
	}

}