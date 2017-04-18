function saveMarineCargoItems(refresh){	
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
			
			var executeSave = false;
			var objParameters = new Object();			
			
			objParameters = setCommonRecordsToObjParams(objParameters);
			
			objParameters.setCarrierRows	= getAddedAndModifiedJSONObjects(objGIPIWCargoCarrier);
			objParameters.delCarrierRows	= getDeletedJSONObjects(objGIPIWCargoCarrier);
			objParameters.delVesAccumuRows	= getAddedAndModifiedJSONObjects(objGIPIWVesAccumulation);
			objParameters.setMortgagees		= getAddedAndModifiedJSONObjects(objMortgagees);
			objParameters.delMortgagees		= getDeletedJSONObjects(objMortgagees);
	
			for(attr in objParameters){
				if(objParameters[attr].length > 0){								
					executeSave = true;
					break;
				}
			}
	
			if(executeSave){
				if(($$("div#itemTable .selectedRow")).length > 0){
					fireEvent(($$("div#itemTable .selectedRow"))[0], "click");
				}									
				
				objParameters = setCommonRecordsInObjToJson(objParameters);
				
				objParameters.setCarrierRows	= prepareJsonAsParameter(objParameters.setCarrierRows);
				objParameters.delCarrierRows	= prepareJsonAsParameter(objParameters.delCarrierRows);
				objParameters.delVesAccumuRows	= prepareJsonAsParameter(objParameters.delVesAccumuRows);
				objParameters.setMortgagees		= prepareJsonAsParameter(objParameters.setMortgagees);
				objParameters.delMortgagees		= prepareJsonAsParameter(objParameters.delMortgagees);
				objParameters.gipiWPolbas	= objGIPIWPolbas;
	
				objParameters.parId			= (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
				objParameters.lineCd		= (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"));
				objParameters.sublineCd		= (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd"));
				objParameters.parType		= (objUWGlobal.packParId != null ? objCurrPackPar.parType : /*$F("globalParType")*/ objUWParList.parType);
				
				//to include Peril Miscellaneous Fields
				objParameters = includePerilParamsForSaving(objParameters);
				
				new Ajax.Request(contextPath + "/GIPIWCargoController?action=saveParMNItems", {
					method : "POST",
					parameters : {
						parameters : JSON.stringify(objParameters)
					},
					asynchronous: false,
					evalScripts: true,
					onCreate : function(){
						showNotice("Saving Marine Cargo Items, please wait ...");
					},
					onComplete : function(response){
						hideNotice();
						if(checkCustomErrorOnResponse(response)){
							if(response.responseText != "SUCCESS"){
								if(response.responseText.include("ORA-20001")){
									//showWaitingMessageBox(response.responseText, imgMessage.ERROR, showItemInfo);
									showWaitingMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR, showItemInfo);
									//added by reymon 03212013 to validate tsi or prem
								}else if (response.responseText.include("ORA-20438")) {
									showMessageBox("Package total sum insured amount exceeds to 999,999,999,99,999.99.", "E");
								}else if (response.responseText.include("ORA-20439")) {
									showMessageBox("Package total premium amount exceeds to 9,999,999,999.99.", "E");
								}else{
									showMessageBox(response.responseText, imgMessage.ERROR);
								}
							}else{
								clearObjectRecordStatus2(objGIPIWItem);
								clearObjectRecordStatus2(objGIPIWCargoCarrier);
								clearObjectRecordStatus2(objGIPIWVesAccumulation);
								clearObjectRecordStatus2(objDeductibles);								
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
		showErrorMessage("saveMarineCargoItems", e);
	}
}