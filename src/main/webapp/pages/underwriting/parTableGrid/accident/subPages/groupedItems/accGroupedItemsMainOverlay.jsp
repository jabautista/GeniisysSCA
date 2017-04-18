<div class="sectionDiv" style="width: 874px;">
	<input type="hidden" id="isFromOverWriteBen" value="${isFromOverwriteBen}" />
	<input type="hidden" id="itemPerilExist" name="itemPerilExist" value="" />
	<input type="hidden" id="itemPerilGroupedExist" name="itemPerilGroupedExist" value="" />

	<div id="groupedItemsDetail">
		<jsp:include page="/pages/underwriting/parTableGrid/accident/subPages/groupedItems/subPages/accGroupedItems.jsp"></jsp:include>			
	</div>
	
	<div id="coverageDetail">
		<div id="outerDiv" name="outerDiv" style="width:872px; background-color:white;" >
			<div id="innerDiv" name="innerDiv">
				<label>Enrollee Coverage</label>
					<span class="refreshers" style="margin-top: 0;">
					<label id="showCoverage" name="groItem" tableGrid="tbgItmperlGrouped" style="margin-left: 5px;">Show</label>
				</span>
			</div>
		</div>	
		<div id="accCoverageInfo" class="sectionDiv" style="display: none; width:872px; background-color:white;">
			<jsp:include page="/pages/underwriting/parTableGrid/accident/subPages/groupedItems/subPages/accCoverage.jsp"></jsp:include>
		</div> 				 
	</div>
	
	<div id="accBeneficiaryDetail">
		<div id="outerDiv" name="outerDiv" style="width:872px; background-color:white;">
			<div id="innerDiv" name="innerDiv">
		   		<label>Beneficiary Information</label>
		   		<span class="refreshers" style="margin-top: 0;">
		   			<label id="showAccBeneficiary" name="groItem" tableGrid="tbgGrpItemsBeneficiary" style="margin-left: 5px;">Show</label>
		   		</span>
		   	</div>
		</div>					
		<div id="accBeneficiaryInfo" class="sectionDiv" style="display: none; width:872px; background-color:white;">	
			<jsp:include page="/pages/underwriting/parTableGrid/accident/subPages/groupedItems/subPages/accGrpItemsBen.jsp"></jsp:include>
		</div>	
	</div>
	
	<div class="buttonsDiv">
		<input type="button" class="button"  id="btnCancelGrp" name="btnCancel"  value="Cancel" 	style="width: 60px;" />
		<input type="button" class="button"  id="btnSaveGrp" 	name="btnSave" 	  value="Save" 		style="width: 60px;" />
	</div>	
</div>
<script type="text/javascript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	initializeItemAccordion();
	
	function validateBeforeSave(refresh){
		try{
			var cntEnrollee = ((tbgGroupedItems.bodyTable.down('tbody').childElements()).filter(function(row){ return row.style.display != "none"; })).length;
			if(tbgGroupedItems.pager.total != 0 && tbgGroupedItems.pager.total < 2){
				showMessageBox("Minimum no. of Grouped Items is two(2).", imgMessage.INFO);
				return false;
			}else if(objCurrItem.gipiWAccidentItem.noOfPersons != objGIPIWGroupedItems.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1;	}).length){
				showConfirmBox("Message", "Saving the changes will update the No. of Persons, do you want to continue ?", "Yes", "No", 
						function(){
							var noOfPerson = objGIPIWGroupedItems.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1;	}).length;
							$("noOfPerson").value = noOfPerson == 0 ? 1 : noOfPerson;							
							objCurrItem.gipiWAccidentItem.noOfPersons = $F("noOfPerson"); //apollo cruz 03.31.2015
							addModifiedJSONObject(objGIPIWItem, setParItemObj());
							saveAccidentGroupedItemsModal(refresh);	
						}, ""
				);
			}else{
				saveAccidentGroupedItemsModal(refresh);
			}
		}catch(e){
			showErrorMessage("validateBeforeSave", e);
		}
	}
	
	function saveAccidentGroupedItemsModal(refresh){
		try{
			var executeSave = false;
			var objParameters = new Object();
			
			objParameters.setItemRows			= getAddedAndModifiedJSONObjects(objGIPIWItem);
			objParameters.setGroupedItems 		= getAddedAndModifiedJSONObjects(objGIPIWGroupedItems);
			objParameters.delGroupedItems 		= getDeletedJSONObjects(objGIPIWGroupedItems);
			objParameters.setWItmperlGrouped	= getAddedAndModifiedJSONObjects(objGIPIWItmperlGrouped);
			objParameters.delWItmperlGrouped	= getDeletedJSONObjects(objGIPIWItmperlGrouped);
			objParameters.setGrpItemsBens		= getAddedAndModifiedJSONObjects(objGIPIWGrpItemsBeneficiary);
			objParameters.delGrpItemsBens		= getDeletedJSONObjects(objGIPIWGrpItemsBeneficiary);
			objParameters.setWItmperlBens		= getAddedAndModifiedJSONObjects(objGIPIWItmperlBeneficiary);
			objParameters.detWItmperlBens		= getDeletedJSONObjects(objGIPIWItmperlBeneficiary);
			for(attr in objParameters){
				if(objParameters[attr].length > 0){
					executeSave = true;
					break;
				}
			}

			if(executeSave){
				objParameters.misc	= prepareJsonAsParameter(objFormMiscVariables);
				
				objParameters.setItemRows		= prepareJsonAsParameter(objParameters.setItemRows);
				objParameters.setGroupedItems	= prepareJsonAsParameter(objParameters.setGroupedItems);
				objParameters.delGroupedItems	= prepareJsonAsParameter(objParameters.delGroupedItems);
				objParameters.setCoverages		= prepareJsonAsParameter(objParameters.setWItmperlGrouped);
				objParameters.delCoverages		= prepareJsonAsParameter(objParameters.delWItmperlGrouped);
				objParameters.setBeneficiaries	= prepareJsonAsParameter(objParameters.setGrpItemsBens);
				objParameters.delBeneficiaries	= prepareJsonAsParameter(objParameters.delGrpItemsBens);
				objParameters.setBenPerils		= prepareJsonAsParameter(objParameters.setWItmperlBens);
				objParameters.delBenPerils		= prepareJsonAsParameter(objParameters.detWItmperlBens);
				
				new Ajax.Request(contextPath + "/GIPIWAccidentItemController?action=saveAccidentGroupedItemsModalTG", {
					method : "POST",
					parameters : {
						parameters : JSON.stringify(objParameters),
						parId : (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId),
						lineCd : (objUWGlobal.lineCd != null ? objUWGlobal.lineCd: objUWParList.lineCd),
						issCd : (objUWGlobal.issCd != null  ? objUWGlobal.issCd: objUWParList.issCd)
					},
					asynchronous : false,
					evalScripts : true,
					onCreate : function(){
						showNotice("Saving grouped items, please wait ...");
					},
					onComplete : function(response){
						hideNotice();						
						if(checkErrorOnResponse(response)){
							if(response.responseText != "SUCCESS"){
								showMessageBox(response.responseText, imgMessage.ERROR);
							}else{
								changeTag = 0;
								showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
									if(refresh) {
										//reloadAccGroupedModal();
									} else {
										closeOverlay();
									}
								});
							}
						}
					}
				});
			}
			
			
		}catch(e){
			showErrorMessage("saveAccidentGroupedItemsModal", e);
		}
	}
	
	function closeOverlay(){
		overlayGroupedItems.close();
		delete overlayGroupedItems;
		showItemInfo();
	}
	
	observeCancelForm("btnCancelGrp", function(){	validateBeforeSave(false);	}, function(){	closeOverlay(); });
	observeSaveForm("btnSaveGrp", function(){	validateBeforeSave(true);	});
</script>