<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="endtItemInformationMainDiv" name="endtItemInformationMainDiv" style="margin-top: 1px;">	
	<!-- HIDDEN FIELDS -->
	<input type="hidden" id="otherInfo"			name="otherInfo"		 value="" />
	<input type="hidden" id="changedFields"		name="changedFields"	 value="" />
	<input type="hidden" name="pageName" id="pageName" value="itemInformation" />
	<input type="hidden" id="perilExists" 		name="perilExists" 			value="N" />
	<input type="hidden" id="itemGrp"			name="itemGrp"			 value="" />
	<input type="hidden" id="tsiAmt"			name="tsiAmt"			 value="" />
	<input type="hidden" id="premAmt"			name="premAmt"			 value="" />
	<input type="hidden" id="annPremAmt"		name="annPremAmt"		 value="" />
	<input type="hidden" id="annTsiAmt"			name="annTsiAmt"		 value="" />
	<input type="hidden" id="recFlag"			name="recFlag"			 value="A" />
	<input type="hidden" id="packLineCd"		name="packLineCd"		 value="" />
	<input type="hidden" id="packSublineCd"		name="packSublineCd"	 value="" />
	<!-- END HIDDEN FIELDS -->
	<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
	<jsp:include page="/pages/underwriting/endt/engineering/subPages/endtEngineeringItemInformation.jsp"></jsp:include>
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
	<div id="perilInfoSubPage">
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
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
	</div>
</div>
<div class="buttonsDiv" style="float:left; width: 100%;">			
	<input type="button" style="width: 80px; " id="btnCancel" name="btnCancel"	class="button" value="Cancel" />
	<input type="button" style="width: 80px;" id="btnSave" name="btnSave" class="button" value="Save" />
</div> 
<script>
	setModuleId("GIPIS067");
	initializeAccordion();

	objDeductibles = new Array();
	loadFormVariables();
	loadFormParameters();
	loadFormMiscVariables();	
	
	observeAccessibleModule(accessType.SUBPAGE, "GIPIS169", "showDeductible2", function() {		
		if($("inputDeductible2") == null){
			showDeductibleModal(2);					
		}
	});

	observeAccessibleModule(accessType.SUBPAGE, "GIPIS097", "perilInfoSubPage", function(){
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

	$("btnSave").observe("click", saveEndtItemInformation);	
		
	$("btnCancel").observe("click", function () {
		showConfirmBox("Cancel Engineering Endorement.", "Do you want to cancel the changes you have made?", "Yes", "No", goBackToMain , "");	
	});	

	function saveEndtItemInformation(){
		var objParameters	= new Object();

		objParameters.setItemRows 	= prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objEndtENItems));
		objParameters.delItemRows 	= prepareJsonAsParameter(getDeletedJSONObjects(objEndtENItems));
		objParameters.setItemPerils	= prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objGIPIWItemPeril));
		objParameters.delItemPerils = prepareJsonAsParameter(getDeletedJSONObjects(objGIPIWItemPeril));
		objParameters.setDeductRows	= prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objDeductibles));
		objParameters.delDeductRows	= prepareJsonAsParameter(getDeletedJSONObjects(objDeductibles));
		
		
		new Ajax.Request(contextPath + "/GIPIWEngineeringItemController?action=saveEndtParEN" , {
			method: "POST",
			parameters: {
				parameter: JSON.stringify(objParameters),
				globalParId: $F("globalParId")
			},
			evalScripts: true,
			asynchronous: true,
			onCreate: function(){
				showNotice("Saving information, please wait...");
			},
			onComplete: function (response){
				showMessageBox(response.responseText, imgMessage.SUCCESS);
			}
		});
		objDeductibles = null;
		objGIPIWItemPeril = null;
		//objEndtENItems = null;
	}

	function prepareParameters(){
		try {						
			var setAddedEngineeringItem			= getAddedModifiedEngineeringJSONObject();
			var delEngineeringItem				= getDeletedEngineeringJSONObject();
		
			// Sets the parameters
			var objParameters = new Object();
			objParameters.addModifiedEngineeringItem	 = setAddedEngineeringItem;
			objParameters.deletedEngineeringItem	     = delEngineeringItem;

			return JSON.stringify(objParameters);
		} catch (e) {
			showErrorMessage("prepareParameters", e);
			//showMessageBox("prepareParameters: "+ e.message);
		}
	}

	//function getAddedModified
	function getAddedModifiedEngineeringJSONObject(){
		var tempObjArray = new Array();
				
		for(var i=0; i<objEndtENItems.length; i++) {	
			if (objEndtENItems[i].recordStatus == 0 || objEndtENItems[i].recordStatus == 1){
				tempObjArray.push(objEndtENItems[i]);
			}
		}
		return tempObjArray;
	}

	function getDeletedEngineeringJSONObject(){
		var tempObjArray = new Array();
				
		for(var i=0; i<objEndtENItems.length; i++) {	
			if (objEndtENItems[i].recordStatus == -1){
				tempObjArray.push(objEndtENItems[i]);
			}
		}
		return tempObjArray;
	}

	function goBackToMain() {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
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
				'"varVShortRtPercent" : ' + objParPolbas[0].shortRtPercent + "," +
				'"varVProvPremTag" : "${varProvPremTag}",' +
				'"varVProvPremPct" : "${varProvPremPct}",' +
				'"varVProrateFlag" : ' + objParPolbas[0].prorateFlag + "," +
				'"varCompSw" : ' + objParPolbas[0].prorateFlag + "," + 
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

	$("currency").value = '${defaultCurrency}';
	
	showDeductibleModal(2);
	showEndtPerilInfoPage();
	checkIfCancelledEndorsement(); // nica
</script>
