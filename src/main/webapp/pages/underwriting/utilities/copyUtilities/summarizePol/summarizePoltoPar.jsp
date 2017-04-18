<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="summarizePolicyMainDiv" name="summarizePolicyMainDiv" style="margin-top : 0px;">
	<div id="summaryPolicyMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="summaryPolExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<form id="copySummarizePolicyForm" name="copySummarizePolicyForm">
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Copy Summarize Policy To PAR</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label> 
			 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
				</span>
			</div>
		</div>
		<div id="copySummarizePolicyDiv" name="copySummarizePolicyDiv" class="sectionDiv" align="center">
			<table style="width: 480px; margin-top: 40px;">
				<tr>
					<td class="rightAligned">Policy No.</td>
					<td class="leftAligned" style="width: 360">
						<div style="width: 43px; float: left;" class="withIconDiv">
							<input type="text" id="txtPolLineCd" name="txtPolLineCd" value="" style="width: 18px;" class="withIcon allCaps upper" maxlength="2">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtLineCdIcon" name="txtLineCdIcon" alt="Go" />
						</div>
						<div style="width: 89px; float: left;" class="withIconDiv">
							<input type="text" id="txtSublineCd" name="txtSublineCd" value="" style="width: 64px;" class="withIcon allCaps upper" maxlength="7">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtSublineCdIcon" name="txtSublineCdIcon" alt="Go" />
						</div>
						<div style="width: 43px; float: left;" class="withIconDiv">
							<input type="text" id="txtPolIssCd" name="txtPolIssCd" value="" style="width: 18px;" class="withIcon allCaps upper" maxlength="2">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtPolIssCdIcon" name="txtPolIssCdIcon" alt="Go" />
						</div>
						<div style="width: 43px; float: left;" class="withIconDiv">
							<input type="text" id="txtIssueYy" name="txtIssueYy" value="" style="width: 18px;" class="withIcon integerUnformatted rightAligned" 
							regExpPatt="pDigit02" hasOwnChange="N" maxlength="2" />
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtIssueYyIcon" name="txtIssueYyIcon" alt="Go" />
						</div>
						<div style="width: 89px; float: left;" class="withIconDiv">
							<input type="text" id="txtPolSeqNo" name="txtPolSeqNo" value="" style="width: 64px;" class="withIcon integerUnformatted rightAligned" 
							regExpPatt="pDigit07" hasOwnChange="N" maxlength="7" /> 
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtPolSeqNoIcon" name="txtPolSeqNoIcon" alt="Go" />
						</div>
						<div style="width: 43px; float: left;" class="withIconDiv">
							<input type="text" id="txtRenewNo" name="txtRenewNo" value="" style="width: 18px;" class="withIcon integerUnformatted rightAligned" 
							regExpPatt="pDigit02" hasOwnChange="N" maxlength="2" />
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtRenewNoIcon" name="txtRenewNoIcon" alt="Go" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">PAR No.</td>
					<td class="leftAligned" style="width: 360">
						<input type="text" name="txtParLineCd" id="txtParLineCd" parField="1" style="width:37px;" title="Par Line" readonly="readonly"/>
						<input class="required allCaps" type="text" name="txtParIssCd" id="txtParIssCd" parField="1" style="width:37px;" title="Par Issue Code" maxlength="2"/>
						<input class="required integerUnformatted" type="text" name="txtParYy" id="txtParYy" parField="1" style="width:34px;" title="Par Year" maxlength="3"/>
						<input type="text" name="txtParSeqNo" id="txtParSeqNo" parField="1" style="width:86px;" title="Par Sequence No" readonly="readonly"/>
						<input type="text" name="txtQuoteSeqNo" id="txtQuoteSeqNo" parField="1" style="width:35px;" title="Quote Sequence No" readonly="readonly"/>
					</td>
				</tr>
			</table>
			<table style="margin-top: 20px; margin-bottom: 30px; margin-left: 100px;">
				<tr>
					<td style="width: 250px;">
						<input type="checkbox" id="chkSpoiledPolicy" name="chkSpoiledPolicy" />Include Spoiled Policy
					</td>
					<td style="width: 250px;">
						<input type="checkbox" id="chkCancelledPolicy" name="chkCancelledPolicy" />Include Cancelled Records
					</td>
				</tr>
				<tr>
					<td style="width: 250px;">
						<input type="checkbox" id="chkSpoiledEndt" name="chkSpoiledEndt" />Include Spoiled Endorsements
					</td>
					<td style="width: 250px;">
						<input type="checkbox" id="chkExpiredPolicies" name="chkExpiredPolicies" />Include Expired Records
					</td>
				</tr>
			</table>
		</div>
		<div class="buttonsDiv">
			<input type="button" id="btnCopy" name="btnCopy" class="disabledButton" value="Copy" />
			<input type="button" id="btnCancel" name="btnCancel" class="button" value="Cancel" />
		</div>
	</form>
</div>
<script type="text/javascript">
	var policyId = null;
	var policyValidated = false;
	var newParYy = dateFormat(serverDate, 'yy');
	setModuleId("GIUTS009");
	setDocumentTitle("Copy Summarize Policy To PAR");
	objUWGlobal.hideObjGIUTS009 = {};
	initializeAll();
	initializeAccordion();
	observeReloadForm("reloadForm", showSummarizePolicy);
	
	function enableDisableCopy() {
		if(!($F("txtPolLineCd") == "" ||
				$F("txtSublineCd") == "" ||
				$F("txtPolIssCd") == "" ||
				$F("txtIssueYy") == "" ||
				$F("txtPolSeqNo") == "" ||
				$F("txtRenewNo") == "")) {
			enableButton("btnCopy");
		} else {
			disableButton("btnCopy");
		}
	}
	
	$$("input[type='checkbox']").each(function(row) {
		row.observe("change", function() {
			if($F("txtPolLineCd") == "" ||
					$F("txtSublineCd") == "" ||
					$F("txtPolIssCd") == "" ||
					$F("txtIssueYy") == "" ||
					$F("txtPolSeqNo") == "" ||
					$F("txtRenewNo") == "") {
				showMessageBox("Please enter Policy Number.");
				row.checked = false;
			} else {
				checkPolicyGIUTS009();
			}
		});
	});
	
	function checkPolicyGIUTS009() {
		try {
			new Ajax.Request(contextPath+"/CopyUtilitiesController", {
				method: "GET",
				parameters: {
					action: "checkPolicy",
					lineCd: $F("txtPolLineCd"),
					sublineCd: $F("txtSublineCd"),
					issCd: $F("txtPolIssCd"),
					issueYy: $F("txtIssueYy"),
					polSeqNo: removeLeadingZero($F("txtPolSeqNo")),
					renewNo: removeLeadingZero($F("txtRenewNo")),
					spldPolSw: $("chkSpoiledPolicy").checked ? "Y" : "N",
					spldEndtSw: $("chkSpoiledEndt").checked ? "Y" : "N",
					cancelSw: $("chkCancelledPolicy").checked ? "Y" : "N",
					expiredSw: $("chkExpiredPolicies").checked ? "Y" : "N"
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response) {
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
						policyValidated = true;
						enableButton("btnCopy");
					} else {
						policyValidated = false;
					}
				}
			});
		} catch(e) {
			showErrorMessage("checkPolicyGIUTS009", e);
		}
	}
	
	function checkIfPolicyExists(field) {
		try {
			if(!($F("txtPolLineCd") == "" ||
					$F("txtSublineCd") == "" ||
					$F("txtPolIssCd") == "" ||
					$F("txtIssueYy") == "" ||
					$F("txtPolSeqNo") == "" ||
					$F("txtRenewNo") == "")) {
				checkPolicyGIUTS009();
			} else {
				new Ajax.Request(contextPath+"/CopyUtilitiesController", {
					method: "GET",
					parameters: {
						action: "checkIfPolicyExists",
						lineCd: $F("txtPolLineCd"),
						sublineCd: $F("txtSublineCd"),
						issCd: $F("txtPolIssCd"),
						issueYy: $F("txtIssueYy"),
						polSeqNo: removeLeadingZero($F("txtPolSeqNo")),
						renewNo: removeLeadingZero($F("txtRenewNo"))
					},
					asynchronous: false,
					evalScripts: true,
					onComplete: function(response) {
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
							policyValidated = true;
							enableDisableCopy();
						} else {
							$(field).value = "";
							if(field == "txtIssueYy") $("txtParYy").value = "";
							$(field).focus();
						}
					}
				});
			}
		} catch(e) {
			showErrorMessage("checkIfPolicyExists", e);
		}
	}
	objUWGlobal.hideObjGIUTS009.checkIfPolicyExists = checkIfPolicyExists;
	
	function validateLineGIUTS009() {
		try {
			new Ajax.Request(contextPath+"/CopyUtilitiesController", {
				method: "GET",
				parameters: {
					action: "validateSummaryLine",
					lineCd: $F("txtPolLineCd"),
					sublineCd: $F("txtSublineCd"),
					issCd: $F("txtPolIssCd"),
					issueYy: $F("txtIssueYy"),
					polSeqNo: removeLeadingZero($F("txtPolSeqNo")),
					renewNo: removeLeadingZero($F("txtRenewNo")),
					spldPolSw: $("chkSpoiledPolicy").checked ? "Y" : "N",
					spldEndtSw: $("chkSpoiledEndt").checked ? "Y" : "N",
					cancelSw: $("chkCancelledPolicy").checked ? "Y" : "N",
					expiredSw: $("chkExpiredPolicies").checked ? "Y" : "N"
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Validating Line Code, please wait...");
				},
				onComplete: function(response) {
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
						policyValidated = true;
						enableDisableCopy();
					} else {
						policyValidated = false;
						$("txtPolLineCd").value = "";
						$("txtParLineCd").value = "";
						$("txtPolLineCd").focus();
					}
				}
			});
		} catch(e) {
			showErrorMessage("validateLineGIUTS009", e);
		}
	}
	
	function validateIssCdGIUTS009() {
		try {
			var policyValidated = false;
			
			new Ajax.Request(contextPath+"/CopyUtilitiesController", {
				method: "GET",
				parameters: {
					action: "validateSummaryIssCd",
					lineCd: $F("txtPolLineCd"),
					sublineCd: $F("txtSublineCd"),
					issCd: $F("txtPolIssCd"),
					issueYy: $F("txtIssueYy"),
					polSeqNo: removeLeadingZero($F("txtPolSeqNo")),
					renewNo: removeLeadingZero($F("txtRenewNo")),
					spldPolSw: $("chkSpoiledPolicy").checked ? "Y" : "N",
					spldEndtSw: $("chkSpoiledEndt").checked ? "Y" : "N",
					cancelSw: $("chkCancelledPolicy").checked ? "Y" : "N",
					expiredSw: $("chkExpiredPolicies").checked ? "Y" : "N"
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response) {
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
						policyValidated = true;
						enableDisableCopy();
					} else {
						$("txtPolIssCd").value = "";
						$("txtParIssCd").value = "";
						$("txtPolIssCd").focus();
					}
				}
			});
			return policyValidated;
		} catch(e) {
			showErrorMessage("validateIssCdGIUTS009", e);
		}
	}
	
	function validateParIssCdGIUTS009() {//added by steven 5.10.2013
		try {
			var policyValidated = false;
			new Ajax.Request(contextPath+"/CopyUtilitiesController", {
				method: "GET",
				parameters: {
					action: "validateParIssCd",
					lineCd: $F("txtPolLineCd"),
					parIssCd: $F("txtParIssCd")
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response) {
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
						policyValidated = true;
					} else {
						$("txtParIssCd").value = "";
						$("txtParIssCd").focus();
					}
				}
			});
			return policyValidated;
		} catch(e) {
			showErrorMessage("validateIssCdGIUTS009", e);
		}
	}
	
	function clearSummaryFields() {
		$("txtPolLineCd").value = "";
		$("txtIssueYy").value = "";
		$("txtSublineCd").value = "";
		$("txtParYy").value = "";
		$("txtPolSeqNo").value = "";
		$("txtPolIssCd").value = "";
		$("txtRenewNo").value = "";
		$("txtParLineCd").value = "";
		$("txtParIssCd").value = "";
		$("txtParYy").value = "";
		$("txtParSeqNo").value = "";
		$("txtQuoteSeqNo").value = "";
		$("chkSpoiledPolicy").checked = false;
		$("chkCancelledPolicy").checked = false;
		$("chkSpoiledEndt").checked = false;
		$("chkExpiredPolicies").checked = false;
		policyId = null;
	}
	
	$("btnCancel").observe("click", function() {
		if(policyId == null || policyId == "") {
			var exist = false;
			$$("div#copySummarizePolicyDiv input[type='text']").each(function(row) {
				if(row.value != "") exist = true;
			});
			clearSummaryFields();
			if(exist) {
				clearSummaryFields();
			} else {
				fireEvent($("summaryPolExit"), "click");
			}
		} else {
			clearSummaryFields();
		}
	});
	
	function showConfirmationOverlay(policy, par) {
		var contentDiv = new Element("div", {id : "modal_content_summary"});
		var contentHTML = '<div id="modal_content_summary"></div>';
		 
		summaryOverlay = Overlay.show(contentHTML, {
					id: 'modal_dialog_summary',
	 				title: "Message",
	 				width: 240,
	 				height: 180,
	 				draggable: true,
	 				closable: true
 				}); 
		
		new Ajax.Updater("modal_content_summary", 
				contextPath+"/CopyUtilitiesController?action=confirmPolicySummarized&policy="+policy+"&par="+par+"&isPack=N", {
			evalScripts: true,
			asynchronous: false,
			onComplete: function (response) {			
				if (!checkErrorOnResponse(response)) {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	
	$("btnCopy").observe("click", function() {
		try {
			if (checkAllRequiredFieldsInDiv("copySummarizePolicyDiv")) { //added by steven 5.10.2013
				if(!($F("txtPolLineCd") == "" ||
						$F("txtSublineCd") == "" ||
						$F("txtPolIssCd") == "" ||
						$F("txtIssueYy") == "" ||
						$F("txtPolSeqNo") == "" ||
						$F("txtRenewNo") == "") && policyValidated) {
					new Ajax.Request(contextPath+"/CopyUtilitiesController?", {
						method: "GET",
						parameters: {
							action: "summarizePolToPar",
							lineCd: $F("txtPolLineCd"),
							sublineCd: $F("txtSublineCd"),
							issCd: $F("txtPolIssCd"),
							issueYy: $F("txtIssueYy"),
							polSeqNo: removeLeadingZero($F("txtPolSeqNo")),
							renewNo: removeLeadingZero($F("txtRenewNo")),
							parIssCd: $F("txtParIssCd"),
							spldPolSw: $("chkSpoiledPolicy").checked ? "Y" : "N",
							spldEndtSw: $("chkSpoiledEndt").checked ? "Y" : "N",
							cancelSw: $("chkCancelledPolicy").checked ? "Y" : "N",
							expiredSw: $("chkExpiredPolicies").checked ? "Y" : "N"
						},
						evalScripts: true,
						asynchronous: false,
						onCreate: function(){
							showNotice("Copying Summarize Policy To PAR, please wait...");
						},
						onComplete: function(response) {
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
								var res = JSON.parse(response.responseText);
								if(res.txtResult == "success") {
									$("txtParSeqNo").value = parseInt(res.parSeqNo).toPaddedString(6);
									$("txtQuoteSeqNo").value = parseInt(res.quoteSeqNo).toPaddedString(2);
									var policy = $F("txtPolLineCd")+"-"+$F("txtSublineCd")+"-"+
									$F("txtPolIssCd")+"-"+$F("txtIssueYy")+"-"+$F("txtPolSeqNo")+"-"+
									$F("txtRenewNo");
									var par = $F("txtParLineCd")+"-"+$F("txtParIssCd")+"-"+$F("txtParYy")+"-"+
										$F("txtParSeqNo")+"-"+$F("txtQuoteSeqNo");
									showConfirmationOverlay(policy, par);
								}
							} 
						}
					});
				} else {
					showMessageBox("There are no records found for this option you have chosen.");
				}
			}
		} catch(e) {
			showErrorMessage("copyPol", e);
		}
	});
	
// 	$("txtRenewNo").observe("change", function() {
// 		if($F("txtPolLineCd") != "" && $F("txtSublineCd") != "" && $F("txtPolIssCd") != "" 
// 			&& $F("txtIssueYy") != "" && $F("txtPolSeqNo") != "" && $F("txtRenewNo")) {
// 			checkIfPolicyExists();
// 		}
// 	});
	
	$("txtLineCdIcon").observe("click", function() {
		//if(policyId == null) {
			//showLineCdLOV2($F("txtPolIssCd"), "GIUTS009", function(row) {
			showGiuts009LineCdLOV($F("txtPolIssCd"), "GIUTS009", function(row) {
				var oldLine = $F("txtPolLineCd");
				if(oldLine != unescapeHTML2(row.lineCd)) {
					clearSummaryFields();
					$("txtPolLineCd").value = unescapeHTML2(row.lineCd);
					$("txtParLineCd").value = unescapeHTML2(row.lineCd);
					$("txtPolLineCd").focus();
					validateLineGIUTS009();
				}
			});
		//}
	});
	
	$("txtSublineCdIcon").observe("click", function() {
		if($F("txtPolLineCd") != "") {
			showSublineCdLOV2($F("txtPolLineCd"), "GIUTS009", function(row) {
				$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
				$("txtIssueYy").value = "";
				$("txtPolSeqNo").value = "";
				$("txtRenewNo").value = "";
			});
		}
	});
	
	$("txtPolIssCdIcon").observe("click", function() {
		showIssCdNameLOV2($F("txtPolLineCd"), "GIUTS009", function(row) {
			$("txtPolIssCd").value = row.issCd;
			$("txtParIssCd").value = row.issCd;
			$("txtIssueYy").value = "";
			$("txtPolSeqNo").value = "";
			$("txtRenewNo").value = "";
			validateIssCdGIUTS009();
		});
	});

	$("txtIssueYyIcon").observe("click", function() {
		if($F("txtPolLineCd") != "" && $F("txtSublineCd") != "" && $F("txtPolIssCd") != "") {
			showIssueYyLOV($F("txtPolLineCd"), $F("txtSublineCd"), $F("txtPolIssCd"), "GIUTS009");
		}
	});
	
	$("txtPolSeqNoIcon").observe("click", function() {
		if($F("txtPolLineCd") != "" && $F("txtSublineCd") != "" && $F("txtPolIssCd") != "" && $F("txtIssueYy") != "") {
			showPolSeqNoLOV($F("txtPolLineCd"), $F("txtSublineCd"), $F("txtPolIssCd"), $F("txtIssueYy"),"GIUTS009");
		}
	});
	
	$("txtRenewNoIcon").observe("click", function() {
		if($F("txtPolLineCd") != "" && $F("txtSublineCd") != "" && $F("txtPolIssCd") != "" && $F("txtIssueYy") != "" && $F("txtPolSeqNo") != "") {
			showRenewNoLOV($F("txtPolLineCd"), $F("txtSublineCd"), $F("txtPolIssCd"), $F("txtIssueYy"), $F("txtPolSeqNo"), "GIUTS009");
		}
	});	
	
	$("txtPolLineCd").observe("change", function() {
		var line = $F("txtPolLineCd");
		clearSummaryFields();
		$("txtPolLineCd").value = line;
		$("txtParLineCd").value = line;
		validateLineGIUTS009();
	});
	
	$("txtSublineCd").observe("change", function() {
		$("txtIssueYy").value = "";
		$("txtPolSeqNo").value = "";
		$("txtRenewNo").value = "";
		checkIfPolicyExists("txtSublineCd");
	});
	
	$("txtPolIssCd").observe("change", function() {
		$("txtParIssCd").value = $F("txtPolIssCd");
		/* $("txtIssueYy").value = "";
		$("txtPolSeqNo").value = "";
		$("txtRenewNo").value = ""; */
		validateIssCdGIUTS009();
	});
	
	$("txtParIssCd").observe("change", function() {//added by steven 5/10/2013
		validateParIssCdGIUTS009();
	});
	
	$("txtIssueYy").observe("change", function() {
		if(!(isNaN(removeLeadingZero($F("txtIssueYy")))) && $F("txtIssueYy").trim() != '') {
			$("txtIssueYy").value = parseInt($F("txtIssueYy")).toPaddedString(2);
			$("txtParYy").value = (newParYy);
			$("txtPolSeqNo").value = "";
			$("txtRenewNo").value = "";
			checkIfPolicyExists("txtIssueYy");
		} else {
			$("txtIssueYy").value = "";
		}
	});
	
	$("txtPolSeqNo").observe("change", function() {
		if(isNaN(removeLeadingZero($F("txtPolSeqNo"))) || $F("txtPolSeqNo").trim() == '') {
			$("txtPolSeqNo").value = "";
		} else {
			$("txtPolSeqNo").value = lpad($F("txtPolSeqNo"),7,'0');
			$("txtRenewNo").value = "";
			checkIfPolicyExists("txtPolSeqNo");
		}
	});
	
	$("txtRenewNo").observe("change", function() {
		if(isNaN(removeLeadingZero($F("txtRenewNo"))) || $F("txtRenewNo").trim() == '') {
			$("txtRenewNo").value = "";
		} else {
			$("txtRenewNo").value = parseInt($F("txtRenewNo")).toPaddedString(2);
			checkIfPolicyExists("txtRenewNo");
		}
	});
	
	$("summaryPolExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	makeInputFieldUpperCase();
</script>