<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="policyEntryMainDiv" class="sectionDiv" style="text-align: center; width: 99.6%; margin-bottom: 10px; margin-top: 10px;">
	<div class="tableContainer" style="font-size:12px;">
		<div class="tableHeader">
			<label style="width: 30px; margin-left: 13px;">Line</label>
			<label style="width: 55px; margin-left: 10px;">Subline</label>
			<label style="width: 30px; margin-left: 8px;">Iss</label>
			<label style="width: 30px; margin-left: 10px;">Yy</label>
			<label style="width: 70px; margin-left: 5px;">Pol Seq #</label>
			<label style="width: 42px;">Rnew</label>
			<label style="width: 70px; margin-left: 1px;">Ref Pol No</label>
		</div>
	<table border="0" align="left" style="margin-top: 10px;">
		<tr>
			<td>
				<input type="text" id="polLineCd" style="width: 25px; margin-left: 7px;" maxlength="2" class="upper"/>
				<input type="text" id="polSublineCd" style="width: 45px; margin-left: 3px;" maxlength="7" class="upper"/>
				<input type="text" id="polIssCd" style="width: 25px; margin-left: 3px;" maxlength="2" class="upper"/>
				<input class="rightAligned" type="text" id="polIssYy" style="width: 25px; margin-left: 3px;" maxlength="2" />
				<input class="rightAligned" type="text" id="policySeqNo" style="width: 55px; margin-left: 3px;" maxlength="7" />
				<input class="rightAligned" type="text" id="polRenewNo" style="width: 25px; margin-left: 3px;" maxlength="2" />
				<input type="text" id="polRefPolNo" style="width: 120px; margin-left: 3px; margin-bottom: 5px;" maxlength="30" />
			</td>
		</tr>	
		<tr>
			<td><input type="checkbox" id="checkDue" value="N" style="float: left; margin-bottom: 10px; margin-left: 7px;"><label style="float: left;">Include not yet due</label></td>
		</tr>
	</table>
	</div>	
</div>
<div id="buttonsDiv" style="text-align: center; margin-bottom: 5px;">
	<input type="button" class="button" id="btnPolicyOk" value="Ok" />
	<input type="button" class="button" id="btnPolicyCancel" value="Cancel" />
</div>

<script>
	makeInputFieldUpperCase();
	initializeAll();
	$("polLineCd").focus();
	
	function clearValues(){
		$("polLineCd").value = null;
		$("polSublineCd").value = null;
		$("polIssCd").value = null;
		$("polIssYy").value = null;
		$("policySeqNo").value = null;
		$("polRenewNo").value = null;
		$("polRefPolNo").value = null;
		$("checkDue").value = null;
	}
	
	function getRefPolNo(){
		if ($F("polLineCd") != "" && $F("polSublineCd") != "" && $F("polIssCd") != "" && $F("polIssYy") != "" && $F("policySeqNo") != "" && $F("polRenewNo") != "") {
			new Ajax.Request(contextPath + "/GIACPdcPremCollnController", {
				method : "GET",
				parameters : {
					action : "getRefPolNo",
					lineCd : $F("polLineCd"),
					sublineCd : $F("polSublineCd"),
					issCd : $F("polIssCd"),
					issueYy : removeLeadingZero($F("polIssYy")),
					polSeqNo : removeLeadingZero($F("policySeqNo")),
					renewNo : removeLeadingZero($F("polRenewNo"))
				},
				evalScripts : true,
				asynchronous : false,
				onComplete : function(response) {
					if (checkErrorOnResponse(response)) {
						$("polRefPolNo").value = response.responseText;
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}
	}

	function checkExists(polInv){
		var rows = postDatedCheckDetailsTableGrid.geniisysRows;
		for(var i=0; i<rows.length; i++){
			if(rows[i].issCd == polInv.issCd && rows[i].premSeqNo == polInv.premSeqNo && rows[i].instNo == polInv.instNo && nvl(rows[i].recordStatus, 0) != -1){
				return true;
			}
		}
		return false;
	}
	
	function getPolicyInvoices(){
		new Ajax.Request(contextPath + "/GIACPdcPremCollnController", {
			method : "GET",
			parameters : {
				action : "getPolicyInvoices",
				lineCd : $F("polLineCd"),
				sublineCd : $F("polSublineCd"),
				issCd : $F("polIssCd"),
				issueYy : removeLeadingZero($F("polIssYy")),
				polSeqNo : removeLeadingZero($F("policySeqNo")),
				renewNo : removeLeadingZero($F("polRenewNo")),
				checkDue : $("checkDue").checked ? 'Y' : 'N'
			},
			evalScripts : true,
			asynchronous : false,
			onComplete : function(response) {
				if (checkErrorOnResponse(response)) {
					if(giacPdcPremCollns.rows == undefined){
						giacPdcPremCollns.rows = [];
					}
					
					var polInv = JSON.parse(response.responseText);
					
					for(var i=0; i<polInv.length; i++){
						if(!checkExists(polInv[i])){
							polInv[i].recordStatus = 1;
							polInv[i].pdcId = objCurrGIACApdcPaytDtl.pdcId == "" || objCurrGIACApdcPaytDtl.pdcId == null ? null : objCurrGIACApdcPaytDtl.pdcId;
							giacPdcPremCollns.rows.push(polInv[i]);
							postDatedCheckDetailsTableGrid.addBottomRow(polInv[i]);
						}
					}
					
					closePolicyEntry();
					computeTotalCollnAmt();
					objGIACApdcPayt.pdcPremChangeTag = 1;
					objGIACApdcPayt.enableDisablePostDatedCheckForm();
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	function showPackageInvoices(){
		giacs090PackInvoicesOverlay = Overlay.show(contextPath+"/GIACPdcPremCollnController", {
			urlParameters: {
				action : "getPackInvoices",
				lineCd : $F("polLineCd"),
				sublineCd : $F("polSublineCd"),
				issCd : $F("polIssCd"),
				issueYy : removeLeadingZero($F("polIssYy")),
				polSeqNo : removeLeadingZero($F("policySeqNo")),
				renewNo : removeLeadingZero($F("polRenewNo")),
				checkDue : $("checkDue").checked ? 'Y' : 'N'
			},
			urlContent: true,
			draggable: true,
		    title: "List Of Invoice",
		    height: 320,
		    width: 550
		});
	}
	
	function validatePolicy(){
		new Ajax.Request(contextPath + "/GIACPdcPremCollnController", {
			evalScripts : true,
			asynchronous : false,
			method : "GET",
			parameters : {
				action : "validatePolicy",
				lineCd : $F("polLineCd"),
				sublineCd : $F("polSublineCd"),
				issCd : $F("polIssCd"),
				issueYy : removeLeadingZero($F("polIssYy")),
				polSeqNo : removeLeadingZero($F("policySeqNo")),
				renewNo : removeLeadingZero($F("polRenewNo")),
				checkDue : $("checkDue").checked ? 'Y' : 'N'
			},
			onComplete : function(response) {
				if (checkErrorOnResponse(response)) {
					var result = response.responseText;
					if (result == '1') {
						showMessageBox("Please enter a valid policy no.", imgMessage.ERROR);
					}else if(result == '2') {
						showMessageBox("Bills for this policy have been settled.", imgMessage.ERROR);
					}else if(result == '3') {
						showWaitingMessageBox("This is a package policy. Select from the list of invoices you would want to settle.", imgMessage.INFO,
								function() {
									showPackageInvoices();
									closePolicyEntry();
								});
					}else{
						getPolicyInvoices();
					}
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	function closePolicyEntry(){
		giacs090PolicyOverlay.close();
		delete giacs090PolicyOverlay;
	}
	
	$("polLineCd").observe("change", function(){
		if ($F("polLineCd") != "") {
			getRefPolNo();
		}
	});
	
	$("polSublineCd").observe("change", function(){
		if ($F("polSublineCd") != "") {
			getRefPolNo();
		}
	});
	
	$("polIssCd").observe("change", function(){
		if ($F("polIssCd") != "") {
			getRefPolNo();
		}
	});
	
	$("polIssYy").observe("change", function(){
		if ($F("polIssYy") == "" || isNaN($F("polIssYy")) || parseInt($F("polIssYy")) < 0) {
			$("polIssYy").value = "";
		} else {
			$("polIssYy").value = parseInt($F("polIssYy")).toPaddedString(2);
			getRefPolNo();
		}
	});
	
	$("policySeqNo").observe("change", function(){
		if ($F("policySeqNo") == "" || isNaN($F("policySeqNo")) || parseInt($F("policySeqNo")) < 0) {
			$("policySeqNo").value = "";
		} else {
			$("policySeqNo").value = parseInt($F("policySeqNo")).toPaddedString(6);
			getRefPolNo();
		}
	});
	
	$("polRenewNo").observe("change", function(){
		if ($F("polRenewNo") == "" || isNaN($F("polRenewNo")) || parseInt($F("polRenewNo")) < 0) {
			$("polRenewNo").value = "";
		} else {
			$("polRenewNo").value = parseInt($F("polRenewNo")).toPaddedString(2);
			getRefPolNo();
		}
	});
			
	$("btnPolicyOk").observe("click", function(){
		if ($F("polLineCd") != "" && $F("polSublineCd") != "" && $F("polIssCd") != "" && $F("polIssYy") != "" && $F("policySeqNo") != "" && $F("polRenewNo") != "") {
			validatePolicy();
		} else {
			showMessageBox("Please enter a valid policy no.", imgMessage.ERROR);
			return;
		}
	});
			
	$("btnPolicyCancel").observe("click", function(){
		closePolicyEntry();
	});
	
</script> 