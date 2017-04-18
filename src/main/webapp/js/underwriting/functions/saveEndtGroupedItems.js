function saveEndtGroupedItems(){
	var objParameters = new Object();
	var executeSave = false;

	objParameters.setItemRows		= getAddedAndModifiedJSONObjects(objGIPIWItem);
	objParameters.setGroupedItems 	= getAddedAndModifiedJSONObjects(objGIPIWGroupedItems);
	objParameters.delGroupedItems 	= getDeletedJSONObjects(objGIPIWGroupedItems);
	objParameters.setCoverages		= getAddedAndModifiedJSONObjects(objGIPIWItmperlGrouped);
	objParameters.delCoverages		= getDeletedJSONObjects(objGIPIWItmperlGrouped);
	objParameters.setBeneficiaries 	= getAddedAndModifiedJSONObjects(objGIPIWGrpItemsBeneficiary);		
	objParameters.delBeneficiaries 	= getDeletedJSONObjects(objGIPIWGrpItemsBeneficiary);	
	objParameters.setBenPerils 		= getAddedAndModifiedJSONObjects(objGIPIWItmperlBeneficiary);		
	objParameters.delBenPerils 		= getDeletedJSONObjects(objGIPIWItmperlBeneficiary);
	for(attr in objParameters){
		if(objParameters[attr].length > 0){
			executeSave = true;
		}	
	}
	
	if(executeSave){
		objFormVariables.varNegateItem = null;
		objFormMiscVariables.confirmAction1 = 0;
		objFormMiscVariables.confirmAction2 = 0;
		
		//var temp = new Array();
		//objParameters.newItemNos	= prepareJsonAsParameter((objFormMiscVariables.miscChangedItems== null ? temp : objFormMiscVariables.miscChangedItems));
		//objParameters.oldItemNos	= prepareJsonAsParameter(objFormMiscVariables.miscRenumberedItems==null ? temp :
		//								objFormMiscVariables.miscRenumberedItems);
		
		//objFormMiscVariables.miscChangedItems = null;
		//objFormMiscVariables.miscRenumberedItems = null;
		
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
		//objParameters = includePerilParamsForSaving(objParameters);
		
		new Ajax.Request(contextPath + "/GIPIWAccidentItemController?action=saveEndtACGroupedItemsModal", {
			method : "POST",
			parameters : {
				parameters : JSON.stringify(objParameters),
				globalParId: objParameters.parId
			},
			asynchronous: true,
			evalScripts: true,
			onCreate : 
				function(){
					showNotice("Saving Endt Accident Grouped Items, please wait...");
				},
			onComplete : 	
				function(response){					
					hideNotice();						
					//if(checkErrorOnResponse(response)){ commented out by reymon 03212013
						if(response.responseText != "SUCCESS"){
							//added by reymon 03212013 to validate tsi or prem
							if (response.responseText.include("ORA-20438")) {
								showMessageBox("Package total sum insured amount exceeds to 999,999,999,99,999.99.", "E");
							} else if (response.responseText.include("ORA-20439")) {
								showMessageBox("Package total premium amount exceeds to 9,999,999,999.99.", "E");
							} else{
								showMessageBox(response.responseText, imgMessage.ERROR);
							}
						}else{
							clearObjectRecordStatus2(objGIPIWGroupedItems);
							clearObjectRecordStatus2(objGIPIWItmperlGrouped);
							clearObjectRecordStatus2(objGIPIWGrpItemsBeneficiary);
							clearObjectRecordStatus2(objGIPIWItmperlBeneficiary);
							changeTag = 0;
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, 
								function(){	
									//overlayAccidentGroup.close();
									$("btnCancelGrp").click();
									showItemInfo();
								});								
							//updateParParameters();	
						}
					//}						
				}
		});
	}else{				
		showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
	}	
}