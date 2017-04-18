<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="lossExpenseHistMainDiv" name="lossExpenseHistMainDiv"> 
	<form id="lossExpenseHistForm" name="lossExpenseHistForm">
		<c:choose>
			<c:when test="${fromClaimMenu eq 'Y'}">
				<div id="claimListingMenu">
					<div id="mainNav" name="mainNav">
						<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
							<ul>
								<li><a id="exit">Exit</a></li>
							</ul>
						</div>
					</div>
				</div>
				<jsp:include page="/pages/claims/subPages/claimInformation2.jsp"></jsp:include>
			</c:when>
			<c:otherwise>
				<jsp:include page="/pages/claims/subPages/claimInformation.jsp"></jsp:include>
			</c:otherwise>
		</c:choose>
		
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Item Information</label>
				<span class="refreshers" style="margin-top: 0;">
					<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>
		<div class="sectionDiv" id="giclItemPerilDiv" name="giclItemPerilDiv"></div>
		<jsp:include page="/pages/claims/lossExpenseHistory/subPages/payeeDetails.jsp"></jsp:include>
		<jsp:include page="/pages/claims/lossExpenseHistory/subPages/historyDetails.jsp"></jsp:include>
		<div id="distDetailsDiv" name="distDetailsDiv" style="display: none;">
			<jsp:include page="/pages/claims/lossExpenseHistory/subPages/distributionDetails.jsp"></jsp:include>
		</div>
		<div id="hiddenParamDiv" name="hiddenParamDiv" style="display: none;">
			<input type="hidden" id="hidMaxClmLossId"		name="hidMaxClmLossId"		value="${maxClmLossId}"/>
			<input type="hidden" id="hidNextClmLossId"		name="hidNextClmLossId"		value="${maxClmLossId}"/>
			<input type="hidden" id="hidDepreciationCd" 	name="hidDepreciationCd" 	value="${depreciationCd}"/>
			<input type="hidden" id="hidMCTowing" 			name="hidMCTowing" 		 	value="${mcTowing}"/>
			<input type="hidden" id="hidMCLineName" 		name="hidMCLineName" 		value="${motorLineName}"/>
			<input type="hidden" id="hidRiPayeeClass" 		name="hidRiPayeeClass" 	 	value="${riPayeeClass}"/>
			<input type="hidden" id="hidAssdClassCd" 		name="hidAssdClassCd" 	 	value="${assdClassCd}"/>
			<input type="hidden" id="hidAdjpClassCd" 		name="hidAdjpClassCd" 	 	value="${adjpClassCd}"/>
			<input type="hidden" id="hidMortgClassCd" 		name="hidMortgClassCd" 	 	value="${mortgClassCd}"/>
			<input type="hidden" id="hidMortgClassDesc" 	name="hidMortgClassDesc" 	value="${mortgClassDesc}"/>
			<input type="hidden" id="hidCheckPLA" 			name="hidCheckPLA" 	 		value="${checkPLA}"/>
			<input type="hidden" id="hidEnableUpdSetHist" 	name="hidEnableUpdSetHist" 	value="${enableUpdateSettlementHist}"/>
			<input type="hidden" id="hidDfltDistDate" 		name="hidDfltDistDate" 	 	value="${defaultDistDate}"/>
			<input type="hidden" id="hidRiCd" 				name="hidRiCd" 	 			value="${riCd}"/>
			<input type="hidden" id="hidIntmClassCd" 		name="hidIntmClassCd" 	 	value="${intmClassCd}"/>
		</div>
		<div class="buttonsDiv" align="center">
			<table align="center" cellpadding="1">
				<tr>
					<td><input type="button" id="btnDistDate"		name="btnDistDate" 		   style="width: 120px;" class="button"	value="Distribution Date" /></td>
					<td><input type="button" id="btnDistribute"		name="btnDistribute" 	   style="width: 100px;" class="button"	value="Distribute" /></td>
					<td><input type="button" id="btnMaintainPayees"	name="btnMaintainPayees"   style="width: 120px;" class="button"	value="Maintain Payees" /></td>
					<td><input type="button" id="btnViewHistory"	name="btnViewHistory" 	   style="width: 100px;" class="button"	value="View History" /></td>
					<td><input type="button" id="btnCancelHistory"	name="btnCancelHistory"    style="width: 100px;" class="button"	value="Cancel History" /></td>
					<td><input type="button" id="btnCancelledAdvice" name="btnCancelledAdvice" style="width: 120px;" class="button"	value="Cancelled Advice" /></td>
					<td><input type="button" id="btnCancel"			name="btnCancel" 		   style="width: 100px;" class="button"	value="Cancel" /></td>
				</tr>
				<tr>
					<td><input type="button" id="btnEvalReport" 	name="btnEvalReport" 	   style="width: 120px;" class="button"	value="Evaluation Report" /></td>
					<td><input type="button" id="btnClearHist" 		name="btnClearHist" 	   style="width: 100px;" class="button"	value="Clear History" /></td>
					<td><input type="button" id="btnBillInfo" 		name="btnBillInfo" 	 	   style="width: 120px;" class="button"	value="Bill Information" /></td>
					<td><input type="button" id="btnLOA" 			name="btnLOA" 	 		   style="width: 100px;" class="button"	value="LOA" /></td>
					<td><input type="button" id="btnCSL" 			name="btnCSL" 	 		   style="width: 100px;" class="button"	value="CSL" /></td>
					<td><input type="button" id="btnNegate" 		name="btnNegate" 	 	   style="width: 120px;" class="button"	value="Negate" /></td>
					<td><input type="button" id="btnSave" 			name="btnSave" 	 		   style="width: 100px;" class="button"	value="Save" /></td>
				</tr>
			</table>			
		</div>
	</form>
</div>

<script type="text/javascript">
	changeTag = 0;
	initializeAll();
 	initializeAccordion();
 	initializeAllMoneyFields();
	initializeChangeTagBehavior(saveLossExpenseHistory);
	initializeChangeAttribute();
	var dummyObj = new Object();
	savedFromLossExpDtl = 'N'; fireEvent($("btnSave"), "click"); //added by robert GENQA 5027 11.04.15
	
	if('${fromClaimMenu}' == "Y"){
		fromClaimMenu = "Y";
		
		$("exit").observe("click", function (){
			goClaimsMain();
		});
		
		$("btnClaimNo").observe("click", function(){
			
		});
		
	}else{
		fromClaimMenu = "N";
	}
 	
 	if(objCLMGlobal.lineCd != "MC" && objCLMGlobal.menuLineCd != "MC"){
		disableButton("btnLOA");
		disableButton("btnCSL");
		disableButton("btnEvalReport");
		disableButton("btnDepreciation");
	}else{
		$("hidDepreciationCd").value = '${depreciationCd}';
		$("hidMCTowing").value = '${mcTowing}';
	}
 	
 	clearAllLossExpRelatedObjects();
	showLossExpenseGiclItemPeril();
	retrievePayeeDetails(dummyObj);
	retrieveClmLossExpense(dummyObj);
	retrieveLossExpDetail(dummyObj);
	populatePayeeForm(null);
	populateClmLossExpForm(null);
	populateLossExpDtlForm(null);
	
	observeReloadForm("reloadForm", showLossExpenseHistory);
	//observeCancelForm("btnCancel", saveLossExpenseHistory, nvl(fromClaimMenu, "N") == "Y" ? goClaimsMain : showClaimListing);
	// commented out by Kris 08.06.2013 and replaced with the ff:
	function doExitOnBtnCancel(){
		if(objGICLS051.previousModule != null && objGICLS051.previousModule == "GICLS051"){
			objGICLS051.previousModule = null;
			showGeneratePLAFLAPage(objGICLS051.currentView, objCLMGlobal.lineCd);
		} else {
			showClaimListing();
		}
	}
	observeCancelForm("btnCancel", saveLossExpenseHistory, nvl(fromClaimMenu, "N") == "Y" ? goClaimsMain : doExitOnBtnCancel);	
	
	$("btnSave").observe("click", function(){
		if(changeTag == 1 || checkLossExpChildRecords()){
			saveLossExpenseHistory();
		}else{
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		}
	});
	
	function goClaimsMain(){
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
		setModuleId("");
	}
	
	function saveLossExpenseHistory(){
		var objParameters = new Object();
		objParameters.setGiclLossExpPayees  = getAddedAndModifiedJSONObjects(objGICLLossExpPayees);
		objParameters.delGiclLossExpPayees  = getDeletedJSONObjects(objGICLLossExpPayees);
		objParameters.setGiclClmLossExpense = getAddedAndModifiedJSONObjects(objGICLClmLossExpense);
		objParameters.delGiclClmLossExpense = getDeletedJSONObjects(objGICLClmLossExpense);
		objParameters.setGiclLossExpDtl = getAddedAndModifiedJSONObjects(objGICLLossExpDtl);
		objParameters.delGiclLossExpDtl = getDeletedJSONObjects(objGICLLossExpDtl);
		
		new Ajax.Request(contextPath+"/GICLClaimLossExpenseController", {
			asynchronous: true,
			parameters:{
				action: "saveLossExpenseHistory",
				parameters: JSON.stringify(objParameters) 
			},
			onCreate: function(){
				showNotice("Saving Loss Expense history...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if(response.responseText == "SUCCESS"){
						if(savedFromLossExpDtl == "N"){ //added by robert GENQA 5027 11.04.15
							showWaitingMessageBox(objCommonMessage.SUCCESS, "S", refreshLossExpensePage);
						}
						changeTag = 0;	
						savedFromLossExpDtl = "N"; //added by robert GENQA 5027 11.04.15
					}else{
						showMessageBox(response.responseText, "E");							
					}
				}	
			}
		});
	}
	
	
	$("btnDistDate").observe("click", function(){
		showDistributionDate();
	});
	
	$("btnViewHistory").observe("click", function(){
		getViewHistoryListing();
	});
	
	$("btnCancelledAdvice").observe("click", function(){
		showCancelledAdviceList();
	});
	
	$("btnEvalReport").observe("click", function(){
		checkLossExpenseChanges(showLossExpEvalNumList);
	});
	
	$("btnCancelHistory").observe("click", function(){
		checkLossExpenseChanges(cancelHistory);
	});
	
	$("btnClearHist").observe("click", function(){
		checkLossExpenseChanges(validateClearHistory);
	});
	
	$("btnBillInfo").observe("click", function(){
		checkLossExpenseChanges(showLossExpBillInfo);
	});
	
	$("btnLOA").observe("click", function(){
		checkLossExpenseChanges(showLossExpLOA);
	});
	
	$("btnCSL").observe("click", function(){
		checkLossExpenseChanges(showLossExpCSL);
	});
	
	$("btnNegate").observe("click", function(){
		checkLossExpenseChanges(validateNegateHistory);
	});
	
	$("btnDistribute").observe("click", function(){
		checkLossExpenseChanges(validateDistribution);
	});
	
	//kenneth 11.24.2014
	//$("btnMaintainPayees").observe("click", function(){
	observeAccessibleModule(accessType.BUTTON, "GICLS150", "btnMaintainPayees", function(){ //marco - 05.21.2015 - GENQA SR 4470
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			objCLMGlobal.callingForm = "GICLS030";
			showMenuClaimPayeeClass(null, null);
		}
	});

	hideNotice();
</script>