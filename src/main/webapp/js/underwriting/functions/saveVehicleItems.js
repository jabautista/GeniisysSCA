function saveVehicleItems(refresh){
	try {
		if ("" == $F("txtPerilName")){
			clearChangeAttribute("addItemPerilContainerDiv");
			executeSave = false;
		}
		
		//if(itemTablegridSw == "Y"){
			if(!tsiAmtAndPerilValidationTG()){
				return;
			}
		/*}else{
			if(!tsiAmtAndPerilValidation()){
				return;
			}
		}*/		
		
		if($F("hidDiscountExists") == "N") objUWParList.discExists == "N";
		
		if(checkPendingRecordChanges()){
			if($$("div#itemInformationDiv [changed=changed]").length > 0){
				fireEvent($("btnAddItem"), "click");
				return false;			
			}
	
			var objParameters = new Object();
			var executeSave = false;			
			
			objParameters = setCommonRecordsToObjParams(objParameters);
			
			objParameters.setMortgagees	= getAddedAndModifiedJSONObjects(objMortgagees);
			objParameters.delMortgagees	= getDeletedJSONObjects(objMortgagees);
			objParameters.setAccRows	= getAddedAndModifiedJSONObjects(objGIPIWMcAcc);
			objParameters.delAccRows	= getDeletedJSONObjects(objGIPIWMcAcc);
			
			for(attr in objParameters){
				if(objParameters[attr].length > 0){																			
					executeSave = true;
					break;
				}	
			}
			if(executeSave){
				objParameters.vars			= prepareJsonAsParameter(objFormVariables);
				objParameters.pars			= prepareJsonAsParameter(objFormParameters);
				objParameters.misc			= prepareJsonAsParameter(objFormMiscVariables);
				//objParameters.itemNoList	= prepareJsonAsParameter(objItemNoList);
				objParameters.gipiWPolbas	= objGIPIWPolbas;
				
				objParameters.parId			= (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
				objParameters.lineCd		= (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"));
				objParameters.sublineCd		= (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd"));
				objParameters.parType		= (objUWGlobal.packParId != null ? objCurrPackPar.parType : /*$F("globalParType")*/ objUWParList.parType); // andrew - 05.05.2011 - added for endt
				
				//to include Peril Miscellaneous Fields BRY 02.08.2011
				objParameters = includePerilParamsForSaving(objParameters);	
				
				new Ajax.Request(contextPath + "/GIPIWVehicleController?action=saveParMCItems", {
					method : "POST",
					parameters : {
						parameters : JSON.stringify(objParameters)
					},
					asynchronous: false,
					evalScripts: true,
					onCreate : 
						function(){
							showNotice("Saving Motorcar Items, please wait...");
						},
					onComplete : 
						function(response){	
							hideNotice();
							if(checkCustomErrorOnResponse(response)){
								if(response.responseText != "SUCCESS"){
									if(response.responseText.include("ORA-20001")){
										//showWaitingMessageBox(response.responseText, imgMessage.ERROR, showItemInfo);
										showWaitingMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR, showItemInfo);
									//added by reymon 03212013 to validate tsi or prem
									} else if (response.responseText.include("ORA-20438")) {
										showMessageBox("Package total sum insured amount exceeds to 999,999,999,99,999.99.", "E");
									} else if (response.responseText.include("ORA-20439")) {
										showMessageBox("Package total premium amount exceeds to 9,999,999,999.99.", "E");
									}  else{
										showMessageBox(response.responseText, imgMessage.ERROR);
									}
								}else{
									clearObjectRecordStatus2(objGIPIWItem);
									clearObjectRecordStatus2(objDeductibles);
									clearObjectRecordStatus2(objMortgagees);
									clearObjectRecordStatus2(objGIPIWMcAcc);
									clearObjectRecordStatus2(objGIPIWItemPeril);
									clearObjectRecordStatus2(objGIPIWPolWC);
									changeTag = 0;	
	
									onSuccessfulSave();
								}
							}						
						}
				});
			}else{
				showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
			}
		}
	} catch(e){
		showErrorMessage("saveVehicleItems", e);
	}
}