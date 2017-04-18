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
	<form id="enItemInfoForm" name="enItemInfoForm">
		<c:if test="${'Y' ne isPack}">
			<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		</c:if>
		<div id="enItemListingDiv">
			<jsp:include page="/pages/underwriting/endt/jsonEngineering/subPages/endtENItemInformation.jsp"></jsp:include>
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
			<div id="deductibleDiv3" class="sectionDiv" style="display: none;" changeTagAttr="true">
			</div>
			<input type="hidden" id="dedLevel" name="dedLevel" value="3">
		</div>
		
		<div id="hidItemLoc" style="display: none;">
			<c:forEach var="itemLoc" items="${itemLoc}">
				<input type="hidden" id="itemLoc${itemLoc.itemNo}" name="itemLoc" value="${itemLoc.itemNo}" />
			</c:forEach>
		</div>
		<div id="insertLocations" name="insertLocations" style="visibility: hidden;"></div>
		<div id="deleteLocations" name="deleteLocations" style="visibility: hidden;"></div> 
		
		<div class="buttonsDiv">
			<input type="button" id="btnCancel" 			name="btnCancel" 			class="button" value="Cancel" style="width: 100px;" />
			<input type="button" id="btnSave" 				name="btnSave" 				class="button" value="Save" style="width: 100px;" />			
		</div>
	</form>
</div>

<script type="text/javascript">
try {
	var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
	var lineCd = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"));
	var sublineCd = (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd"));
	setCursor("wait");
	if(objUWGlobal.packParId == null) setDocumentTitle("Item Information - Engineering - Endorsement");
	setModuleId(getItemModuleId("E", lineCd));
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();

	formMap = eval((('(' + '${formMap}' + ')').replace(/&#62;/g, ">")).replace(/&#60;/g, "<"));

	objGIPIWItem = JSON.parse(Object.toJSON(formMap.gipiWEnItem));
	objGIPIWPerilDiscount = JSON.parse(Object.toJSON(formMap.gipiWPerilDiscount));
	objItemAnnTsiPrem = JSON.parse(Object.toJSON(formMap.itemAnnTsiPrem));//monmon
	objPolbasics = JSON.parse('${gipiPolbasics}'); // andrew - 08072015 - SR 19335
	objParPolbas = JSON.parse('${gipiWPolbas}'); // andrew - 08072015 - SR 19335
	
	showItemList(objGIPIWItem);

	loadFormVariables(formMap.vars);
	loadFormParameters(formMap.pars);
	loadFormMiscVariables(formMap.misc);
	setDefaultItemForm();

	objItemNoList = [];	
	createItemNoList(objGIPIWItem);

	observeAccessibleModule(accessType.SUBPAGE, "GIPIS169", "showDeductible2", /*function(){
		if($("inputDeductible2") == null){			
			showDeductibleModal(2);
			initializeChangeTagBehavior();			
		}
	}*/"");

	observeAccessibleModule(accessType.SUBPAGE, "GIPIS038", "showPeril", /*function(){
		//showPerilInfoPage();
		initializeChangeTagBehavior();
	}*/"");
	
	if (checkUserModule("GIPIS038")) {
		observeAccessibleModule(accessType.SUBPAGE, "GIPIS169", "showDeductible3", /*function() { //remove by steven 08.15.2014 it caused an error on the setEndtPerilForm.
			if($("inputDeductible3") == null){
				showDeductibleModal(3);
			}
		}*/"");
	} else {
		disableSubpage("showDeductible3");
	}

	$("reloadForm").observe("click", function() {
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
			showItemInfo();
			changeTag = 0;
		}
	});
	
	$("btnCancel").observe("click", function() {
		if (changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
				function() {saveENItems(false); showParListing();}, showParListing, "");
		} else {
			showParListing();	
		}
	});
	
	observeReloadForm("reloadForm", showItemInfo);
	observeCancelForm("btnCancel", function(){saveEndtEngineeringItems(false);}, showEndtParListing);
	observeSaveForm("btnSave", function(){saveEndtEngineeringItems(true);});

	loadItemRowObserver();
	showDeductibleModal(1);
	showDeductibleModal(2);
	showDeductibleModal(3); //added by steven 08.15.2014
	showEndtPerilInfoPage();
	changeTag = 0;
	initializeChangeTagBehavior(saveEndtEngineeringItems);
	initializeChangeAttribute();
} catch(e) {
	showErrorMessage("enItemInformationMain.jsp", e);
}
</script>