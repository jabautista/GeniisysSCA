function saveEndtACItems(refresh){
	try {
		/*
		if ("" == $F("txtPerilName")){
			clearChangeAttribute("addItemPerilContainerDiv");
			executeSave = false;
		}
		
		if(!tsiAmtAndPerilValidation()){
			return;
		}
		
		if($F("hidDiscountExists") == "N") objUWParList.discExists == "N";
		*/
		if(checkPendingRecordChanges()){
			if($$("div#itemInformationDiv [changed=changed]").length > 0){
				fireEvent($("btnAddItem"), "click");
				return false;			
			}
			var objParameters = new Object();
			var executeSave = false;
	
			objParameters.setItemRows 	= getAddedAndModifiedJSONObjects(objGIPIWItem);
			objParameters.delItemRows 	= getDeletedJSONObjects(objGIPIWItem);
			objParameters.setDeductRows	= getAddedAndModifiedJSONObjects(objDeductibles);
			objParameters.delDeductRows	= getDeletedJSONObjects(objDeductibles);
			objParameters.setPerils 	= getAddedAndModifiedJSONObjects(objGIPIWItemPeril);		
			objParameters.delPerils 	= getDeletedJSONObjects(objGIPIWItemPeril);	
			objParameters.setWCs 		= getAddedAndModifiedJSONObjects(objGIPIWPolWC);
			
			objParameters.setGrpItmRows	= getAddedAndModifiedJSONObjects(objGIPIWGroupedItems);
			objParameters.delGrpItmRows	= getDeletedJSONObjects(objGIPIWGroupedItems);
			objParameters.setGrpItmBenRows	= getAddedAndModifiedJSONObjects(objGIPIWGrpItemsBeneficiary);
			objParameters.delGrpItmBenRows	= getDeletedJSONObjects(objGIPIWGrpItemsBeneficiary);
			
			objParameters.setBeneficiaries = getAddedAndModifiedJSONObjects(objBeneficiaries);
			objParameters.delBeneficiaries = getDeletedJSONObjects(objBeneficiaries);
	
			for(attr in objParameters){
				if(objParameters[attr].length > 0){
					executeSave = true;
				}	
			}
	
			if(executeSave){
				objFormVariables.varNegateItem = null;
				objFormMiscVariables.confirmAction1 = nvl(objFormMiscVariables.confirmAction1, 0);
				objFormMiscVariables.confirmAction2 = nvl(objFormMiscVariables.confirmAction2, 0);
				
				var temp = new Array();
				objParameters.newItemNos	= prepareJsonAsParameter((objFormMiscVariables.miscChangedItems== null ? temp : objFormMiscVariables.miscChangedItems));
				objParameters.oldItemNos	= prepareJsonAsParameter(objFormMiscVariables.miscRenumberedItems==null ? temp :
												objFormMiscVariables.miscRenumberedItems);
				
				objFormMiscVariables.miscChangedItems = null;
				objFormMiscVariables.miscRenumberedItems = null;
				
				objParameters.vars			= prepareJsonAsParameter(objFormVariables);
				objParameters.pars			= prepareJsonAsParameter(objFormParameters);
				objParameters.misc			= prepareJsonAsParameter(objFormMiscVariables);
				
				objParameters.gipiWPolbas	= objGIPIWPolbas;
				
				objParameters.parId			= (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
				objParameters.lineCd		= (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"));
				objParameters.sublineCd		= (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd"));
				objParameters.parType		= (objUWGlobal.packParId != null ? objCurrPackPar.parType : /*$F("globalParType")*/ objUWParList.parType);
				//return false;
				//objParameters = includePerilParamsForSaving(objParameters);	
				
				//to include Peril Miscellaneous Fields 
				objParameters = includePerilParamsForSaving(objParameters);
				
				new Ajax.Request(contextPath + "/GIPIWAccidentItemController?action=saveGIPIWAccidentInfo", {
					method : "POST",
					parameters : {
						parameters : JSON.stringify(objParameters),
						globalParId: objParameters.parId
					},
					asynchronous: false,
					evalScripts: true,
					onCreate : 
						function(){
							showNotice("Saving Accident Items, please wait...");
						},
					onComplete : 	
						function(response){					
							hideNotice();	
							if(checkCustomErrorOnResponse(response)){
								if(response.responseText != "SUCCESS"){
									if(response.responseText.include("ORA-20001")){
										//showWaitingMessageBox(response.responseText, imgMessage.ERROR, showItemInfo);
										showWaitingMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR, showItemInfo);
									} else if (response.responseText.include("ORA-20002")) {
										showConfirmBox("Stop", extractSqlExceptionMessage(response.responseText), 
												"Ok", "Cancel", function() {
													objFormMiscVariables.confirmAction1 = 0;
													objFormMiscVariables.confirmAction2 = 1;
													saveEndtACItems(refresh);
												}, "", "btnSave");
									} else if (response.responseText.include("ORA-20003")) {
										showConfirmBox("Stop", extractSqlExceptionMessage(response.responseText), 
												"Ok", "Cancel", function() {
													objFormMiscVariables.confirmAction1 = 1;
													objFormMiscVariables.confirmAction2 = 0;
													saveEndtACItems(refresh);
												}, "", "btnSave");
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
									clearObjectRecordStatus2(objGIPIWItemPeril);
									clearObjectRecordStatus2(objGIPIWPolWC);
									changeTag = 0;
									showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, refresh ? showItemInfo :function(){null;});
									updateParParameters();	
									if(objUWGlobal.packParId != null && objUWGlobal.packParId != undefined){ // andrew - 07.08.2011 - to update na package par parameters
										updatePackParParameters();
									}
								}
							}						
						}
				});
			}else{				
				showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
			}	
		}
	} catch(e) {
		showErrorMessage("saveEndtACItem", e);
	}
}