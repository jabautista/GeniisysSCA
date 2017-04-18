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
			<jsp:include page="/pages/underwriting/parTableGrid/fire/subPages/fireItemInformation.jsp"></jsp:include>
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
		
		<div class="buttonsDiv">
			<input type="button" id="btnCancel"	name="btnCancel"	class="button"	value="Cancel" 	style="width: 100px;" />
			<input type="button" id="btnSave" 	name="btnSave" 		class="button"	value="Save" 	style="width: 100px;" />			
		</div>
	</form>
</div>

<script type="text/javascript">
try{
	var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
	var lineCd = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : getLineCd()/*$F("globalLineCd")*/);
	var sublineCd = (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd"));
	setCursor("wait");
	if(objUWGlobal.packParId == null) setDocumentTitle("Item Information - Fire");
	//initializeAccordion();
	initializeItemAccordion();	
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	setModuleId(getItemModuleId("P", getLineCd()));	
	
	observeItemMainFormButtons();

	setCursor("default");
	changeTag = 0;
	initializeChangeTagBehavior(saveFireItems);
	initializeChangeAttribute();
	hideNotice("");
}catch(e){
	showErrorMessage("Item Info - " + objUWParList.lineCd + " Main Page", e);
}	
</script>