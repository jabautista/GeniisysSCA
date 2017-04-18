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
	<form id="mhItemInfoForm" name="mhItemInfoForm">
		<c:if test="${'Y' ne isPack}">
			<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		</c:if>
		
		<div id="addDeleteItemDiv">
			<jsp:include page="/pages/underwriting/par/marineHull/subPages/marineHullItemInfo.jsp"></jsp:include>
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
		
		<div class="buttonsDiv">
			<input type="button" id="btnCancel"	name="btnCancel"	class="button"	value="Cancel" 	style="width: 100px;" />
			<input type="button" id="btnSave" 	name="btnSave" 		class="button"	value="Save" 	style="width: 100px;" />			
		</div>
	</form>
</div>

<script type="text/javascript">
	var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
	var lineCd = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : getLineCd() /*$F("globalLineCd")*/);
	var sublineCd = (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd"));
	setCursor("wait");
	if(objUWGlobal.packParId == null) setDocumentTitle("Item Information - Marine Hull");
	setModuleId(getItemModuleId("P", getLineCd()));	
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();

	formMap = eval((('(' + '${formMap}' + ')').replace(/&#62;/g, ">")).replace(/&#60;/g, "<"));
	
	objGIPIWItem = JSON.parse(Object.toJSON(formMap.mhItems));
	objGIPIWPerilDiscount = JSON.parse(Object.toJSON(formMap.gipiWPerilDiscount));
	
	showItemList(objGIPIWItem);

	loadFormVariables(formMap.vars);
	loadFormParameters(formMap.pars);
	loadFormMiscVariables(formMap.misc);	
	setDefaultItemForm();	

	objItemNoList = [];	
	createItemNoList(objGIPIWItem);
	
	observeAccessibleModule(accessType.SUBPAGE, "GIPIS169", "showDeductible2", "");
	observeAccessibleModule(accessType.SUBPAGE, "GIPIS038", "showPeril", "");

	if (checkUserModule("GIPIS038")) {
		observeAccessibleModule(accessType.SUBPAGE, "GIPIS169", "showDeductible3", function() {
			if($("inputDeductible3") == null){
				showDeductibleModal(3);
				//initializeChangeTagBehavior(changeTagFunc);
			}
		});
		//showDeductibleModal(3);
	} else {
		disableSubpage("showDeductible3");
	}

	//filterVesselLOV("vesselCd", $("vesselCd").value, "MH");

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

	$("btnSave").observe("click", saveMHItems);
	
	$("btnCancel").observe("click", function(){		
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function(){
				saveMHItems();
				changeTag = 0;
			}, showParListing, "");
		}else{
			changeTag = 0;
			showParListing();
		}	
	});*/

	/* comment out by andrew - transferred in underwriting-item-save-functions.js - can be removed later
	function saveMHItems() {
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

				objParameters.gipiWPolbas	= prepareJsonAsParameter(objGIPIWPolbas);

				objParameters.parId			= parId;
				objParameters.lineCd		= lineCd;
				objParameters.sublineCd		= sublineCd;	

				objParameters = includePerilParamsForSaving(objParameters);	

				new Ajax.Request(contextPath + "/GIPIWItemVesController?action=saveMHItemInfo", {
					method : "POST",
					parameters : {
						parameters : JSON.stringify(objParameters),
						globalParId : $F("globalParId")
					},
					onCreate : 
						function(){
							showNotice("Saving Marine Hull Items, please wait...");
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
									clearObjectRecordStatus2(objGIPIWItemPeril);
									clearObjectRecordStatus2(objGIPIWPolWC);
									changeTag = 0;				
									showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, showItemInfo);
									updateParParameters();																			
								}
							}						
						}
				});
			} else{
				showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
			}
		}
	}*/

	observeReloadForm("reloadForm", showItemInfo);
	observeCancelForm("btnCancel", function(){ validateSaving(false);}, showParListing);
	observeSaveForm("btnSave", function(){ validateSaving(true);});
	
	loadItemRowObserver();	

	showDeductibleModal(1);
	showDeductibleModal(2);	

	setCursor("default");
	changeTag = 0;
	initializeChangeTagBehavior(saveMHItems);
	initializeChangeAttribute();
	hideNotice("");
</script>