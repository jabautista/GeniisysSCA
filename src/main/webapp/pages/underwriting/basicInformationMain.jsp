<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<!-- added by Jerome Orio 11.04.2010 -->
<script type="text/javascript">
	objUW.hidObjGIPIS002 = {};
	objUW.hidObjGIPIS002.forSaving = false;
	objUW.hidObjGIPIS002.gipiWPolbasJSON = JSON.parse('${gipiWPolbasJSON}'.replace(/\\/g, '\\\\'));
	objUW.hidObjGIPIS002.reqCredBranch = ('${reqCredBranch}');
	objUW.hidObjGIPIS002.defCredBranch = ('${defCredBranch}');
	objUW.hidObjGIPIS002.updCredBranch = ('${updCredBranch}');
	objUW.hidObjGIPIS002.dispDefaultCredBranch = ('${dispDefaultCredBranch}'); // Kris 07.04.2013 for UW-SPECS-2013-091
	objUW.hidObjGIPIS002.reqRefPolNo = ('${reqRefPolNo}');
	objUW.hidObjGIPIS002.reqRefNo = ('${reqRefNo}'); //added by Jdiago 09.09.2014
	objUW.hidObjGIPIS002.genBankRefNoTag = "N"; //added by Jdiago 09.09.2014
	objUW.hidObjGIPIS002.updIssueDate = ('${updIssueDate}');
	objUW.hidObjGIPIS002.issCdRi = ('${issCdRi}');
	objUW.hidObjGIPIS002.gipiWPolbasExist = ('${isExistGipiWPolbas}');
	objUW.hidObjGIPIS002.gipiWItmperlExist = ('${isExistGipiWItmperl}');
	objUW.hidObjGIPIS002.gipiWinvTaxExist = ('${isExistGipiWinvTax}');
	objUW.hidObjGIPIS002.gipiWPolnrepExist = ('${isExistGipiWPolnrep}');
	objUW.hidObjGIPIS002.gipiWOpenPolicyExist = ('${isExistGipiWOpenPolicy}');
	objUW.hidObjGIPIS002.gipiWItemExist = ('${isExistGipiWItem}');
	objUW.hidObjGIPIS002.gipiWInvoiceExist = ('${isExistGipiWInvoice}');
	objUW.hidObjGIPIS002.lineCd = ('${gipiParList.lineCd}');
	objUW.hidObjGIPIS002.paramSublineCdDesc = "";
	objUW.hidObjGIPIS002.paramSublineCd = unescapeHTML2(('${gipiWPolbas.sublineCd }')); // added unescape by j.diago 05.20.2014
	objUW.hidObjGIPIS002.deleteAllTables = "N";
	objUW.hidObjGIPIS002.deleteCommInvoice = "N";
	objUW.hidObjGIPIS002.mnSublineMop = ('${mnSublineMop}');
	objUW.hidObjGIPIS002.lcMN = ('${lcMN}');
	objUW.hidObjGIPIS002.lcMN2 = ('${lcMN2}');
	objUW.hidObjGIPIS002.lcFI = ('${lcFI}');
	objUW.hidObjGIPIS002.inspectionStatus = ('${inspectionStatus}');
	objUW.hidObjGIPIS002.reqSurveySettAgent = ('${reqSurveySettAgent}');
	objUW.hidObjGIPIS002.opFlag = "N";
	objUW.hidObjGIPIS002.ora2010Sw = ('${ora2010Sw}');
	objUW.hidObjGIPIS002.invoiceSwB540 = ('${gipiWPolbas.invoiceSw}');
	objUW.hidObjGIPIS002.designationB540 = ('${gipiWPolbas.designation}');
	objUW.hidObjGIPIS002.issCdB540 = ('${gipiWPolbas.issCd}');
	objUW.hidObjGIPIS002.isOpenPolicy = "N";
	objUW.hidObjGIPIS002.deleteBillSw = "N";
	objUW.hidObjGIPIS002.deleteSw = "N";
	objUW.hidObjGIPIS002.deleteWPolnrep = "N";
	objUW.hidObjGIPIS002.deleteCoIns = "";
	objUW.hidObjGIPIS002.validatedIssuePlace = "N";
	objUW.hidObjGIPIS002.validatedBookingDate = "N";
	objUW.hidObjGIPIS002.issueYy = ('${gipiWPolbas.issueYy }');
	/* 	comment out by andrew - 02.03.2012
	
		if (objUW.hidObjGIPIS002.lcMN == objUW.hidObjGIPIS002.lineCd 
			|| objUW.hidObjGIPIS002.lcMN2 == "MN") {
		objUW.hidObjGIPIS002.surveyAgentLOV = JSON
				.parse('${surveyAgentListingJSON}'.replace(/\\/g, '\\\\'));
		objUW.hidObjGIPIS002.settlingAgentLOV = JSON
				.parse('${settlingAgentListingJSON}'.replace(/\\/g, '\\\\'));
	} */
	if (objUW.hidObjGIPIS002.ora2010Sw == "Y") {
		objUW.hidObjGIPIS002.companyLOV = JSON.parse('${companyListingJSON}'.replace(/\\/g, '\\\\'));
		objUW.hidObjGIPIS002.employeeLOV = JSON.parse('${employeeListingJSON}'.replace(/\\/g, '\\\\'));
		objUW.hidObjGIPIS002.bancTypeCdLOV = JSON.parse('${bancTypeCdListingJSON}'.replace(/\\/g, '\\\\'));
		objUW.hidObjGIPIS002.bancAreaCdLOV = JSON.parse('${bancAreaCdListingJSON}'.replace(/\\/g, '\\\\'));
		objUW.hidObjGIPIS002.bancBranchCdLOV = JSON.parse('${bancBranchCdListingJSON}'.replace(/\\/g, '\\\\'));
		objUW.hidObjGIPIS002.managerCd = ('${gipiWPolbas.managerCd}');
		;
		objUW.hidObjGIPIS002.planCdLOV = JSON.parse('${planCdListingJSON}'.replace(/\\/g, '\\\\'));
	}
	objUW.hidObjGIPIS002.geninInfoCd = ('${gipiWPolGenin.geninInfoCd}');
	objUW.hidObjGIPIS002.paramCompSw = ('${gipiWPolbas.compSw}');
	objUW.hidObjGIPIS002.precommitDelTab = "N";
	objUW.hidObjGIPIS002.overrideTakeupTerm = ('${overrideTakeupTerm}');
	objUW.hidObjGIPIS002.coInsurance = JSON.parse('${coInsuranceJSON}'.replace(/\\/g, '\\\\'));
	objUWGlobal.coInsurance = objUW.hidObjGIPIS002.coInsurance;
	objUW.hidObjGIPIS002.typeCdStatus = ('${typeCdStatus}');
	objUW.hidObjGIPIS002.bookingAdv = ('${bookingAdv}');
	objUW.hidObjGIPIS002.updateBooking = ('${updateBooking}');
	objUW.hidObjGIPIS002.allowExpiredPolicyIssuance = ('${allowExpiredPolicyIssuance}' == "" ? "N" : '${allowExpiredPolicyIssuance}'); //added by Kenneth L. 03.26.2014 value from giis_parameter (ALLOW_EXPIRED_POLICY_ISSUANCE)
	objUW.hidObjGIPIS002.checkItemExist = ('${checkItemExist}');	//added by Gzelle 10032014
	objUW.hidObjGIPIS002.copyRefpolFrmOpenPol = ('${copyRefpolFrmOpenPol}'); //added by robert SR 21901 03.28.16
	objItemTempStorage = {};
	objMortgagees = [];
	objDeductibles = [];	

	tbgMortgagee = null;
	tbgPolicyDeductible = null;
</script>
<div id="basicInformationMainDiv" style="margin-top: 1px;" changeTagAttr="true"><!--  display: none; -->
	<div id="message" style="display: none;">${message}</div>
	<form id="basicInformationForm" name="basicInformationForm">
		<input type="hidden" name="parType" 	id="parType" 	value="${gipiParList.parType}" /> 
		<input type="hidden" name="parId" 		id="parId" 		value="<c:if test="${not empty gipiParList}">${gipiParList.parId}</c:if>" />
		<input type="hidden" name="lineCd" 		id="lineCd" 	value="<c:if test="${not empty gipiParList}">${gipiParList.lineCd}</c:if>" />
		<input type="hidden" name="issCd" 		id="issCd" 		value="<c:if test="${not empty gipiParList}">${gipiParList.issCd}</c:if>" />
		<input type="hidden" name="parStatus" 	id="parStatus" 	value="<c:if test="${not empty gipiParList}">${gipiParList.parStatus}</c:if>" />
		<input type="hidden" name="endtYy" 		id="endtYy" 	value="${gipiWPolbas.endtYy}<c:if test="${empty gipiWPolbas.endtYy}">0</c:if>" />
		<input type="hidden" name="endtSeqNo" 	id="endtSeqNo" 	value="${gipiWPolbas.endtSeqNo}<c:if test="${empty gipiWPolbas.endtSeqNo}">0</c:if>" />
		<input type="hidden" name="varVdate" 	id="varVdate" 	value="${varVdate }" />
		<input type="hidden" name="samePolnoSw" id="samePolnoSw" value="${gipiWPolbas.samePolnoSw}" />
		<input type="hidden" name="updateIssueDate" id="updateIssueDate" value="N" /> 
		<input type="hidden" name="samePolnoSw" id="samePolnoSw" value="${gipiWPolbas.samePolnoSw}" />
		<input type="hidden" name="pageName" 		id="pageName" 		 value="basicInformation" /> 
		<jsp:include page="subPages/basicInformation.jsp"></jsp:include> 
		<jsp:include page="subPages/poi.jsp"></jsp:include>
		<div id="renewalDetail">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
					<label>Renewal / Replacement Detail</label> 
					<span class="refreshers" style="margin-top: 0;">
						<label id="showRenewal" name="gro" style="margin-left: 5px;">Show</label>
					</span>
				</div>
			</div>
			<div id="policyRenewalDiv" align="center" class="sectionDiv" style="display: none;">
			</div>
		</div>
		<div id="openPolicy"></div>
		<c:if test="${lcMN eq gipiParList.lineCd or lcMN2 eq 'MN'}">
			<div id="marineDetails">
			<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv"><label>Marine Details</label>
			<span class="refreshers" style="margin-top: 0;"> <label
				id="showMarineDetails" name="gro" style="margin-left: 5px;">Show</label>
			</span></div>
			</div>
			<div id="marineDetailsInfo" class="sectionDiv" style="display: none;">
			<div id="marineDetailsSecDiv" style="margin: 10px auto;">
			<table width="100%" border="0">
				<tr>
					<td class="rightAligned" width="30%">Survey Agent</td>
					<td class="leftAligned">
						<!-- <select id="surveyAgentCd"
						name="surveyAgentCd" style="width: 450px;">
						<option value=""></option>
						</select> -->
						<div id="surveyAgentDiv" style="width: 448px;" class="withIconDiv">							
							<input type="hidden" id="surveyAgentCd" name="surveyAgentCd" type="text" readonly="readonly" value="${gipiWPolbas.surveyAgentCd}" />
							<input style="width: 420px;" id="surveyAgentName" name="surveyAgentName" type="text" readonly="readonly" class="withIcon" value="${gipiWPolbas.surveyAgentName}"/>
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSurveyAgent" name="searchSurveyAgent" alt="Go" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Settling Agent</td>
					<td class="leftAligned">
						<!-- <select id="settlingAgentCd"
						name="settlingAgentCd" style="width: 450px;">
						<option value=""></option>
						</select> -->
						<div id="settlingAgentDiv" style="width: 448px;" class="withIconDiv">							
							<input type="hidden" id="settlingAgentCd" name="settlingAgentCd" type="text" readonly="readonly" value="${gipiWPolbas.settlingAgentCd}"/>
							<input style="width: 420px;" id="settlingAgentName" name="settlingAgentName" type="text" readonly="readonly" class="withIcon" value="${gipiWPolbas.settlingAgentName}"/>
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSettlingAgent" name="searchSettlingAgent" alt="Go" />
						</div>
					</td>
				</tr>
			</table>
			</div>
			</div>
			</div>
		</c:if> 
		<c:if test="${ora2010Sw eq 'Y'}">
			<jsp:include page="subPages/bankPaymentDetails.jsp"></jsp:include>
			<jsp:include page="subPages/bancaDtls.jsp"></jsp:include>
		</c:if>
		<div id="mortgageePopups">
			<input type="hidden" id="mortgageeLevel" name="mortgageeLevel" value="0" />
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
		<div id="deductibleDetail1">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Policy Deductible</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showDeductible1" name="groItem" tableGrid="tbgPolicyDeductible" style="margin-left: 5px;">Show</label>
			   		</span>
			   	</div>
			</div>			
			<div id="deductibleDiv1" class="sectionDiv" style="display: none;">
				<jsp:include page="/pages/underwriting/common/deductibles/policy/policyDeductibles.jsp"></jsp:include>
			</div>			 		
			<input type="hidden" id="dedLevel" name="dedLevel" value="1" />
		</div>		
		<jsp:include page="subPages/otherDetails.jsp"></jsp:include>
	</form>

 	<div id="basicInfoDiv" name="basicInfoDiv" style="display: none;"></div>
	<form id="basicInformationFormButton" name="basicInformationFormButton">
		<div class="buttonsDiv" style="float: left; width: 100%;">
			<table align="center">
				<tr>
					<td><input type="button" class="button noChangeTagAttr" id="btnInspection"
						name="btnInspection" value="Select Inspection" style="display: none;"/></td>
					<td><input type="button" class="button" id="btnCancel"
						name="btnCancel" value="Cancel" style="width: 60px;" /></td>
					<td><input type="button" class="button" id="btnSave"
						name="btnSave" value="Save" style="width: 60px;" /></td>
				</tr>
			</table>
		</div>
	</form>
</div>

<script type="text/JavaScript">
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	setModuleId("GIPIS002");
	var lcMN = '${lcMN}';
	var lineCdTemp = '${gipiParList.lineCd}';
	var lcMN2 = '${lcMN2}';
	if (lcMN == lineCdTemp ||  lcMN2 == "MN"){ //added by steven 11/6/2012  - para papasok lang siya kapag marine cargo.
		var surveyAgentNameTemp = '${gipiWPolbas.surveyAgentName}';
		var settlingAgentNameTemp = '${gipiWPolbas.settlingAgentName}';
		if (surveyAgentNameTemp != null || surveyAgentNameTemp != ""){$("surveyAgentName").value = unescapeHTML2(surveyAgentNameTemp);}	//added by steven 10/31/2012
		if (settlingAgentNameTemp != null || settlingAgentNameTemp != ""){$("settlingAgentName").value = unescapeHTML2(settlingAgentNameTemp);} //added by steven 10/31/2012
		
	}
	$("packagePolicy").disable();
	$("quotationPrinted").disable();
	$("covernotePrinted").disable();
	if ($F("lineCd") != 'MC') {
		$("fleetTag").disable();
	}
	var delTariffPerils = false;
	//added by andrew 03.18.2010
	/* $("showRenewal").observe("click", function() {
		if ($("wpolnrepOldPolicyId") == null) {
			openRenewalReplacementDetailModal();
		}
	}); */ //moved to initAllFirst
	
	//added by andrew 03.18.2010
	$("showDeductible1").observe("click", function() {
		if ($("inputDeductible1") == null) {
			//showDeductibleModal(1);
			retrieveDeductibles(objUWParList.parId, 0, 1);
		}
	});

	
	observeAccessibleModule(accessType.SUBPAGE, "GIPIS168", "showMortgagee",
		function() {
			if ($F("mortgageeLevel") == 0) {
				//showMortgageeInfoModal($F("globalParId"), "0");
				retrieveMortgagee(objUWParList.parId, 0);
			}
	});	

	initializeItemAccordion();

	

	function getOpenPolicy() {
		try {
			new Ajax.Updater(
					"openPolicy",
					contextPath
							+ "/GIPIWOpenPolicyController?action=showOpenPolicyDetails&ajax=1&globalParId="
							+ $F("globalParId") + "&globalAssdNo="
							+ $F("globalAssdNo")
							+ "&lineCd=" + $F("lineCd")
							+ "&doe=" + $F("doe")
							+ "&doi=" + $F("doi")
							, {
						postBody : Form.serialize("basicInformationForm"),
						method : "GET",
						asynchronous : true,
						evalScripts : true,
						onCreate : function() {
						},
						onComplete : function() {
						}
					});
		} catch (e) {
			showErrorMessage("getOpenPolicy", e);
		}
	}

	function cancelFuncMain() {
		try {
			Effect.Fade("parInfoDiv", {
				duration : .001,
				afterFinish : function() {
					if ($("parListingMainDiv").down("div", 0).next().innerHTML
							.blank()) {
						if ($F("globalParType") == "E") {
							showEndtParListing();
						} else {
							showParListing();
						}
					} else {
						$("parInfoMenu").hide();
						Effect.Appear("parListingMainDiv", {
							duration : .001
						});
					}
					$("parListingMenu").show();
				}
			});
		} catch (e) {
			showErrorMessage("cancelFuncMain", e);
		}
	}

	function saveFuncMain() {
		try {
			if (objUW.hidObjGIPIS002.gipiWInvoiceExist == "1") {
				if ($F("doi") != $F("paramDoi")) {
					function onOkFunc() {
						objUW.hidObjGIPIS002.gipiWInvoiceExist = "0";
						if ($F("paramProrateFlag") != $F("prorateFlag")) {
							objUW.hidObjGIPIS002.precommitDelTab = "Y";
						}
						saveBasicInfoGIPIS002();
					}
					function onCancelFunc() {
						null;
					}
					if (objUW.hidObjGIPIS002.deleteBillSw == "N") {
						showConfirmBox(
								"Message",
								"You have changed the inception date of the policy from "
										+ $F("paramDoi")
										+ " to "
										+ $F("doi")
										+ " . This will delete the existing records in BILL PREMIUM / INVOICE COMMISSION. Do you want to continue ?",
								"Ok", "Cancel", onOkFunc, onCancelFunc);

					} else {
						saveBasicInfoGIPIS002();
					}
				} else {
					saveBasicInfoGIPIS002();
				}
			} else {
				saveBasicInfoGIPIS002();
			}
		} catch (e) {
			showErrorMessage("saveFuncMain", e);
		}
	}

	observeReloadForm("reloadForm", showBasicInfo);
	observeCancelForm("btnCancel", saveFuncMain, cancelFuncMain);

	function prepareParametersGIPIS002(objParameters) { //added parameter by robert 01.17.2014
		try {
			var params = "&deleteAllTables="
					+ objUW.hidObjGIPIS002.deleteAllTables + 
					"&deleteCommInvoice=" + objUW.hidObjGIPIS002.deleteCommInvoice;
			params = params + "&mnSublineMop="
					+ objUW.hidObjGIPIS002.mnSublineMop;
			params = params + "&lcMN=" + objUW.hidObjGIPIS002.lcMN;
			params = params + "&lcMN2=" + objUW.hidObjGIPIS002.lcMN2;
			params = params + "&ora2010Sw=" + objUW.hidObjGIPIS002.ora2010Sw;
			params = params + "&managerCd=" + objUW.hidObjGIPIS002.managerCd;
			if ($F("doi") != nvl($F("paramDoi"), $F("doi"))
					|| $F("doe") != nvl($F("paramDoe"), $F("doe"))) {
				params = params + "&dateSw=Y";
				params = params + "&deleteSw=Y";
			} else {
				params = params + "&dateSw=N";
				params = params + "&deleteSw=" + objUW.hidObjGIPIS002.deleteSw;
			}
			params = params + "&invoiceSwB540="
					+ objUW.hidObjGIPIS002.invoiceSwB540;
			params = params + "&designationB540="
					+ objUW.hidObjGIPIS002.designationB540;
			params = params + "&issCdB540=" + objUW.hidObjGIPIS002.issCdB540;
			params = params + "&isOpenPolicy="
					+ objUW.hidObjGIPIS002.isOpenPolicy;
			params = params + "&deleteBillSw="
					+ objUW.hidObjGIPIS002.deleteBillSw;
			params = params + "&deleteWPolnrep="
					+ objUW.hidObjGIPIS002.deleteWPolnrep;
			params = params + "&deleteCoIns="
					+ objUW.hidObjGIPIS002.deleteCoIns;
			params = params + "&validatedIssuePlace="
					+ objUW.hidObjGIPIS002.validatedIssuePlace;
			params = params + "&validatedBookingDate="
					+ objUW.hidObjGIPIS002.validatedBookingDate;
			params = params + "&issueYy=" + objUW.hidObjGIPIS002.issueYy;
			params = params + "&geninInfoCd="
					+ objUW.hidObjGIPIS002.geninInfoCd;
			params = params + "&precommitDelTab="
					+ objUW.hidObjGIPIS002.precommitDelTab;
			params = params + "&parameters=" //added by robert 01.17.2014
					+ encodeURIComponent(JSON.stringify(objParameters));
			return params;
		} catch (e) {
			showErrorMessage("prepareParametersGIPIS002", e);
		}
	}

	function saveGIPIS002() {
		try {
			var objParameters = new Object();
			objParameters.setMortgagees 	= prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objMortgagees));
			objParameters.delMortgagees 	= prepareJsonAsParameter(getDeletedJSONObjects(objMortgagees));
			objParameters.setDeductibles 	= prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objDeductibles));
			objParameters.delDeductibles	= prepareJsonAsParameter(getDeletedJSONObjects(objDeductibles));
			$("basicInformationForm").enable();
			new Ajax.Request(
					contextPath
							+ '/GIPIParInformationController?action=saveBasicInfo', //&parameters=' removed by robert 01.17.2014
							//+ encodeURIComponent(JSON.stringify(objParameters)), removed by robert 01.17.2014
					{
						method : "POST",
						postBody : Form.serialize("uwParParametersForm") + "&"
								+ Form.serialize("basicInformationForm")
								+ prepareParametersGIPIS002(objParameters), //added parameter by robert 01.17.2014
						asynchronous : false,
						evalScripts : true,
						onCreate : function() {
							$("basicInformationForm").disable();
							disableButton("btnCancel");
							disableButton("btnSave");
							showNotice("Saving, please wait...");
						},
						onComplete : function(response) {
							enableButton("btnCancel");
							enableButton("btnSave");
							hideNotice("");
							if (checkErrorOnResponse(response)) {
								var result = JSON.parse(response.responseText);
								if (result.message == "SUCCESS") {
									objUW.hidObjGIPIS002.gipiWPolbasJSON = result.gipiWPolbas;
									changeTag = 0;
									if (objUW.hidObjGIPIS002.ora2010Sw == "Y") {
										$("bankRefNo").value = result.bankRefNo;
									}
									postSaveGIPIS002();
									updateParParameters();
									updateBasicInfoParameters();
									showWaitingMessageBox(
											objCommonMessage.SUCCESS,
											imgMessage.SUCCESS,
											checkMenuGIPIS002);
								} else {
									showMessageBox(
											changeSingleAndDoubleQuotes(result.message),
											imgMessage.ERROR);
									postSaveGIPIS002();
								}
							}
						}
					});
		} catch (e) {
			showErrorMessage("saveGIPIS002", e);
		}
	}

	function checkPackPlanTag() {
		try {
			if (!$("packPLanTag").checked) {
				removeAllOptions($("selPlanCd"));
				$("selPlanCd").disable();
				var opt = document.createElement("option");
				opt.value = "";
				opt.text = "";
				opt.setAttribute("sublineCd", "");
				$("selPlanCd").options.add(opt);
				$("selPlanCd").removeClassName("required");
			} else {
				$("selPlanCd").addClassName("required");
			}
		} catch (e) {
			showErrorMessage("checkPackPlanTag", e);
		}
	}

	function postSaveGIPIS002() {
		try {
			$("basicInformationForm").enable();
			$("basicInformationFormButton").enable();
			$("packagePolicy").disable();
			$("quotationPrinted").disable();
			$("covernotePrinted").disable();
			if ($F("lineCd") != 'MC') {
				$("fleetTag").disable();
			}
			if ($F("premWarrTag") != 'Y') {
				$("premWarrDays").disable();
			}
			if ($("defaultDoe").value != $("doe").value) {
				$("prorateFlag").enable();
			} else {
				$("prorateFlag").disable();
			}
			if (objUW.hidObjGIPIS002.issCdRi == $("issCd").value) {
				$("coIns").disable();
			}
			if (objUW.hidObjGIPIS002.updCredBranch != "Y") {
				if ($("creditingBranch").value != "") {
					$("creditingBranch").disable();
				}
			}
			
			if(nvl(objUW.hidObjGIPIS002.updateBooking, "Y") == "N"){
				$("bookingMonth").disable(); // added bY: Nica 05.10.2012 - Per Ms VJ, booking month LOV should be disabled if UPDATE_BOOKING is equal to N.
			}
			
			if (objUW.hidObjGIPIS002.ora2010Sw == "Y") {
				if ($F("bankRefNo") != "") {
					generateBankRefNo($F("bankRefNo"));
					$("swBankRefNo").value = "Y";
				}
				if (!$("bancaTag").checked) {
					$("selBancTypeCd").clear();
					$("selAreaCd").clear();
					$("selBranchCd").clear();
					objUW.hidObjGIPIS002.managerCd = "";
					$("dspManagerCd").clear();
					$("dspManagerName").value = "No managers for the given values.";
				}
				checkPackPlanTag();
			}
			checkCoInsurance();
			delTariffPerils = false; //added by Gzelle 12022014
		} catch (e) {
			showErrorMessage("postSaveGIPIS002", e);
		}
	}

	function saveBasicInfoGIPIS002() {
		try {
			objUW.hidObjGIPIS002.forSaving = true;
			//validating open policy details --BRY 03.10.2010
			if (objUW.hidObjGIPIS002.isOpenPolicy == "Y") { // added if condition by jerome
				if (validateOpenPolicyBeforeSave()) {
					if (validateParDetailRecords()) {
						if ($F("openPolicyChanged") == "Y") {
							new Ajax.Request(
									contextPath
											+ "/GIPIWOpenPolicyController?action=validatePolicyDate",
									{
										method : "POST",
										evalScripts : true,
										asynchronous : false,
										parameters : {
											globalLineCd : $F("globalLineCd"),
											opSublineCd : $F("opSublineCd"),
											opIssCd : $F("opIssCd"),
											opIssYear : $F("opIssYear"),
											opPolSeqNo : $F("opPolSeqNo"),
											opRenewNo : $F("opRenewNo"),
											globalEffDate : $F("globalEffDate"),
											globalExpiryDate : $F("globalExpiryDate"),
											doi : $F("doi"),
											doe : $F("doe")
										},
										onComplete : function(response) {
											if (checkErrorOnResponse(response)) {
												var msg = response.responseText;
												var a = msg.split(",");
												var message1 = a[0];
												var message2 = a[1];
												var messageCode = a[2];
												if ("2" == messageCode) {
													showMessageBox(message1,
															imgMessage.INFO);
												} else if ("3" == messageCode) {
													if ("" != message1) {
														message3 = message2;
														showWaitingMessageBox(
																message1,
																imgMessage.INFO,
																showMessage3);
													} else {
														showMessage3();
													}

												} else if ("1" == messageCode) {
													showWaitingMessageBox(
															message1,
															imgMessage.INFO, "");
												} else {
													//saveOpenPolicy();
												}
											} else {
												return false;
											}
										}
									});
						}
					} else {
						return false;
					}
				} else {
					return false;
				}
			}
			
			if (validateBeforeSave()) {
				if (validateBeforeSave2()) {
					function onOkFunc() {
						objUW.hidObjGIPIS002.deleteAllTables = "Y";
						if (delTariffPerils) {
							deleteWitemPerilTariff(0,"basic");
						}
						saveGIPIS002();
					}
					function onCancelFunc() {
						return false;
						//objUW.hidObjGIPIS002.deleteAllTables = "N";
						//$("sublineCd").value = $("paramSubline").value;
						//saveGIPIS002();
					}
										
					if (objUW.hidObjGIPIS002.gipiWItemExist == "Y"
							&& objUW.hidObjGIPIS002.gipiWPolbasExist == "1"
							&& $F("sublineCd") != objUW.hidObjGIPIS002.paramSublineCd) {
						showConfirmBox(
								"Message",
								"Updating subline from "
										+ objUW.hidObjGIPIS002.paramSublineCdDesc
										+ " to "
										+ getListTextValue("sublineCd")
										+ ". Will delete records with to previous subline. Continue?",
								"Ok", "Cancel", onOkFunc, onCancelFunc);
					} else {
						if (delTariffPerils) {
							deleteWitemPerilTariff(0,"basic");
						}
						saveGIPIS002();
					}
					// shan 07.05.2013, SR-13491: moved functions above if-else condition to prevent undefined onOkFunc error
					/*function onOkFunc() {
						objUW.hidObjGIPIS002.deleteAllTables = "Y";
						saveGIPIS002();
					}
					function onCancelFunc() {
						return false;
						//objUW.hidObjGIPIS002.deleteAllTables = "N";
						//$("sublineCd").value = $("paramSubline").value;
						//saveGIPIS002();
					}*/
				}
			}
			$("reloadForm").click(); //edgar 02/02/2015
			objUW.hidObjGIPIS002.forSaving = false;
		} catch (e) {
			showErrorMessage("saveBasicInfoGIPIS002", e);
		}
	}

	$("btnSave").observe("focus", function() {
		objUW.hidObjGIPIS002.forSaving = true;
	});
	
	$("btnSave").observe("click", function() {
		if (changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
			objUW.hidObjGIPIS002.forSaving = false;
			return;
		}
		
		//marco - 05.30.2013 - added condition
		if($F("globalIssCd") != $F("globalIssCdRI")){
			//added by jeffdojello 04.24.2013
			if ((makeDate($("doe").value) < makeDate($("issueDate").value)) && objUW.hidObjGIPIS002.allowExpiredPolicyIssuance == "N") { //added Kenneth L. 03.26.2014 condition for objUW.hidObjGIPIS002.allowExpiredPolicyIssuance
				showWaitingMessageBox("A policy cannot expire before the date of its issuance.", imgMessage.ERROR,
						function(){	
								$("doe").focus();												  
						});
				return;
			}
		}
		
		saveFuncMain();
		
		//added by Daniel Marasigan SR 2169 08.01.2016; recreate invoice after saving basic info
		if ($("assuredName").getAttribute("prevAssdNo") != "" || $F("issuePlace") != $F("paramIssuePlace")){
			recreateInvoice($F('parId'), $F('lineCd'), $F('issCd'));
		}
	});

	function validateBeforeSave2() {
		try {
			var result = true;
			if (($F("policyStatus") == "2") || ($F("policyStatus") == "3")) {
				//var rowCount = $$("div[name='rowPolnrep']").size();
				if (objUW.hidObjGIPIS002.gipiWPolnrepExist == "0") {
					//if (($F("paramSubline") == $F("sublineCd")) && ($F("paramPolicyStatus") == $F("policyStatus"))) {
					result = false;
					showMessageBox(
							"This type of policy requires an entry of a renewal  or a replacement policy.",
							imgMessage.ERROR);
					//}	
				} else if (objUW.hidObjGIPIS002.gipiWPolnrepExist == "1") { //added by d.alcantara, 05092012
					var incept = makeDate($F("doi"));
					$$("div[name='rowPolnrep']").each(function (row) {			
						//if(incept < new Date(row.down("input", 8).value)) {
						if(($F("policyStatus") == "2") && incept < new Date(row.down("input", 8).value)) { //robert 12.05.2012 added condition 
							result = false;
							showMessageBox("Incept Date is within the duration of the policy to be renewed. \n"+
									"Either change the policy inception or change the policy to be renewed.", imgMessage.ERROR);
						}
					});
				}
			}
			if (objUW.hidObjGIPIS002.isOpenPolicy == "Y") {
				if (objUW.hidObjGIPIS002.gipiWOpenPolicyExist == "0") {
					result = false;
					showMessageBox(
							"This subline requires an entry of an open policy.",
							imgMessage.ERROR);
				}
			}
			
			if (objUW.hidObjGIPIS002.ora2010Sw == "Y" && result) {
				if($("bancaTag").checked != ($("bancaTag").getAttribute("originalValue") == "Y" ? true : false) && $F("globalParStatus") > 5){
					if(!(objUW.hidObjGIPIS002.gipiWItemExist == "Y" && objUW.hidObjGIPIS002.gipiWPolbasExist == "1" && $F("sublineCd") != objUW.hidObjGIPIS002.paramSublineCd)){
						result = false;
						showConfirmBox("Message", "Commission Invoice will be deleted because Bancassurance Type was changed. Do you want to continue?", "Yes", "No",
								function(){
									objUW.hidObjGIPIS002.deleteCommInvoice = "Y";
									if (delTariffPerils) {
										deleteWitemPerilTariff(0,"basic");
									}
									saveGIPIS002();
							  	});	
					}
				}
			}

			return result;
		} catch (e) {
			showErrorMessage("validateBeforeSave2", e);
		}
	}

	function validateBeforeSave() {
		try {
			var result = true;
			var today = new Date();
			var eff = makeDate($F("issueDate"));
			var incept = makeDate($F("doi"));
			var exp = makeDate($F("doe"));

			if ($F("parNo") == "") {
				result = false;
				customShowMessageBox("PAR No. is required.", imgMessage.ERROR,
						"parNo");
				return false;
			}
			if ($F('sublineCd') == '') {
				result = false;
				customShowMessageBox("Subline is required.", imgMessage.ERROR,
						"sublineCd");
			}
			if ($F('policyStatus') == '') {
				result = false;
				customShowMessageBox("Policy Status is required.",
						imgMessage.ERROR, "policyStatus");
				return false;
			}
			if ($F("assuredName") == "") {
				result = false;
				customShowMessageBox("Assured Name is required.",
						imgMessage.ERROR, "assuredName");
				return false;
			}
			if ($F("doi") == "") {
				result = false;
				customShowMessageBox("Inception date is required.",
						imgMessage.ERROR, "doi");
				return false;
			}
			if ($F("doe") == "") {
				result = false;
				customShowMessageBox("Expiry date is required.",
						imgMessage.ERROR, "doe");
				return false;
			}
			if ($F("address1") == "") {
				result = false;
				customShowMessageBox("Address 1 is required.",
						imgMessage.ERROR, "address1");
				return false;
			}
			if ($F("premWarrTag") == 'Y') {
				if ($F("premWarrDays") == '') {
					result = false;
					customShowMessageBox("Premium warranty days is required.",
							imgMessage.ERROR, "premWarrDays");
					return false;
				}
				if (parseInt($F("premWarrDays")) < 1
						|| parseInt($F("premWarrDays")) > 999) {
					$("premWarrDays").clear();
					result = false;
					customShowMessageBox(
							"Entered premium warranty days is invalid. Valid value is from 1 to 999.",
							imgMessage.ERROR, "premWarrDays");
					return false;
				}
			}
			if ($F("prorateFlag") == "1" && parseInt($F("noOfDays")) < 0) {
				result = false;
				customShowMessageBox(
						"Entered pro-rate number of days is invalid. Valid value is from 0 to 99999.",
						imgMessage.ERROR, "noOfDays");
				$("noOfDays").value = $("paramNoOfDays").value;
				return false;
			}
			if ($F("prorateFlag") == "1" && $F("noOfDays") == "") {
				result = false;
				customShowMessageBox("Pro-rate number of days is required.",
						imgMessage.ERROR, "noOfDays");
				return false;
			}
			if ($F("prorateFlag") == "3") {
				if ($F("shortRatePercent") == "") {
					result = false;
					customShowMessageBox("Short Rate percent is required.",
							imgMessage.ERROR, "shortRatePercent");
					return false;
				}
				if (parseFloat($F("shortRatePercent")) < 0.000000001
						|| parseFloat($F('shortRatePercent')) > 100.000000000
						|| isNaN(parseFloat($F('shortRatePercent')))) {
					result = false;
					customShowMessageBox(
							"Entered short rate percent is invalid. Valid value is from 0.000000001 to 100.000000000.",
							imgMessage.ERROR, "shortRatePercent");
					return false;
				}
			}
			if ($F("provisionalPremium") == 'Y') {
				if ($F("provPremRatePercent") == "") {
					result = false;
					customShowMessageBox(
							"Provisional Premium percent is required.",
							imgMessage.ERROR, "provPremRatePercent");
					return false;
				}
				if (parseFloat($F("provPremRatePercent")) < 0
						|| parseFloat($F('provPremRatePercent')) > 100.000000000
						|| isNaN(parseFloat($F('provPremRatePercent')))) {
					result = false;
					customShowMessageBox(
							"Entered provisional premium percent is invalid. Valid value is from 0.000000000 to 100.000000000.",
							imgMessage.ERROR, "provPremRatePercent");
					return false;
				}
			}
			if ($F("issueDate") == "") {
				result = false;
				customShowMessageBox("Issue date is required.",
						imgMessage.ERROR, "issueDate");
				return false;
			}
			if ($F("bookingMonth") == "") {
				result = false;
				customShowMessageBox("Booking Date is required.",
						imgMessage.ERROR, "bookingMonth");
				return false;
			}
			if (($("generalInformation").value.length * 1) > 34000) {
				result = false;
				customShowMessageBox(
						"You have exceeded the maximum number of allowed characters(34000) for General Information.",
						imgMessage.ERROR, "generalInformation");
				return false;
			}
			if (($("initialInformation").value.length * 1) > 34000) {
				result = false;
				customShowMessageBox(
						"You have exceeded the maximum number of allowed characters(34000) for Initial Information.",
						imgMessage.ERROR, "initialInformation");
				return false;
			}
			if ($F("manualRenewNo") == "") {
				result = false;
				customShowMessageBox("Manual Renew No. is required.",
						imgMessage.ERROR, "manualRenewNo");
				return false;
			}
			if ($F("creditingBranch") == "") {
				if (objUW.hidObjGIPIS002.reqCredBranch == "Y") {
					if (objUW.hidObjGIPIS002.defCredBranch == "ISS_CD") {
						result = false;
						customShowMessageBox("Crediting Branch is required.",
								imgMessage.ERROR, "creditingBranch");
						return false;
					}
				}
			}
			if ($F("referencePolicyNo") == "") {
				if (objUW.hidObjGIPIS002.reqRefPolNo == "Y") {
					result = false;
					customShowMessageBox("Reference Policy No. is required.",
							imgMessage.ERROR, "referencePolicyNo");
					return false;
				}
			}
			
			if(objUW.hidObjGIPIS002.genBankRefNoTag != "Y"){ //added by Jdiago 09.09.2014
				if(objUW.hidObjGIPIS002.reqRefNo == "Y" && objUW.hidObjGIPIS002.ora2010Sw == "Y"){	//Gzelle 06172015 SR3866 added ora2010sw
					result = false;
					customShowMessageBox("Please provide a bank reference number for this PAR before saving the policy.",imgMessage.ERROR,"nbtAcctIssCd");
					return false;
				}
			}
		
			if ($F("takeupTermType") == "") {
				result = false;
				customShowMessageBox("Take-up term is required. ",
						imgMessage.ERROR, "takeupTermType");
				$("takeupTermType").value = $("paramTakeupTermType").value;
				return false;
			}

			if (result) {
				if (objUW.hidObjGIPIS002.lcMN == $F("lineCd")
						|| objUW.hidObjGIPIS002.lcMN2 == "MN") {
					if (objUW.hidObjGIPIS002.reqSurveySettAgent == "Y") {
						if ($F("surveyAgentCd") == "") {
							result = false;
							customShowMessageBox(
									"Survey Agent in marine details is required.",
									imgMessage.ERROR, "surveyAgentName");
							return false;
						}
						if ($F("settlingAgentCd") == "") {
							result = false;
							customShowMessageBox(
									"Settling Agent in marine details is required.",
									imgMessage.ERROR, "settlingAgentName");
							return false;
						}
					}
				}
			}

			if (objUW.hidObjGIPIS002.ora2010Sw == "Y") {
				if ($F("companyCd") != "" && $F("employeeCd") == "") {
					if (result) {
						result = false;
						customShowMessageBox(
								"Choose an employee first before proceeding.",
								imgMessage.INFO, "employeeCd");
						return false;
					}
				} else if ($F("companyCd") == "" && $F("employeeCd") != "") {
					if (result) {
						result = false;
						customShowMessageBox("Company is required.",
								imgMessage.ERROR, "companyCd");
						return false;
					}
				}
				if ($("bancaTag").checked) {
					if (result) {
						if ($F("selBancTypeCd") == "" || $F("selAreaCd") == ""
								|| $F("selBranchCd") == ""
								|| objUW.hidObjGIPIS002.managerCd == ""
								|| $F("dspManagerCd") == "") {
							result = false;
							customShowMessageBox(
									"Please be advised that information for bank assurance should be complete.",
									imgMessage.ERROR, "selBancTypeCd");
							return false;
						}
					}
				}
				if ($("packPLanTag").checked) {
					if ($F("selPlanCd") == "") {
						result = false;
						customShowMessageBox("Package plan is required.",
								imgMessage.ERROR, "selPlanCd");
						return false;
					}
				}
				if ($F("swBankRefNo") == "N") {
					if ($F("bankRefNo") != "") {
						if (!validateBankRefNo()) {
							result = false;
							return false;
						} else {
							result = true;
						}
					} else {
						if ($F("nbtAcctIssCd") != "01"
								|| $F("nbtBranchCd") != "0000") {
							$("bankRefNo").value = formatNumberDigits(
									$F("nbtAcctIssCd"), 2)
									+ "-"
									+ formatNumberDigits($F("nbtBranchCd"), 4)
									+ "-"
									+ formatNumberDigits($F("dspRefNo"), 7)
									+ "-"
									+ formatNumberDigits($F("dspModNo"), 2);
							if (!validateBankRefNo()) {
								result = false;
								return false;
							} else {
								result = true;
							}
						}
					}
				}
			}

			if (result) {
				if (exp < incept) {
					result = false;
					customShowMessageBox(
							"Expiry date is invalid. Expiry date must be later than Inception date.",
							imgMessage.ERROR, "doe");
					return false;
				} /*else if (incept<today) {
								result = false;
								$("doi").focus();
								showMessageBox("Incept date must not be earlier than system date.", imgMessage.ERROR);
							} else if (Math.ceil((eff-today)/1000/24/60/60)>30){
								result = false;
								$("issueDate").focus();
								showMessageBox('Issue date should be at least 30 days after system date.');	
							}*/
			}
			return result;
		} catch (e) {
			showErrorMessage("validateBeforeSave", e);
		}
	}

	function validateOpenPolicyBeforeSave() { //bry 03.10.2010
		var result = true;
		if (($F("opSublineCd") == "") || ($F("opIssCd") == "")
				|| ($F("opIssYear") == "") || ($F("opPolSeqNo") == "")
				|| ($F("opRenewNo") == "")) {
			result = false;
			$("opLineCd").focus();
			showMessageBox("An open policy must be entered.", imgMessage.ERROR);
		}
		return result;
	}

	function validateParDetailRecords() {
		try {
			var result = true;
			if (($F("paramOpSublineCd") == $F("opSublineCd"))
					&& ($F("paramOpIssCd") == $F("opIssCd"))
					&& (parseFloat($F("paramOpIssueYy")) == parseFloat($F("opIssYear")))
					&& (parseFloat($F("paramOpPolseqNo")) == parseFloat($F("opPolSeqNo")))
					&& (parseFloat($F("paramOpRenewNo")) == parseFloat($F("opRenewNo")))) {
				//none
			} else {
				if ("Y" == $F("gipiWItemExist")) {
					$("opSublineCd").value = $F("paramOpSublineCd");
					$("opIssCd").value = $F("paramOpIssCd");
					$("opIssYear").value = $F("paramOpIssueYy");
					$("opPolSeqNo").value = $F("paramOpPolseqNo");
					$("opRenewNo").value = $F("paramOpRenewNo");
					$("declaration").value = $F("paramDecltnNo");
					setPaddedFields();
					result = false;
					showMessageBox(
							"The open policy referred to by this PAR cannot be updated, for detail records already exist.  However, you may choose to delete this PAR and recreate it with the necessary changes.",
							imgMessage.ERROR);
				}
			}
			return result;
		} catch (e) {
			showErrorMessage("validateParDetailRecords", e);
		}
	}

	function setPaddedFields() {
		try {
			$("opIssYear").value = $F("opIssYear") == "" ? "" : parseFloat(
					$F("opIssYear")).toPaddedString(2);
			$("opPolSeqNo").value = $F("opPolSeqNo") == "" ? "" : parseFloat(
					$F("opPolSeqNo")).toPaddedString(7);
		} catch (e) {
			showErrorMessage("setPaddedFields", e);
		}
	}

	function showMessage3() {
		showMessageBox(message3, imgMessage.INFO);
	}

	$("sublineCd")
			.observe(
					"change",
					function() {
						objUW.hidObjGIPIS002.opFlag = $("sublineCd").options[$("sublineCd").selectedIndex]
								.getAttribute("opFlag");
						var paramSubline = $("paramSubline").value;
						var sublineCd = $("sublineCd").value;
						if (sublineCd == "") {
							showMessageBox("Subline is required.",
									imgMessage.ERROR);
							$("sublineCd").value = $("paramSubline").value;
						}

						if ((paramSubline != sublineCd) && (sublineCd != "")) {
							if (objUW.hidObjGIPIS002.gipiWPolbasExist == "1") {
								new Ajax.Updater(
										"message",
										contextPath + '/GIPIParInformationController?action=whenValidateSubline',
										{
											method : "POST",
											parameters : {
												paramSublineCd : $("paramSubline").value,
												lineCd : $("lineCd").value,
												sublineCd : $("sublineCd").value,
												parId : $("parId").value,
												issCd : $("issCd").value
											},
											asynchronous : true,
											evalScripts : true,
											onCreate : function() {
												//showNotice("Validating subline...");
												$("basicInformationFormButton")
														.disable();
											},
											onComplete : function(response) {
												$("basicInformationFormButton")
														.enable();
												if ($("message").innerHTML != "SUCCESS") {
													showMessageBox($("message").innerHTML);
													$("sublineCd").value = paramSubline;
												} else {
													clearRenRepGIPIS002();
												}
												//hideNotice("");	
												validateOpenPolicyButton();
											}
										});
							}
							if ($F("policyStatus") == "2"
									|| $F("policyStatus") == "3") { //added by nok 09.15.10
								$("wpolnrepSublineCd").value = sublineCd; // added by andrew 03.16.2010
							}
							validateOpenPolicyButton();
						} else {
							validateOpenPolicyButton();
							objUW.hidObjGIPIS002.deleteWPolnrep = "N";
						}
						if (objUW.hidObjGIPIS002.ora2010Sw == "Y") {
							updatePlanCdLOV(false);
							checkPackPlanTag();
						}
					});

	var preBookingMonth;
	var preBookingYear;
	var preBookingMth;
	$("bookingMonth").observe(
			"focus",
			function() {
				preBookingMonth = $("bookingMonth").value;
				preBookingYear = $("bookingYear").value;
				preBookingMth = $("bookingMth").value;

				if ($("bookingMonth").options.length <= 1) {
					$("bookingMonth").blur();
					showWaitingMessageBox(
							"List of Values contains no entries.",
							imgMessage.ERROR, function() {
								$("bookingMonth").blur();
							});
				}
			});

	$("bookingMonth").observe("change", function() {
		if ($F("bookingMonth") != "") {
			if($F("issueDate") == "") {
				showMessageBox("Please enter an Issue Date first.", "e");
				$("bookingMonth").selectedIndex = 0;
			} else if($F("doi") == ""){ //added by jeffdojello 06052013 SR-13347
				showMessageBox("Please enter an Inception Date first.", "e");
				$("bookingMonth").selectedIndex = 0;			
		    }else {
				objUW.hidObjGIPIS002.validatedBookingDate = "Y";
				if (!validateBookingDate()) {
					$("bookingMonth").value = preBookingMonth;
					$("bookingYear").value = preBookingYear;
					$("bookingMth").value = preBookingMth;
				}
	
				$("opt2") ? $("opt2").remove() : null;
			}
			//if (($F("bookingYear") != $F("paramBookingYear")) || ($F("bookingMth") != $F("paramBookingMth"))) {
			//	objUW.hidObjGIPIS002.validatedBookingDate = "Y";
			//} else {
			//	objUW.hidObjGIPIS002.validatedBookingDate = "N";
			//}		
		} else {
			objUW.hidObjGIPIS002.validatedBookingDate = "N";
		}
		if ($F("doi") != "" && $F("bookingMonth") != "") {
			getIssueYyGIPIS002();
		}
	});

	function validateOpenPolicyButton() {
		objUW.hidObjGIPIS002.isOpenPolicy = $("sublineCd").options[$("sublineCd").selectedIndex]
				.getAttribute("openPolicySw");
		if (objUW.hidObjGIPIS002.isOpenPolicy == "Y") {
			getOpenPolicy();
			$("openPolicy").show();
		} else {
			$("openPolicy").hide();
		}
	}

	$("policyStatus")
			.observe(
					"change",
					function() {
						if (($("policyStatus").value == 1)
								|| ($("policyStatus").value == 2)
								|| ($("policyStatus").value == 3)
								|| ($("policyStatus").value == 4)
								|| ($("policyStatus").value == 5)
								|| ($("policyStatus").value == 'S')) {
							null;
						} else if ($("policyStatus").value == "") {
							$("policyStatus").value = $("paramPolicyStatus").value;
							showMessageBox("Policy Status is required.",
									imgMessage.ERROR);
							initAllFirst();
						} else {
							$("policyStatus").value = $("paramPolicyStatus").value;
							showMessageBox("Invalid policy status.",
									imgMessage.ERROR);
							initAllFirst();
						}

						if (($("paramPolicyStatus").value == 2)
								|| ($("paramPolicyStatus").value == 3)) {
							if ($("policyStatus").value == 1) {
								$("renewNo").value = 0;
							} else if ($("policyStatus").value == $("paramPolicyStatus").value) {
								$("renewNo").value = $("paramRenewNo").value;
							}
						}

						if ($F("paramPolicyStatus") != $F("policyStatus")) {
							if (objUW.hidObjGIPIS002.gipiWPolbasExist == "1") {
								objUW.hidObjGIPIS002.deleteWPolnrep = "Y";
							}
						} else {
							objUW.hidObjGIPIS002.deleteWPolnrep = "N";
						}

						if (($F("policyStatus") == "2")
								|| ($F("policyStatus") == "3")) {
							$("renewalDetail").setStyle( {
								display : ""
							}); //added by andrew 03.18.2010
							objUW.hidObjGIPIS002.deleteWPolnrep = "N";
						} else {
							$("renewalDetail").setStyle( {
								display : "none"
							}); //added by andrew 03.18.2010
							objUW.hidObjGIPIS002.deleteWPolnrep = "Y";
						}

						if ($("samePolicyNo") != null) { //added by andrew 07.15.2010
							($F("policyStatus") == 3 ? $("samePolicyNo")
									.disable() : $("samePolicyNo").enable());
						}
						clearRenRepGIPIS002();
					});

	var takeupTermOverrideOk = "N"; //override was successful?
	$("takeupTermType")
			.observe(
					"focus",
					function() {
						if (nvl(objUW.hidObjGIPIS002.overrideTakeupTerm, "N") == "Y"
								&& takeupTermOverrideOk == "N") { //if override is required
							objAC.funcCode = "OT";
							objACGlobal.calledForm = "GIPIS002";
							var ok = validateUserFunc2(objAC.funcCode,
									objACGlobal.calledForm);
							if (!ok) {
								$("takeupTermType").blur();
								commonOverrideOkFunc = function() {
									takeupTermOverrideOk = "Y";
									$("takeupTermType").focus();
									$("takeupTermType").scrollTo();
								};
								commonOverrideNotOkFunc = function() {
									showWaitingMessageBox(
											$("overideUserName").value
													+ " does not have an overriding function for this module.",
											imgMessage.ERROR, clearOverride);
									$("takeupTermType").value = $("paramTakeupTermType").value;
								};
								getUserInfo();
								$("overlayTitle").innerHTML = "Override default take-up term";
							} else if (ok) {
								takeupTermOverrideOk = "Y";
							}
						}
					});

	$("takeupTermType")
			.observe(
					"change",
					function() {
						if(checkPostedBinder()){ //added edgar 01/30/2015
							showWaitingMessageBox("You cannot update Take-Up Term Type. PAR has posted binder.", imgMessage.ERROR, 
									function(){
												$("takeupTermType").value = $("paramTakeupTermType").value;
												objUW.hidObjGIPIS002.forSaving = false;
												changeTag = 0;
											  });
							return false;
						}
						if (nvl(objUW.hidObjGIPIS002.overrideTakeupTerm, "N") == "Y"
								&& takeupTermOverrideOk == "N")
							$("takeupTermType").value = $("paramTakeupTermType").value;
						if (objUW.hidObjGIPIS002.gipiWPolbasExist == "1") {
							if ($F("takeupTermType") != $F("paramTakeupTermType")) {
								showConfirmBox(
										"Message",
										"Changing the take-up term will recreate the records in the tables and thus records in Bill Premium / Invoice Commission would be deleted, if any. Continue?",
										"Ok", "Cancel", onOkFunc, onCancelFunc);
							}
						}
						function onOkFunc() {
							//objUW.hidObjGIPIS002.deleteBillSw = "Y";
							objUW.hidObjGIPIS002.deleteSw = "Y";
							if (objUW.hidObjGIPIS002.forSaving) {
								saveBasicInfoGIPIS002();
							}
						}
						function onCancelFunc() {
							$("takeupTermType").value = $("paramTakeupTermType").value;
							objUW.hidObjGIPIS002.forSaving = false;
						}
					});

	function showRelatedSpan() {
		if ($F("prorateFlag") == "1") {
			$("shortRateSelected").hide();
			$("shortRatePercent").hide();
			$("prorateSelected").show();
			$("noOfDays").show();
			$("noOfDays").value = computeNoOfDays($F("doi"), $F("doe"),
					$F("compSw"));
		} else if ($F("prorateFlag") == "3") {
			$("prorateSelected").hide();
			$("shortRateSelected").show();
			$("shortRatePercent").show();
			$("noOfDays").hide();
			$("noOfDays").value = "";
		} else {
			$("shortRateSelected").hide();
			$("shortRatePercent").hide();
			$("prorateSelected").hide();
			$("noOfDays").hide();
			$("noOfDays").value = "";
		}
	}

	$("doe")
			.observe(
					"blur",
					function() {
						if ($F("doe") != $F("paramDoe")) {//added edgar 01/29/2015 to check for posted binder
							if(checkPostedBinder()){ 
								showWaitingMessageBox("You cannot update Expiry Date. PAR has posted binder.", imgMessage.ERROR, 
										function(){
													$("doe").value = $F("paramDoe");
													objUW.hidObjGIPIS002.deleteBillSw = "N";
													$("prorateFlag").value = $F("paramProrateFlag");
													showRelatedSpan();
													$("prorateFlag").enable();
													objUW.hidObjGIPIS002.forSaving = false;
													changeTag = 0;
												  });
								return false;
							}
						}
						if ($F("doe") != $F("paramDoe") && $F("doe") != "") {
							if (($("paramProrateFlag").value == "1")
									&& (objUW.hidObjGIPIS002.deleteBillSw == "N")) {
								if ((objUW.hidObjGIPIS002.gipiWPolbasExist == "1")
										&& (objUW.hidObjGIPIS002.gipiWItmperlExist == "1")) {
									showConfirmBox(
											"Message",
											"You have changed your policy's expiry date from "
													+ $("paramDoe").value
													+ " to "
													+ $("doe").value
													+ '. Will now do the necessary changes.?',
											"Ok", "Cancel", onOkFunc,
											onCancelFunc);
								}
							}
						}
						function onOkFunc() {
							deleteBillFunc();
						}
						function onCancelFunc() {
							$("doe").value = $F("paramDoe");
							objUW.hidObjGIPIS002.deleteBillSw = "N";
							$("doe").focus();
							$("prorateFlag").value = $F("paramProrateFlag");
							showRelatedSpan();
							$("prorateFlag").enable();
							objUW.hidObjGIPIS002.forSaving = false;
						}
						validateOpenPolicyButton(); //added by bryan 11.18.2010
					});

	function getIssueYyGIPIS002() {
		try {
			new Ajax.Updater(
					"message",
					contextPath + '/GIPIParInformationController?action=getIssueYy',
					{
						method : "POST",
						postBody : Form.serialize("basicInformationForm"),
						asynchronous : true,
						evalScripts : true,
						onCreate : function() {
							$("basicInformationFormButton").disable();
						},
						onComplete : function(response) {
							$("basicInformationFormButton").enable();
							if (checkErrorOnResponse(response)) {
								if (response.responseText == "Y") {
									showMessageBox(
											"Invalid param_value_v for parameter name POL_ISSUE_YY. Please contact your DBA.",
											imgMessage.ERROR);
								} else {
									objUW.hidObjGIPIS002.issueYy = response.responseText;
								}
								hideNotice("");
							}
						}
					});
		} catch (e) {
			showErrorMessage("getIssueYyGIPIS002", e);
		}
	}

	$("doi")
			.observe(
					"blur",
					function() {
						if ($F("paramDoi") != $F("doi")) {
							if(checkPostedBinder()){ //added edgar 01/29/2015 to check for posted binder
								showWaitingMessageBox("You cannot update Inception Date. PAR has posted binder.", imgMessage.ERROR, 
										function(){
													$("doi").value = $F("paramDoi");
													$("doe").value = $F("paramDoe");
													objUW.hidObjGIPIS002.deleteBillSw = "N";
													$("prorateFlag").value = $F("paramProrateFlag");
													showRelatedSpan();
													$("prorateFlag").enable();
													objUW.hidObjGIPIS002.forSaving = false;
													changeTag = 0;
												  });
								return false;
							}
							if (($("paramProrateFlag").value == "1")
									&& (objUW.hidObjGIPIS002.deleteBillSw == "N")) {
								if ((objUW.hidObjGIPIS002.gipiWPolbasExist == "1")
										&& (objUW.hidObjGIPIS002.gipiWItmperlExist == "1")) {
									showConfirmBox(
											"Message",
											"You have changed your policy's inception date from "
													+ $("paramDoi").value
													+ " to "
													+ $("doi").value
													+ '. Will now do the necessary changes.?',
											"Ok", "Cancel", onOkFunc,
											onCancelFunc);
								}
							}
						}
						function onOkFunc() {
							deleteBillFunc();
						}
						function onCancelFunc() {
							$("doi").value = $F("paramDoi");
							$("doe").value = $F("paramDoe");
							objUW.hidObjGIPIS002.deleteBillSw = "N";
							$("doi").focus();
							$("prorateFlag").value = $F("paramProrateFlag");
							showRelatedSpan();
							$("prorateFlag").enable();
							objUW.hidObjGIPIS002.forSaving = false;
						}
						if ($F("doi") != "") {
							if ((objUW.hidObjGIPIS002.issueYy == null)
									|| $F("paramDoi") != $F("doi")	//added by jeffdojello 02.18.2014
									|| (objUW.hidObjGIPIS002.issueYy == "")) {
								getIssueYyGIPIS002();
							}
						}
						validateOpenPolicyButton(); //added by bryan 11.18.2010
					});

	$("assuredName")
			.observe(
					"focus",
					function() {
						if ($("assuredNo").value != $("paramAssuredNo").value) {
							showConfirmBox(
									"Message",
									"Change of Assured will automatically recreate invoice and delete corresponding data on group information both ITEM and GROUP level. Do you wish to continue?",
									"Yes", "No", onOkFunc, onCancelFunc);
						}
						function onOkFunc() {
							disableMenu("post");
							disableMenu("enterInvoiceCommission");
							if (objUW.hidObjGIPIS002.forSaving) {
								saveBasicInfoGIPIS002();
							}
						}
						function onCancelFunc() {
							$("assuredNo").value = $("paramAssuredNo").value;
							$("assuredName").value = $("paramAssuredName").value;
							$("address1").value = 	objUW.hidObjGIPIS002.gipiWPolbasJSON.address1;
							$("address2").value = 	objUW.hidObjGIPIS002.gipiWPolbasJSON.address2;
							$("address3").value = 	objUW.hidObjGIPIS002.gipiWPolbasJSON.address3;
							$("industry").value = 	objUW.hidObjGIPIS002.gipiWPolbasJSON.industryCd;
							objUW.hidObjGIPIS002.forSaving = false;
						}
					});

	$("coIns")
			.observe(
					"change",
					function() {
						new Ajax.Updater(
								"message",
								contextPath + '/GIPIParInformationController?action=whenValidateCoInsurance',
								{
									method : "POST",
									parameters : {
										lineCd : $("lineCd").value,
										sublineCd : $("sublineCd").value,
										parId : $("parId").value,
										issCd : $("issCd").value,
										coIns : $("coIns").value
									},
									asynchronous : true,
									evalScripts : true,
									onCreate : function() {
										//showNotice("Validating Co-Insurance...");
										$("basicInformationFormButton")
												.disable();
									},
									onComplete : function(response) {
										$("basicInformationFormButton")
												.enable();
										if (checkErrorOnResponse(response)) {
											objUWGlobal.coInsSw = $F("coIns");
											if (response.responseText == "SUCCESS") {
												objUW.hidObjGIPIS002.deleteCoIns = "";
												if ($("coIns").value != "1") {
													checkCoInsMenu(objUW.hidObjGIPIS002.coInsurance);
												} else {
													disableMenu("coInsurance");
												}
											} else if (response.responseText == "1") {
												condOne();
											} else if (response.responseText == "2") {
												condTwo();
											}
											//hideNotice("");
										}
									}
								});

						function condOne() {
							showConfirmBox(
									"Message",
									"You have changed this policy from lead policy to other type. Will now do the necessary changes.",
									"Ok", "Cancel", onOkFunc, onCancelFunc);
							function onOkFunc() {
								objUW.hidObjGIPIS002.deleteCoIns = "Y";
								if (objUW.hidObjGIPIS002.forSaving) {
									saveBasicInfoGIPIS002();
								}
								if ($("coIns").value != "1") {
									checkCoInsMenu(objUW.hidObjGIPIS002.coInsurance);
								} else {
									disableMenu("coInsurance");
								}
							}
							function onCancelFunc() {
								objUW.hidObjGIPIS002.deleteCoIns = "";
								$("coIns").value = $("paramCoInsurance").value;
								objUW.hidObjGIPIS002.forSaving = false;
								if ($("coIns").value != "1") {
									checkCoInsMenu(objUW.hidObjGIPIS002.coInsurance);
								} else {
									disableMenu("coInsurance");
								}
							}
						}

						function condTwo() {
							showConfirmBox(
									"Message",
									"You have changed this policy to lead policy from other type. Will now do the necessary changes.",
									"Ok", "Cancel", onOkFunc, onCancelFunc);
							function onOkFunc() {
								objUW.hidObjGIPIS002.deleteCoIns = "";
								if (objUW.hidObjGIPIS002.forSaving) {
									saveBasicInfoGIPIS002();
								}
								if ($("coIns").value != "1") {
									checkCoInsMenu(objUW.hidObjGIPIS002.coInsurance);
								} else {
									disableMenu("coInsurance");
								}
							}
							function onCancelFunc() {
								objUW.hidObjGIPIS002.deleteCoIns = "";
								$("coIns").value = $("paramCoInsurance").value;
								objUW.hidObjGIPIS002.forSaving = false;
								if ($("coIns").value != "1") {
									checkCoInsMenu(objUW.hidObjGIPIS002.coInsurance);
								} else {
									disableMenu("coInsurance");
								}
							}
						}
					});

	$("provisionalPremium")
			.observe(
					"change",
					function() {
						if(checkPostedBinder()){ //added edgar 01/29/2015 to check for posted binder
							showWaitingMessageBox("You cannot Tag/Untag Provisional Premium. PAR has posted binder.", imgMessage.ERROR, 
									function(){
												if (!($("provisionalPremium").checked)){
													$("provisionalPremium").checked = true;
												}else if ($("provisionalPremium").checked){
													$("provisionalPremium").checked = false;
												} 
												objUW.hidObjGIPIS002.deleteBillSw = "N";
												objUW.hidObjGIPIS002.forSaving = false;
												changeTag = 0;
											  });
							return false;
						}
						if (objUW.hidObjGIPIS002.deleteBillSw == "N") {
							if ((objUW.hidObjGIPIS002.gipiWPolbasExist == "1")
									&& (objUW.hidObjGIPIS002.gipiWItmperlExist == "1")) {
								if ($F("provisionalPremium") == "Y") {
									$("provPremRatePercent").blur();
									showConfirmBox(
											"Message",
											"You have tagged your prov. prem. Will now do the necessary changes.",
											"Ok", "Cancel", onOkFunc,
											onCancelFunc);
								} else {
									$("provPremRatePercent").blur();
									showConfirmBox(
											"Message",
											"You have untagged your prov. prem. Will now do the necessary changes.",
											"Ok", "Cancel", onOkFunc,
											onCancelFunc);
								}
							}
						}

						function onOkFunc() {
							deleteBillFunc();
						}
						function onCancelFunc() {
							if ($("provisionalPremium").checked) {
								$("provisionalPremium").checked = false;
								$("provPremRate").hide();
							} else {
								$("provisionalPremium").checked = true;
								$("provPremRate").show();
							}
							objUW.hidObjGIPIS002.deleteBillSw = "N";
							objUW.hidObjGIPIS002.forSaving = false;
						}
					});

	$("provPremRatePercent")
			.observe(
					"blur",
					function() {
						if (objUW.hidObjGIPIS002.deleteBillSw == "N") {
							if ((objUW.hidObjGIPIS002.gipiWPolbasExist == "1")
									&& (objUW.hidObjGIPIS002.gipiWItmperlExist == "1")) {
								if ($F("provPremRatePercent") != $F("paramProvPremRatePercent")) {
									if(checkPostedBinder()){ // to check for posted binder edgar 01/30/2015
										showWaitingMessageBox("You cannot change Provisional Premium Percentage. PAR has posted binder.", imgMessage.ERROR, 
												function(){
															$("provPremRatePercent").value = $F("paramProvPremRatePercent");
															objUW.hidObjGIPIS002.deleteBillSw = "N";
															objUW.hidObjGIPIS002.forSaving = false;
															changeTag = 0;
														  });
										return false;
									}
									showConfirmBox(
											"Message",
											"You have updated your option from "
													+ $("paramProvPremRatePercent").value
													+ " to "
													+ $("provPremRatePercent").value
													+ ". Will now do the necessary changes.",
											"Ok", "Cancel", onOkFunc,
											onCancelFunc);
								}
							}
						}
						function onOkFunc() {
							deleteBillFunc();
						}
						function onCancelFunc() {
							$("provPremRatePercent").value = $F("paramProvPremRatePercent");
							objUW.hidObjGIPIS002.deleteBillSw = "N";
							objUW.hidObjGIPIS002.forSaving = false;
						}
					});

	$("shortRatePercent")
			.observe(
					"blur",
					function() {
						if (objUW.hidObjGIPIS002.deleteBillSw == "N"
								&& $F("shortRatePercent") != "") {
							if ((objUW.hidObjGIPIS002.gipiWPolbasExist == "1")
									&& (objUW.hidObjGIPIS002.gipiWItmperlExist == "1")) {
								if ($F("shortRatePercent") != $F("paramShortRatePercent")) {
									if(checkPostedBinder()){ 
										showWaitingMessageBox("You cannot update Short Rate Percentage. PAR has posted binder.", imgMessage.ERROR, 
												function(){
															changeTag = 0;
															$("shortRatePercent").value = $F("paramShortRatePercent");
															objUW.hidObjGIPIS002.deleteBillSw = "N";
															objUW.hidObjGIPIS002.forSaving = false;
														  });
										return false;
									}
									showConfirmBox(
											"Message",
											"You have updated short rate percent from "
													+ $("paramShortRatePercent").value
													+ " to "
													+ $("shortRatePercent").value
													+ ". Will now do the necessary changes.",
											"Ok", "Cancel", onOkFunc,
											onCancelFunc);
								}
							}
						}
						function onOkFunc() {
							deleteBillFunc();
						}
						function onCancelFunc() {
							$("shortRatePercent").value = $F("paramShortRatePercent");
							objUW.hidObjGIPIS002.deleteBillSw = "N";
							objUW.hidObjGIPIS002.forSaving = false;
						}
					});

	$("compSw")
			.observe(
					"change",
					function() {
						if(checkPostedBinder()){ //added edgar 01/29/2015 to check for posted binder
							showWaitingMessageBox("You cannot update Prorate Condition. PAR has posted binder.", imgMessage.ERROR, 
									function(){
												changeTag = 0;
												$("compSw").value = objUW.hidObjGIPIS002.paramCompSw;
												$("noOfDays").value = computeNoOfDays($F("doi"),
														$F("doe"), $F("compSw"));
												objUW.hidObjGIPIS002.deleteBillSw = "N";
												objUW.hidObjGIPIS002.forSaving = false;
											  });
							return false;
						}
						if (objUW.hidObjGIPIS002.deleteBillSw == "N") {
							if ((objUW.hidObjGIPIS002.gipiWPolbasExist == "1")
									&& (objUW.hidObjGIPIS002.gipiWItmperlExist == "1")) {
								if ($F("noOfDays") != $F("paramNoOfDays")) {
									showConfirmBox(
											"Message",
											"You have changed the computation for the policy no of days. Will now do the necessary changes.",
											"Ok", "Cancel", onOkFunc,
											onCancelFunc);
								}
							}
						}
						function onOkFunc() {
							deleteBillFunc();
						}
						function onCancelFunc() {
							$("compSw").value = objUW.hidObjGIPIS002.paramCompSw;
							$("noOfDays").value = computeNoOfDays($F("doi"),
									$F("doe"), $F("compSw"));
							objUW.hidObjGIPIS002.deleteBillSw = "N";
							objUW.hidObjGIPIS002.forSaving = false;
						}
					});

	$("noOfDays")
			.observe(
					"blur",
					function() {
						if (objUW.hidObjGIPIS002.deleteBillSw == "N") {
							if ((objUW.hidObjGIPIS002.gipiWPolbasExist == "1")
									&& (objUW.hidObjGIPIS002.gipiWItmperlExist == "1")) {
								if ($F("noOfDays") != $F("paramNoOfDays")) {
									if(checkPostedBinder()){ //edgar 01/29/2015
										showWaitingMessageBox("You cannot update Number of Days. PAR has posted binder.", imgMessage.ERROR, 
												function(){
															$("doe").value = $F("paramDoe");
															$("noOfDays").value = $F("paramNoOfDays");
															objUW.hidObjGIPIS002.deleteBillSw = "N";
															objUW.hidObjGIPIS002.forSaving = false;
															changeTag = 0;
														  });
										return false;
									}
									showConfirmBox(
											"Message",
											"You have updated policy's no. of days from "
													+ $("paramNoOfDays").value
													+ " to "
													+ $("noOfDays").value
													+ ". Will now do the necessary changes.",
											"Ok", "Cancel", onOkFunc,
											onCancelFunc);
								}
							}
						}
						function onOkFunc() {
							var addtl = 0;
							if ("Y" == $F("compSw")) {
								addtl = -1;
							} else if ("M" == $F("compSw")) {
								addtl = 1;
							}
							var newDate = Date.parse($F("doi"));
							var num = $("noOfDays").value;
							num = num * 1 + addtl;
							newDate.add(num).days();
							var month = newDate.getMonth() + 1 < 10 ? "0"
									+ (newDate.getMonth() + 1) : newDate
									.getMonth() + 1;
							$("doe").value = month
									+ "-"
									+ ((newDate.getDate() < 10) ? "0"
											+ newDate.getDate() : newDate
											.getDate()) + "-"
									+ newDate.getFullYear();
							deleteBillFunc();
						}
						function onCancelFunc() {
							$("doe").value = $F("paramDoe");
							$("noOfDays").value = $F("paramNoOfDays");
							objUW.hidObjGIPIS002.deleteBillSw = "N";
							objUW.hidObjGIPIS002.forSaving = false;
						}

						var compSwAddtl = $F("compSw");
						var addtl = 0;
						if ("Y" == compSwAddtl) {
							addtl = -1;
						} else if ("M" == compSwAddtl) {
							addtl = +1;
						}
						var newDate = Date.parse($F("doi"));
						var num = $("noOfDays").value;
						num = num * 1;
						newDate.add(num + addtl).days();
						var month = newDate.getMonth() + 1 < 10 ? "0"
								+ (newDate.getMonth() + 1)
								: newDate.getMonth() + 1;
						var preDoe = $("doe").value;
						$("doe").value = month
								+ "-"
								+ ((newDate.getDate() < 10) ? "0"
										+ newDate.getDate() : newDate.getDate())
								+ "-" + newDate.getFullYear();

						var incept = makeDate($F("doi"));
						var exp = makeDate($F("doe"));
						if (exp < incept) {
							$("doe").value = preDoe;
							customShowMessageBox(
									"Expiry date is invalid. Expiry date must be later than Inception date.",
									imgMessage.ERROR, "noOfDays");
							return false;
						}
					});

	$("issuePlace")
			.observe(
					"change",
					function() {
						if(checkPostedBinder()){ //added edgar 01/29/2015 to check for posted binder
							showWaitingMessageBox("You cannot change the Issuing Place. PAR has posted binder.", imgMessage.ERROR, 
									function(){
												$("issuePlace").value = $("paramIssuePlace").value;
												changeTag = 0;
											  });
							return false;
						}
						if (objUW.hidObjGIPIS002.validatedIssuePlace != "Y") {
							if ($("issuePlace").value != $("paramIssuePlace").value) {
								if (objUW.hidObjGIPIS002.gipiWinvTaxExist == "1") {
									showConfirmBox(
											"Message",
											"Some taxes are dependent to place of issuance... changing/removing place of issuance will automatically recreate invoice. Do you want to continue?",
											"Yes", "No", onOkFunc, onCancelFunc);
								}
							}
						}
						function onOkFunc() {
							objUW.hidObjGIPIS002.deleteSw = "Y";
							objUW.hidObjGIPIS002.validatedIssuePlace = "Y";
							if (objUW.hidObjGIPIS002.forSaving) {
								saveBasicInfoGIPIS002();
							}
						}
						function onCancelFunc() {
							$("issuePlace").value = $("paramIssuePlace").value;
							objUW.hidObjGIPIS002.forSaving = false;
						}
					});

	$("prorateFlag")
			.observe(
					"change",
					function() {
						var tempProrateFlag = $("prorateFlag").options[($("paramProrateFlag").value - 1)].text;
						if (objUW.hidObjGIPIS002.deleteBillSw == "N") {
							if ((objUW.hidObjGIPIS002.gipiWPolbasExist == "1")
									&& (objUW.hidObjGIPIS002.gipiWItmperlExist == "1")) {
								if ($("prorateFlag").value != $("paramProrateFlag").value) {
									if(checkPostedBinder()){ //added edgar 01/30/2015
										showWaitingMessageBox("You cannot update Condition. PAR has posted binder.", imgMessage.ERROR, 
												function(){
															objUW.hidObjGIPIS002.deleteBillSw = "N";
															$("prorateFlag").value = $("paramProrateFlag").value;
															$("prorateFlag").focus();
															showRelatedSpan();
															objUW.hidObjGIPIS002.forSaving = false;
															changeTag = 0;
														  });
										return false;
									}
									showConfirmBox(
											"Message",
											"You have changed your policy term from "
													+ tempProrateFlag
													+ " to "
													+ $("prorateFlag").options[$("prorateFlag").selectedIndex].text
													+ ". Will now do the necessary changes.",
											"Ok", "Cancel", onOkFunc,
											onCancelFunc);
								}
							}
						}
						function onOkFunc() {
							deleteBillFunc();
						}
						function onCancelFunc() {
							objUW.hidObjGIPIS002.deleteBillSw = "N";
							$("prorateFlag").value = $("paramProrateFlag").value;
							$("prorateFlag").focus();
							showRelatedSpan();
							objUW.hidObjGIPIS002.forSaving = false;
						}
					});

	$("referencePolicyNo")
			.observe(
					"blur",
					function() {
						if ($("referencePolicyNo").value != "") {
							$("referencePolicyNo").value = $("referencePolicyNo").value
									.toUpperCase();
							new Ajax.Updater(
									"message",
									contextPath + '/GIPIParInformationController?action=whenValidateRefPolNo',
									{
										method : "POST",
										parameters : {
											parId : $("parId").value,
											lineCd : $("lineCd").value,
											issCd : $("issCd").value,
											refPolNo : $("referencePolicyNo").value
										},
										asynchronous : true,
										evalScripts : true,
										onCreate : function() {
											//showNotice("Validating Reference Policy No...");
											$("basicInformationFormButton")
													.disable();
										},
										onComplete : function(response) {
											if (checkErrorOnResponse(response)) {
												$("basicInformationFormButton")
														.enable();
												var text = response.responseText;
												var arr = text
														.split(resultMessageDelimiter);
												function show2() {
													if (arr[1] != "") {
														showMessageBox(arr[1],
																imgMessage.INFO);
													}
												}
												if (arr[0] != "") {
													showWaitingMessageBox(
															arr[0],
															imgMessage.INFO,
															show2);
												} else {
													show2();
												}
												//if (response.responseText != "SUCCESS"){
												//	showMessageBox(response.responseText, imgMessage.INFO);
												//}		
												//hideNotice("");
											}
										}
									});
						}
					});

 	$("referencePolicyNo") //Added by Jerome 10.25.2016 SR 5740
 	.observe(
 			"input",
 			function() {
 				changeTag = 1;
 				if ($("referencePolicyNo").value != "") {
 					$("referencePolicyNo").value = $("referencePolicyNo").value
 							.toUpperCase();
 					new Ajax.Updater(
 							"message",
 							contextPath + '/GIPIParInformationController?action=whenValidateRefPolNo',
 							{
 								method : "POST",
 								parameters : {
 									parId : $("parId").value,
 									lineCd : $("lineCd").value,
 									issCd : $("issCd").value,
 									refPolNo : $("referencePolicyNo").value
 								},
 								asynchronous : true,
 								evalScripts : true,
 								onCreate : function() {
 									//showNotice("Validating Reference Policy No...");
 									$("basicInformationFormButton")
 											.disable();
 								},
 								onComplete : function(response) {
 									if (checkErrorOnResponse(response)) {
 										$("basicInformationFormButton")
 												.enable();
 										var text = response.responseText;
 										var arr = text
 												.split(resultMessageDelimiter);
 										function show2() {
 											if (arr[1] != "") {
 												showMessageBox(arr[1],
 														imgMessage.INFO);
 												changeTag = 0;
 											}
 										}
 										if (arr[0] != "") {
 											showWaitingMessageBox(
 													arr[0],
 													imgMessage.INFO,
 													show2);
 											changeTag=0;
 										} else {
 											show2();
 										}
 										//if (response.responseText != "SUCCESS"){
 										//	showMessageBox(response.responseText, imgMessage.INFO);
 										//}		
 										//hideNotice("");
 									}
 								}
 							});
 				}
 			});
	
	//for Leased tag label
	$("labelTag").observe("click", function() {
		if ($("labelTag").checked) {
			$("rowInAccountOf").innerHTML = "Leased to";
		} else {
			$("rowInAccountOf").innerHTML = "In Account Of";
		}
	});

	//function to check menu to enabled/disabled
	function checkMenuGIPIS002() {
		try {
			// andrew - comment muna - 04.15.2011
			//setParMenus(nvl(objUWGlobal.parStatus, $F("parStatus")), $F("globalLineCd"), $F("globalSublineCd"), $F("globalOpFlag"), $F("globalIssCd")); // andrew - 10.04.2010 - added this line
			//comment out by andrew - 04.13.2011 - conflict in disabling and enabling of related menus
			/*var parStat = $F("parStatus");
			disableMenu("limitsOfLiabilities");
			disableMenu("cargoLimitsOfLiability");		
			nvl(objUWGlobal.parStatus,$("globalParStatus").value) >= 3 ? enableMenu("itemInfo") :disableMenu("itemInfo");
			if (objUW.hidObjGIPIS002.lcMN != $F("lineCd") && objUW.hidObjGIPIS002.opFlag == "Y" && parStat > 2){
				enableMenu("limitsOfLiabilities");
				//disableMenu("carrierInfo");
				disableMenu("cargoLimitsOfLiability");
				disableMenu("itemInfo");
			}else if (objUW.hidObjGIPIS002.lcMN == $F("lineCd")){
				if (objUW.hidObjGIPIS002.opFlag == "Y"){
					enableMenu("cargoLimitsOfLiability");
					//disableMenu("carrierInfo");
					disableMenu("itemInfo");
				}else{
					disableMenu("cargoLimitsOfLiability");
					//enableMenu("carrierInfo");
				}	
			}*/
			
			if($("coIns") != null){ // Nica 05.17.2012 - to handle javascript error element is null
				objUWGlobal.coInsSw = $F("coIns");
				if ($("coIns").value != "1") {
					checkCoInsMenu(objUW.hidObjGIPIS002.coInsurance);
				} else {
					disableMenu("coInsurance");
				}				
			}
			
			if($F("globalIssCd") == "RI" || $F("globalIssCd") == "RB") {
				enableMenu("initialAcceptance");
			} else {
				disableMenu("initialAcceptance");
			}
		} catch (e) {
			showErrorMessage("checkMenuGIPIS002", e);
		}
	}

	//initialize first
	function initAllFirst() {
		try {
			if (($("policyStatus").value == 2)
					|| ($("policyStatus").value == 3)) {
				$("renewalDetail").setStyle( {
					display : ""
				}); //added by andrew 03.18.2010
				objUW.hidObjGIPIS002.deleteWPolnrep = "N";
				
				observeAccessibleModule(accessType.SUBPAGE, "GIPIS002", "showRenewal",
						function() {
							if ($("wpolnrepOldPolicyId") == null) {
								openRenewalReplacementDetailModal();
							}
					});	
			} else {
				$("renewalDetail").setStyle( {
					display : "none"
				}); //added by andrew 03.18.2010
				objUW.hidObjGIPIS002.deleteWPolnrep = "Y";
				
				$("showRenewal").observe("click", function() {
					if ($("wpolnrepOldPolicyId") == null) {
						openRenewalReplacementDetailModal();
					}
				});
			}

			if ($("sublineCd").value != "") {
				validateOpenPolicyButton();
			}

			if (objUW.hidObjGIPIS002.gipiWPolbasExist != "1") {
				$("mortgageeInfo").hide();
			}

			if ($("defaultDoe").value != $("doe").value) {
				$("prorateFlag").enable();
			} else {
				$("prorateFlag").disable();
			}

			if (objUW.hidObjGIPIS002.issCdRi == $("issCd").value) {
				$("coIns").disable();
			}

			if ($("labelTag").checked) {
				$("rowInAccountOf").innerHTML = "Leased to";
			} else {
				$("rowInAccountOf").innerHTML = "In Account Of";
			}
			objUW.hidObjGIPIS002.paramSublineCdDesc = getListTextValue("sublineCd");
			objUW.hidObjGIPIS002.opFlag = $("sublineCd").options[$("sublineCd").selectedIndex]
					.getAttribute("opFlag");

			if (objUW.hidObjGIPIS002.lcMN == $F("lineCd")
					|| objUW.hidObjGIPIS002.lcMN2 == "MN") {
				if (objUW.hidObjGIPIS002.reqSurveySettAgent == "Y") {
					//$("surveyAgentCd").addClassName("required");
					$("surveyAgentName").addClassName("required");
					$("surveyAgentDiv").addClassName("required");
					//$("settlingAgentCd").addClassName("required");
					$("settlingAgentName").addClassName("required");
					$("settlingAgentDiv").addClassName("required");
				}
			}
			checkMenuGIPIS002();
			$("manualRenewNo").value = formatNumberDigits($F("manualRenewNo"),
					2);

			if (nvl(objUW.hidObjGIPIS002.typeCdStatus, "") == "") {
				$("typeOfPolicy").disable();
			}

			if (objUW.hidObjGIPIS002.lcFI == $F("lineCd")){
				if (objUW.hidObjGIPIS002.inspectionStatus == "P"){
					$("btnInspection").show(); //display Inspection button
					enableButton("btnInspection");
					if (objUW.hidObjGIPIS002.gipiWItemExist == "Y"){
						disableButton("btnInspection");//disable if item exist
					}else{
						$("btnInspection").observe("click", function(){
							if (objUW.hidObjGIPIS002.gipiWPolbasExist == "1"){
								//showApprovedInspectionList($F("globalParId"), $("assuredNo").value); replaced by: Nica 09.26.2012
								showApprovedInspectionList2($F("globalParId"), $("assuredNo").value);
							}else{
								showMessageBox("Please enter values for required fields." ,"I");
							}		
						});
					}		
				}	
			}	
		} catch (e) {
			showErrorMessage("initAllFirst", e);
		}
	}

	//function to update all parameters needed in GIPIS002
	function updateBasicInfoParameters() {
		try {
			objUW.hidObjGIPIS002.gipiWPolbasExist = "1";
			if (objUW.hidObjGIPIS002.deleteBillSw == "Y") {
				objUW.hidObjGIPIS002.gipiWItmperlExist = "0";
				objUW.hidObjGIPIS002.gipiWinvTaxExist = "0";
			}
			objUW.hidObjGIPIS002.deleteBillSw = "N";
			objUW.hidObjGIPIS002.deleteSw = "N";
			objUW.hidObjGIPIS002.deleteWPolnrep = "N";
			objUW.hidObjGIPIS002.validatedIssuePlace = "N";
			objUW.hidObjGIPIS002.validatedBookingDate = "N";
			$("paramSubline").value = $("sublineCd").value;
			$("paramPolicyStatus").value = $("policyStatus").value;
			$("paramRenewNo").value = $("renewNo").value;
			$("paramAssuredNo").value = $("assuredNo").value;
			$("paramAssuredName").value = $("assuredName").value;
			$("paramIssuePlace").value = $("issuePlace").value;
			$("paramProvPremRatePercent").value = $("provPremRatePercent").value;
			$("paramDoi").value = $("doi").value;
			$("paramProrateFlag").value = $("prorateFlag").value;
			$("paramNoOfDays").value = $("noOfDays").value;
			$("paramShortRatePercent").value = $("shortRatePercent").value;
			$("paramBookingYear").value = $("bookingYear").value;
			$("paramBookingMth").value = $("bookingMth").value;
			$("paramDoe").value = $("doe").value;
			$("paramCoInsurance").value = $("coIns").value;
			$("paramTakeupTermType").value = $("takeupTermType").value;
			objUW.hidObjGIPIS002.deleteCoIns = "";
			$("updateIssueDate").value = "N";
			objUW.hidObjGIPIS002.paramSublineCdDesc = getListTextValue("sublineCd");
			objUW.hidObjGIPIS002.deleteAllTables = "N";
			objUW.hidObjGIPIS002.deleteCommInvoice = "N";
			objUW.hidObjGIPIS002.forSaving = false;
			$("bancaTag").setAttribute("originalValue", $("bancaTag").checked ? "Y" : "N");
		} catch (e) {
			showErrorMessage("updateBasicInfoParameters", e);
		}
	}

	//for Marine Cargo line code

	/* comment out by andrew - 02.03.2012 	
 
 	if (objUW.hidObjGIPIS002.lcMN == objUW.hidObjGIPIS002.lineCd
			|| objUW.hidObjGIPIS002.lcMN2 == "MN") {
		updateSurveyAgentLOV();
		updateSettlingAgentLOV();
	} */

	if (objUW.hidObjGIPIS002.ora2010Sw == "Y") {
		//for Package plan.
		if ($("packPLanTag").checked) {
			updatePlanCdLOV(true);
		}
		checkPackPlanTag();
		$("packPLanTag").observe("change", function() {
			if ($("packPLanTag").checked == true && objUW.hidObjGIPIS002.checkItemExist > 1) {
				showWaitingMessageBox("You are not allowed to have a package plan with more than one item.", imgMessage.INFO, onCancelFunc);
			}
			
			if (objUW.hidObjGIPIS002.gipiWPolbasJSON.planSw != ($("packPLanTag").checked == true ? "Y" : "N")) {	//added by Gzelle 09262014
				if (objUW.hidObjGIPIS002.gipiWinvTaxExist == "1" && objUW.hidObjGIPIS002.precommitDelTab == "N" && objUW.hidObjGIPIS002.deleteSw == "N") {
					showConfirmBox(
							"Message",
							"Changing/removing package plan will automatically recreate invoice. Do you want to continue?",
							"Yes", "No", function() {
									updatePlanCdLOV(false);
									checkPackPlanTag();
									objUW.hidObjGIPIS002.precommitDelTab = "Y";
									objUW.hidObjGIPIS002.deleteSw = "Y";
									deleteBillFunc();
									if (objUW.hidObjGIPIS002.forSaving) {
										saveBasicInfoGIPIS002();
									}
							}, onCancelFunc);
				}else {
					updatePlanCdLOV(false);
					checkPackPlanTag();
				}
			}else {
				updatePlanCdLOV(false);
				checkPackPlanTag();
			}
			
			function onCancelFunc() {
				$("packPLanTag").checked = objUW.hidObjGIPIS002.gipiWPolbasJSON.planSw == "Y" ? true : false;
				changeTag = 0;
				objUW.hidObjGIPIS002.forSaving = false;
				if (objUW.hidObjGIPIS002.gipiWPolbasJSON.planSw != "Y") {
					updatePlanCdLOV(false);
					checkPackPlanTag();
				}
			}
		});
		
		$("selPlanCd").observe("change", function() {
			if ($("selPlanCd").value != "") {
				if ($("selPlanCd").value != ('${gipiWPolbas.planCd}')) {
					if (objUW.hidObjGIPIS002.gipiWinvTaxExist == "1" && objUW.hidObjGIPIS002.precommitDelTab == "N" && objUW.hidObjGIPIS002.deleteSw == "N") {
						showConfirmBox(
							"Message",
							"Changing/removing package plan will automatically recreate invoice. Do you want to continue?",
							"Yes", "No", function() {
								objUW.hidObjGIPIS002.precommitDelTab = "Y";
								objUW.hidObjGIPIS002.deleteSw = "Y";
								deleteBillFunc();
								if (objUW.hidObjGIPIS002.forSaving) {
									saveBasicInfoGIPIS002();
								}
							}, function() {
								checkPackPlanTag();
								changeTag = 0;
								$("selPlanCd").value = ('${gipiWPolbas.planCd}');
							}
						);
					}
				}
			}
		});
	}

	/*	Created by	: Jerome Orio 11.17.2010
	 * 	Description	: update LOV for Survey Agent in GIPIS002
	 * 	Parameters	: 
	 */
	/* function updateSurveyAgentLOV() {
		try {
			$("surveyAgentCd").enable();
			var objArray = objUW.hidObjGIPIS002.surveyAgentLOV;
			removeAllOptions($("surveyAgentCd"));
			var opt = document.createElement("option");
			opt.value = "";
			opt.text = "";
			$("surveyAgentCd").options.add(opt);
			for ( var a = 0; a < objArray.length; a++) {
				var opt = document.createElement("option");
				opt.value = objArray[a].payeeNo;
				opt.text = changeSingleAndDoubleQuotes(objArray[a].nbtPayeeName);
				$("surveyAgentCd").options.add(opt);
			}
			$("surveyAgentCd").value = ('${gipiWPolbas.surveyAgentCd}');
		} catch (e) {
			showErrorMessage("updateSurveyAgentLOV", e);
		}
	} */

	/*	Created by	: Jerome Orio 11.17.2010
	 * 	Description	: update LOV for Settling Agent in GIPIS002
	 * 	Parameters	: 
	 */
/* 	function updateSettlingAgentLOV() {
		try {
			$("settlingAgentCd").enable();
			var objArray = objUW.hidObjGIPIS002.settlingAgentLOV;
			removeAllOptions($("settlingAgentCd"));
			var opt = document.createElement("option");
			opt.value = "";
			opt.text = "";
			$("settlingAgentCd").options.add(opt);
			for ( var a = 0; a < objArray.length; a++) {
				var opt = document.createElement("option");
				opt.value = objArray[a].payeeNo;
				opt.text = changeSingleAndDoubleQuotes(objArray[a].nbtPayeeName);
				$("settlingAgentCd").options.add(opt);
			}
			$("settlingAgentCd").value = ('${gipiWPolbas.settlingAgentCd}');
		} catch (e) {
			showErrorMessage("updateSettlingAgentLOV", e);
		}
	} */

	/*	Created by	: Jerome Orio 11.17.2010
	 * 	Description	: clear Renewal/Replacement details in GIPIS002
	 * 	Parameters	: 
	 */
	function clearRenRepGIPIS002() {
		try {
			if (objUW.hidObjGIPIS002.gipiWPolnrepExist == "1"
					&& $("policyRenewalDiv").innerHTML != "") {
				objUW.hidObjGIPIS002.deleteWPolnrep = "Y";
				objUW.hidObjGIPIS002.gipiWPolnrepExist = "0";
				$("wpolnrepIssCd").value = "";
				$("wpolnrepIssueYy").value = "";
				$("wpolnrepPolSeqNo").value = "";
				$("wpolnrepRenewNo").value = "";
				$("samePolicyNo").checked = false;
				$("samePolicyNo").disabled = false;
				$$("div[name='rowPolnrep']").each(
						function(row) {
							Effect.Fade(row, {
								duration : .5,
								afterFinish : function() {
									row.remove();
									checkTableIfEmpty("rowPolnrep",
											"renewalTable");
									checkIfToResizeTable("policyNoListing",
											"rowPolnrep");
								}
							});
						});
			}
		} catch (e) {
			showErrorMessage("clearRenRepGIPIS002", e);
		}
	}

	/*	Created by	: Jerome Orio 11.17.2010
	 * 	Description	: update LOV for package plan  in GIPIS002
	 * 	Parameters	: 
	 */
	function updatePlanCdLOV(param) {
		try {
			$("selPlanCd").enable();
			var objArray = objUW.hidObjGIPIS002.planCdLOV;
			removeAllOptions($("selPlanCd"));
			var opt = document.createElement("option");
			opt.value = "";
			opt.text = "";
			opt.setAttribute("sublineCd", "");
			$("selPlanCd").options.add(opt);
			for ( var a = 0; a < objArray.length; a++) {
				if ($F("sublineCd") != "") {
					if (objArray[a].sublineCd == $F("sublineCd")) {
						var opt = document.createElement("option");
						opt.value = objArray[a].planCd;
						opt.text = changeSingleAndDoubleQuotes(objArray[a].planDesc);
						opt.setAttribute("sublineCd", objArray[a].sublineCd);
						$("selPlanCd").options.add(opt);
					}
				}
			}
			if (param) {
				$("selPlanCd").value = ('${gipiWPolbas.planCd}');
			}
		} catch (e) {
			showErrorMessage("updatePlanCdLOV", e);
		}
	}

	function deleteBillFunc() {
		try {
			objUW.hidObjGIPIS002.deleteBillSw = "Y";
			disableMenu("post");
			disableMenu("coInsurance");
			disableMenu("bill");
			disableMenu("distribution");
			if (objUW.hidObjGIPIS002.gipiWItemExist == "Y") {
				enableMenu("itemInfo");
			} else {
				disableMenu("itemInfo");
			}
			if (objUW.hidObjGIPIS002.forSaving) {
				saveBasicInfoGIPIS002();
			}
		} catch (e) {
			showErrorMessage("deleteBillFunc", e);
		}
	}

	function checkCoInsurance() {
		new Ajax.Request(contextPath + "/GIPIParInformationController", {
			method : "POST",
			parameters : {
				action : "coInsurance",
				parId : $("parId").value
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response) {
				if (checkErrorOnResponse(response)) {
					var result = JSON.parse(response.responseText);
					objUW.hidObjGIPIS002.coInsurance = result;
					objUWGlobal.coInsurance = result;
				}
			}
		});
	}

	initAllFirst();
	setDocumentTitle("Basic Information");
	window.scrollTo(0, 0);
	hideNotice("");
	changeTag = 0;
	initializeChangeTagBehavior(saveFuncMain);
	objItemNoList = [ {
		"itemNo" : 0
	} ]; // added by mark jm 01.21	
	
	if (objUW.hidObjGIPIS002.lcMN == objUW.hidObjGIPIS002.lineCd // added by andrew - 02.03.2012
			|| objUW.hidObjGIPIS002.lcMN2 == "MN") {
		$("searchSurveyAgent").observe("click", function(){ 
			try {
				LOV.show({
					controller: "UnderwritingLOVController",
					urlParameters: {action : "getSurveyAgentLOV",
									page : 1},
					title: "Survey Agent",
					width: 500,
					height: 360,
					columnModel : [	{	id : "payeeNo",
										title: "Code",
										width: '80px',
										align: 'right'
									},
									{	id : "nbtPayeeName",
										title: "Survey Agent Name",
										width: '380px'
									}
								],
					draggable: true,
					onSelect: function(row){
						$("surveyAgentCd").value = row.payeeNo;
						$("surveyAgentName").value = unescapeHTML2(nvl(row.nbtPayeeName,"")); //added by steve 10/30/2012
						changeTag = 1;
					}
				  });
			} catch (e){
				showErrorMessage("searchSurveyAgent", e);
			}
		});
		
		$("searchSettlingAgent").observe("click", function(){ // added by andrew - 02.03.2012
			try {
				LOV.show({
					controller: "UnderwritingLOVController",
					urlParameters: {action : "getSettlingAgentLOV",
									page : 1},
					title: "Settling Agent",
					width: 500,
					height: 360,
					columnModel : [	{	id : "payeeNo",
										title: "Code",
										width: '80px',
										align: 'right'
									},
									{	id : "nbtPayeeName",
										title: "Settling Agent Name",
										width: '380px'
									}
								],
					draggable: true,
					onSelect: function(row){
						$("settlingAgentCd").value = row.payeeNo;
						$("settlingAgentName").value = unescapeHTML2(nvl(row.nbtPayeeName,"")); //added by steve 10/30/2012
						changeTag = 1;
					}
				  });
			} catch (e){
				showErrorMessage("searchSettlingAgent", e);
			}
		});
		
		$("surveyAgentName").observe("keyup", function(event){
			if(event.keyCode == 46){
				$("surveyAgentCd").value = "";
			}
		});
		
		$("settlingAgentName").observe("keyup", function(event){
			if(event.keyCode == 46){
				$("settlingAgentCd").value = "";
			}
		});
	}
	
	//added by Gzelle 12022014
	var wTariffSw = $F("wTariff");
	var exists = checkExistingTariffPeril("0");
	
	$("wTariff").observe("click", function(){
		if (wTariffSw == "Y") {
			if ($F("wTariff") != "Y") {
				if (exists == "X") {
					showConfirmBox("Tariff", "Changing/removing 'W/ Tariff' will automatically delete the peril information. " +
							"Do you want to continue?","Yes","No", function() {
								delTariffPerils = true;
							}, function() {
								delTariffPerils = false;
							}
					);
				}
			}
		}
	});	
	//added edgar 01/29/2015 to check for posted binders
	function checkPostedBinder(){ 
		var vExists = false;	
		new Ajax.Request(contextPath+"/GIPIWinvoiceController",{
				parameters:{
					action: "checkForPostedBinders",
					parId : $F("globalParId")
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						if(response.responseText == 'Y'){
							vExists = true;
						}else {
							vExists = false;
						}
					}
				}
			});
		return vExists;
	}
	
	function recreateInvoice(parId, lineCd, issCd){
		new Ajax.Request(contextPath+"/GIPIWinvoiceController",{
			parameters: {
				action: "recreateInvoice",
				parId: parId,
				lineCd: lineCd,
				issCd: issCd
			},
			onComplete: function(response){
				if(!checkErrorOnResponse(response)){
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});	
	}
	
</script>
