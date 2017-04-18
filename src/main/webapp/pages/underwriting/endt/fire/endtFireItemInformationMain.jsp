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
		<jsp:include page="/pages/underwriting/endt/fire/subPages/endtFireItemInformation.jsp"></jsp:include>
		
		<!-- end of item information-->
		<div id="addDeleteItemDiv" style="display: none;">
		</div>
		
		<!-- misc variables -->
		<input type="hidden" name="varVFireItemTypeBldg" id="varVFireItemTypeBldg" value="${pFireItemTypeBldg}"/>
		
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
			<div id="deductibleDiv2" class="sectionDiv" style="display: none;">
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
			<div id="mortgageeInfo" class="sectionDiv" style="display: none;"></div>			
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
		<div class="buttonsDiv">
			<input type="button" id="btnCancel"	name="btnCancel" 	class="button" value="Cancel" />					
			<input type="button" id="btnSave"	name="btnSave" 		class="button" value="Save" />										
		</div>
	</form>
</div>

<script type="text/javascript" defer="defer">	
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	enableAllElements();
	setModuleId(getItemModuleId("E", $F("globalLineCd"))); // andrew - 10.04.2010 - added this line
	
	//loadPerilListingTable();
	//$("parExit").stopObserving();
	//$("parExit").observe("click", exitPar());
	
	$("showPerilInfoSubPage").observe("click", function() { // added by andrew 07.08.2010
		try {
			if($("perilCd") == null){
				showEndtPerilInfoPage();						
			} 
		} catch(e){
			showErrorMessage("endtFireItemInformationMain.jsp - showPerilInfoSubPage", e);
			//showMessageBox("showPerilInfoSubPage : " + e.message);	
		}
	});

	$("showDeductible2").observe("click", function() { // added by andrew 08.09.2010
		try {
			if($("inputDeductible2") == null){
				showDeductibleModal(2);							
			} 
		} catch(e){
			showErrorMessage("endtFireItemInformationMain.jsp - showDeductible2", e);
			//showMessageBox("showPerilDeductible : " + e.message);
		}
	});
	
	$("showDeductible3").observe("click", function() { // added by andrew 07.08.2010
		try {
			if($("inputDeductible3") == null){
				showDeductibleModal(3);							
			} 
		} catch(e){
			showErrorMessage("endtFireItemInformationMain.jsp - showDeductible3", e);
			//showMessageBox("showPerilDeductible : " + e.message);
		}
	});
	
	$("btnCancel").observe("click", getLineListingForEndtPAR);

	$("btnSave").observe("click", function() {
		var result = true;
		var pExist1 = "N";
		var pExist2 = "N";
		var vExist  = "N";
		var pDistNo = 0;
		//:B480 pre-insert

		if ($F("globalParStatus") < 3) {
			showMessageBox("You are not granted access to this form. " +
					"The changes that you have made will not be committed to the database.", imgMessage.ERROR);
			return false;
		} else if (!deleteDiscount()) {
			return false;
		} else {
			new Ajax.Request(contextPath + "/GIPIParMCItemInformationController?action=updateGipiWpolbasEndt",{
				method : "GET",
				parameters : {
					globalParId : $F("globalParId"),
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
				onCreate: function() {
					showNotice("Updating. Please wait...");
				},
				onComplete : function(response){
					hideNotice("Done!");
					if (response.responseText == "SUCCESS") {
						$("invoiceSw").value = "Y";
						result = true;
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
						result = false;
					}
				}
			});
		}

		/*if(itemNos.trim() == "" && delItemNos.trim() == "" && mortgageeItemNos.trim() == "" && deductibleItemNos.trim() == "" &&
				accessoryItemNos.trim() == "" && perilItemNos.trim() == "" && carrierItemNos.trim() == "" && groupItemsItemNos.trim() == "" && 
				personnelItemNos.trim() == "" && beneficiaryItemNos.trim() == ""){
				showMessageBox("No changes to save.");
				return false;
			}*/
			
			//if(itemNos.trim() != "" || delItemNos.trim() != ""){
				/* execute the following codes if any changes has been made to the item (insert/update/delete) */		
				var tempVarVal = $F("tempVariable");			
				
				new Ajax.Request(contextPath + "/GIPIItemMethodController?action=saveItem&globalParId="+$F("globalParId")+"&lineCd="+$F("globalLineCd")+"&sublineCd="+$F("globalSublineCd")+"&globalParType="+$F("globalParType"), {
					method : "POST",
					postBody : Form.serialize("itemInformationForm"),				
					asynchronous : false /* true */,
					evalScripts : true,
					onCreate : 
						function(){						
							showNotice("Saving item, please wait...");
							$("notice").show();																
							disableAllElements();
						},
					onComplete :
						function(response){
							if (checkErrorOnResponse(response)) {
								hideNotice(response.responseText);
								if(response.responseText == "SUCCESS"){
									$("tempVariable").value = response.responseText;							
								} else {
									result = false;
								}
							}					
						}
				});

				if (!result) {
					return false;
				}

				disableAllElements();
	            
				// item details
				if($F("tempVariable") == "SUCCESS"){
					// save details depending on lineCd
					var lineCd = $F("globalLineCd");
					var controller = "GIPIWFireItmController";
					var action = "saveGipiParFireItem";
					
					new Ajax.Request(contextPath + "/"+controller+"?action="+action+"&globalParId="+$F("globalParId"), {
						method : "POST",
						postBody : Form.serialize("itemInformationForm"),
						asynchronous : false,
						evalScripts : true,
						onCreate : 
							function(){
								showNotice("Saving item details, please wait...");
							},
						onComplete :
							function(response){
								if (checkErrorOnResponse(response)) {
									hideNotice(response.responseText);							
									$("tempVariable").value = tempVar; // bring back the value of tempVariable
									
									saveEndtPeril(); // added by andrew 07.13.2010
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
								} else {
									result = false;
								}
							}
					});
				} else{
					return false;
				}

				if (!result) {
					//enableAllElements();
					//return false;
					result = true;
				}
				
				//post-forms-commit
				if($F("varPost2") == "N"){
					return false;
				} else {
					//get dist no
					new Ajax.Request(contextPath + "/GIPIParMCItemInformationController?action=getDistNo", {
						method : "GET",
						parameters : {
							globalParId : $F("globalParId")
						},
						asynchronous : false,
						evalScripts : true,
						onCreate : 
							function(){
								showNotice("Getting dist no. Please wait...");									
							},
						onComplete :
							function(response){
								if (checkErrorOnResponse(response)) {
									hideNotice("Done!");
									pDistNo = parseInt(response.responseText);
								} else {
									result = false;
								}
							}
					});

					if (!result) {
						enableAllElements();
						return false;
					}
					
					if ($F("varPost").blank()) {
						//INSERT_PARHIST
						new Ajax.Request(contextPath + "/GIPIItemMethodController?action=insertParhist", {
							method : "GET",
							parameters: {
								globalParId : $F("globalParId")
							},
							asynchronous : false /*true*/,
							evalScripts : true,
							onCreate : 
								function(){
									showNotice("Inserting record to Parhist, please wait...");							
								},
							onComplete :
								function(response){
									if (checkErrorOnResponse(response)) {
										hideNotice(response.responseText);							
										$("tempVariable").value = response.responseText;
									} else {
										result = false;
									}																			
								}
						});

						if (!result) {
							enableAllElements();
							return false;
						}

						//VALIDATE_OTHER_INFO
						new Ajax.Request(contextPath + "/GIPIItemMethodController?action=endtParValidateItemInfo", {
							method : "GET",
							parameters: {
								parId : $F("globalParId"),
								funcPart : 1,
								alertConfirm : ""
							},
							asynchronous : false,
							evalScripts : true,
							onCreate : 
								function(){
									showNotice("Validating other info, please wait...");							
								},
							onComplete :
								function(response){
									if (checkErrorOnResponse(response)) {
										hideNotice(response.responseText);
										var msg = response.responseText;
										
										if (msg == "SUCCESS") {
											saveItemInfo2(result, pExist1, pExist2, vExist, pDistNo);
										} else if (msg.split(" ")[0] == "1") {
											showConfirmBox("Validate Other Info", msg.substring(2), "Yes", "No",
												function() {
													new Ajax.Request(contextPath + "/GIPIItemMethodController?action=endtParValidateItemInfo", {
														method : "GET",
														parameters: {
															parId : $F("globalParId"),
															funcPart : 2,
															alertConfirm : "Y"
														},
														asynchronous : false,
														evalScripts : true,
														onCreate : 
															function(){
																showNotice("Validating other info, please wait...");							
															},
														onComplete :
															function(response){
																if (checkErrorOnResponse(response)) {
																	hideNotice(response.responseText);
																	var msg = response.responseText;

																	if (msg == "SUCCESS") {
																		saveItemInfo2(result, pExist1, pExist2, vExist, pDistNo);
																	} else if (msg.split(" ")[0] == "2") {
																		showConfirmBox("Validate Other Info", msg.substring(2), "Yes", "No",
																				function() {
																					//result = true;
																					saveItemInfo2(result, pExist1, pExist2, vExist, pDistNo);
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
												},
												function() {
													enableAllElements();
													result = false;
												});
										} else if (msg.split(" ")[0] == "2") {
											showConfirmBox("Validate Other Info", msg.substring(2), "Yes", "No",
													function() {
														result = true;
														saveItemInfo2(result, pExist1, pExist2, vExist, pDistNo);
													},
													function() {
														enableAllElements();
														result = false;
													});
											}
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
				}
			//}
	});

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
	

	//module functions
	
	//RECOMPUTE_TOTAL_DEDUCTIBLES
	/*
	function recomputeTotalDeductibles() {
		var totalDeductibles = 0;
	}*/
	//$("parExit").stopObserving();
	//initializePARBasicMenu(); // commented by andrew 02.21.2011 - causing multiple event execution
</script>