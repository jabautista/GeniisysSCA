<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="updInitialAcceptanceMainDiv" name="updInitialAcceptanceMainDiv" style="margin-top: 1px;">
	<div id="updInitialAcceptanceMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="updateInitialAceptanceForm">
	<form id="updInitialAcceptance" name="updInitialAcceptance">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="outerDiv">
					<label>Initial Acceptance</label>
						<span class="refreshers" style="margin-top: 0;">
							<label name="gro" style="margin-left: 5px;">Hide</label> 
					 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
						</span>
				</div>
			</div>
			<div id="mainDiv" class="sectionDiv" style="border: 0px;">	
				<div id="fBLock" class="sectionDiv">
						<table cellspacing="2" border="0">
							<tbody>
								<tr>
									<td class="rightAligned" style="width: 200px;">Policy No.</td>
									<td class="leftAligned" style="width: 230px;">
										<div class="withIconDiv" style="width: 226px; float: left; border: 1px solid gray;">
											<input id="txtLineCd" type="hidden" readonly="readonly" style="width: 195px;" value="" name="txtLineCd">
											<input id="txtSublineCd" type="hidden" readonly="readonly" style="width: 195px;" value="" name="txtSublineCd">
											<input id="txtIssCd" type="hidden" readonly="readonly" style="width: 195px;" value="" name="txtIssCd">
											<input id="txtIssueYy" type="hidden" readonly="readonly" style="width: 195px;" value="" name="txtIssueYy">
											<input id="txtPolSeqNo" type="hidden" readonly="readonly" style="width: 195px;" value="" name="txtPolSeqNo">
											<input id="txtRenewNo" type="hidden" readonly="readonly" style="width: 195px;" value="" name="txtRenewNo">
											<input id="txtPolicyId" type="hidden" readonly="readonly" style="width: 195px;" value="" name="txtPolicyId">
											<input id="oldOrigTSIAmt" type="hidden" readonly="readonly" style="width: 195px;" value="" name="oldOrigTSIAmt">
											<input id="oldOrigPremAmt" type="hidden" readonly="readonly" style="width: 195px;" value="" name="oldOrigPremAmt">
											<input id="txtPolicyNo" class="withIcon" type="text" readonly="readonly" style="width: 195px;" value="" name="txtPolicyNo">
											<img id="searchPolNo" alt="Go" name="searchPolNo" src="/Geniisys/images/misc/searchIcon.png" style="float: right;">
										</div>
									</td>
									<td class="rightAligned" style="width: 120px;">Endorsement No.</td>
									<td class="leftAligned" style="width: 230px;">
										<input type="text" readonly="readonly" value="" name="txtEndorsementNo" id="txtEndorsementNo" style="width: 210px; text-align: right; border: 1px solid gray;">
									</td>
								</tr>
								<tr>
									<td class="rightAligned" style="width: 140px;">Assured Name</td>
									<td class="leftAligned" style="width: 230px;">
									<input type="text" readonly="readonly" value="" name="txtAssuredNo" id="txtAssuredNo" style="width: 220px; text-align: left; border: 1px solid gray;">
									</td>
								</tr>	
							</tbody>				
						</table>
				</div>
			<!-- </div> -->
			<div id="bodyDiv" class="sectionDiv" style="border: 0px;">
				<div id="acceptanceDiv" class="sectionDiv">
					<table cellspacing="2" border="0" style="margin: 10px auto;">
						<tbody>
							<tr>
								<td class="rightAligned" style="width: 140px;">Acceptance No.</td>
								<td class="leftAligned" style="width: 230px;">
									<input type="text" readonly="readonly" value="" name="txtAcceptanceNo" id="txtAcceptanceNo" style="width: 200px; text-align: right; border: 1px solid gray;">
								</td>
								<td class="rightAligned" style="width: 140px;">Ref. Accept No.</td>
								<td class="leftAligned" style="width: 230px;">
									<input type="text" readonly="readonly" value="" name="txtRefAcceptNo" id="txtRefAcceptNo" style="width: 200px; text-align: right; border: 1px solid gray;">
								</td>
							</tr>
							<tr>
								<td class="rightAligned" style="width: 140px;">Accepted By</td>
								<td class="leftAligned" style="width: 230px;">
									<input type="text" readonly="readonly" value="" name="txtAcceptedBy" id="txtAcceptedBy" style="width: 200px; text-align: left; border: 1px solid gray;">
								</td>
								<td class="rightAligned" style="width: 140px;">Accept Date</td>
								<td class="leftAligned" style="width: 230px;">
									<input type="text" readonly="readonly" value="" name="txtAcceptDate" id="txtAcceptDate" style="width: 200px; text-align: left; border: 1px solid gray;">
								</td>
							</tr>
							<tr>
								<td class="rightAligned" style="width: 140px;">Ceding Company</td>
								<td class="leftAligned" style="width: 230px;">
									<input type="text" readonly="readonly" value="" name="txtCedingCompany" id="txtCedingCompany" style="width: 200px; text-align: left; border: 1px solid gray;">
								</td>
								<td class="rightAligned" style="width: 140px;">Reassured</td>
								<td class="leftAligned" style="width: 230px;">
									<input type="text" readonly="readonly" value="" name="txtReassured" id="txtReassured" style="width: 200px; text-align: left; border: 1px solid gray;">
								</td>
							</tr>	
							<tr>
								<td class="rightAligned" style="width: 140px;">RI Policy No.</td>
								<td class="leftAligned" style="width: 230px;">
									<input type="text" value="" name="txtRIPolicyNo" id="txtRIPolicyNo" maxlength="27" style="width: 200px; text-align: left; border: 1px solid gray;">
								</td>
								<td class="rightAligned" style="width: 140px;">RI Binder No.</td>
								<td class="leftAligned" style="width: 230px;">
									<input type="text" value="" name="txtRIBinderNo" id="txtRIBinderNo" maxlength="20" style="width: 200px; text-align: left; border: 1px solid gray;">
								</td>
							</tr>
							<tr>
								<td class="rightAligned" style="width: 140px;">RI Endt. No.</td>
								<td class="leftAligned" style="width: 230px;">
									<input type="text" value="" name="txtRIEndtNo" id="txtRIEndtNo" maxlength="20" style="width: 200px; text-align: left; border: 1px solid gray;">
								</td>
								<td class="rightAligned" style="width: 140px;">Date Offered</td>
								<td class="leftAligned" style="width: 230px;">
									<input type="text" readonly="readonly" value="" name="txtDateOffered" id="txtDateOffered" style="width: 200px; text-align: left; border: 1px solid gray;">
								</td>
							</tr>
							<tr>
								<td class="rightAligned" style="width: 140px;">Offered By</td>
								<td class="leftAligned" style="width: 230px;">
									<input type="text" readonly="readonly" value="" name="txtOfferedBy" id="txtOfferedBy" style="width: 200px; text-align: left; border: 1px solid gray;">
								</td>
								<td class="rightAligned" style="width: 140px;">Amount Offered</td>
								<td class="leftAligned" style="width: 230px;">
									<input type="text" readonly="readonly" value="" name="txtAmountOffered" id="txtAmountOffered" style="width: 200px; text-align: right; border: 1px solid gray;">
								</td>
							</tr>
							<tr>
								<td class="rightAligned" style="width: 140px;">Orig. TSI Amount</td>
								<td class="leftAligned" style="width: 230px;">
									<input type="text" class="money2" value="" name="txtOrigTSIAmount" id="txtOrigTSIAmount" style="width: 200px; text-align: right; border: 1px solid gray;" maxlength="17">
								</td>
								<td class="rightAligned" style="width: 140px;">Orig. Premium Amount</td>
								<td class="leftAligned" style="width: 230px;">
									<input type="text" value="" name="txtOrigPremAmount" id="txtOrigPremAmount" style="width: 200px; text-align: right; border: 1px solid gray;" maxlength="13" class="money2">
								</td>
							</tr>
							<tr>
								<td class="rightAligned" style="width: 140px;">Remarks</td>
								<td class="leftAligned" colspan="3" style="width: 230px;">
									<div class="withIconDiv" style="float: left; width: 588px">
										<textarea id="txtRemarks" class="withIcon" style="width: 550px; resize:none;" name="txtRemarks" onkeyup="limitText(this,4000);" onkeydown="limitText(this,4000);"></textarea>
										<img id="editTxtRemarks" alt="edit" style="width: 14px; height: 14px; margin: 3px; float: right;" src="/Geniisys/images/misc/edit.png">
									</div>
								</td>
							</tr>
						</tbody>				
					</table>
				</div>
			</div>
			</div>
			<div class="buttonDiv" style="float: left; width: 100%"> 
				<table align="center">
					<tbody>
						<tr>
							<td>
								<input id="btnInspection" class="button noChangeTagAttr" type="button" style="display: none; value="Select Inspection" name="btnInspection">
							</td>
							<td>
								<input id="btnCancel" class="button" type="button" style="width: 60px;" value="Cancel" name="btnCancel">
							</td>
							<td>
								<input id="btnSave" class="button" type="button" style="width: 60px;" value="Save" name="btnSave">
							</td>
						</tr>
					</tbody>
				</table>
			</div>
	</form>
	</div>
</div>
<script>

	$("searchPolNo").observe("click", function() {
		showINPolbasLOV();
	});

	$("btnSave").observe("click", function() {
		
		$("txtOrigTSIAmount").value = unformatCurrencyValue($F("txtOrigTSIAmount"));
		$("txtOrigPremAmount").value = unformatCurrencyValue($F("txtOrigPremAmount"));
		
		if(isNaN($F("txtOrigTSIAmount")) && $F("txtOrigTSIAmount") != "" ){
			showMessageBox("Orig TSI Amount legal characters are 0-9 - + E.", imgMessage.ERROR);
		} else if (isNaN($F("txtOrigPremAmount")) && $F("txtOrigPremAmount") != ""){
			showMessageBox("Orig Prem Amount legal characters are 0-9 - + E.", imgMessage.ERROR);
		} else {
			if(changeTag == 0) {
				//noChanges();
				showMessageBox(objCommonMessage.NO_CHANGES, "I");
			} else {
				$("txtOrigTSIAmount").value = formatCurrency($F("txtOrigTSIAmount"));
				$("txtOrigPremAmount").value = formatCurrency($F("txtOrigPremAmount"));
				updateAcceptanceInfo();
			}
		}
	});
	
	$("btnCancel").observe("click", function() {
		if(changeTag == 1) {
			showConfirmBox4("Confirm", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveAndCancel, exit, "");
		} else {
			exit();
		}
	});
	
	$$("div#acceptanceDiv input[type='text']").each(function(text) {
		$(text.id).observe("change", function() {
			changeTag = 1;
		});
	});
	
	$$("div#acceptanceDiv textarea").each(function(text) {
		$(text.id).observe("change", function() {
			changeTag = 1;
		});
	});
	
	$("txtOrigTSIAmount").observe("change", function(){
		/*if(isNaN($F("txtOrigTSIAmount"))){
			showMessageBox("Orig TSI Amount legal characters are 0-9 - + E.", imgMessage.ERROR);
			$("txtOrigTSIAmount").value =  $F("oldOrigTSIAmt");
		}*/ // replaced by: Nica 05.09.2013
		if((unformatCurrency("txtOrigTSIAmount") > 99999999999999.99) || (unformatCurrency("txtOrigTSIAmount") < -9999999999999.99)){ 
			showWaitingMessageBox("Field must be of form 99,999,999,999,999.99", "E",
				function(){
					$("txtOrigTSIAmount").value =  $F("oldOrigTSIAmt");
				}
			);
		}else {
			$("txtOrigTSIAmount").value = formatCurrency($F("txtOrigTSIAmount"));
		}
		
	});
	
	$("txtOrigPremAmount").observe("change", function(){
		/*if(isNaN($F("txtOrigPremAmount"))){
			showMessageBox("Orig Prem Amount legal characters are 0-9 - + E.", imgMessage.ERROR);
			$("txtOrigPremAmount").value =  $F("oldOrigPremAmt");
		}*/ // replaced by: Nica 05.09.2013
		if((unformatCurrency("txtOrigPremAmount") > 9999999999.99) || (unformatCurrency("txtOrigPremAmount") < -999999999.99)){  
			showWaitingMessageBox("Field must be of form 9,999,999,999.99", "E",
				function(){
					$("txtOrigPremAmount").value =  $F("oldOrigPremAmt");
				}
			);
		}else {
			$("txtOrigPremAmount").value = formatCurrency($F("txtOrigPremAmount"));
		}
		
	});

	$("btnExit").observe("click", function() {
		if(changeTag == 1) {
			showConfirmBox4("Confirm", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveAndCancel, exit, "");
		} else {
			exit();
		}
	});

	$("editTxtRemarks").observe("click", function() {
		if($F("txtAssuredNo") == null || $F("txtAssuredNo") == ""){
			
		} else {
			showEditor("txtRemarks", 4000);
		}
	});

	function saveAndCancel() {
		objGIUTS012.exitTag = "Y";
		updateAcceptanceInfo();
	}

	function exit() {
		objGIUTS012.exitTag = "N";
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}
	
	changeTag = 0;

	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	$("txtRIPolicyNo").readOnly = true;
	$("txtRIBinderNo").readOnly = true;
	$("txtRIEndtNo").readOnly = true;
	$("txtOrigTSIAmount").readOnly = true;
	$("txtOrigPremAmount").readOnly = true;
	$("txtOrigPremAmount").readOnly = true;
	$("txtRemarks").readOnly = true;
	
	changeTagFunc = updateAcceptanceInfo; // for logout confirmation

	observeReloadForm("reloadForm", showUpdateInitialAcceptance);
	setModuleId("GIUTS026");
	setDocumentTitle("Update Initial Acceptance");
	
</script>