/**
 * Shows Table Maintenance Claim Payee page
 * Module: GICLS150 - Table Maintenance Claim Payee 
 * @author Fons Ellarina 
 * @date 04.24.2013
 */
function showMenuClaimPayeeClass(payeeClassCd, classDesc){
	try{		
		new Ajax.Request(contextPath + "/GICLClaimTableMaintenanceController", {
			evalScript : true,
		    parameters : {action : "showMenuClaimPayeeClass",			    			
    			  dateAsOf: getCurrentDate(),
    			  payeeClassCd: payeeClassCd,
		  	      classDesc: classDesc},
		    onCreate : showNotice("Loading, please wait..."),
			onComplete : function(response){
				hideNotice();
				try {
					if(checkErrorOnResponse(response)){
						if(objCLMGlobal.callingForm == "GICLS014"){ // Added by J. Diago 10.16.2013 : Call Claim Payee Maintenance from Motor Item Info.
							Windows.close("modal_dialog_mcTpDtl");
							$("motorcarItemInfoMainDiv").style.display = "none";
							$("motorcarItemInfoTempDiv").style.display = null;
							$("motorcarItemInfoTempDiv").update(response.responseText);
						}else if(objCLMGlobal.callingForm == "GICLS025"){ //Gzelle 11.26.2013 = "GICLS025"){ //marco - added condition - 10.17.2013
							if(nvl($("recoveryInfoDiv"), null) == null){
								$("claimInfoDiv").down('div', 0).hide();
								$("basicInformationMainDiv").update(response.responseText);
							}else{
								$("lossRecoveryListingMainDiv").hide();
								$("recoveryInfoDiv").update(response.responseText);
							}
						} else if(objCLMGlobal.callingForm == "GICLS140"){
							$("claimPayeeDiv").update(response.responseText);
						}else if(objCLMGlobal.callingForm == "GIACS039"){ //Added by Steven 09.22.2014
							$("dummyClaimPayeeDiv").update(response.responseText);
						} else if(objCLMGlobal.callingForm == "GICLS030"){
							 $("claimInfoDiv").down('div', 0).hide();
							 $("lossExpenseHistMainDiv").update(response.responseText);
						}else {
							$("dynamicDiv").update(response.responseText);
						}
					}
				} catch(e){
					showErrorMessage("showMenuClaimPayee - onComplete : ", e);
				}								
			} 
		});
	}catch(e){
		showErrorMessage("showMenuClaimPayeeClass : ", e); 
	}	
}