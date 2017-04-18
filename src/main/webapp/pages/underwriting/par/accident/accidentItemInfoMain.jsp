<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<script type="text/javascript">
	formMap = eval((('(' + '${formMap}' + ')').replace(/&#62;/g, ">")).replace(/&#60;/g, "<"));
	
	loadFormVariables(formMap.vars);
	loadFormParameters(formMap.pars);
	loadFormMiscVariables(formMap.misc);
</script>
<div id="parItemInformationMainDiv" name="parItemInformationMainDiv" style="margin-top: 1px;">
	<form id="itemInformationForm" name="itemInformationForm">
		<input type="hidden" id="wpolbasInceptDate" name="wpolbasInceptDate" value="" />
		<input type="hidden" id="wpolbasExpiryDate" name="wpolbasExpiryDate" value="" />
		<c:if test="${'Y' ne isPack}">		
			<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		</c:if>
		<div id="addDeleteItemDiv">
			<jsp:include page="/pages/underwriting/par/accident/subPages/accidentItemInfo.jsp"></jsp:include>
		</div>
		<jsp:include page="/pages/underwriting/par/accident/subPages/accidentItemInfoAdditional.jsp"></jsp:include>
		
		<div id="personalAdditionalInfoDetail">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Personal Additional Information</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showPersonalAdditionalInfo" name="gro" style="margin-left: 5px; display:none">Show</label>
			   		</span>
			   	</div>
			</div>					
			<div id="personalAdditionalInformationInfo" class="sectionDiv" style="display: none;">
				<jsp:include page="/pages/underwriting/par/accident/subPages/accidentPersonalAdditionalInfo.jsp"></jsp:include>	
			</div>	
		</div>

		<div id="beneficiaryDetail">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Beneficiary Information</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showBeneficiary" name="gro" style="margin-left: 5px;">Show</label>
			   		</span>
			   	</div>
			</div>					
			<div id="beneficiaryInformationInfo" class="sectionDiv" style="display: none;">	
				<jsp:include page="/pages/underwriting/par/accident/subPages/beneficiaryInformation.jsp"></jsp:include>
			</div>	
		</div>
		
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
		
		<div class="buttonsDiv" changeTagAttr="true">
			<input type="button" id="btnCancel" 			name="btnCancel" 			class="button" value="Cancel" style="width: 100px;" />
			<input type="button" id="btnSave" 				name="btnSave" 				class="button" value="Save" style="width: 100px;" />			
		</div>
	</form>
</div>

<script type="text/javascript">
//try {
	var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
	var lineCd = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : getLineCd() /*$F("globalLineCd")*/);
	var menuLineCd = (objUWGlobal.packParId != null ? objCurrPackPar.menuLineCd : objUWGlobal.menuLineCd);
	var sublineCd = (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd"));
	setCursor("wait");
	
	if(objUWGlobal.packParId == null) setDocumentTitle("Item Information - Accident");
	setModuleId(getItemModuleId("P", getLineCd(), menuLineCd));
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();

	//formMap = eval((('(' + '${formMap}' + ')').replace(/&#62;/g, ">")).replace(/&#60;/g, "<"));
	
	objGIPIWItem = JSON.parse(Object.toJSON(formMap.gipiWAccidentItem));
	objGIPIWPerilDiscount = JSON.parse(Object.toJSON(formMap.gipiWPerilDiscount));
	objBeneficiaries = JSON.parse(Object.toJSON(formMap.beneficiaries));
	objGIPIWItemWGroupedPeril = JSON.parse(Object.toJSON(formMap.gipiWItmPerilGrouped));	//added 03/23/2011
	
	$("wpolbasInceptDate").value = formMap.polbasInceptDate;
	$("wpolbasExpiryDate").value = formMap.polbasExpiryDate;
	
	showItemList(objGIPIWItem);	

	//loadFormVariables(formMap.vars);
	//loadFormParameters(formMap.pars);
	//loadFormMiscVariables(formMap.misc);
	setDefaultItemForm();
	
	objItemNoList = [];	
	createItemNoList(objGIPIWItem);	

	observeAccessibleModule(accessType.SUBPAGE, "GIPIS169", "showDeductible2", "");

	observeAccessibleModule(accessType.SUBPAGE, "GIPIS038", "showPeril", "");
	
/*	observeAccessibleModule(accessType.SUBPAGE, "GIPIS169", "showDeductible2", function(){
		if($("inputDeductible2") == null){			
			showDeductibleModal(2);
			initializeChangeTagBehavior();			
		}
	});

	observeAccessibleModule(accessType.SUBPAGE, "GIPIS038", "showPeril", function(){
		//showPerilInfoPage();
		initializeChangeTagBehavior();
	});*/
	
	if (checkUserModule("GIPIS038")) {
		observeAccessibleModule(accessType.SUBPAGE, "GIPIS169", "showDeductible3", function() {
			if($("inputDeductible3") == null){
				showDeductibleModal(3);
			}
		});
	} else {
		disableSubpage("showDeductible3");
	}

	/*$("reloadForm").observe("click", function() {
		if (changeTag == 1){		
			showConfirmBox("Confirmation", "Reloading form will disregard all changes. Proceed?", "Yes", "No", 
				function(){
					if(objUWGlobal.packParId != null){
						showPackItemsPerLine(objUWGlobal.packParId, objLineCds.MC);
					} else {
						showItemInfo();
					}
					changeTag = 0;
				}, stopProcess);
		} else {
			showItemInfo();
			changeTag = 0;
		}
	});	

	$("btnCancel").observe("click", function() {
		if (changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveAndExit, showParListing, "");
		} else {
			showParListing();	
		}
	});

	$("btnSave").observe("click", function() { 
		saveAHItem();
	});*/

	/* comment out by andrew - transferred in underwriting-item-save-functions.js - can be removed later
	function saveAHItem() {
		try {
			var objParameters = new Object();
			var executeSave = false;

			objParameters.setItemRows 	= prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objGIPIWItem));
			objParameters.delItemRows 	= prepareJsonAsParameter(getDeletedJSONObjects(objGIPIWItem));
			objParameters.setDeductRows	= prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objDeductibles));
			objParameters.delDeductRows	= prepareJsonAsParameter(getDeletedJSONObjects(objDeductibles));
			objParameters.setPerils 	= prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objGIPIWItemPeril));		
			objParameters.delPerils 	= prepareJsonAsParameter(getDeletedJSONObjects(objGIPIWItemPeril));	
			objParameters.setWCs 		= prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objGIPIWPolWC));
			objParameters.setBeneficiaries = prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objBeneficiaries));
			objParameters.delBeneficiaries = prepareJsonAsParameter(getDeletedJSONObjects(objBeneficiaries));

			for(attr in objParameters){
				if(objParameters[attr].length > 2){
					executeSave = true;
				}	
			}

			if(executeSave){
				var temp = new Array();
				objParameters.newItemNos	= prepareJsonAsParameter((objFormMiscVariables.miscChangedItems== null ? temp : objFormMiscVariables.miscChangedItems));
				objParameters.oldItemNos	= prepareJsonAsParameter(objFormMiscVariables.miscRenumberedItems==null ? temp :
												objFormMiscVariables.miscRenumberedItems);
				
				objFormMiscVariables.miscChangedItems = null;
				objFormMiscVariables.miscRenumberedItems = null;
				
				objParameters.vars			= prepareJsonAsParameter(objFormVariables);
				objParameters.pars			= prepareJsonAsParameter(objFormParameters);
				objParameters.misc			= prepareJsonAsParameter(objFormMiscVariables);
				
		
				objParameters.gipiWPolbas	= prepareJsonAsParameter(objGIPIWPolbas);
				
				objParameters.parId			= parId;
				objParameters.lineCd		= lineCd;
				objParameters.sublineCd		= sublineCd;
				//return false;
				//objParameters = includePerilParamsForSaving(objParameters);	
				
				//to include Peril Miscellaneous Fields 
				objParameters = includePerilParamsForSaving(objParameters);
				
				new Ajax.Request(contextPath + "/GIPIWAccidentItemController?action=saveGIPIWAccidentInfo", {
					method : "POST",
					parameters : {
						parameters : JSON.stringify(objParameters),
						globalParId: parId
					},
					onCreate : 
						function(){
							showNotice("Saving Accident Items, please wait...");
						},
					onComplete : 	
						function(response){					
							hideNotice();						
							if(checkErrorOnResponse(response)){
								if(response.responseText != "SUCCESS"){
									showMessageBox(response.responseText, imgMessage.ERROR);
								}else{
									showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, showItemInfo);
								}
							}						
						}
				});
			}else{
				showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
			}		
		} catch(e) {
			showErrorMessage("saveAHItem", e);
			//showMessageBox("Save Accident Item: " + e.message);
		}
	}*/

	/*function saveAndExit() {
		saveAHItem();
		showParListing();
	}*/

	observeReloadForm("reloadForm", showItemInfo);
	observeCancelForm("btnCancel", function(){ validateSaving(false);}, showParListing);
	observeSaveForm("btnSave", function(){ validateSaving(true);});

	loadItemRowObserver();

	showDeductibleModal(1);
	showDeductibleModal(2);	

	changeTag = 0;
	initializeChangeTagBehavior(saveAHItem);
	initializeChangeAttribute();
	hideNotice("");
/*} catch(e) {
	showErrorMessage("accidentItemInfoMain.jsp", e);
	//showMessageBox("An error occured while page is being loaded... " + e.message);
}*/	
</script>
