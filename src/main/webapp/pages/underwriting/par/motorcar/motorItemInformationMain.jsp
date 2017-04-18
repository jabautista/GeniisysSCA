<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="parItemInformationMainDiv" name="parItemInformationMainDiv" style="margin-top: 1px;">
	<form id="itemInformationForm" name="itemInformationForm">
		<c:if test="${'Y' ne isPack}">
			<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		</c:if>
		
		<div id="addDeleteItemDiv">
			<jsp:include page="/pages/underwriting/par/motorcar/subPages/motorItemInformation.jsp"></jsp:include>
		</div>
		
		<jsp:include page="/pages/underwriting/par/motorcar/subPages/motorItemInfoAdditional.jsp"></jsp:include>
		
		<div id="deductibleDetail2" divName="Item Deductible">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Item Deductible</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showDeductible2" name="gro" style="margin-left: 5px;">Show</label>
			   		</span>
			   	</div>
			</div>					
			<div id="deductibleDiv2" class="sectionDiv" style="display: none;"></div>
			<div id="deductibleDiv1" class="sectionDiv" style="display: none;"></div>
			<input type="hidden" id="dedLevel" name="dedLevel" value="2" />
		</div>
		
		<div id="mortgageePopups">
			<input type="hidden" id="mortgageeLevel" name="mortgageeLevel" value="1" />
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Mortgagee Information</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showMortgagee" name="gro" style="margin-left: 5px;">Show</label>
			   		</span>
			   	</div>
			</div>			
			<div id="mortgageeInfo" class="sectionDiv" style="display: none;" changeTagAttr="true">
				<jsp:include page="/pages/underwriting/pop-ups/mortgageeInformation.jsp"></jsp:include>
			</div>						
		</div>
		
		<div id="accessoryPopups">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Accessory Information</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showAccessory" name="gro" style="margin-left: 5px;" >Show</label>
			   		</span>
			   	</div>
			</div>
			<div id="accessory" class="sectionDiv" style="display: none;" changeTagAttr="true">
				<jsp:include page="/pages/underwriting/pop-ups/accessoryInformation.jsp"></jsp:include>
			</div>
		</div>		
		
		<jsp:include page="/pages/underwriting/subPages/parPerilInformation.jsp"></jsp:include>
		<div id="deductibleDetail3">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Peril Deductible</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showDeductible3" name="gro" style="margin-left: 5px;">Show</label>
			   		</span>
			   	</div>
			</div>
			<div id="deductibleDiv3" class="sectionDiv" style="display: none;" changeTagAttr="true">
			</div>
			<input type="hidden" id="dedLevel" name="dedLevel" value="3">
		</div>
		
		<div class="buttonsDiv">
			<input type="button" id="btnColor" 				name="btnColor" 			class="button" value="Color" style="width: 100px;" />
			<input type="button" id="btnMake" 				name="btnMake" 				class="button" value="Make" style="width: 100px;" />
			<input type="button" id="btnUploadFleetData" 	name="btnUploadFleetData" 	class="button" value="Fleet Data" style="width: 100px;" />
			<input type="button" id="btnMotorCarIssuance"	name="btnMotorCarIssuance"	class="button" value="MC Issuance" style="width: 100px;" />
			<input type="button" id="btnCancel" 			name="btnCancel" 			class="button" value="Cancel" style="width: 100px;" />
			<input type="button" id="btnSave" 				name="btnSave" 				class="button" value="Save" style="width: 100px;" />			
		</div>
	</form>
</div>
<script type="text/javascript">
try{
	var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
	var lineCd = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : getLineCd() /*$F("globalLineCd")*/);
	var sublineCd = (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd"));
	setCursor("wait");
	if(objUWGlobal.packParId == null) setDocumentTitle("Item Information - Motorcar"); // andrew - 03.18.2011 - added condition for pack
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	setModuleId(getItemModuleId("P", getLineCd()));	
	
	showItemList(objGIPIWItem);
	setDefaultItemForm();
	
	objItemNoList = [];	
	createItemNoList(objGIPIWItem);
	
	observeAccessibleModule(accessType.SUBPAGE, "GIPIS168", "showMortgagee", /*function() {		
		if($("mortgageeInfo").empty()){
			showMortgageeInfoModal($F("globalParId"), "0");
		}		
	}*/ "");

	observeAccessibleModule(accessType.SUBPAGE, "GIPIS169", "showDeductible2", /*function(){
		if($("inputDeductible2") == null){			
			showDeductibleModal(2);
			initializeChangeTagBehavior();			
		}
	}*/ "");

	observeAccessibleModule(accessType.SUBPAGE, "GIPIS038", "showPeril", /*function(){
		//showPerilInfoPage();
		initializeChangeTagBehavior();
	}*/ "");

	if (checkUserModule("GIPIS038")) {
		observeAccessibleModule(accessType.SUBPAGE, "GIPIS169", "showDeductible3", function() {
			if($("inputDeductible3") == null){
				showDeductibleModal(3);
			}
		});
	} else {
		disableSubpage("showDeductible3");
	}

	observeAccessibleModule(accessType.BUTTON, "GIPIS198", "btnUploadFleetData", function() {		
		//showMe("GIPIWVehicleController?action=showUploadFleetPage&globalParId="+parId, 600);	
		var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId);
		showUploadFleetData(parId);
	});
	
	$("showAccessory").observe("click", function(){
		if($("accessory").empty()){
			showAccessoryInfoModal(parId, "0");
		}			
	});
	
	/* comment out by andrew - transferred in underwriting-item-save-functions.js - can be removed later	
	function saveVehicleItems(){
		//belle 03082011 validation if items have peril(s)
		var perilExists;
		var itemCount = 0;
		var withPerilCount = 0;
		var itemWithoutPeril = new Array();
		for(var i=0; i<objGIPIWItem.length; i++){
			if(objGIPIWItem[i].recordStatus != -1) {
				perilExists = false;
				itemCount++;
				for (var j=0; j<objGIPIWItemPeril.length; j++) {
					if (objGIPIWItemPeril[j].itemNo == objGIPIWItem[i].itemNo && objGIPIWItemPeril[j].recordStatus != -1) {
						withPerilCount++;
						perilExists = true;
						break;							
					}
				}	
											
				if (!perilExists){
					itemWithoutPeril.push(objGIPIWItem[i].itemNo);
				}
			}
		}
		
		if(!(itemCount == withPerilCount || itemCount == itemWithoutPeril.length)) {
			showConfirmBox("Confirmation", "Do you want to go to the next item without peril(s)?", "Yes", "No", 
					function(){
						itemWithoutPeril.sort();
						if(!$("row"+itemWithoutPeril[0]).hasClassName("selectedRow")){
							fireEvent($("row"+itemWithoutPeril[0]), "click");
						}
						$("row"+itemWithoutPeril[0]).scrollTo();
					}, "");
			return false;			
		}
		
		//belle 03072011 validation if all default perils have TSI Amount
		for(var i=0; i<objGIPIWItemPeril.length; i++){
			if ("0" == objGIPIWItemPeril[i].tsiAmt) {
				showMessageBox("Peril " +objGIPIWItemPeril[i].perilName + " has no TSI Amount.", imgMessage.Info);
				if(!$("rowPeril" +objGIPIWItemPeril[i].itemNo+objGIPIWItemPeril[i].perilCd).hasClassName("selectedRow")){
					fireEvent($("rowPeril" +objGIPIWItemPeril[i].itemNo+objGIPIWItemPeril[i].perilCd), "click");
				}
			return false;
			}
		}
		
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
			objParameters.setMortgagees	= getAddedAndModifiedJSONObjects(objMortgagees);
			objParameters.delMortgagees	= getDeletedJSONObjects(objMortgagees);
			objParameters.setAccRows	= getAddedAndModifiedJSONObjects(objGIPIWMcAcc);
			objParameters.delAccRows	= getDeletedJSONObjects(objGIPIWMcAcc);
			objParameters.setPerils 	= getAddedAndModifiedJSONObjects(objGIPIWItemPeril);
			objParameters.delPerils 	= getDeletedJSONObjects(objGIPIWItemPeril);	
			objParameters.setWCs 		= getAddedAndModifiedJSONObjects(objGIPIWPolWC);	
			
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
				
				objParameters.vars			= prepareJsonAsParameter(objFormVariables);
				objParameters.pars			= prepareJsonAsParameter(objFormParameters);
				objParameters.misc			= prepareJsonAsParameter(objFormMiscVariables);
				//objParameters.itemNoList	= prepareJsonAsParameter(objItemNoList);
				
				objParameters.gipiWPolbas	= prepareJsonAsParameter(objGIPIWPolbas);

				objParameters.parId			= parId;
				objParameters.lineCd		= lineCd;
				objParameters.sublineCd		= sublineCd;

				//to include Peril Miscellaneous Fields BRY 02.08.2011
				objParameters = includePerilParamsForSaving(objParameters);	
				
				new Ajax.Request(contextPath + "/GIPIWVehicleController?action=saveParMCItems", {
					method : "POST",
					parameters : {
						parameters : JSON.stringify(objParameters)
					},
					onCreate : 
						function(){
							showNotice("Saving Motorcar Items, please wait...");
						},
					onComplete : 
						function(response){	
							hideNotice();
						if(checkErrorOnResponse(response)){
								if(response.responseText != "SUCCESS"){
									showMessageBox(response.responseText, imgMessage.ERROR);
								}else{
									clearObjectRecordStatus2(objGIPIWItem);
									clearObjectRecordStatus2(objDeductibles);
									clearObjectRecordStatus2(objMortgagees);
									clearObjectRecordStatus2(objGIPIWMcAcc);
									clearObjectRecordStatus2(objGIPIWItemPeril);
									clearObjectRecordStatus2(objGIPIWPolWC);
									changeTag = 0;	
									showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, showItemInfo);	
									updateParParameters();																			
								}
							}						
						}
				});
			}else{
				showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
			}
		}
	}*/
	/*$("reloadForm").observe("click", function() {
		if (changeTag == 1){		
			showConfirmBox("Confirmation", objCommonMessage.RELOAD_WCHANGES, "Yes", "No", 
				function(){
					if(objUWGlobal.packParId != null){
						showPackItemsPerLine(objUWGlobal.packParId, objLineCds.MC);
					} else {
						showItemInfo();
					}
					changeTag = 0;
				}, stopProcess);
		} else {
			changeTag = 0;
			showItemInfo();			
		}
	});	
	
	$("btnCancel").observe("click", function(){		
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function(){
				saveVehicleItems();
				changeTag = 0;
			}, showParListing, "");
		}else{
			changeTag = 0;
			showParListing();
		}	
	});
	
	$("btnSave").observe("click", saveVehicleItems);*/ //belle 04122011 replaced by codes below

	observeReloadForm("reloadForm", showItemInfo);
	observeCancelForm("btnCancel", function(){ validateSaving(false);}, showParListing);
	observeSaveForm("btnSave", function(){ validateSaving(true);});
	
	loadItemRowObserver();
	
	showDeductibleModal(2);
	//showMortgageeInfoModal(parId, "0");	
	//showAccessoryInfoModal(parId, "0");
	
	setCursor("default");
	changeTag = 0;
	initializeChangeTagBehavior(saveVehicleItems);
	initializeChangeAttribute();
	hideNotice("");		
}catch(e){
	showErrorMessage("motorItemInformationMain", e);
}
</script>
