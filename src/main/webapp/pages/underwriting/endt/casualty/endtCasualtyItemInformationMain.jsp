<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="endtItemInformationMainDiv" name="endtItemInformationMainDiv" style="margin-top: 1px;" >
	<form id="itemInformationForm" name="itemInformationForm" >
		<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		
		<!-- For item information -->
		<div id="addDeleteItemDiv">
			<jsp:include page="/pages/underwriting/endt/casualty/subPages/endtCasualtyItemInformation.jsp"></jsp:include>
		</div>
		
		<jsp:include page="/pages/underwriting/endt/casualty/subPages/endtCasualtyItemInfoAdditional.jsp"></jsp:include>
		<div id="groupedItemsPopup" divName="Grouped Items">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Grouped Items</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showGroupedItems" name="gro" style="margin-left: 5px;">Show</label>
			   		</span>
			   	</div>
			</div>	
			<div id="groupedItemsInfo" class="sectionDiv" style="display: none;">
				<jsp:include page="/pages/underwriting/endt/pop-ups/groupedItems.jsp"></jsp:include>
			</div>			
		</div>
		<div id="personnelInformationPopup" divName="Personnel Information">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Personnel Information</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showPersonnelInformation" name="gro" style="margin-left: 5px;">Show</label>
			   		</span>
			   	</div>
			</div>	
			<div id="personnelInformationInfo" class="sectionDiv" style="display: none;">
				<jsp:include page="/pages/underwriting/endt/pop-ups/casualtyPersonnel.jsp"></jsp:include>
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
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="outerDiv">
				<label id="">Peril Information</label>
				<span class="refreshers" style="margin-top: 0;"> 
					<label id="showPerilInfoSubPage" name="gro" style="margin-left: 5px;">Show</label> 
				</span>
			</div>
		</div>
		<div class="sectionDiv" id="perilInformationDiv" name="perilInformationDiv" style="display: none;"></div>
		<div id="deductibleDetail3" divName="Peril Deductible">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
					<label>Peril Deductible</label>
					<span class="refreshers" style="margin-top: 0;">
						<label id="showDeductible3" name="gro" style="margin-left: 5px;">Show</label>
					</span>
				</div>
			</div>
			<div id="deductibleDiv3" class="sectionDiv" style="display: none;"></div>
			<input type="hidden" id="dedLevel" name="dedLevel" value="3" />
		</div>
		<div class="buttonsDiv">
			<input type="button" id="btnCancel"	name="btnCancel"	class="button" value="Cancel"	style="width : 60px;" />
			<input type="button" id="btnSave" 	name="btnSave" 		class="button" value="Save" 	style="width : 60px;" />			
		</div>	
	</form>
</div>

<script type="text/javascript">
	setDocumentTitle("Casualty Endt Item Information");
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	setModuleId(getItemModuleId("E", $F("globalLineCd"))); // andrew - 10.04.2010 - added this line
	
	loadFormVariables();
	loadFormParameters();
	loadFormMiscVariables();	

	observeAccessibleModule(accessType.SUBPAGE, "GIPIS169", "showDeductible2", function(){
		if($("inputDeductible2") == null){			
			showDeductibleModal(2);
			initializeChangeTagBehavior();			
		}
	});

	observeAccessibleModule(accessType.SUBPAGE, "GIPIS097", "showPerilInfoSubPage", function(){
		if($("perilCd") == null){
			showEndtPerilInfoPage();	
			initializeChangeTagBehavior();					
		} 
	});

	observeAccessibleModule(accessType.SUBPAGE, "GIPIS169", "showDeductible3", function(){
		if($("inputDeductible3") == null){
			showDeductibleModal(3);
			initializeChangeTagBehavior();
		}
	});

	$("reloadForm").observe("click", function() {
		if (changeTag == 1){		
			showConfirmBox("Confirmation", "Reloading form will disregard all changes. Proceed?", "Yes", "No", 
				function(){
					showItemInfo();
					changeTag = 0;
				}, stopProcess);
		} else {
			showItemInfo();
			changeTag = 0;
		}
	});
	
	$("btnSave").observe("click", function(){
		//var d='{ "name":\"Violet\","occupation":"character" }'.evalJSON();
		saveEndtCAItems();		
	});

	$("btnCancel").observe("click", function(){	
		showEndtParListing();	
	});	

	function addToObject(objArray, obj){
		objArray.push(obj);
	}

	function loadFormVariables(){
		objFormVariables = eval('[{' +
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
	}

	function loadFormParameters(){
		objFormParameters = eval('[{' +
				'"paramItemCnt" : null,' +
				'"paramAddDeleteSw" : 1,' + 
				'"paramPostRecordSw" : "N",' +
				'"paramPolFlagSw" : "${parPolFlagSw}",' +
				'"paramPostRecSwitch" : "N"}]');
	}

	function loadFormMiscVariables(){
		objFormMiscVariables = eval('[{' +
				'"miscAllowUpdateCurrRate" : "${allowUpdateCurrRate}",' +
				'"miscDeletePolicyDeductibles": "N",' +
				'"miscNbtInvoiceSw" : "N",' +
				'"miscCopyPeril" : "N",' +
				'"miscDeletePerilDiscById" : "N",' +
				'"miscDeleteItemDiscById" : "N",' +
				'"miscDeletePolbasDiscById" : "N"' +
				'}]');
	}

	function saveEndtCAItems(){
		var objParameters	= new Object();

		objParameters.setItemRows 	= prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objEndtCAItems));
		objParameters.delItemRows 	= prepareJsonAsParameter(getDeletedJSONObjects(objEndtCAItems));
		objParameters.setGrpItmRows = prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objEndtGroupedItems));
		objParameters.delGrpItmRows	= prepareJsonAsParameter(getDelFilteredObjs(objEndtGroupedItems));
		objParameters.setCasPerRows	= prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objEndtCAPersonnels));
		objParameters.delCasPerRows	= prepareJsonAsParameter(getDelFilteredObjs(objEndtCAPersonnels));		
		objParameters.setItemPerils	= prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objGIPIWItemPeril));
		objParameters.delItemPerils = prepareJsonAsParameter(getDeletedJSONObjects(objGIPIWItemPeril));
		objParameters.setPerilWCs	= prepareJsonAsParameter(objPerilWCs);
		objParameters.setDeductRows	= prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objDeductibles));
		objParameters.delDeductRows	= prepareJsonAsParameter(getDeletedJSONObjects(objDeductibles));

		objParameters.vars			= prepareJsonAsParameter(objFormVariables);
		objParameters.pars			= prepareJsonAsParameter(objFormParameters);
		objParameters.misc			= prepareJsonAsParameter(objFormMiscVariables);
		objParameters.itemNoList	= prepareJsonAsParameter(objItemNoList);

		objParameters.parId			= $F("globalParId");
		objParameters.lineCd		= $F("globalLineCd");
		objParameters.sublineCd		= $F("globalSublineCd");		
		
		new Ajax.Request(contextPath + "/GIPIWCasualtyItemController?action=saveEndtCAItems", {
			method : "POST",
			parameters : {	globalParId		: $F("globalParId"),							
							parameters		: JSON.stringify(objParameters)},
			onCreate : 
				function(){
					showNotice("Saving Casualty Items, please wait...");
				},
			onComplete : 
				function(){					
					hideNotice();
					//clearObjectRecordStatus(objEndtCAItems);					
					showWaitingMessageBox("Record Saved.", imgMessage.INFO, showItemInfo);
				}
		});

		objEndtCAItems = null;
		objEndtGroupedItems = null;
		objEndtCAPersonnels = null;
		objDeductibles = null;
		objGIPIWItemPeril = null;
		objFormVariables = null;
		objFormParameters = null;
		objFormMiscVariables = null;
		objItemNoList = null;		
	}

	showDeductibleModal(2);
	showEndtPerilInfoPage();
</script>
