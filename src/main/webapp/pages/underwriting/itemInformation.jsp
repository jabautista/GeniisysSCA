<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="itemInformationMainDiv" name="itemInformationMainDiv" style="margin-top: 1px; display: none;">
	<div id="message" style="display : none;">${message}</div>	
	<form id="itemInformationForm" name="itemInformationForm">
		<!-- <input type="hidden" name="parId" id="parId" value="${parId}" /> -->
		<!-- <input type="hidden" name="lineCd" id="lineCd" value="${lineCd}" /> -->
		<input type="hidden" id="wpolbasInceptDate"   name="wpolbasInceptDate"	value="${fromDate }" />
		<input type="hidden" id="wpolbasExpiryDate"   name="wpolbasExpiryDate"	value="${toDate }" />
		<input type="hidden" name="sublineCd" id="sublineCd" value="${sublineCd}"/>
		<input type="hidden" name="itemCount" id="itemCount" value="${itemCount}">
		<input type="hidden" name="pageName" id="pageName" value="itemInformation" />
		<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		<jsp:include page="/pages/underwriting/subPages/itemInformation.jsp"></jsp:include>
		<div id="deductibleDiv1" class="sectionDiv" style="display: none;" changeTagAttr="true">
		</div>
		<c:choose>
			<c:when test="${lineCd eq 'MC'}">
				<jsp:include page="/pages/underwriting/subPages/motorItemInformationAdditional.jsp"></jsp:include>
				<input type="hidden" id="dedLevel" name="dedLevel" value="1">
				<div id="deductibleDetail2">					
					<div id="outerDiv" name="outerDiv">
						<div id="innerDiv" name="innerDiv">
					   		<label>Item Deductible</label>
					   		<span class="refreshers" style="margin-top: 0;">
					   			<label id="showDeductible2" name="gro" style="margin-left: 5px;">Show</label>
					   		</span>
					   	</div>
					</div>
					<div id="deductibleDiv2" class="sectionDiv" style="display: none;" changeTagAttr="true">
					</div>
					<input type="hidden" id="dedLevel" name="dedLevel" value="2">
				</div>
				<div id="mortgageePopups">
					<div id="outerDiv" name="outerDiv">
						<div id="innerDiv" name="innerDiv">
					   		<label>Mortgagee Information</label>
					   		<span class="refreshers" style="margin-top: 0;">
					   			<label id="showMortgagee" name="gro" style="margin-left: 5px;">Show</label>
					   		</span>
					   	</div>
					</div>	
					<div id="mortgageeInfo" class="sectionDiv" style="display: none;" changeTagAttr="true"></div>			
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
					<div id="accessory" class="sectionDiv" style="display: none;" changeTagAttr="true"></div>
				</div>				
			</c:when>
			<c:when test="${lineCd eq 'FI'}">
				<jsp:include page="/pages/underwriting/subPages/fireItemInformationAdditional.jsp"></jsp:include>
				<div id="deductibleDetail2">
					<div id="outerDiv" name="outerDiv">
						<div id="innerDiv" name="innerDiv">
					   		<label>Item Deductible</label>
					   		<span class="refreshers" style="margin-top: 0;">
					   			<label id="showDeductible2" name="gro" style="margin-left: 5px;">Show</label>
					   		</span>
					   	</div>
					</div>					
					<div id="deductibleDiv2" class="sectionDiv" style="display: none;" changeTagAttr="true">
					</div>
					<input type="hidden" id="dedLevel" name="dedLevel" value="2">
				</div>
				<div id="mortgageePopups">
					<div id="outerDiv" name="outerDiv">
						<div id="innerDiv" name="innerDiv">
					   		<label>Mortgagee Information</label>
					   		<span class="refreshers" style="margin-top: 0;">
					   			<label id="showMortgagee" name="gro" style="margin-left: 5px;">Show</label>
					   		</span>
					   	</div>
					</div>	
					<div id="mortgageeInfo" class="sectionDiv" style="display: none;" changeTagAttr="true"></div>			
				</div>
			</c:when>
			<c:when test="${lineCd eq 'MN'}">
				<jsp:include page="/pages/underwriting/subPages/marineCargoItemInfoAdditional.jsp"></jsp:include>
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
						<jsp:include page="/pages/underwriting/pop-ups/listOfCarriers.jsp"></jsp:include>
					</div>			
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
					<div id="deductibleDiv2" class="sectionDiv" style="display: none;">
					</div>
					<input type="hidden" id="dedLevel" name="dedLevel" value="2">
				</div>
			</c:when>
			<c:when test="${lineCd eq 'AV'}">
				<jsp:include page="/pages/underwriting/subPages/aviationItemInfoAdditional.jsp"></jsp:include>
				<div id="deductibleDetail2">
					<div id="outerDiv" name="outerDiv">
						<div id="innerDiv" name="innerDiv">
					   		<label>Item Deductible</label>
					   		<span class="refreshers" style="margin-top: 0;">
					   			<label id="showDeductible2" name="gro" style="margin-left: 5px;">Show</label>
					   		</span>
					   	</div>
					</div>					
					<div id="deductibleDiv2" class="sectionDiv" style="display: none;">
					</div>
					<input type="hidden" id="dedLevel" name="dedLevel" value="2">
				</div>
			</c:when>
			<c:when test="${lineCd eq 'CA'}">
				<jsp:include page="/pages/underwriting/subPages/casualtyItemInfoAdditional.jsp"></jsp:include>
				<div id="groupedItemsPopup">
					<div id="outerDiv" name="outerDiv">
						<div id="innerDiv" name="innerDiv">
					   		<label>Grouped Items</label>
					   		<span class="refreshers" style="margin-top: 0;">
					   			<label id="showGroupedItems" name="gro" style="margin-left: 5px;">Show</label>
					   		</span>
					   	</div>
					</div>	
					<div id="groupedItemsInfo" class="sectionDiv" style="display: none;">
						<jsp:include page="/pages/underwriting/pop-ups/groupedItems.jsp"></jsp:include>
					</div>			
				</div>
				<div id="personnelInformationPopup">
					<div id="outerDiv" name="outerDiv">
						<div id="innerDiv" name="innerDiv">
					   		<label>Personnel Information</label>
					   		<span class="refreshers" style="margin-top: 0;">
					   			<label id="showPersonnelInformation" name="gro" style="margin-left: 5px;">Show</label>
					   		</span>
					   	</div>
					</div>	
					<div id="personnelInformationInfo" class="sectionDiv" style="display: none;">
						<jsp:include page="/pages/underwriting/pop-ups/personnelInformation.jsp"></jsp:include>
					</div>			
				</div>
				<div id="otherInformationPopup">
					<div id="outerDiv" name="outerDiv">
						<div id="innerDiv" name="innerDiv">
					   		<label>Other Information</label>
					   		<span class="refreshers" style="margin-top: 0;">
					   			<label id="showOtherInformation" name="gro" style="margin-left: 5px;">Show</label>
					   		</span>
					   	</div>
					</div>	
					<div id="otherInformationInfo" class="sectionDiv" style="display: none;">
						<jsp:include page="/pages/underwriting/pop-ups/otherInformation.jsp"></jsp:include>
					</div>			
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
					<div id="deductibleDiv2" class="sectionDiv" style="display: none;">
					</div>
					<input type="hidden" id="dedLevel" name="dedLevel" value="2">
				</div>
			</c:when>
			<c:when test="${lineCd eq 'MH'}">
				<jsp:include page="/pages/underwriting/subPages/marineHullItemInfoAdditional.jsp"></jsp:include>
				<div id="deductibleDetail2">
					<div id="outerDiv" name="outerDiv">
						<div id="innerDiv" name="innerDiv">
					   		<label>Item Deductible</label>
					   		<span class="refreshers" style="margin-top: 0;">
					   			<label id="showDeductible2" name="gro" style="margin-left: 5px;">Show</label>
					   		</span>
					   	</div>
					</div>					
					<div id="deductibleDiv2" class="sectionDiv" style="display: none;">
					</div>
					<input type="hidden" id="dedLevel" name="dedLevel" value="2">
				</div>
			</c:when>
			<c:when test="${lineCd eq 'AH'}"> 
				<jsp:include page="/pages/underwriting/subPages/accidentItemInfoAdditional.jsp"></jsp:include>
				<div id="personalAdditionalInfoDetail">
					<div id="outerDiv" name="outerDiv">
						<div id="innerDiv" name="innerDiv">
					   		<label>Personal Additional Information</label>
					   		<span class="refreshers" style="margin-top: 0;">
					   			<label id="showPersonalAdditionalInfo" name="gro" style="margin-left: 5px; display:none">Show</label>
					   		</span>
					   	</div>
					</div>					
					<div id="personalAdditionalInformationInfo" class="sectionDiv" style="display: none;">
						<jsp:include page="/pages/underwriting/par/accident/subPages/accidentItemInfoAdditional.jsp"></jsp:include>
					</div>	
				</div>
				<div id="beneficiaryDetail">
					<div id="outerDiv" name="outerDiv">
						<div id="innerDiv" name="innerDiv">
					   		<label>Beneficiary Information</label>
					   		<span class="refreshers" style="margin-top: 0;">
					   			<label id="showBeneficiary" name="gro" style="margin-left: 5px;">Show</label>
					   		</span>
					   	</div>
					</div>					
					<div id="beneficiaryInformationInfo" class="sectionDiv" style="display: none;">
						<jsp:include page="/pages/underwriting/pop-ups/beneficiaryInformation.jsp"></jsp:include>
					</div>	
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
					<div id="deductibleDiv2" class="sectionDiv" style="display: none;">
					</div>
					<input type="hidden" id="dedLevel" name="dedLevel" value="2">
				</div>
			</c:when>
			<c:when test="${lineCd eq 'EN'}">
				<script type="text/javascript">
					$("btnCopyItemInfo").hide();
					$("btnCopyItemPerilInfo").hide();
					if($F("sublineCd") == "BPV") {
						$("btnLocation").show();
						$("btnDefaultLoc").show();
					}
				</script>
				<!-- 
				<div id="deductibleDiv2" class="sectionDiv" style="display: block;">
				</div>
				<input type="hidden" id="dedLevel" name="dedLevel" value="2">
				 -->
				<div id="hidItemLoc" style="display: none;">
					<c:forEach var="itemLoc" items="${itemLoc}">
						<input type="hidden" id="itemLoc${itemLoc.itemNo}" name="itemLoc" value="${itemLoc.itemNo}" />
					</c:forEach>
				</div>
				<div id="insertLocations" name="insertLocations" style="visibility: hidden;"></div>
				<div id="deleteLocations" name="deleteLocations" style="visibility: hidden;"></div> 
				 
				<div id="deductibleDetail2">
					<div id="outerDiv" name="outerDiv">
						<div id="innerDiv" name="innerDiv">
					   		<label>Item Deductible</label>
					   		<span class="refreshers" style="margin-top: 0;">
					   			<label id="showDeductible2" name="gro" style="margin-left: 5px;">Show</label>
					   		</span>
					   	</div>
					</div>					
					<div id="deductibleDiv2" class="sectionDiv" style="display: none;">
					</div>
					<input type="hidden" id="dedLevel" name="dedLevel" value="2">
				</div>
			</c:when>
		</c:choose>		
		<jsp:include page="/pages/underwriting/subPages/parPerilInformation.jsp"></jsp:include>
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
		<c:choose>
			<c:when test="${lineCd eq 'MC'}">				
				<div class="buttonsDiv">					
					<input type="button" id="btnColor" 				name="btnColor" 			class="button" value="Color" />
					<input type="button" id="btnMake" 				name="btnMake" 				class="button" value="Make" />
					<input type="button" id="btnUploadFleetData" 	name="btnUploadFleetData" 	class="button" value="Upload Fleet Data" />
					<input type="button" id="btnMotorCarIssuance"	name="btnMotorCarIssuance"	class="button" value="View Motorcar Issuance" />
					<input type="button" id="btnCancel" 			name="btnCancel" 			class="button" value="Cancel" />
					<input type="button" id="btnSave" 				name="btnSave" 				class="button" value="Save" />
				</div>
				<script type="text/javascript">
					/*
					$("btnAccessories").observe("click", 
						function(){
							var itemNos = $F("itemNumbers").trim();
							var tempItemNumbers = $F("tempItemNumbers");

							if((tempItemNumbers.indexOf($F("itemNo")) < 0) && (itemNos.indexOf($F("itemNo")) < 0)){
								messageAlertSelectItem();
							} else{
								if($F("cocYY") == "" || $F("motorNo") == "" || $F("serialNo") == "" || $F("motorType") == "" || $F("sublineType") == ""){
									showMessageBox("This item has no COC number.", imgMessage.INFO); // I 
								}
								var parId = $F("globalParId");
								var itemNo = $F("itemNo");
								showAccessoryInfoModal(parId,itemNo);
							}		
					});*/
					
					try {
					$("btnColor").observe("click", 
						function(){
							var itemNos = $F("itemNumbers").trim();
							var tempItemNumbers = $F("tempItemNumbers");

							if((tempItemNumbers.indexOf($F("itemNo")) < 0) && (itemNos.indexOf($F("itemNo")) < 0)){
								messageAlertSelectItem();
							} else{
								if($F("motorType") == "" || $F("sublineType") == "" || $F("motorNo") == "" || $F("serialNo") == ""){
									showMessageBox("Complete the policy information before proceeding to Color Maintenance screen.", imgMessage.INFO); /* I */
									return false;
								}
								
								if(tempItemNumbers.indexOf($F("itemNo")) > -1){
									messageAlertUnsavedChanges("Color Maintenance");
								}
							}
					});
					
					$("btnMake").observe("click", 
						function() { 
							var itemNos = $F("itemNumbers").trim();
							var tempItemNumbers = $F("tempItemNumbers");
					
							if((tempItemNumbers.indexOf($F("itemNo")) < 0) && (itemNos.indexOf($F("itemNo")) < 0)){
								messageAlertSelectItem();
							} else{
								if($F("motorType") == "" || $F("sublineType") == "" || $F("motorNo") == "" || $F("serialNo") == ""){
									showMessageBox("Complete the policy information before proceeding to Make Maintenance screen.", imgMessage.INFO); /* I */
									return false;
								}
								
								if(tempItemNumbers.indexOf($F("itemNo")) > -1){
									messageAlertUnsavedChanges("Make Maintenance");
								} 
							}
					});

					//$("btnUploadFleetData").observe("click", 
					observeAccessibleModule(accessType.BUTTON, "GIPIS198", "btnUploadFleetData", // andrew - 09.28.2010 - change observe 
						function() {
							/*var itemNos = $F("itemNumbers").trim();
							var tempItemNumbers = $F("tempItemNumbers");
					
							if((tempItemNumbers.indexOf($F("itemNo")) < 0) && (itemNos.indexOf($F("itemNo")) < 0)){
								messageAlertSelectItem();
							} else{*/ 
								showMe("GIPIParMCItemInformationController?action=showUploadFleetPage&globalParId="+$F("globalParId"), 600);
							//} 
						});
					} catch (e) {
						showErrorMessage("itemInformation.jsp", e);
					}
				</script>
			</c:when>
			<c:when test="${lineCd eq 'FI'}">				
				<div class="buttonsDiv">
					<input type="button" id="btnCancel"	name="btnCancel" 	class="button" value="Cancel" />					
					<input type="button" id="btnSave"	name="btnSave" 		class="button" value="Save" />										
				</div>
			</c:when>
			<c:when test="${lineCd eq 'MN'}">				
				<div class="buttonsDiv">
					<input type="button" id="btnCancel"	name="btnCancel" 	class="button" value="Cancel" />					
					<input type="button" id="btnSave"	name="btnSave" 		class="button" value="Save" />										
				</div>
			</c:when>
			<c:when test="${lineCd eq 'AV'}">				
				<div class="buttonsDiv">
					<input type="button" id="btnCancel"	name="btnCancel" 	class="button" value="Cancel" />					
					<input type="button" id="btnSave"	name="btnSave" 		class="button" value="Save" />										
				</div>
			</c:when>
			<c:when test="${lineCd eq 'CA'}">				
				<div id="casualtyButtonsDiv" class="buttonsDiv">
					<input type="button" id="btnMaintainLocation" 	name="btnMaintainLocation" 	class="button" value="Maintain Location" />
					<input type="button" id="btnUploadFleetData" 	name="btnUploadFleetData" 	class="button" value="Upload Property Floater" />
					<input type="button" id="btnCancel"	name="btnCancel" 	class="button" value="Cancel" />					
					<input type="button" id="btnSave"	name="btnSave" 		class="button" value="Save" />										
				</div>
			</c:when>
			<c:when test="${lineCd eq 'MH'}">				
				<div class="buttonsDiv">
					<input type="button" id="btnCancel"	name="btnCancel" 	class="button" value="Cancel" />					
					<input type="button" id="btnSave"	name="btnSave" 		class="button" value="Save" />										
				</div>
			</c:when>
			<c:when test="${lineCd eq 'AH'}">				
				<div class="buttonsDiv">
					<input type="button" id="btnCancel"	name="btnCancel" 	class="button" value="Cancel" />					
					<input type="button" id="btnSave"	name="btnSave" 		class="button" value="Save" />										
				</div>
			</c:when>
			<c:when test="${lineCd eq 'EN'}">				
				<div class="buttonsDiv">
					<input type="button" id="btnCancel"	name="btnCancel" 	class="button" value="Cancel" />					
					<input type="button" id="btnSave"	name="btnSave" 		class="button" value="Save" />										
				</div>
			</c:when>
		</c:choose>		
	</form>
</div>

<script type="text/javascript">

	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	setModuleId(getItemModuleId("P", $F("globalLineCd")));
	//$("btnCancel").observe("click", getLineListingForPAR);
	
	if($F("globalLineCd") != "EN") {
		observeAccessibleModule(accessType.SUBPAGE, "GIPIS169", "showDeductible2", function() { // andrew - 09.27.2010 - added this function to observe only user accessible modules
			if($("inputDeductible2") == null){
				showDeductibleModal(2);
			}
		});
	}
	
	observeAccessibleModule(accessType.SUBPAGE, "GIPIS038", "showPeril", ""); // andrew - 09.28.2010 - added this function to observe only user accessible modules
	
	if (checkUserModule("GIPIS038")) { // check if user has access to peril module
		observeAccessibleModule(accessType.SUBPAGE, "GIPIS169", "showDeductible3", function() { // andrew - 09.27.2010 - added this function to observe only user accessible modules
			if($("inputDeductible3") == null){
				showDeductibleModal(3);
			}
		});
	} else {
		disableSubpage("showDeductible3");
	}

	if($F("globalLineCd") != "MN" && $F("globalLineCd") != "AV" && $F("globalLineCd") != "CA" && $F("globalLineCd") != "AH" && $F("globalLineCd") != "MH"){ //orio MH condition added by cris05.07.10
		//$("showMortgagee").observe("click", function(){
		observeAccessibleModule(accessType.SUBPAGE, "GIPIS168", "showMortgagee", function() { // andrew - 09.28.2010 - added this function to observe only user accessible modules		
			if($("mortgageeInfo").empty()){
				showMortgageeInfoModal($F("globalParId"), "0");
			}		
		});
	}
	
	if($F("globalLineCd") == "MC"){
		$("showAccessory").observe("click", function(){
			if($("accessory").empty()){
				showAccessoryInfoModal($F("globalParId"), "0");
			}			
		});			
	}

	if( $F("globalLineCd") == "EN") {
		var sublineCd = $F("globalSublineCd");
		if(sublineCd == "BPV") {
			//var btn = '<input type="button" class="button" style="width: 70px;  margin: 5px 0px 5px 0px;" id="btnLocation" value="Location"/>';
			//$("dedButtonsDiv2").insert({bottom: btn});
			//btn = '<input type="button" class="button" style="width: 120px; margin-left: 5px;" id="btnDefaultLoc" value="Default Location"/>';
			//$("dedButtonsDiv2").insert({bottom: btn});
			var exists = false;
			$$("input[name='itemLoc']").each(function(iLoc) {
				$$("div#parItemTableContainer div[name='rowItem']").each(function(r){
					if(iLoc.value == r.down("input", 1).value) {
						exists = true;
					}
				});
			});
			if(exists == true) {
				disableButton("btnDefaultLoc");
			}

			$("btnLocation").observe("click", function() {
				showOverlayContent2(contextPath+"/GIPIWEngineeringItemController?action=showLocationSelect&locType=1&globalParId="+$F("globalParId"), "Location", 560, "");
			});

			$("btnDefaultLoc").observe("click", function() {
				showOverlayContent2(contextPath+"/GIPIWEngineeringItemController?action=showLocationSelect&locType=2&globalParId="+$F("globalParId"), "Location", 560, "");
			});

		}
	}

	showDeductibleModal(1);
	showDeductibleModal(2);
	showDeductibleModal(3); //added by BRY
	
	/* for perils */
	new Ajax.Request(contextPath+"/GIISPerilController?action=checkIfPerilExists&lineCd="+$F("globalLineCd")+"&nbtSublineCd="+$F("sublineCd"), {
		method: "POST",
		evalScripts: true,
		asynchronous: false,
		//postBody: Form.serialize("parInformationForm"),
		onComplete: function (response)	{
			if (checkErrorOnResponse(response)) {
				if (response.responseText == 'Y'){
					enableButton("btnCreatePerils");
				}
			}
			//$("parInformationMainDiv").show();
		}
	});

	if ($F("globalPackParId") != null ){
		if ($F("itemCount") > 1){
			$("btnCopyPeril").removeClassName("disabledButton");
			$("btnCopyPeril").addClassName("button");
			$("btnCopyPeril").enable();
		}
	}
	
	//loadPerilListingTable();
	/* end for perils */		
	
	$("btnCancel").observe("click", 
		function() {
			if(changeTag == 1){			
				showConfirmBox("Confirmation", "There are unsaved changes you have made. Do you want to cancel it?", "Yes", "No", cancelPage, stopProcess);			
			}else{
				cancelPage();
			}
		});			

	function cancelPage(){
		Effect.Fade("parInfoDiv", {
			duration: .001,
			afterFinish: function () {
				if ($("parListingMainDiv").down("div", 0).next().innerHTML.blank()) {										
					showParListing();						
				} else {
					$("parInfoMenu").hide();
					Effect.Appear("parListingMainDiv", {duration: .001});
				}
				$("parListingMenu").show();
			}
		});	
	}

	$("btnSave").observe("click", 
		function() {
			//var tempItemNumbers = $F("tempItemNumbers");			
			var itemNos				 = $F("tempItemNumbers");
			var delItemNos			 = $F("deleteItemNumbers");
			var mortgageeItemNos 	 = $F("tempMortgageeItemNos");
			var deductibleItemNos	 = $F("tempDeductibleItemNos");
			var accessoryItemNos	 = $F("globalLineCd") == "MC" ? $F("tempAccessoryItemNos") : "";
			var perilItemNos		 = $F("tempPerilItemNos");
			var carrierItemNos		 = $F("tempCarrierItemNos");
			var groupItemsItemNos	 = $F("tempGroupItemsItemNos");
			var personnelItemNos 	 = $F("tempPersonnelItemNos");
			var beneficiaryItemNos 	 = $F("tempBeneficiaryItemNos");
			var carrierSaveList	     = "Y";
			var groupedItemsSaveList = "Y";
			var personnelSaveList	 = "Y";
			var benefeciarySaveList	 = "Y";
			
			$$("input[name='itemNos']").each(
				function(item){
					itemNos = itemNos + $F(item) + " ";
				});
			
			if(masterDetail){
				showMessageBox("Please update item changes first before saving.", imgMessage.ERROR);
				$("itemNo").scrollTo();
				return false;
			}else{
				saveTransaction();
			}					
			
			return false;
			/* FOR CARRIER LIST */
			if(carrierItemNos.trim() != "" && carrierSaveList == "Y"){
				if ($("paramVesselCd").value != $("vesselCd").value){
					showMessageBox("Please update the item first before saving.", imgMessage.ERROR);
					return false;
				} else {
					saveCarrierModal();		
				}	
			}
			/* END FOR CARRIER LIST */
			
			/* FOR GROUP LIST AND PERSONNEL LIST */
			if ((groupItemsItemNos.trim() != "" && groupedItemsSaveList == "Y") || (personnelItemNos.trim() != "" && personnelSaveList == "Y")){
				saveCasualtyItemModal();			
			}
			/* END FOR GROUP LIST AND PERSONNEL LIST */
			
			/* FOR BENEFICIARY LIST */
			if (beneficiaryItemNos.trim() != "" && benefeciarySaveList == "Y"){
				saveBeneficiaryItemModal();	
			}	
			/* END FOR BENEFICIARY LIST */			
									
		});	

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

	$("reloadForm").observe("click", function() {		
		if(changeTag == 1){			
			showConfirmBox("Confirmation", "Reloading form doesn't save the changes you had made. Do you want to continue?", "Yes", "No", showItemInfo, stopProcess);			
		}else{
			showItemInfo();
		}				
	});
	
	function saveTransaction(){
		disableAllElements();
		//$("itemInformationForm").disable();
		
		// save details depending on lineCd
		var lineCd = $F("globalLineCd");
		var controller = "";
		var action = "";
		var objParameters = new Object();
		
		if(objUWGlobal.lineCd == objLineCds.MC || objUWGlobal.menuLineCd == objLineCds.MC){
			controller = "GIPIParMCItemInformationController";
			action = "saveGipiParVehicle";
		} else if(objUWGlobal.lineCd == objLineCds.FI || objUWGlobal.menuLineCd == objLineCds.FI){
			controller = "GIPIWFireItmController";
			action = "saveGipiParFireItem";
		} else if(objUWGlobal.lineCd == objLineCds.MN || objUWGlobal.menuLineCd == objLineCds.MN){
			controller = "GIPIWCargoController";
			action = "saveGipiParMarineCargoItem";
			carrierSaveList = "N";
		} else if(objUWGlobal.lineCd == objLineCds.AV || objUWGlobal.menuLineCd == objLineCds.AV){
			controller = "GIPIWAviationItemController";
			action = "saveGipiParAviationItem";
		} else if(objUWGlobal.lineCd == objLineCds.CA || objUWGlobal.menuLineCd == objLineCds.CA){
			controller = "GIPIWCasualtyItemController";
			action = "saveGipiParCasualtyItem";
			groupedItemsSaveList = "N";
			personnelSaveList    = "N";
		} else if(objUWGlobal.lineCd == objLineCds.AC || objUWGlobal.menuLineCd == objLineCds.AC){ //belle
			controller = "GIPIWAccidentItemController";
			action = "saveGipiParAccidentItem";
			benefeciarySaveList	 = "N";
		} else if(objUWGlobal.lineCd == objLineCds.MH || objUWGlobal.menuLineCd == objLineCds.MH){		
			controller = "GIPIWItemVesController";
			action = "saveGipiParItemVes";
		} else if(objUWGlobal.lineCd == objLineCds.EN || objUWGlobal.menuLineCd == objLineCds.EN){
			controller = "GIPIWEngineeringItemController";
			action = "saveGipiParItemEN";
		}
		
		objParameters.setMortgagees	= prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objMortgagees));
		objParameters.delMortgagees = prepareJsonAsParameter(getDelFilteredObjs(objMortgagees));
		objParameters.setPerils 	= prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objGIPIWItemPeril));		
		objParameters.delPerils 	= prepareJsonAsParameter(getDeletedJSONObjects(objGIPIWItemPeril));	
		objParameters.setWCs 		= prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objGIPIWPolWC));
		//objParameters.delMortgagees = prepareJsonAsParameter(getDeletedJSONObjects(objMortgagees));

		new Ajax.Request(contextPath + "/"+controller+"?action="+action + "&parameters=" + encodeURIComponent(JSON.stringify(objParameters)), {
			method : "POST",
			postBody : Form.serialize("uwParParametersForm") + "&" + Form.serialize("itemInformationForm"),											
			asynchronous : true,
			evalScripts : true,
			onCreate : 
				function(){
					showNotice("Saving item details, please wait...");
				},
			onComplete :
				function(response){						
					hideNotice("");
					if (checkErrorOnResponse(response)) {														
						if(response.responseText == "SUCCESS"){									
							//$("tempVariable").value = tempVar; // bring back the value of tempVariable								
							enableAllElements();
							//$("itemInformationForm").enable();								
							showWaitingMessageBox("Record Saved.", imgMessage.INFO, showItemInfo);																
						}					
					}						
				}
		});
	}	
	
	function stopProcess(){
		return false;
	}
	changeTag = 0;
	initializeChangeTagBehavior(saveTransaction);
	initializeItemInfoTagBehavior("masterDetail");
</script>