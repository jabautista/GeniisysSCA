<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="accidentModalMainDiv" style="height: 525px; overflow-y: auto;">
	<form id="accidentModalForm" name="accidentModalForm">
		<input type="hidden" id="isFromOverWriteBen" value="${isFromOverwriteBen}" />
		<input type="hidden" id="itemPerilExist" name="itemPerilExist" value="" />
		<input type="hidden" id="itemPerilGroupedExist" name="itemPerilGroupedExist" value="" />

		<div id="groupedItemsDetail">
			<div id="outerDiv" name="outerDiv" style="width:872px; background-color:white;">
					<div id="innerDiv" name="innerDiv">
					<label>Grouped Items/Beneficiary Information</label>
						<span class="refreshers" style="margin-top: 0;">
						<label id="showGroupedItems" name="gro2" style="margin-left: 5px;">Hide</label>
					</span>
				</div>
				<jsp:include page="/pages/underwriting/par/accident/subPages/groupedItems/accidentGroupedItems.jsp"></jsp:include>
			</div>
		</div>
			
<!--		<div id="popBenDiv">
			<div id="outerDiv" name="outerDiv" style="width:872px; background-color:white;" >
				<div id="innerDiv" name="innerDiv">
					<label>Copy Benefits</label>
						<span class="refreshers" style="margin-top: 0;">
						<label id="showPopBenefit" name="gro" style="margin-left: 5px;">Hide</label>
					</span>
				</div>
			</div>	
		 	<jsp:include page="/pages/underwriting/par/accident/subPages/groupedItems/accidentPopulateBenefits.jsp"></jsp:include>  
		</div>-->
		
		<div id="coverageDetail">
			<div id="outerDiv" name="outerDiv" style="width:872px; background-color:white;" >
				<div id="innerDiv" name="innerDiv">
					<label>Enrollee Coverage</label>
						<span class="refreshers" style="margin-top: 0;">
						<label id="showCoverage" name="gro3" style="margin-left: 5px;">Show</label>
					</span>
				</div>
			</div>			
 			<jsp:include page="/pages/underwriting/par/accident/subPages/groupedItems/accidentCoverage.jsp"></jsp:include>	 
		</div>
		
		<div id="beneficiaryDetail">
			<div id="outerDiv" name="outerDiv" style="width:872px; background-color:white;" >
				<div id="innerDiv" name="innerDiv">
					<label>Beneficiary Information</label>
						<span class="refreshers" style="margin-top: 0;">
						<label id="showBeneficiary" name="gro" style="margin-left: 5px;">Show</label>
					</span>
				</div>
			</div>			
 			<jsp:include page="/pages/underwriting/par/accident/subPages/groupedItems/accidentBeneficiary.jsp"></jsp:include>	
		</div>
		
		<div class="buttonsDiv">
			<input type="button" class="button"  id="btnCancelGrp" name="btnCancel"  value="Cancel" 	style="width: 60px;" />
			<input type="button" class="button"  id="btnSaveGrp" 	name="btnSave" 	  value="Save" 		style="width: 60px;" />
		</div>	
		
	</form>
</div>

<script type="text/javascript">
	/*
	** This page is not yet in use and unfinished. Currently used for accident grouped items is
	** 	../pages/underwriting/pop-ups/accidentAdditionalInfo.jsp
	*/
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	initializeAccordion();
	initializeAccordion2();

	var groupMap = eval((('(' + '${groupMap}' + ')').replace(/&#62;/g, ">")).replace(/&#60;/g, "<"));
	
	objGIPIWGroupedItems = JSON.parse(Object.toJSON(groupMap.gipiWGroupedItems));
	itemPerilExist = groupMap.itemPerilExist;
	itemPerilGroupedExist = groupMap.itemPerilGroupedExist;
	objWItmperlGrouped = JSON.parse(Object.toJSON(groupMap.gipiWItmperlGrouped));		//for accident coverage
	objWGrpItemBen = JSON.parse(Object.toJSON(groupMap.gipiWGrpItemsBeneficiary));
	objWItmPerilBen = JSON.parse(Object.toJSON(groupMap.gipiWItmperlBeneficiary));
	itemTsi = groupMap.itemTsi;
	
	$("itemPerilExist").value = itemPerilExist;
	$("itemPerilGroupedExist").value = itemPerilGroupedExist; 	
	
	showAcGroupedItemsList(objGIPIWGroupedItems);

	// = = = = = = = = = = = = = = = = = = = = = = = = = = = = 

	function initializeAccordion2()	{
		$$("label[name='gro2']").each(function (label)	{
			label.observe("click", function ()	{
				label.innerHTML = label.innerHTML == "Hide" ? "Show" : "Hide";
				var infoDiv = label.up("div", 1).next().readAttribute("id");
				Effect.toggle(infoDiv, "blind", {duration: .3});
				Effect.toggle("groupedItemsInformationInfo2", "blind", {duration: .3});
			});
		});

		$$("label[name='gro3']").each(function (label)	{
			label.observe("click", function ()	{
				if ($F("itemPerilExist") == "Y" && $F("itemPerilGroupedExist") != "Y"){
					showMessageBox("You cannot insert grouped item perils because there are existing item perils for this item. Please check the records in the item peril module");
					return false;
				} else{
					label.innerHTML = label.innerHTML == "Hide" ? "Show" : "Hide";
					var infoDiv = label.up("div", 1).next().readAttribute("id");
					Effect.toggle(infoDiv, "blind", {duration: .3});
				}		
			});
		});
	}

	$("btnCancelGrp").observe("click", function() {
		changeTag = 0;
		Modalbox.hide();
	});

	$("btnSaveGrp").observe("click", function() {
		try {
			var objParameters = new Object();
			var executeSave = false;
			objParameters.setGrpItemRows = prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objGIPIWGroupedItems));
			objParameters.delGrpItemRows = prepareJsonAsParameter(getDeletedJSONObjects(objGIPIWGroupedItems));
			objParameters.setCoverageRows = prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objWItmperlGrouped));
			objParameters.delCoverageRows = prepareJsonAsParameter(getDeletedJSONObjects(objWItmperlGrouped));
			objParameters.setGrpBenRows = prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objWGrpItemBen));
			objParameters.delGrpBenRows = prepareJsonAsParameter(getDeletedJSONObjects(objWGrpItemBen));
			objParameters.setGrpBenPerils = prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objWItmPerilBen));
			objParameters.delGrpBenPerils = prepareJsonAsParameter(getDeletedJSONObjects(objWItmPerilBen));

			for(attr in objParameters){
				if(objParameters[attr].length > 0){
					executeSave = true;
					break;
				}
			}

			if(executeSave) {
				
			}
		} catch(e) {
			showErrorMessage("saveGrp", e);
		}
	});

	function saveGroupedItems() {
		
	}
</script>