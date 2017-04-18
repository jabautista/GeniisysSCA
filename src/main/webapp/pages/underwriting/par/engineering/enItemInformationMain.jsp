<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="parItemInformationMainDiv" name="parItemInformationMainDiv" style="margin-top: 1px;" changeTagAttr="true">
	<form id="enItemInfoForm" name="enItemInfoForm">
		<c:if test="${'Y' ne isPack}">
			<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		</c:if>
		<div id="enItemListingDiv">
			<jsp:include page="/pages/underwriting/par/engineering/subPages/enItemInformation.jsp"></jsp:include>
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
		
		<div id="hidItemLoc" style="display: none;">
			<c:forEach var="itemLoc" items="${itemLoc}">
				<input type="hidden" id="itemLoc${itemLoc.itemNo}" name="itemLoc" value="${itemLoc.itemNo}" />
			</c:forEach>
		</div>
		<div id="insertLocations" name="insertLocations" style="visibility: hidden;"></div>
		<div id="deleteLocations" name="deleteLocations" style="visibility: hidden;"></div> 
		
		<div class="buttonsDiv">
			<input type="button" id="btnCancel" 			name="btnCancel" 			class="button" value="Cancel" style="width: 100px;" />
			<input type="button" id="btnSave" 				name="btnSave" 				class="button" value="Save" style="width: 100px;" />			
		</div>
	</form>
</div>

<script type="text/javascript">
try {
	var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
	var lineCd = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : getLineCd() /*$F("globalLineCd")*/);
	var sublineCd = (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd"));
	setCursor("wait");
	if(objUWGlobal.packParId == null) setDocumentTitle("Item Information - Engineering");
	setModuleId(getItemModuleId("P", getLineCd()));	
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();

	formMap = eval((('(' + '${formMap}' + ')').replace(/&#62;/g, ">")).replace(/&#60;/g, "<"));

	objGIPIWItem = JSON.parse(Object.toJSON(formMap.gipiWEnItem));
	objGIPIWPerilDiscount = JSON.parse(Object.toJSON(formMap.gipiWPerilDiscount));
	
	showItemList(objGIPIWItem);

	loadFormVariables(formMap.vars);
	loadFormParameters(formMap.pars);
	loadFormMiscVariables(formMap.misc);
	setDefaultItemForm();

	objItemNoList = [];	
	createItemNoList(objGIPIWItem);

	observeAccessibleModule(accessType.SUBPAGE, "GIPIS169", "showDeductible2", /*function(){
		if($("inputDeductible2") == null){			
			showDeductibleModal(2);
			initializeChangeTagBehavior();			
		}
	}*/"");

	observeAccessibleModule(accessType.SUBPAGE, "GIPIS038", "showPeril", /*function(){
		//showPerilInfoPage();
		initializeChangeTagBehavior();
	}*/"");
	
	if (checkUserModule("GIPIS038")) {
		observeAccessibleModule(accessType.SUBPAGE, "GIPIS169", "showDeductible3", function() {
			if($("inputDeductible3") == null){
				showDeductibleModal(3);
			}
		});
	} else {
		disableSubpage("showDeductible3");
	}

	$("reloadForm").observe("click", function() {
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
			showItemInfo();
			changeTag = 0;
		}
	});
	
	/* comment out by andrew - transferred in underwriting-item-save-functions.js - can be removed later
	function saveENItems(afterSave) {
		try {
			//validation if items have peril(s)
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
			
			//validation if all default perils have TSI Amount
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
				objParameters.setItemRows 	= prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objGIPIWItem));
				objParameters.delItemRows 	= prepareJsonAsParameter(getDeletedJSONObjects(objGIPIWItem));
				objParameters.setDeductRows	= prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objDeductibles));
				objParameters.delDeductRows	= prepareJsonAsParameter(getDeletedJSONObjects(objDeductibles));
				objParameters.setPerils 	= prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objGIPIWItemPeril));		
				objParameters.delPerils 	= prepareJsonAsParameter(getDeletedJSONObjects(objGIPIWItemPeril));	
				objParameters.setWCs 		= prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objGIPIWPolWC));
				
				for(attr in objParameters){
					if(objParameters[attr].length > 2){
						executeSave = true;
					}	
				}
				if(executeSave){
					objParameters.vars			= prepareJsonAsParameter(objFormVariables);
					objParameters.pars			= prepareJsonAsParameter(objFormParameters);
					objParameters.misc			= prepareJsonAsParameter(objFormMiscVariables);
					objParameters.gipiWPolbas	= prepareJsonAsParameter(objGIPIWPolbas);
					
					objParameters.parId			= parId;
					objParameters.lineCd		= lineCd;
					objParameters.sublineCd		= sublineCd;	
					
					//to include Peril Miscellaneous Fields
					objParameters = includePerilParamsForSaving(objParameters);	
					new Ajax.Request(contextPath + "/GIPIWEngineeringItemController?action=saveParItemEN", {
						method : "POST",
						parameters : {
							parameters : JSON.stringify(objParameters),
							globalParId: parId
						},
						onCreate : 
							function(){
								showNotice("Saving Engineering Items, please wait...");
							},
						onComplete : 
							function(response){					
								hideNotice();	
								if(checkErrorOnResponse(response)){
									if(response.responseText != "SUCCESS"){
										showMessageBox(response.responseText, imgMessage.ERROR);
									}else if (afterSave == 0){
										showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, showItemInfo);
										updateParParameters();	
									}else if (afterSave == 1){
										showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, showParListing);
									}else {
										showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
									}
								}						
							}
					});
				}else{
					showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
				}
			}
		} catch(e) {
			showErrorMessage("saveENItems", e);
		}
	}*/

	$("btnCancel").observe("click", function() {
		if (changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
				function() {saveENItems(false); showParListing();}, showParListing, "");
		} else {
			showParListing();	
		}
	});
	
	observeReloadForm("reloadForm", showItemInfo);
	observeCancelForm("btnCancel", function(){ validateSaving(false);}, showParListing);
	observeSaveForm("btnSave", function(){ validateSaving(true);});

	loadItemRowObserver();
	showDeductibleModal(1);
	showDeductibleModal(2);
	changeTag = 0;
	initializeChangeTagBehavior(saveENItems);
	initializeChangeAttribute();
	hideNotice("");
} catch(e) {
	showErrorMessage("enItemInformationMain.jsp", e);
}
</script>