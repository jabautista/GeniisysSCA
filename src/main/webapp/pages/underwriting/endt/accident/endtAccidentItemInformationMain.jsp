<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="endtItemInformationMainDiv" name="endtItemInformationMainDiv" style="margin-top: 1px;">	
	<form id="itemInformationForm" name="itemInformationForm">
		<!-- module variables -->
		<input type="hidden" 	name="varEndtTaxSw" 	id="varEndtTaxSw" 	value="${endtTaxSw}"/>
		<input type="hidden" 	name="varPackParId" 	id="varPackParId" 	value="${varPackParId}"/>
		<input type="hidden" 	name="varPost" 	 		id="varPost" 	   	value=""/>
		<input type="hidden" 	name="varPost2" 	 	id="varPost2" 	   	value="Y"/>
		<input type="hidden" 	name="varTotalDeductibles"		id="varTotalDeductibles" 		value="" />
		<input type="hidden" 	name="varNewSw2" 	 		id="varNewSw2" 	   	value="Y"/>
		<input type="hidden" 	name="varGroupSw" 	 		id="varGroupSw" 	   	value="N"/>
		<input type="hidden"    name="varCopyItemTag"	id="varCopyItemTag" value="N" />
		<input type="hidden"    name="varNegateItem"	id="varNegateItem"  value="N" />
		<input type="hidden"    name="varCompSw"	id="varCompSw"  value="${wPolBasic.compSw }<c:if test="${empty wPolBasic.compSw}">N</c:if>" />
		<input type="hidden" 	name="varProrateFlag" 	 	id="varProrateFlag" 	   	value="${wPolBasic.prorateFlag }"/>
		<input type="hidden" 	name="varDeductibleExist" 	id="varDeductibleExist" 	   	value="${pDeductibleExist }"/>
		
		<input type="hidden" 	name="varEffDate" 	 	id="varEffDate" 	   	value="${effDate }"/>
		<input type="hidden" 	name="varEndtExpiryDate" 	 	id="varEndtExpiryDate" 	   	value="${endtExpiryDate }"/>
		<input type="hidden" 	name="varProvPremTag" 	 	id="varProvPremTag" 	   	value="${wPolBasic.provPremTag }"/>
		<input type="hidden" 	name="varProvPremPct" 	 	id="varProvPremPct" 	   	value="${wPolBasic.provPremPct }"/>
		<input type="hidden" 	name="varShortRtPercent" 	 	id="varShortRtPercent" 	   	value="${wPolBasic.shortRtPercent }"/>
		<input type="hidden" 	name="varPackPolFlag" 	 	id="varPackPolFlag" 	   	value="${wPolBasic.packPolFlag }"/>
		<input type="hidden" 	name="varCoInsSw" 	 	id="varCoInsSw" 	   	value="${wPolBasic.coInsuranceSw }"/>
		<input type="hidden"    name="varDiscExist"	    id="varDiscExist" 	value="${discExists }" />
		<input type="hidden"    name="varExpiryDate"	id="varExpiryDate" 	value="${expiryDate }" />
		<input type="hidden"    name="varPhilPeso"		id="varPhilPeso" 	value="${vPhilPeso }" />
		<input type="hidden"    name="varLineCd"		id="varLineCd" 	value="${vMotorCar }" />
		
		<input type="hidden" 	name="varOrigEstValue" 	 		id="varOrigEstValue" 	   	value=""/>
		
		<!-- params -->
		<input type="hidden" name="paramDfltCoverage" id="paramDfltCoverage" value="${paramDfltCoverage}"/>
		<input type="hidden" name="paramPolFlagSw" id="paramPolFlagSw" value="
			<c:choose>
				<c:when test="${wPolBasic.polFlag eq '4'}">Y</c:when>
				<c:otherwise>N</c:otherwise>
			</c:choose>
			"/>
		<input type="hidden" name="paramAddDeleteSw" id="paramAddDeleteSw" value=""/>
		<input type="hidden" name="paramItemCnt" id="paramItemCnt" value="0"/>
		
		<!-- miscellaneous variables -->		
		<input type="hidden" name="vAllowUpdateCurrRate" id="vAllowUpdateCurrRate" value="${pAllowUpdateCurrRate}"/>
		<input type="hidden" name="vPolicyNo"		id="vPolicyNo"	value="${policyNo}"/>
		<input type="hidden" name="isLoaded"		id="isLoaded"	value="0"/>
		<input type="hidden" name="changedFields"	id="changedFields"	value="0"/>
		<input type="hidden" name="gipiWItemExist"	id="gipiWItemExist"	value="N"/>
		<input type="hidden" name="gipiWItemPerilExist"	id="gipiWItemPerilExist"	value="N"/>
		<input type="hidden" name="aItem"	id="aItem"	value="N"/>
		<input type="hidden" name="aPeril"	id="aPeril"	value="N"/>
		<input type="hidden" name="cItem"	id="cItem"	value="N"/>
		<input type="hidden" name="cPeril"	id="cPeril"	value="N"/>
		<input type="hidden" name="itemRecANoPerilCount" id="itemRecANoPerilCount" value="0"/>
		
		<input type="hidden" name="copyItem" id="copyProcess" value="N"/>
		<input type="hidden" name="copyPeril" id="copyPeril" value="N"/> 		
		<!-- GIPI_PARLIST (b240) -->
		<input type="hidden" id="invoiceSw"				name="invoiceSw"			value="" />
		
		<!-- GIPI_WPOLBAS (b540) -->
		<input type="hidden" 	name="packPolFlag" 	 	id="packPolFlag" 	   	value="${wPolBasic.packPolFlag }"/>
		<input type="hidden" 	name="polProrateFlag" 	id="polProrateFlag"	   	value="${wPolBasic.prorateFlag }"/>
		<input type="hidden" 	name="polCompSw" 	id="polCompSw" 	   	value="${wPolBasic.compSw }<c:if test="${empty wPolBasic.compSw}">N</c:if>"/>
		<input type="hidden" 	name="polProrateFlag" 	id="polProrateFlag"	   	value="${wPolBasic.prorateFlag }"/>
		<input type="hidden" 	name="polAssdNo" 	id="polAssdNo"	   	value="${wPolBasic.assdNo }"/>
		<input type="hidden" 	name="address1" 	id="address1"	   	value="${wPolBasic.address1 }"/>
		<input type="hidden" 	name="address2" 	id="address2"	   	value="${wPolBasic.address2 }"/>
		<input type="hidden" 	name="address3" 	id="address3"	   	value="${wPolBasic.address3 }"/>
		
		<input type="hidden" 	name="wpolbasInceptDate"	id="wpolbasInceptDate"		value="${wPolBasic.inceptDate }"/>
		<input type="hidden"	name="wpolbasExpiryDate"	id="wpolbasExpiryDate"		value="${wPolBasic.expiryDate }"/>
		
		<!-- GIPI_POLBASIC -->
		<input type="hidden" 	name="polbasicAddress1" 	id="polbasicAddress1"	   	value="${polbasicAddress1 }"/>
		<input type="hidden" 	name="polbasicAddress2" 	id="polbasicAddress2"	   	value="${polbasicAddress2 }"/>
		<input type="hidden" 	name="polbasicAddress3" 	id="polbasicAddress3"	   	value="${polbasicAddress3 }"/>

		<!-- GIIS_ASSURED -->
		<input type="hidden" 	name="assdAddress1" 	id="assdAddress1"	   	value="${assdMailAddress1 }"/>
		<input type="hidden" 	name="assdAddress2" 	id="assdAddress2"	   	value="${assdMailAddress2 }"/>
		<input type="hidden" 	name="assdAddress3" 	id="assdAddress3"	   	value="${assdMailAddress3 }"/>
		
		<input type="hidden" name="sublineCd" id="sublineCd" value="${sublineCd}"/>
		<input type="hidden" name="itemCount" id="itemCount" value="${itemCount}">
		<input type="hidden" name="pageName" id="pageName" value="itemInformation" />
		<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		
		<!-- For item information -->
		
		<jsp:include page="/pages/underwriting/endt/accident/subPages/endtAccidentItemInformation.jsp"></jsp:include>
		
		<jsp:include page="/pages/underwriting/endt/accident/subPages/endtAccidentItemInfoAdditional.jsp"></jsp:include>

		<div id="addDeleteItemDiv" style="display: none;">
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
				<jsp:include page="/pages/underwriting/endt/accident/subPages/endtBeneficiaryInformation.jsp"></jsp:include>
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
			<div id="deductibleDiv2" class="sectionDiv" style="display: none;"></div>
			<input type="hidden" id="dedLevel" name="dedLevel" value="2">
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
			
		<div id="additionalInfoDetails">
			<input type="hidden" id="hidDateOfBirth" 				name="hidDateOfBirth" 					value="" />
			<input type="hidden" id="hidAge" 						name="hidAge" 							value="" />
			<input type="hidden" id="hidCivilStatus" 				name="hidCivilStatue" 					value="" />
			<input type="hidden" id="hidSex"						name="hidSex" 							value="" />
			<input type="hidden" id="hidHeight" 					name="hidHeight" 						value="" />
			<input type="hidden" id="hidWeight" 					name="hidWeight" 						value="" />
			
			<input type="hidden" id="hidGroupPrintSw"  				name="hidGroupPrintSw"   				value="" />
			<input type="hidden" id="hidAcClassCd" 					name="hidAcClassCd" 					value="" />
			<input type="hidden" id="hidLevelCd" 					name="hidLevelCd" 						value="" />
			<input type="hidden" id="hidParentLevelCd" 				name="hidParentLevelCd" 				value="" />
			<input type="hidden" id="hidItemWitmperlExist" 			name="hidItemWitmperlExist" 			value="" />
			<input type="hidden" id="hidItemWitmperlGroupedExist"  	name="hidItemWitmperlGroupedExist" 		value="" />
			<input type="hidden" id="hidPopulatePerils" 			name="hidPopulatePerils" 				value="" />
			<input type="hidden" id="hidItemWgroupedItemsExist"    	name="hidItemWgroupedItemsExist"       	value="" />
			<input type="hidden" id="hidAccidentDeleteBill"    		name="hidAccidentDeleteBill"       		value="" />
		</div>
			
		<div class="buttonsDiv">
			<input type="button" id="btnCancel"	name="btnCancel" 	class="button" value="Cancel" />					
			<input type="button" id="btnSave"	name="btnSave" 		class="button" value="Save" />										
		</div>
		
	</form>
</div>

<input type="hidden" name="tempChangeSw" id="tempChangeSw" value="N" /> 
<input type="hidden" name="addInfoSw"	 id="addInfoSw"	   value="Y" />
<input type="hidden" name="copiedItemNo" id="copiedItemNo" value="" />
<input type="hidden" name="copiedItemNoTo" id="copiedItemNoTo" value="" />

<script type="text/javascript" defer="defer">	
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	enableAllElements();
	setModuleId(getItemModuleId("E", $F("globalLineCd"))); // andrew - 10.04.2010 - added this line

	objAccidentItems = eval('${accidentItems}');
	objGipiwGroupedItemsList = eval('${gipiWGroupedItems}');
	objGipiwCoverageItems = eval('${gipiWCoverageItems}');
	objGipiwGroupedBenItems = eval('${gipiWGroupedBenItems}');
	objGipiwGroupedBenPerils = eval('${gipiWGroupedBenPerils}');
	objGipiwGroupedOtherParams = eval('[]');
	
	//loadPerilListingTable();
	//$("parExit").stopObserving();
	//$("parExit").observe("click", exitPar());
	
	$("showPerilInfoSubPage").observe("click", function() { // added by andrew 07.08.2010
		try {
			if($("perilCd") == null){
				showEndtPerilInfoPage();						
			} 
		} catch(e){
			showErrorMessage("showPerilInfoSubPage", e);
			//showMessageBox("showPerilInfoSubPage : " + e.message);	
		}
	});

	$("showDeductible3").observe("click", function() { // added by andrew 07.08.2010
		try {
			if($("inputDeductible3") == null){
				showDeductibleModal(3);					
			} 
		} catch(e){
			showErrorMessage("showDeductible3", e);
			//showMessageBox("showPerilDeductible : " + e.message);
		}
	});

	//$("btnCancel").observe("click", getLineListingForEndtPAR);
	
	$("btnCancel").observe("click", function (){
		var msg = "";
		for (var x = 0; x < objGipiwGroupedItemsList.length; x++){
			if (objGipiwGroupedItemsList[x].itemNo == $F("itemNo")){
				msg = msg + JSON.stringify(objGipiwGroupedItemsList[x]);
			}
		}
	});

	$("btnSave").observe("click", function() {
		continueSaving();
	});

	function continueSaving(){	
		var result = true;
		var pExist1 = "N";
		var pExist2 = "N";
		var vExist  = "N";
		var pDistNo = 0;
		var vCounter = 0;
		var itemCount = 0;
		var itemWithPerilCount = 0;
		var itemRecANoPerilCount = 0; // counts all items that has recflag = A with no perils 

		//added to prevent inserting null value for GIPI_WBENEFICIARY
		//if ($F("itemNo") == ""){
		//	showMessageBox('Please select an item first.', imgMessage.INFO);
		//	return false;
		//}

		if ($F("delDedSw") == "Y"){
			new Ajax.Request(contextPath + "/GIPIWDeductibleController?action=deleteGipiWdeductibles2", {
				method: "GET",
				parameters: {
					globalParId: $F("globalParId"),
					globalLineCd: $F("globalLineCd"),
					globalSublineCd: $F("globalSublineCd")
				},
				evalScripts: true,
				asynchronous: true
			});
		}

		if ($F("delItemDiscSw") == "Y"){
			deleteDiscount();
			hideNotice();
		}

		if ($F("deletedItemNos") != ""){
			new Ajax.Request(contextPath + "/GIPIEndtParMCItemInfoController?action=deleteEndtItem", {
				method: "GET",
				parameters: {
					itemNos: $F("deletedItemNos"),
					itemNo: $F("itemNo"),
					globalParId: $F("globalParId")	
				},
				asynchronous: false,
				evalScripts: true
				/*
				onComplete: function(response){
					if (response.responseText != "SUCCESS"){
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
				*/
			});
		}

		if ($F("addedItemNos") != ""){
			new Ajax.Request(contextPath + "/GIPIEndtParMCItemInfoController?action=addEndtItem", {
				method: "GET",
				parameters: {
					itemNos: $F("addedItemNos"),
					globalParId: $F("globalParId")
				},
				asynchronous: false,
				evalScripts: true
				/*
				onComplete: function(response){
					if (response.responseText != "SUCCESS"){
						showMessageBox(response.responseText, imgMessage.ERROR);
					} else {
						$$("div[name='addDeleteItemRow']").each(function (row){
							if (row.down("input", 0).checked == true){
								showEndtItemInfo();
							}
						});
					}
				}
				*/
			});
		}
				
		//end angelo

		$$("div#parItemTableContainer div[name='row']").each(function(r){
			//vCounter = vCounter + parseInt(r.down("input", 53).value);
			itemCount = itemCount + 1;
			$("gipiWItemExist").value = "Y";
			var perilCounter = 0;
			$("aItem").value = "Y";
			if ("A" == r.down("input", 10).value){
				if ("Y" == r.down("input", 47).value){
					itemWithPerilCount = itemWithPerilCount + 1;
				} else {
					//VARIABLE.COUNTER for validate par status for post commit
					itemRecANoPerilCount = itemRecANoPerilCount + 1; 
				}
			}
			$("itemRecANoPerilCount").value = itemRecANoPerilCount;
			// check if all item has peril. 
			if(itemCount == itemWithPerilCount){
				$("aPeril").value = "Y";	
			}else{
				$("aPeril").value = "N";
			}
		});

		if ($("detailItemWitmperlExist") == "Y"){
			$("gipiWItemPerilExist").value = "Y";
		}

		if ($F("globalParStatus") < 3) {
			showMessageBox("You are not granted access to this form. " +
					"The changes that you have made will not be committed to the database.", imgMessage.ERROR);
			return false;
		} else if ("N" == $F("varPost2")) {
			return false;
		} else {
			//this portion are procedures in POST-FORMS-COMMIT that cannot be implemented in DAO due to requirement of message box show up
			if (("Y" == $F("invoiceSw")) && ("" == $F("varPost"))){
			//CHECK_ADDTL_INFO
				var accidentItemNo = "";
				$$("div#parItemTableContainer div[name='row']").each(function(x){
					if (x.down("input", 31).value == ""){
						if ("" != accidentItemNo){
							accidentItemNo = accidentItemNo + ",";
						}
						accidentItemNo = accidentItemNo + x.down("input", 1).value;
					}
				});
				if ("" != accidentItemNo){
					showMessageBox("Item no(s) "+ accidentItemNo +"  has no corresponding additional information. " 
							+"Please do the necessary changes.", "info");
					return false;
				}
			}
			
		}

		new Ajax.Request(contextPath + "/GIPIWAccidentItemController?action=checkUpdateGipiWPolbasValidity&globalParId="
				+$F("globalParId"),{
			method : "POST",
			asynchronous : true,
			evalScripts : true,
			postBody : Form.serialize("itemInformationForm"),
			onCreate: function() {
				showNotice("Updating. Please wait...");
			},
			onComplete : function(response){
				//hideNotice("Done!");
				if (response.responseText == "") {
					//$("invoiceSw").value = "Y";
					$("updateGIPIWPolbas").value = "Y";
					result = true;
				} else {
					hideNotice("");
					result = false;
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
		/*if(itemNos.trim() == "" && delItemNos.trim() == "" && mortgageeItemNos.trim() == "" && deductibleItemNos.trim() == "" &&
				accessoryItemNos.trim() == "" && perilItemNos.trim() == "" && carrierItemNos.trim() == "" && groupItemsItemNos.trim() == "" && 
				personnelItemNos.trim() == "" && beneficiaryItemNos.trim() == ""){
				showMessageBox("No changes to save.");
				return false;
			}*/
			//if(itemNos.trim() != "" || delItemNos.trim() != ""){
				/* execute the following codes if any changes has been made to the item (insert/update/delete) */		
		var tempVarVal = $F("tempVariable");			
		if (result) {
			if (itemCount == 0){
				observeBtnSave3();
			} else { 
				observeBtnSave2();
			}
		}        
				// item details
	}
	
	function observeBtnSave2(){
		var result = true;
		if (("Y" == $F("invoiceSw")) && ("" == $F("varPost"))){
			new Ajax.Request(contextPath + "/GIPIWAccidentItemController?action=checkCreateDistributionValidity", {
				method : "GET",
				parameters : {
					globalParId : $F("globalParId")
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : 
					function(){
						showNotice("Checking validity from dependent tables...");									
					},
				onComplete :
					function(response){
						if (checkErrorOnResponse(response)) {
							var errorNo = response.responseText;
							if ("0" == errorNo){
								observeBtnSave3();
							} else if ("1" == errorNo){
								hideNotice("");
								showMessageBox("Pls. be adviced that there are no items for this PAR.", imgMessage.ERROR);
							} else if ("2" == errorNo){
								hideNotice("");
								showConfirmBox("", "This PAR has existing records in the posted POLICY tables. Changes will be made.  Would you like to continue?", 
										"OK", "Cancel", observeBtnSave3, "");
							} else if ("3" == errorNo){
								hideNotice("");
								showConfirmBox("", "Changes will be done to the distribution tables. Do you like to proceed?", 
										"OK", "Cancel", checkRIDistValidity, "");
							} else if ("3A" == errorNo){
								hideNotice("");
								checkRIDistValidity();
							} else if ("4" == errorNo){
								hideNotice("");
								showMessageBox("There are too many distribution numbers assigned for this item. Please contact your database" + 
										" administrator to rectify the matter. Check records in the policy table with par_id = "+$F("globalParId") , imgMessage.ERROR);
							} else if ("5" == errorNo){
								hideNotice("");
								showMessageBox("Could not proceed. The effectivity date or expiry date had not been updated.", imgMessage.ERROR);
							} else if ("6" == errorNo){
								hideNotice("");
								showMessageBox("No row in table SYS.DUAL", imgMessage.ERROR);
							} else if ("7" == errorNo){
								hideNotice("");
								showMessageBox("You had committed an illegal transaction. No records were retrieved in GIPI_WPOLBAS.", imgMessage.ERROR);
							} else if ("8" == errorNo){
								hideNotice("");
								showMessageBox("Multiple rows were found to exist in GIPI_WPOLBAS. Please contact your database administrator to" + 
										" rectify the matter. Check record with par_id = "+$F("globalParId") , imgMessage.ERROR);
							}
						} else {
							//result = false;
						}
					}
			});
		} else {
			observeBtnSave3();
		}
	}

	function checkRIDistValidity(){
		new Ajax.Request(contextPath + "/GIPIWAccidentItemController?action=checkGiriDistfrpsExist", {
			method : "GET",
			parameters : {
				globalParId : $F("globalParId")
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : 
				function(){
					showNotice("Checking validity from dependent tables...");									
				},
			onComplete :
				function(response){
					if (checkErrorOnResponse(response)) {
						if ("Y" == response.responseText){
							hideNotice("");
							showMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR);
						} else {
							observeBtnSave3();
						}
					} else {
						
					}
				}
		 });
	}

	function observeBtnSave3(){
		if (("Y" == $F("invoiceSw")) && ("" == $F("varPost"))){
			proceedSave();
		} else {
			proceedSave();
		}
	}

	function proceedSave(){
		disableAllElements();
		var tempVarVal = $F("tempVariable");
		new Ajax.Request(contextPath + "/GIPIWAccidentItemController?action=saveEndtAccidentItemInfoPage&globalParId="
				+$F("globalParId")+"&globalSublineCd="+$F("globalSublineCd")+"&globalLineCd="+$F("globalLineCd")
				+"&globalIssCd="+$F("globalIssCd"), {
			method : "POST",
			parameters : {
				accidentItems : prepareJsonAsParameter(objAccidentItems)   
			},
			postBody : Form.serialize("itemInformationForm"),	            
			evalScripts : true,
			asynchronous : true,
			onCreate : 
				function(){
					showNotice("Saving item details, please wait...");
				},
			onComplete :function(response){
				if (checkErrorOnResponse(response)) {		
					hideNotice("");		
					saveEndtGroupedItems();
				} else {
					result = false;
					//showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}	/*,
			onSuccess : function(){
			resizeTableToRowNum("parItemTableContainer", "row", 5);
			}*/
		});
	}

	function saveEndtGroupedItems(){
		var groupedItemsObjParameters = prepareAccEndtGroupedObjParams();
		groupedItemsObjParameters.objRetGroupedItemsParams = prepareJsonAsParameter(objRetGroupedItemsParams);

		new Ajax.Request(contextPath + "/GIPIWAccidentItemController?action=saveAccidentEndtGroupedItemsModal&globalParId="
				+$F("globalParId"), {
			method : "POST",
			parameters : {
				groupedItemsObjParameters : JSON.stringify(groupedItemsObjParameters)		
			},
			evalScripts : true,
			asynchronous : true,
			onComplete : function (response){
				enableAllElements();
				showWaitingMessageBox(response.responseText, imgMessage.SUCCESS,showItemInfo);				
				$("tempVariable").value = tempVar; // bring back the value of tempVariable			
				//saveEndtPeril(); // added by andrew 07.13.2010
							     // Transaction in DAO includes: 
								 // 	-insert peril deductible
								 //		-update wpolbas amounts
								 //		-update pack wpolbas amounts
								 //		-delete bill
								 //		-populate orig item peril
								 //		-create winvoice
								 //		-create winvoice1
								 // 	-insert parhist
								 // 	-update par status
				//observeBtnSave4();
			}
		});
	}

	function saveItemInfo2(result, pExist1, pExist2, vExist, pDistNo) {
		if ($F("varPost").blank() && $F("invoiceSw") == "Y") {
			//CHECK_ADDTL_INFO
			new Ajax.Request(contextPath + "/GIPIParMCItemInformationController?action=checkAdditionalInfo", {
				method : "GET",
				parameters : {
					globalParId : $F("globalParId")
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : 
					function(){
						showNotice("Checking additional info, please wait...");									
					},
				onComplete :
					function(response){
						if (checkErrorOnResponse(response)) {
							hideNotice("Done!");
							if (response.responseText != "SUCCESS") {
								showMessageBox(response.responseText, imgMessage.ERROR);
								result = false;
							} else {
								result = true;
							}
						} else {
							result = false;
						}
					}
			});

			if (!result) {
				enableAllElements();
				return false;
			} else {
				//CHANGE_ITEM_GRP
				new Ajax.Request(contextPath + "/GIPIItemMethodController?action=changeItemGroup", {
					method : "GET",
					parameters : {
						globalParId : $F("globalParId"),
						globalPackPolFlag : $F("packPolFlag")
					},
					asynchronous : false,
					evalScripts : true,
					onCreate : 
						function(){
							showNotice("Changing item group, please wait...");									
						},
					onComplete :
						function(response){
							if (checkErrorOnResponse(response)) {
								hideNotice(response.responseText);
							} else {
								result = false;
							}								
						}
				});	
			}

			if (!result) {
				enableAllElements();
				return false;
			}
			
			if ($F("varEndtTaxSw") != "Y") {
				//DELETE_BILL
				new Ajax.Request(contextPath + "/GIPIItemMethodController?action=deleteBill", {
					method : "GET",
					parameters : {
						globalParId : $F("globalParId")
					},
					asynchronous : false /*true*/,
					evalScripts : true,
					onCreate : 
						function(){
							showNotice("Deleting record on main_co_insurer, please wait...");									
						},
					onComplete :
						function(response){
							if (checkErrorOnResponse(response)) {
								hideNotice(response.responseText);
							} else {
								result = false;
							}																
						}
				});
			}

			if (!result) {
				enableAllElements();
				return false;
			}

			//UPDATE_GIPI_WPOLBAS2
			new Ajax.Request(contextPath + "/GIPIParMCItemInformationController?action=updateGipiWpolbasEndt",{
				method : "GET",
				parameters : {
					globalParId : $F("globalParId"),
					negateItem : $F("varNegateItem"),
					prorateFlag : $F("varProrateFlag"),
					compSw : $F("varCompSw"),
					endtExpiryDate : $F("varEndtExpiryDate"),
					effDate : $F("varEffDate"),
					expiryDate : ($F("varExpiryDate")),
					shortRtPercent : $F("varShortRtPercent")
				},
				asynchronous : false,
				evalScripts : true,
				onCreate: function() {
					showNotice("Updating. Please wait...");
				},
				onComplete : function(response){
					if (checkErrorOnResponse(response)) {
						hideNotice(response.responseText);
					} else {
						result = false;
					}
				}
			});

			if (!result) {
				enableAllElements();
				return false;
			}

			//CREATE_DISTRIBUTION
			//p_exist1 = "Y";
			if ($$("div[name='itemRow']").size() == 0) {
				var alert1 = "N";
				var alert2 = "N";
				
				new Ajax.Request(contextPath + "/GIPIItemMethodController?action=createEndtParDistribution1", {
					method : "GET",
					parameters : {
						parId : $F("globalParId"),
						distNo : pDistNo
					},
					asynchronous : false /*true*/,
					evalScripts : true,
					onCreate : 
						function(){
							showNotice("Validating creation of distribution. please wait...");									
						},
					onComplete :
						function(response){
							if (checkErrorOnResponse(response)) {
								var msg = response.responseText.split(" ");

								if (msg[0] != null && msg[0] == "NO_ITEMS") {
									showMessageBox("Pls. be adviced that there are no items for this PAR.", imgMessage.ERROR);
									result = false;
									return false;
								} else if (msg[0] != null && msg[0] == "REC_EXISTS_IN_POST_POL_TAB") {
									showConfirmBox("Create Distribution", "This PAR has existing records in the posted POLICY tables.  Changes will be made.  Would you like to continue?", "Yes", "No",
											 function() {
												 alert1 = "Y";
											 },
											 function() {
												 result = false;
											 });
								}

								if (msg[1] != null && msg[1] == "DISTRIBUTION") {
									showConfirmBox("Create Distribution", "Changes will be done to the distribution tables. Do you like to proceed?", "Yes", "No",
											 function() {
												 alert2 = "Y";
											 },
											 function() {
												 result = false;
											 });
								}
							} else {
								result = false;
							}														
						}
				});

				if (!result) {
					return false;
				} else {
					new Ajax.Request(contextPath + "/GIPIItemMethodController?action=createEndtParDistribution2", {
						method : "GET",
						parameters : {
							parId : $F("globalParId"),
							distNo : pDistNo,
							alert1 : alert1,
							alert2 : alert2
						},
						asynchronous : false /*true*/,
						evalScripts : true,
						onCreate : 
							function(){
								showNotice("Creating distribution. please wait...");									
							},
						onComplete : function(response) {
								if (checkErrorOnResponse(response)) {
									hideNotice(response.responseText);
								} else {
									result = false;
								}
							}
					});
				}

				p_exist1 = "Y";
			}

			if (!result) {
				return false;
			}
			
			if ($F("varEndtTaxSw") != "Y") {
				//POPULATE_ORIG_ITMPERIL and CREATE_WINVOICE in one package
				new Ajax.Request(contextPath + "/GIPIParMCItemInformationController?action=populateOrigItmperil", {
					method : "GET",
					parameters : {
						globalParId : $F("globalParId")
					},
					asynchronous : false /*true*/,
					evalScripts : true,
					onCreate : 
						function(){
							showNotice("Populating orig itmperil. Please wait...");									
						},
					onComplete :
						function(response){
							if (checkErrorOnResponse(response)) {
								hideNotice("Done!");
								pExist2 = response.responseText;
							} else {
								result = false;
							}										
						}
				});
			}

			if (!result) {
				enableAllElements();
				return false;
			}

			if ($$("div[name='itemRow']").size() == 0) {
				vExist = "Y";
			}

			if (pExist1 == "N") {
				//DELETE_DISTRIBUTION
				new Ajax.Request(contextPath + "/GIPIParMCItemInformationController?action=deleteDistribution", {
					method : "GET",
					parameters : {
						globalParId : $F("globalParId"),
						distNo : pDistNo
					},
					asynchronous : false /*true*/,
					evalScripts : true,
					onCreate : 
						function(){
							showNotice("Deleting distribution. Please wait...");									
						},
					onComplete :
						function(response){
							if (checkErrorOnResponse(response)) {
								hideNotice("Done!");
							}	else {
								result = false;
							}											
						}
				});
			}

			if (!result) {
				enableAllElements();
				return false;
			}

			if (pExist2 == "N" && $F("varEndtTaxSw") != "Y") {
				//delete records from gipi_winv*
				new Ajax.Request(contextPath + "/GIPIParMCItemInformationController?action=deleteWinvRecords", {
					method : "GET",
					parameters : {
						globalParId : $F("globalParId")
					},
					asynchronous : false,
					evalScripts : true,
					onCreate : 
						function(){
							showNotice("Deleting records from Winvoice tables. Please wait...");									
						},
					onComplete :
						function(response){
							if (checkErrorOnResponse(response)) {
								hideNotice("Done!");
							}	else {
								result = false;
							}										
						}
				});
			}

			if (!result) {
				enableAllElements();
				return false;
			}

			//ADD_PAR_STATUS_NO
			//1. CREATE_INVOICE_ITEM
			new Ajax.Request(contextPath + "/GIPIItemMethodController?action=createEndtInvoiceItem", {
				method : "GET",
				parameters : {
					parId : $F("globalParId")
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : 
					function(){
						showNotice("Processing invoice information...");									
					},
				onComplete : function(response) {
						if (checkErrorOnResponse(response)) {
							hideNotice(response.responseText);
						}
					}
			});

			//2. CREATE_DISTRIBUTION_ITEM
			if ($$("div[name='itemRow']").size() == 0) {
				var alert1 = "N";
				var alert2 = "N";
				
				new Ajax.Request(contextPath + "/GIPIItemMethodController?action=createEndtParDistributionItem1", {
					method : "GET",
					parameters : {
						parId : $F("globalParId"),
						distNo : pDistNo
					},
					asynchronous : false /*true*/,
					evalScripts : true,
					onCreate : 
						function(){
							showNotice("Processing distribution information...");									
						},
					onComplete :
						function(response){
							if (checkErrorOnResponse(response)) {
								var msg = response.responseText.split(" ");

								if (msg[0] != null && msg[0] == "NO_ITEMS") {
									showMessageBox("Pls. be adviced that there are no items for this PAR.", imgMessage.ERROR);
									result = false;
									return false;
								} else if (msg[0] != null && msg[0] == "REC_EXISTS_IN_POST_POL_TAB") {
									showConfirmBox("Create Distribution", "This PAR has existing records in the posted POLICY tables.  Changes will be made.  Would you like to continue?", "Yes", "No",
											 function() {
												 alert1 = "Y";
											 },
											 function() {
												 result = false;
											 });
								}

								if (msg[1] != null && msg[1] == "DISTRIBUTION") {
									showConfirmBox("Create Distribution", "Changes will be done to the distribution tables. Do you like to proceed?", "Yes", "No",
											 function() {
												 alert2 = "Y";
											 },
											 function() {
												 result = false;
											 });
								}
							}																
						}
				});

				if (!result) {
					return false;
				} else {
					new Ajax.Request(contextPath + "/GIPIItemMethodController?action=createEndtParDistributionItem2", {
						method : "GET",
						parameters : {
							parId : $F("globalParId"),
							distNo : pDistNo,
							alert1 : alert1,
							alert2 : alert2
						},
						asynchronous : false /*true*/,
						evalScripts : true,
						onCreate : 
							function(){
								showNotice("Creating distribution. please wait...");									
							},
						onComplete : function(response) {
								if (checkErrorOnResponse(response)) {
									hideNotice(response.responseText);
								}
							}
					});
				}
			}

			//Finally, proceed to ADD_PAR_STATUS_NO
			//message = "Updating PAR Status..."
			new Ajax.Request(contextPath + "/GIPIItemMethodController?action=addEndtParStatusNo", {
					method : "GET",
					parameters : {
						parId : $F("globalParId"),
						lineCd : $F("globalLineCd"),
						issCd : $F("globalIssCd"),
						endtTaxSw : $F("varEndtTaxSw"),
						coInsSw : $F("varCoInsSw"),
						negateItem : $F("varNegateItem"),
						prorateFlag : $F("varProrateFlag"),
						compSw : $F("varCompSw"),
						endtExpiryDate : $F("varEndtExpiryDate"),
						effDate : $F("varEffDate"),
						expiryDate : $F("varExpiryDate"),
						shortRtPercent : $F("varShortRtPercent")
					},
					asynchronous : false,
					evalScripts : true,
					onCreate : 
						function(){
							showNotice("Updating PAR Status...");									
						},
					onComplete : function(response) {
							if (checkErrorOnResponse(response)) {
								hideNotice(response.responseText);
							}
						}
			});
		}

		//CHECK_PACK_POL_FLAG and UPDATE_GIPI_WPACK_LINE_SUBLINE
		new Ajax.Request(contextPath + "/GIPIItemMethodController?action=updateEndtGipiWpackLineSubline", {
				method : "GET",
				parameters : {
					parId : $F("globalParId"),
					packLineCd : $F("packLineCd"),
					packSublineCd : $F("packSublineCd")
				},
				asynchronous : false /*true*/,
				evalScripts : true,
				onCreate : 
					function(){
						showNotice("Updating Gipi Wpack Line Subline...");									
					},
				onComplete :
					function(response){
						if (checkErrorOnResponse(response)) {
							hideNotice(response.responseText);
						}
				}
		});
		
		//SET_PACKAGE_MENU
		new Ajax.Request(contextPath + "/GIPIItemMethodController?action=setPackageMenu", {
					method : "GET",
					parameters : {
						parId : $F("globalParId"),
						packParId : $F("globalPackParId")
					},
					asynchronous : false /*true*/,
					evalScripts : true,
					onCreate : 
						function(){
							showNotice("Setting package menu...");									
						},
					onComplete :
						function(response){
							if (checkErrorOnResponse(response)) {
								hideNotice(response.responseText);
							}
						}
		});
		
		$("varNegateItem").value = "N";

		enableAllElements();
		showEndtItemInfo();
		initializePARBasicMenu();
	}

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
	
	$("reloadForm").observe("click", function (){
		showItemInfo();
	});

	$("showDeductible2").observe("click", function() { // added by andrew 08.09.2010
		try {
			if($("inputDeductible2") == null){
				showDeductibleModal(2);							
			} 
		} catch(e){
			showErrorMessage("messageAlertUnsavedChanges", e);
			//showMessageBox("showPerilDeductible : " + e.message);
		}
	});

	checkIfToResizeTable2("parItemTableContainer", "row");
	checkTableIfEmpty2("row", "itemTable");
</script>