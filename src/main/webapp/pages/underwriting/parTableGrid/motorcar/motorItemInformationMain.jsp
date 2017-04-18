<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="parItemInformationMainDiv" name="parItemInformationMainDiv" style="margin-top: 1px;" changeTagAttr="true">
	<form id="itemInformationForm" name="itemInformationForm">
		<c:if test="${'Y' ne isPack}">
			<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		</c:if>
		
		<div id="addDeleteItemDiv">
			<jsp:include page="/pages/underwriting/parTableGrid/motorcar/subPages/motorItemInformation.jsp"></jsp:include>
		</div>		
		
		<div id="deductibleDetail2" divName="Item Deductible">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Item Deductible</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showDeductible2" name="groItem" tableGrid="tbgItemDeductible" style="margin-left: 5px;">Show</label>
			   		</span>
			   	</div>
			</div>					
			<div id="deductibleDiv2" class="sectionDiv" style="display: none;">
				<jsp:include page="/pages/underwriting/common/deductibles/item/itemDeductibles.jsp"></jsp:include>
			</div>
			<div id="deductibleDiv1" class="sectionDiv" style="display: none;"></div>
			<input type="hidden" id="dedLevel" name="dedLevel" value="2" />
		</div>
		
		<div id="mortgageePopups">
			<input type="hidden" id="mortgageeLevel" name="mortgageeLevel" value="1" />
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Mortgagee Information</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showMortgagee" name="groItem" tableGrid="tbgMortgagee" style="margin-left: 5px;">Show</label>
			   		</span>
			   	</div>
			</div>	
			<div id="mortgageeInfo" class="sectionDiv" style="display: none;">
				<jsp:include page="/pages/underwriting/common/mortgagee/mortgageeInfo.jsp"></jsp:include>
			</div>						
		</div>
		
		<div id="accessoryPopups">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Accessory Information</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showAccessory" name="groItem" tableGrid="tbgAccessory" style="margin-left: 5px;" >Show</label>
			   		</span>
			   	</div>
			</div>
			<div id="accessory" class="sectionDiv" style="display: none;">
				<jsp:include page="/pages/underwriting/common/accessories/accessoryInfo.jsp"></jsp:include>
			</div>
		</div>			
		
		<div id="perilPopups">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="outerDiv">
					<label id="">Peril Information</label> 
					<span class="refreshers" style="margin-top: 0;"> 
						<label id="showPeril" name="groItem" tableGrid="tbgItemPeril" style="margin-left: 5px;">Show</label> 
					</span>
				</div>
			</div>
			<div class="sectionDiv" id="perilInformationDiv" name="perilInformationDiv" style="display: none;">
				<jsp:include page="/pages/underwriting/common/itemperils/parPerilInfo.jsp"></jsp:include>
			</div>
		</div>
		
		<div id="deductibleDetail3">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Peril Deductible</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showDeductible3" name="groItem" tableGrid="tbgPerilDeductible" style="margin-left: 5px;">Show</label>
			   		</span>
			   	</div>
			</div>			
			<div id="deductibleDiv3" class="sectionDiv" style="display: none;">
				<jsp:include page="/pages/underwriting/common/deductibles/peril/perilDeductibles.jsp"></jsp:include>
			</div>
			<input type="hidden" id="dedLevel" name="dedLevel" value="3">
		</div>		
	</form>
</div>
<div class="buttonsDiv">
	<input type="button" id="btnColor" 				name="btnColor" 			class="button" value="Color" 		style="width: 100px;" />
	<input type="button" id="btnMake" 				name="btnMake" 				class="button" value="Make" 		style="width: 100px;" />
	<input type="button" id="btnUploadFleetData" 	name="btnUploadFleetData" 	class="button" value="Fleet Data" 	style="width: 100px;" />
	<input type="button" id="btnMotorCarIssuance"	name="btnMotorCarIssuance"	class="button" value="MC Issuance" 	style="width: 100px;" />
	<input type="button" id="btnCancel" 			name="btnCancel" 			class="button" value="Cancel" 		style="width: 100px;" />
	<input type="button" id="btnSave" 				name="btnSave" 				class="button" value="Save" 		style="width: 100px;" />			
</div>
<script type="text/javascript">
try{
	var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
	var lineCd = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : getLineCd()/*$F("globalLineCd")*/);
	var sublineCd = (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd"));
	setCursor("wait");
	if(objUWGlobal.packParId == null) setDocumentTitle("Item Information - Motorcar"); // andrew - 03.18.2011 - added condition for pack
	//initializeAccordion();
	initializeItemAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	setModuleId(getItemModuleId("P", getLineCd()));		

	observeItemMainFormButtons();
	
	setCursor("default");
	changeTag = 0;
	initializeChangeTagBehavior(saveVehicleItems);
	initializeChangeAttribute();
	hideNotice("");		
	
	observeAccessibleModule(accessType.BUTTON, "GIISS114", "btnColor",  function(){		
		objUWGlobal.callingForm = "GIPIS010";
		showGiiss114();
	});
	
	observeAccessibleModule(accessType.BUTTON, "GIISS103", "btnMake", function(){
		//showMessageBox(objCommonMessage.UNAVAILABLE_MODULE, imgMessage.INFO); // added by andrew - 02.08.2012 - replace if the module is already available
		objUWGlobal.callingForm = "GIPIS010";
		showGIISS103();
	});
	
	/* observeAccessibleModule(accessType.BUTTON, "GIPIS198", "btnUploadFleetData", function(){
		showMessageBox(objCommonMessage.UNAVAILABLE_MODULE, imgMessage.INFO); // added by andrew - 02.08.2012 - replace if the module is already available
	});	 */
	
	observeAccessibleModule(accessType.BUTTON, "GIPIS211", "btnMotorCarIssuance",  function(){ //added by steven 04.11.2014
		showMessageBox(objCommonMessage.UNAVAILABLE_MODULE, imgMessage.INFO); 
	});
	
	$("btnUploadFleetData").observe("click", function() {
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId);
			showUploadFleetData(parId);
		}
	});
}catch(e){
	showErrorMessage("Item Info - " + objUWParList.lineCd + " Main Page", e);
}
</script>
