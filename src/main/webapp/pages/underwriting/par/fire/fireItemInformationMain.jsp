<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="parItemInformationDiv" name="parItemInformationDiv" style="margin-top: 1px;" changeTagAttr="true">
	<form id="itemInformationForm" name="itemInformationForm">
		<c:if test="${'Y' ne isPack}">		
			<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		</c:if>
		
		<div id="addDeleteItemDiv">
			<jsp:include page="/pages/underwriting/par/fire/subPages/fireItemInformation.jsp"></jsp:include>
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
			<div id="mortgageeInfo" class="sectionDiv" style="display: none;">
				<jsp:include page="/pages/underwriting/pop-ups/mortgageeInformation.jsp"></jsp:include>
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
			<div id="deductibleDiv3" class="sectionDiv" style="display: none;">
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
	if(objUWGlobal.packParId == null) setDocumentTitle("Item Information - Fire");
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
			initializeChangeTagBehavior(changeTagFunc);			
		}
	}*/ "");

	observeAccessibleModule(accessType.SUBPAGE, "GIPIS038", "showPeril", /*function(){
		//showPerilInfoPage();
		initializeChangeTagBehavior(changeTagFunc);
	}*/ "");
	
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
	
	/* comment out by andrew - transferred in underwriting-item-save-functions.js - can be removed later
	function saveFireItems(){
		try{
			if(checkPendingRecordChanges()){				
				if($$("div#itemInformationDiv [changed=changed]").length > 0){
					fireEvent($("btnAddItem"), "click");
					return false;			
				}
				
				var executeSave = false;
				var objParameters = new Object();

				objParameters.setItemRows 	= getAddedAndModifiedJSONObjects(objGIPIWItem);
				objParameters.delItemRows 	= getDeletedJSONObjects(objGIPIWItem);
				objParameters.setDeductRows	= getAddedAndModifiedJSONObjects(objDeductibles);
				objParameters.delDeductRows	= getDeletedJSONObjects(objDeductibles);
				objParameters.setMortgagees	= getAddedAndModifiedJSONObjects(objMortgagees);
				objParameters.delMortgagees	= getDeletedJSONObjects(objMortgagees);
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
							
					objParameters.setItemRows 	= prepareJsonAsParameter(objParameters.setItemRows);
					objParameters.delItemRows 	= prepareJsonAsParameter(objParameters.delItemRows);
					objParameters.setDeductRows	= prepareJsonAsParameter(objParameters.setDeductRows);
					objParameters.delDeductRows	= prepareJsonAsParameter(objParameters.delDeductRows);
					objParameters.setMortgagees	= prepareJsonAsParameter(objParameters.setMortgagees);
					objParameters.delMortgagees	= prepareJsonAsParameter(objParameters.delMortgagees);
					objParameters.setPerils 	= prepareJsonAsParameter(objParameters.setPerils);		
					objParameters.delPerils 	= prepareJsonAsParameter(objParameters.delPerils);	
					objParameters.setWCs 		= prepareJsonAsParameter(objParameters.setWCs);
					
					objParameters.vars			= prepareJsonAsParameter(objFormVariables);
					objParameters.pars			= prepareJsonAsParameter(objFormParameters);
					objParameters.misc			= prepareJsonAsParameter(objFormMiscVariables);		
					
					objParameters.gipiWPolbas	= prepareJsonAsParameter(objGIPIWPolbas);

					objParameters.parId			= parId;
					objParameters.lineCd		= lineCd;
					objParameters.sublineCd		= sublineCd;

					//to include Peril Miscellaneous Fields BRY 02.08.2011
					objParameters = includePerilParamsForSaving(objParameters);
					
					new Ajax.Request(contextPath + "/GIPIWFireItmController?action=saveParFIItems", {
						method : "POST",
						parameters : {
							parameters : JSON.stringify(objParameters)
						},
						onCreate : function(){
							showNotice("Saving Fire Items, please wait ...");
						},
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response)){
								if(response.responseText != "SUCCESS"){
									showMessageBox(response.responseText, imgMessage.ERROR);
								}else{
									clearObjectRecordStatus2(objGIPIWItem);
									clearObjectRecordStatus2(objDeductibles);
									clearObjectRecordStatus2(objMortgagees);
									clearObjectRecordStatus2(objGIPIWItemPeril);
									clearObjectRecordStatus2(objGIPIWPolWC);
									changeTag = 0;
									showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, showItemInfo);
									updateParParameters();
								}
							}
						}
					});
				}else{					
					showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);					
				}			
			}	
		}catch(e){
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
				saveFireItems();
				changeTag = 0;
			}, showParListing, "");
		}else{
			changeTag = 0;
			showParListing();
		}	
	});

	$("btnSave").observe("click", saveFireItems);*/

	observeReloadForm("reloadForm", showItemInfo);
	observeCancelForm("btnCancel", function(){ validateSaving(false);}, showParListing);
	observeSaveForm("btnSave", function(){ validateSaving(true);});

	loadItemRowObserver();	

	showDeductibleModal(1);
	showDeductibleModal(2);	
	//showMortgageeInfoModal(parId, "0");

	setCursor("default");
	changeTag = 0;
	initializeChangeTagBehavior(saveFireItems);
	initializeChangeAttribute();
	hideNotice("");
</script>