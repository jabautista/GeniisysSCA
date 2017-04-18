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
			<jsp:include page="/pages/underwriting/endt/jsonMotorcar/subPages/endtMotorItemInformation.jsp"></jsp:include>
		</div>
		
		<jsp:include page="/pages/underwriting/endt/jsonMotorcar/subPages/endtMotorItemInfoAdditional.jsp"></jsp:include>
		
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
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="outerDiv">
				<label id="">Peril Information</label>
				<span class="refreshers" style="margin-top: 0;"> 
					<label id="showPerilInfoSubPage" name="gro" style="margin-left: 5px;">Show</label> 
				</span>
			</div>
		</div>			
		<div class="sectionDiv" id="perilInformationDiv" name="perilInformationDiv" style="display: none;">
			<%-- <jsp:include page="/pages/underwriting/endt/common/subPages/endtPerilInformation.jsp"></jsp:include> --%>
		</div>
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
	var lineCd = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"));
	var sublineCd = (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd"));
	setCursor("wait");
	if(objUWGlobal.packParId == null) setDocumentTitle("Item Information - Motorcar - Endorsement");
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	setModuleId(getItemModuleId("E", lineCd));	
	
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
		observeAccessibleModule(accessType.SUBPAGE, "GIPIS169", "showDeductible3", /* function() { //remove by steven 08.15.2014 it caused an error on the setEndtPerilForm.
			if($("inputDeductible3") == null){
				showDeductibleModal(3);
			}
		} */"");
	} else {
		disableSubpage("showDeductible3");
	}

	observeAccessibleModule(accessType.BUTTON, "GIPIS198", "btnUploadFleetData", function() {		
		showMe("GIPIWVehicleController?action=showUploadFleetPage&globalParId="+parId, 600);		 
	});
	
	$("showAccessory").observe("click", function(){
		if($("accessory").empty()){
			showAccessoryInfoModal(parId, "0");
		}			
	});
	
	observeReloadForm("reloadForm", showItemInfo);
	observeCancelForm("btnCancel", function(){saveEndtVehicleItems(false);}, showEndtParListing);
	observeSaveForm("btnSave", function(){saveEndtVehicleItems(true);});
	
	loadItemRowObserver();
	showDeductibleModal(1);	//Gzelle 09032015 SR4851
	showDeductibleModal(2);
	showDeductibleModal(3); //added by steven 08.15.2014
	showEndtPerilInfoPage();
	//showMortgageeInfoModal(parId, "0");	
	//showAccessoryInfoModal(parId, "0");
	
	setCursor("default");
	changeTag = 0;
	initializeChangeTagBehavior(saveEndtVehicleItems);
	initializeChangeAttribute();
	checkIfCancelledEndorsement(); // added by: Nica 07.23.2012 - to check if to disable fields if PAR is a cancelled endt
}
catch(e){
	showErrorMessage("motorItemInformationMain", e);
}
</script>
