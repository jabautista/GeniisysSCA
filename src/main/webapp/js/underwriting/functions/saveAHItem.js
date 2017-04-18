function saveAHItem(refresh) {
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

			objParameters.setBeneficiaries 	= getAddedAndModifiedJSONObjects(objBeneficiaries);
			objParameters.delBeneficiaries 	= getDeletedJSONObjects(objBeneficiaries);
			objParameters.setGrpItmRows		= getAddedAndModifiedJSONObjects(objGIPIWGroupedItems);
			objParameters.delGrpItmRows		= getDeletedJSONObjects(objGIPIWGroupedItems);
			objParameters.setGrpItmBenRows	= getAddedAndModifiedJSONObjects(objGIPIWGrpItemsBeneficiary);
			objParameters.delGrpItmBenRows	= getDeletedJSONObjects(objGIPIWGrpItemsBeneficiary);
	
			for(attr in objParameters){
				if(objParameters[attr].length > 0){
					executeSave = true;
					break;
				}	
			}
	
			if(executeSave){
				var temp = new Array();
				objParameters.newItemNos	= prepareJsonAsParameter((objFormMiscVariables.miscChangedItems== null ? temp : objFormMiscVariables.miscChangedItems));
				objParameters.oldItemNos	= prepareJsonAsParameter(objFormMiscVariables.miscRenumberedItems==null ? temp : objFormMiscVariables.miscRenumberedItems);
				
				objFormMiscVariables.miscChangedItems = null;
				objFormMiscVariables.miscRenumberedItems = null;
				
				objParameters = setCommonRecordsInObjToJson(objParameters);

				objParameters.setBeneficiaries 	= prepareJsonAsParameter(objParameters.setBeneficiaries);
				objParameters.delBeneficiaries 	= prepareJsonAsParameter(objParameters.delBeneficiaries);
				objParameters.setGrpItmRows		= prepareJsonAsParameter(objParameters.setGrpItmRows);
				objParameters.delGrpItmRows		= prepareJsonAsParameter(objParameters.delGrpItmRows);
				objParameters.setGrpItmBenRows	= prepareJsonAsParameter(objParameters.setGrpItmBenRows);
				objParameters.delGrpItmBenRows	= prepareJsonAsParameter(objParameters.delGrpItmBenRows);
				
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
									//added by reymon 03212013 to validate tsi or prem
									} else if (response.responseText.include("ORA-20438")) {
										showMessageBox("Package total sum insured amount exceeds to 999,999,999,99,999.99.", "E");
									} else if (response.responseText.include("ORA-20439")) {
										showMessageBox("Package total premium amount exceeds to 9,999,999,999.99.", "E");
									} else{
										showMessageBox(response.responseText, imgMessage.ERROR);
									}
								}else{
									clearObjectRecordStatus2(objGIPIWItem);
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
	} catch(e) {
		showErrorMessage("saveAHItem", e);
	}
}