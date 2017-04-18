<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="endtItemInformationMainDiv" name="endtItemInformationMainDiv" style="margin-top: 1px;">	
	<form id="itemInformationForm" name="itemInformationForm">
		<!-- params -->
		<input type="hidden" name="paramDfltCoverage" id="paramDfltCoverage" value="${paramDfltCoverage}"/>
		<input type="hidden" name="paramPolFlagSw" id="paramPolFlagSw" value="
			<c:choose>
				<c:when test="${wPolBasic.polFlag eq '4'}">Y</c:when>
				<c:otherwise>N</c:otherwise>
			</c:choose>
			"/>
		<input type="hidden" name="paramAddDeleteSw" id="paramAddDeleteSw" value=""/>
		<input type="hidden" name="paramItemCnt" id="paramItemCnt" value="0"/>
		
		<!-- miscellaneous variables -->		
		<input type="hidden" name="vAllowUpdateCurrRate" id="vAllowUpdateCurrRate" value="${pAllowUpdateCurrRate}"/>
		<input type="hidden" name="vPolicyNo"		id="vPolicyNo"	value="${policyNo}"/>
		<input type="hidden" name="isLoaded"		id="isLoaded"	value="0"/>
		<input type="hidden" name="changedFields"	id="changedFields"	value="0"/>
		
		<!-- GIPI_PARLIST (b240) -->
		<input type="hidden" id="invoiceSw"				name="invoiceSw"			value="" />
		
		<!-- GIPI_WPOLBAS (b540) -->
		<input type="hidden" 	name="packPolFlag" 	 	id="packPolFlag" 	value="${wPolBasic.packPolFlag }"/>
		<input type="hidden" 	name="polProrateFlag" 	id="polProrateFlag"	value="${wPolBasic.prorateFlag }"/>
		<input type="hidden" 	name="polCompSw" 		id="polCompSw" 	   	value="${wPolBasic.compSw }<c:if test="${empty wPolBasic.compSw}">N</c:if>"/>
		<input type="hidden" 	name="polProrateFlag" 	id="polProrateFlag"	value="${wPolBasic.prorateFlag }"/>
		<input type="hidden" 	name="polAssdNo" 		id="polAssdNo"	   	value="${wPolBasic.assdNo }"/>
		<input type="hidden" 	name="address1" 		id="address1"	   	value="${wPolBasic.address1 }"/>
		<input type="hidden" 	name="address2" 		id="address2"	   	value="${wPolBasic.address2 }"/>
		<input type="hidden" 	name="address3" 		id="address3"	   	value="${wPolBasic.address3 }"/>
		
		<!-- GIPI_POLBASIC -->
		<input type="hidden" 	name="polbasicAddress1" 	id="polbasicAddress1"	   	value="${polbasicAddress1 }"/>
		<input type="hidden" 	name="polbasicAddress2" 	id="polbasicAddress2"	   	value="${polbasicAddress2 }"/>
		<input type="hidden" 	name="polbasicAddress3" 	id="polbasicAddress3"	   	value="${polbasicAddress3 }"/>
		
		<!-- GIIS_ASSURED -->
		<input type="hidden" 	name="assdAddress1" 	id="assdAddress1"	   	value="${assdMailAddress1 }"/>
		<input type="hidden" 	name="assdAddress2" 	id="assdAddress2"	   	value="${assdMailAddress2 }"/>
		<input type="hidden" 	name="assdAddress3" 	id="assdAddress3"	   	value="${assdMailAddress3 }"/>
		
		<input type="hidden" name="sublineCd" id="sublineCd" value="${sublineCd}"/>
		<input type="hidden" name="itemCount" id="itemCount" value="${itemCount}">
		<input type="hidden" name="pageName" id="pageName" value="itemInformation" />
		<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		
		<!-- For item information -->
		<div id="addDeleteItemDiv">
			<jsp:include page="/pages/underwriting/endt/marineCargo/subPages/endtMarineCargoItemInformation.jsp"></jsp:include>
		</div>
		<div id="listOfCarriersPopup">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>List of Carriers</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showListOfCarriers" name="gro" style="margin-left: 5px;">Show</label>
			   		</span>
			   	</div>
			</div>	
			<div id="listOfCarriersInfo" class="sectionDiv" style="display: none;">
				<jsp:include page="/pages/underwriting/endt/marineCargo/subPages/endtListOfCarriers.jsp"></jsp:include>
			</div>
		</div>
		<div id="deductibleDetail1" style="visibility: hidden;">				
			<div id="deductibleDiv1" class="sectionDiv" style="display: none;"></div>
			<input type="hidden" id="dedLevel" name="dedLevel" value="1">
		</div>
		<div id="deductibleDetail2">
			<div id="outerDiv" name="outerDiv">
					<div id="innerDiv" name="innerDiv">
				   		<label>Item Deductible</label>
				   		<span class="refreshers" style="margin-top: 0;">
				   			<label id="showDeductible2" name="gro" style="margin-left: 5px;">Show</label>
				   		</span>
				   	</div>
				</div>					
			<div id="deductibleDiv2" class="sectionDiv" style="display: none;"></div>
			<input type="hidden" id="dedLevel" name="dedLevel" value="2">
		</div>
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="outerDiv">
				<label id="">Peril Information</label>
				<span class="refreshers" style="margin-top: 0;"> 
					<label id="showPerilInfoSubPage" name="gro" style="margin-left: 5px;">Show</label> 
				</span>
			</div>
		</div>		
		<div class="sectionDiv" id="perilInformationDiv" name="perilInformationDiv" style="display: none;"></div>
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
			<input type="button" id="btnCancel"	name="btnCancel" 	class="button" value="Cancel"/>					
			<input type="button" id="btnSave"	name="btnSave" 		class="button" value="Save"/>
		</div>		
	</form>
</div>

<script type="text/javascript">	
	var pageActions = {none: 0, save : 1, reload : 2, cancel : 3}
	var pAction = pageActions.none;	
	objGIPIWItemPeril = new Array();
	objDeductibles = new Array();
	objPerilWCs = new Array();
	objParPolbas = JSON.parse('${gipiWPolbas}'.replace(/\\/g, '\\\\'));
	
	setDocumentTitle("Item Information - Marine Cargo - Endorsement");
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	enableAllElements();
	setModuleId(getItemModuleId("E", $F("globalLineCd")));
	
	$("reloadForm").observe("click", function() {
		if (changeTag == 1){		
			showConfirmBox("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", saveAndReload, showItemInfo);
		} else {
			showItemInfo();
		}
	});

	observeAccessibleModule(accessType.SUBPAGE, "GIPIS097", "showPerilInfoSubPage", function() { // added by andrew 07.08.2010
		if($("perilCd") == null){
			showEndtPerilInfoPage();	
			initializeChangeTagBehavior();					
		} 
	});

	observeAccessibleModule(accessType.SUBPAGE, "GIPIS169", "showDeductible2", function() { // added by andrew 08.09.2010
		if($("inputDeductible2") == null){
			showDeductibleModal(2);		
			initializeChangeTagBehavior();					
		} 
	});
	
	observeAccessibleModule(accessType.SUBPAGE, "GIPIS169", "showDeductible3",function() { // added by andrew 07.08.2010
		if($("inputDeductible3") == null){
			showDeductibleModal(3);
			initializeChangeTagBehavior();
		} 
	});

	$("btnCancel").observe("click", function(){
		if (changeTag == 1){
			showConfirmBox("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", saveAndCancel, showEndtParListing);
		} else {
			showEndtParListing();
		}
	});
	
	$("btnSave").observe("click", function() {
		if (changeTag == 0){
			showMessageBox("There are no changes to save.", imgMessage.INFO);
		} else {
			saveEndtMNItems();
		}
	});

	function saveAndReload(){
		pAction = pageActions.reload;
		saveEndtMNItems();
	}
	
	function saveAndCancel(){
		pAction = pageActions.cancel;
		saveEndtMNItems();
	}

	function prepareParameters(){
		try {			
			var delItemRows		= getDeletedJSONObjects(objEndtMNItems);
			var setItemRows		= getAddedAndModifiedJSONObjects(objEndtMNItems);
			
			var delItemPerils	= getDeletedJSONObjects(objGIPIWItemPeril);
			var setItemPerils	= getAddedAndModifiedJSONObjects(objGIPIWItemPeril);

			var delDeductibles	= getDeletedJSONObjects(objDeductibles);
			var setDeductibles	= getAddedAndModifiedJSONObjects(objDeductibles);
						
			var setCargoCarriers = getAddedAndModifiedJSONObjects(objCargoCarriers);
			var delCargoCarriers = getDeletedJSONObjects(objCargoCarriers);
			
			// Sets the parameters
			var objParameters = new Object();
			objParameters.miscVariables 	= objFormMiscVariables[0];
			objParameters.formVariables 	= objFormVariables[0]; 
			objParameters.formParameters	= objFormParameters[0];
			objParameters.setItemRows 		= setItemRows; 		// items to be inserted/updated
			objParameters.delItemRows 		= delItemRows; 		// items to be deleted
			objParameters.setItemPerils 	= setItemPerils;	// item perils to be inserted/udpated
			objParameters.delItemPerils		= delItemPerils;	// item perils to be deleted
			objParameters.setDeductibles 	= setDeductibles;	// deductibles to be inserted/updated
			objParameters.delDeductibles 	= delDeductibles;	// deductibles to be deleted
			objParameters.setPerilWCs		= objPerilWCs;		// warranty and clauses of perils to be inserted
			objParameters.setCargoCarriers 	= setCargoCarriers; // carriers to be inserted/updated
			objParameters.delCargoCarriers	= delCargoCarriers; // carriers to be deleted
			
			//return changeSingleAndDoubleQuotes(JSON.stringify(objParameters).unescapeHTML());
			return JSON.stringify(objParameters);
		} catch (e) {
			showErrorMessage("prepareParameters", e);
			//showMessageBox("prepareParameters: "+ e.message);
		}
	}
	
	function saveEndtMNItems() {
		if (checkPendingRecordChanges()) {
			var strParameters = prepareParameters();
			if (validateMNItems()) {
				new Ajax.Request(contextPath+"/GIPIWCargoController?action=saveEndtMarineCargoItems",{
						method: "GET",
						parameters: {globalParId: $F("globalParId"),
									 parameters:  strParameters},
						onCreate: function() {
							showNotice("Saving Marine Cargo Items, please wait...");
						},
						onComplete: function(response) {
							hideNotice();
							if(checkErrorOnResponse(response)) {
								changeTag = 0;
								clearObjectRecordStatus(objEndtMNItems);
								clearObjectRecordStatus(objGIPIWItemPeril);
								clearObjectRecordStatus(objDeductibles);
								clearObjectRecordStatus(objCargoCarriers);
								clearObjectRecordStatus(objPerilWCs);
								if (pAction == pageActions.reload){
									showItemInfo();
								} else if (pAction == pageActions.cancel){
									showEndtParListing();
								} else {
									showMessageBox(response.responseText, imgMessage.SUCCESS);
								}
							}
						}
					});
			} 
		}
	}		

	function disableAllElements(){
		$$("input[type=text]").each(
			function(elem){								
				elem.disable();							
			}
		);
		$$("select").each(
			function(elem){								
				elem.disable();							
			}
		);
		$$("textarea").each(
				function(elem){								
					elem.disable();							
				}
		);
	}

	function enableAllElements(){
		$$("input[type=text]").each(
			function(elem){								
				elem.enable();							
			}
		);
		$$("select").each(
			function(elem){								
				elem.enable();							
			}
		);
		$$("textarea").each(
				function(elem){								
					elem.enable();							
				}
		);
	}

	function messageAlertSelectItem(){
		showMessageBox("Please select an item first.", imgMessage.ERROR);
		return false;
	}

	function messageAlertUnsavedChanges(screenName){
		showMessageBox("You have unsaved changes, commit first the changes you have made before " +
			"proceeding to " + screenName + " screen.", imgMessage.INFO);  /* I */
		return false;
	}	
	
	changeTag = 0;
	initializeChangeTagBehavior();
	initializeChangeAttribute();

	objFormMiscVariables = JSON.parse('[{' +
			'"miscAllowUpdateCurrRate" : "${allowUpdateCurrRate}",' +
			'"miscDeletePolicyDeductibles": "N",' +
			'"miscNbtInvoiceSw" : "N",' +
			'"miscCopyPeril" : "N",' +
			'"miscDeletePerilDiscById" : "N",' +
			'"miscDeleteItemDiscById" : "N",' +
			'"miscDeletePolbasDiscById" : "N"' +
			'}]');

	objFormVariables = JSON.parse('[{' +
			'"varItemNo" :	0,' +
			'"varVPhilPeso" : null,' +
			'"varOldCurrencyCd" : null,' +
			'"varOldCurrencyDesc" : null,' +
			'"varVInterestOnPremises" : null,' +
			'"varVSectionOrHazardInfo" : null,' +
			'"varVConveyanceInfo" : null,' +
			'"varVPropertyNo" : null,' +
			'"varCreatePackItem" : null,' +
			'"varPrevAmtCovered" : null,' +
			'"varPrevDeductibleCd" : null,' +
			'"varPrevDeductibleAmt" : null,' +
			'"varVSublineCd" : null,' +
			'"varDeductibleAmt" : null,' +
			'"varVCount" : 0,' +
			'"varVPackPolFlag" : "${varPackPolFlag}",' +
			'"varVItemTag" : null,' +
			'"varCounter" : null,' +
			'"varSwitchRecFlag" : null,' +
			'"varPost" : null,' + 
			'"varGroupSw" : "N",' +
			'"varVEffDate" : "${varEffDate}",' +
			'"varVEndtExpiryDate" : "${varEndtExpiryDate}",' +
			'"varVShortRtPercent" : "${varShortRtPercent}",' +
			'"varVProvPremTag" : "${varProvPremTag}",' +
			'"varVProvPremPct" : "${varProvPremPct}",' +
			'"varVProrateFlag" : "${varProrateFlag}",' +
			'"varCompSw" : "${compSw}",' +
			'"varCopyItem" : null,' +
			'"varPost2" : "Y",' +
			'"varNewSw" : "Y",' +
			'"varNewSw2" : "Y",' +
			'"varDiscExist" : "${discExist}",' +
			'"varOldGroupCd" : null,' +
			'"varOldGroupDesc" : null,' +
			'"varCoInswSw" : "${varCoInsSw}",' +
			'"varEndtTaxSw" : null,' +
			'"varWithPerilSw" : "N",' +
			'"varVExpiryDate" : null,' +
			'"varVNegateItem" : "N",' +
			'"varVCopyItemTag" : false}]');

	objFormParameters = eval('[{' +
			'"paramItemCnt" : null,' +
			'"paramAddDeleteSw" : 1,' + 
			'"paramPostRecordSw" : "N",' +
			'"paramPolFlagSw" : "${parPolFlagSw}",' +
			'"paramPostRecSwitch" : "N"}]');
	
	objFormVariables[0].parId 		= $F("globalParId");
	objFormVariables[0].lineCd 		= $F("globalLineCd");
	objFormVariables[0].sublineCd 	= $F("globalSublineCd");
	objFormVariables[0].userId 		= "${PARAMETERS['userId']}";		
</script>