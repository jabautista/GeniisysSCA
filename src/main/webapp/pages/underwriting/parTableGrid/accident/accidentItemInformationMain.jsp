<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %> 

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="parItemInformationMainDiv" name="parItemInformationMainDiv" style="margin-top: 1px;">
	<form id="itemInformationForm" name="itemInformationForm">
		<div changeTagAttr="true"> <!-- added by steven 8.22.2012 -->
			<input type="hidden" id="wpolbasInceptDate" name="wpolbasInceptDate" value="" />
			<input type="hidden" id="wpolbasExpiryDate" name="wpolbasExpiryDate" value="" />
			<c:if test="${'Y' ne isPack}">		
				<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
			</c:if>
		</div>
		<div id="addDeleteItemDiv">
			<jsp:include page="/pages/underwriting/parTableGrid/accident/subPages/accidentItemInformation.jsp"></jsp:include>
		</div>
		<div changeTagAttr="true"> <!-- added by steven 8.22.2012 -->
			<div id="personalAdditionalInfoDetail"">
				<div id="outerDiv" name="outerDiv">
					<div id="innerDiv" name="innerDiv">
				   		<label>Personal Additional Information</label>
				   		<span class="refreshers" style="margin-top: 0;">
				   			<label id="showPersonalAdditionalInfo" name="gro" style="margin-left: 5px; display:none">Show</label>
				   		</span>
				   	</div>
				</div>					
				<div id="personalAdditionalInformationInfo" class="sectionDiv" style="display: none;">
					<jsp:include page="/pages/underwriting/parTableGrid/accident/subPages/accidentPersonalAddlInfo.jsp"></jsp:include>	
				</div>	
			</div>
			
			<div id="beneficiaryDetail">
				<div id="outerDiv" name="outerDiv">
					<div id="innerDiv" name="innerDiv">
				   		<label>Beneficiary Information</label>
				   		<span class="refreshers" style="margin-top: 0;">
				   			<label id="showBeneficiary" name="groItem" tableGrid="tbgBeneficiary" style="margin-left: 5px;">Show</label>
				   		</span>
				   	</div>
				</div>					
				<div id="beneficiaryInformationInfo" class="sectionDiv" style="display: none;">	
					<jsp:include page="/pages/underwriting/parTableGrid/accident/subPages/beneficiary/beneficiaryInfo.jsp"></jsp:include>
				</div>	
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
			
			<div class="buttonsDiv" changeTagAttr="true">
				<input type="button" id="btnCancel"	name="btnCancel"	class="button" value="Cancel" 	style="width: 100px;" />
				<input type="button" id="btnSave"	name="btnSave"		class="button" value="Save" 	style="width: 100px;" />			
			</div>
		</div>
	</form>
</div>

<script type="text/javascript">
try {
	var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
	var lineCd = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"));
	var menuLineCd = (objUWGlobal.packParId != null ? objCurrPackPar.menuLineCd : objUWGlobal.menuLineCd);
	var sublineCd = (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd"));
	setCursor("wait");
	
	if(objUWGlobal.packParId == null) setDocumentTitle("Item Information - Accident");
	setModuleId(getItemModuleId("P", lineCd, menuLineCd));
	//initializeAccordion();
	initializeItemAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();		
	
	observeItemMainFormButtons();
	
	setCursor("default");
	changeTag = 0;
	initializeChangeTagBehavior(saveAHItem);
	initializeChangeAttribute();
	hideNotice("");
} catch(e) {
	showErrorMessage("Item Info - " + objUWParList.lineCd + " Main Page", e);
}
</script>