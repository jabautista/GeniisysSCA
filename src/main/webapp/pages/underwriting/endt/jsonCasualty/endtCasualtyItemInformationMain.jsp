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
			<jsp:include page="/pages/underwriting/endt/jsonCasualty/subPages/endtCasualtyItemInformation.jsp"></jsp:include>
		</div>
		
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
				<jsp:include page="/pages/underwriting/par/casualty/subPages/groupedItems/groupedItems.jsp"></jsp:include>
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
				<jsp:include page="/pages/underwriting/par/casualty/subPages/casualtyPersonnel/casualtyPersonnel.jsp"></jsp:include>
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
			<div id="deductibleDiv3" class="sectionDiv" style="display: none;">
			</div>
			<input type="hidden" id="dedLevel" name="dedLevel" value="3">
		</div>
		
		<div class="buttonsDiv">
			<input type="button" id="btnMaintainLocation" 	name="btnMaintainLocation" 		class="button" 	style="width: 120px;" value="Maintain Location" />
			<input type="button" id="btnUpdPropertyFloater" name="btnUpdPropertyFloater" 	class="button" 	style="width: 120px;" value="Property Floater" />
			<input type="button" id="btnCancel"				name="btnCancel"				class="button"	style="width: 120px;" value="Cancel" />
			<input type="button" id="btnSave" 				name="btnSave" 					class="button"	style="width: 120px;" value="Save" />			
		</div>
	</form>
</div>

<script type="text/javascript">
try{
	var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
	var lineCd = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"));
	var sublineCd = (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd"));
	setCursor("wait");
	if(objUWGlobal.packParId == null) setDocumentTitle("Item Information - Casualty - Endorsement");
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	setModuleId(getItemModuleId("E", lineCd));	
	
	showItemList(objGIPIWItem);
		
	setDefaultItemForm();	

	objItemNoList = [];	
	createItemNoList(objGIPIWItem);

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
		observeAccessibleModule(accessType.SUBPAGE, "GIPIS169", "showDeductible3", /* function() { //remove by steven 08.15.2014 it caused an error on the setEndtPerilForm.
			if($("inputDeductible3") == null){
				showDeductibleModal(3);
				//initializeChangeTagBehavior(changeTagFunc);
			}
		} */"");
		//showDeductibleModal(3);
	} else {
		disableSubpage("showDeductible3");
	}
	
	observeReloadForm("reloadForm", showItemInfo);
	observeCancelForm("btnCancel", function(){saveEndtCasualtyItems(false);}, showEndtParListing);
	observeSaveForm("btnSave", function(){saveEndtCasualtyItems(true);});

	loadItemRowObserver();

	showDeductibleModal(1);
	showDeductibleModal(2);
	showDeductibleModal(3); //added by steven 08.15.2014
	showEndtPerilInfoPage();
	
	setCursor("default");
	changeTag = 0;
	initializeChangeTagBehavior(saveEndtCasualtyItems);
	initializeChangeAttribute();
	hideNotice("");
	checkIfCancelledEndorsement(); // nica
}catch(e){
	showErrorMessage("Endorsement Casualty Main Page", e);
}
</script>