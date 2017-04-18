/**
 * Updates Function Override Records
 * Module: GICLS183
 * @author Shan Krisne Bati
 * @param approveRecFlg - determines if there are records to be approve
 * 12.18.2012
 */

function updateFunctionOverride(approveRecFlg){
	try {
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		
		var objFunctions = approveRecFlg ? functionOverrideRecordsTableGrid.getModifiedRows() : getModifiedJSONObjects(functionOverrideRecordsTableGrid.geniisysRows);
		
		/*if (approveRecFlg){
			var modified = getModifiedJSONObjects(functionOverrideRecordsTableGrid.geniisysRows);
		}else if (approveRecFlg && !objGICLS183.remarksChanged){
			objFunctions = functionOverrideRecordsTableGrid.getModifiedRows();
		}else if (!approveRecFlg && objGICLS183.remarksChanged){
			objFunctions = getModifiedJSONObjects(functionOverrideRecordsTableGrid.geniisysRows);
		}*/
		
		new Ajax.Request(contextPath+"/GICLFunctionOverrideController",{
			method: "POST",
			parameters: {
				action: "updateGICLFunctionOverride",
				approveRecFlg: approveRecFlg,
				functions: prepareJsonAsParameter(objFunctions)
			},
			asynchronous: true,
			evalScripts: true,
			onCreate: showNotice("Updating functions, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if(response.responseText == "SUCCESS"){						
						changeTag = 0;
						objGICLS183.remarksChanged = false;
						
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							if (objGICLS183.exitPage != null){
								objGICLS183.exitPage();
								objGICLS183.exitPage = null;
							}else{
								functionOverrideRecordsTableGrid.url = contextPath+"/GICLFunctionOverrideController?action=getGICLS183FunctionOverrideRecordsListing"
																	+"&moduleId="+objCLM.hideGICLS183.moduleId+"&functionCd="+objCLM.hideGICLS183.functionCd;
								//if (approveRecFlg){
								//functionOverrideRecordsTableGrid.refreshURL(functionOverrideRecordsTableGrid);
								functionOverrideRecordsTableGrid._refreshList();
								//}
								
								functionOverrideRecordsTableGrid.onRemoveRowFocus();
								disableButton("btnApproveFunctOverride");
							}
						});
					};
				}
			}
			});
	}catch(e){
		showErrorMessage("updateFunctionOverride",e);
	}
}	