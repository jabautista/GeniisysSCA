<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="printOutstandingApArAccountsMainDiv">
	<div id="outerDiv">
		<div id="innerDiv">
			<label>Outstanding AP/AR Accounts</label>
			<span class="refreshers" style="margin-top: 0;">
	 			<label id="btnReloadForm" name="gro" style="margin-left: 5px;">Reload Form</label>
			</span>			
		</div>
	</div>
	<div class="sectionDiv">
		<div style="margin: 30px auto; width: 600px; padding: 3px;">
			<div style="border: 1px solid #E0E0E0; padding: 15px 0;">
				<table align="center">
					<tr>
						<td><label for="rdoPostingDate" style="margin-left: 40px;">Posting Date</label></td>
						<td><input type="radio" id="rdoPostingDate" name="periodTag" style="margin-left: 25px; margin-right: 65px;" tabindex="101" /></td>
						<td><label for="rdoTranDate">Transaction Date</label></td>
						<td><input type="radio" id="rdoTranDate" name="periodTag" style="margin-left: 25px; margin-right: 65px;" tabindex="102" checked="checked" /></td>
					</tr>
				</table>
			</div>
			<div style="border: 1px solid #E0E0E0; margin-top: 2px; padding: 15px 0;">
				<table align="center">
					<tr>
						<td><label for="txtCutOffDate" style="float: right;">Cut-off</label></td>
						<td style="padding-left: 5px;" colspan="2">
							<div style="float: left; width: 140px; height: 20px; margin: 0;" class="withIconDiv required">
								<input type="text" id="txtCutOffDate" class="withIcon required" readonly="readonly" style="width: 116px;" tabindex="203" />
								<img id="imgCutOffDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="" style="margin: 1px 1px 0 0; cursor: pointer" />
							</div>
						</td>
					</tr>
					<tr>
						<td><label for="txtLedgerTypeCd" style="float: right;">Ledger Type</label></td>
						<td style="padding-left: 5px;" colspan="3">
							<span class="lovSpan" style="width: 100px; margin-bottom: 0;">
								<input type="text" id="txtLedgerTypeCd" style="width: 75px; float: left;" class="withIcon upper" maxlength="10" tabindex="204" />
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgLedgerTypeCd" alt="Go" style="float: right;" />
							</span>
							<input type="text" id="txtLedgerType" readonly="readonly" style="margin: 0; height: 14px; width: 282px; margin-left: 2px;" tabindex="205" />
						</td>
					</tr>
					<tr>
						<td><label for="txtSubLedgerTypeCd" style="float: right;">Sub-ledger Type</label></td>
						<td style="padding-left: 5px;" colspan="3">
							<span class="lovSpan" style="width: 100px; margin-bottom: 0;">
								<input type="text" id="txtSubLedgerTypeCd" style="width: 75px; float: left;" class="withIcon upper" maxlength="10" tabindex="204" />
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSubLedgerTypeCd" alt="Go" style="float: right;" />
							</span>
							<input type="text" id="txtSubLedgerType" readonly="readonly" style="margin: 0; height: 14px; width: 282px; margin-left: 2px;" tabindex="205" />
						</td>
					</tr>
					<tr>
						<td><label for="txtTransactionTypeCd" style="float: right;">Transaction Type</label></td>
						<td style="padding-left: 5px;" colspan="3">
							<span class="lovSpan" style="width: 100px; margin-bottom: 0;">
								<input type="text" id="txtTransactionTypeCd" style="width: 75px; float: left;" class="withIcon upper" maxlength="10" tabindex="204" />
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgTransactionTypeCd" alt="Go" style="float: right;" />
							</span>
							<input type="text" id="txtTransactionType" readonly="readonly" style="margin: 0; height: 14px; width: 282px; margin-left: 2px;" tabindex="205" />
						</td>
					</tr>
					<tr>
						<td><label for="txtSLCd" style="float: right;">SL Name</label></td>
						<td style="padding-left: 5px;" colspan="3">
							<span class="lovSpan" style="width: 100px; margin-bottom: 0;">
								<input type="text" id="txtSLCd" style="width: 75px; float: left;" class="withIcon upper" maxlength="12" tabindex="204" />
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSLCd" alt="Go" style="float: right;" />
							</span>
							<input type="text" id="txtSLName" readonly="readonly" style="margin: 0; height: 14px; width: 282px; margin-left: 2px;" tabindex="205" />
						</td>
					</tr>
				</table>
			</div>
			<div style="width: 100%; margin-top: 2px; float: left;">
				<div style="border: 1px solid #E0E0E0; width: 230px; height: 130px; float: left; margin-right: 2px;">
					<ul style="list-style: none; margin: 15px 0px; float: left;">
						<li style="margin-bottom: 25px;">
							<input style="float: left;" type="radio" id="rdoDetailed" name="reportType" checked="checked" tabindex="301" />
							<label style="margin-top: 4px;" for="rdoDetailed">Detailed</label>
						</li>
						<li>
							<input style="clear: both; float: left;" type="radio" id="rdoSummary" name="reportType" tabindex="302" />
							<label style="margin-top: 4px;" for="rdoSummary">Summary</label>
							<ul style="clear: both; list-style: none; margin: 10px -20px; float: left;">
								<li style="display: inline-block; margin-bottom: 10px; float: left;">
									<input style="float: left;" type="radio" id="rdoPerTransactionType" name="summaryOpt" checked="checked" disabled="disabled" tabindex="301" />
									<label style="margin-top: 4px;" for="rdoPerTransactionType">Per Transaction Type</label>
								</li>
								<li>
									<input style="float: left;" type="radio" id="rdoPerSL" name="summaryOpt" disabled="disabled" tabindex="301" />
									<label style="margin-top: 4px;" for="rdoPerSL">Per SL</label>
								</li>
							</ul>
						</li>
					</ul>
				</div>
				<div id="printDiv" style="border: 1px solid #E0E0E0; height: 130px; width: 364px; float: left;">
					<table align="center" style="margin-top: 10px;">
						<tr>
							<td class="rightAligned">Destination</td>
							<td class="leftAligned">
								<select id="selDestination" style="width: 200px;" tabindex="305">
									<option value="screen">Screen</option>
									<option value="printer">Printer</option>
									<option value="file">File</option>
									<option value="local">Local Printer</option>
								</select>
							</td>
						</tr>
						<tr>
							<td></td>
							<td>
								<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="fileType" tabindex="306" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled">
								<label for="rdoPdf" style="margin: 2px 0 4px 0">PDF</label>
								<input value="CSV" title="CSV" type="radio" id="rdoCsv" name="fileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled">
								<label for="rdoCsv" style="margin: 2px 0 4px 0">CSV</label>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Printer</td>
							<td class="leftAligned">
								<select id="selPrinter" style="width: 200px;" class="required" tabindex="308">
									<option></option>
									<c:forEach var="p" items="${printers}">
										<option value="${p.name}">${p.name}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">No. of Copies</td>
							<td class="leftAligned">
								<input type="text" id="txtNoOfCopies" tabindex="309" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma">
								<div style="float: left; width: 15px;">
									<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;">
									<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;">
									<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;">
									<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;">
								</div>
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div>
				<input type="button" class="button" value="Print" tabindex="401" id="btnPrint" style="width: 90px; margin: 20px auto;" />
			</div>
		</div>
	</div>
</div>
<script>
	try {
		function resetSLName() {
			$("txtSLCd").clear();
			$("txtSLName").value = "ALL SL"
		}
		
		function resetTransactionType() {
			$("txtTransactionTypeCd").clear();
			$("txtTransactionType").value = "ALL TRANSACTION";
		}
		
		function resetSubLedgerType() {
			$("txtSubLedgerTypeCd").clear();
			$("txtSubLedgerType").value = "ALL SUB-LEDGER";
			resetTransactionType();
			resetSLName();
		}

		function resetLedgerType() {
			$("txtLedgerTypeCd").clear();
			$("txtLedgerType").value = "ALL LEDGER";
			resetSubLedgerType();
		}
		
		function initGIACS342() {
			setModuleId("GIACS342");
			setDocumentTitle("Outstanding AP/AR Accounts");
			resetLedgerType();
			makeInputFieldUpperCase();
		}

		function showLedgerLOV(filter) {
			try {
				LOV.show({
					controller : "ACGeneralLedgerReportsLOVController",
					urlParameters : {
						action : "getGiacs342LedgerCdLOV",
						filterText : filter
					},
					title : "List of Ledger Types",
					width : 480,
					height : 386,
					columnModel : [ {
						id : "ledgerCd",
						title : "Ledger Code",
						width : '120px'
					}, {
						id : "ledgerDesc",
						title : "Ledger Description",
						width : '345px'
					} ],
					draggable : true,
					autoSelectOneRecord : true,
					filterText : filter,
					onSelect : function(row) {
						if (row != null || row != undefined) {
							$("txtLedgerTypeCd").value = unescapeHTML2(row.ledgerCd);
							$("txtLedgerType").value = unescapeHTML2(row.ledgerDesc);
						}
						resetSubLedgerType();
					},
				});
			} catch (e) {
				showErrorMessage("showLedgerLOV", e);
			}
		}

		function showSubLedgerLOV(filter) {
			try {
				LOV.show({
					controller : "ACGeneralLedgerReportsLOVController",
					urlParameters : {
						action : "getGiacs342SubLedgerCdLOV",
						ledgerCd : $F("txtLedgerTypeCd"),
						filterText : filter
					},
					title : "List of Sub-Ledger Types",
					width : 480,
					height : 386,
					columnModel : [ {
						id : "subLedgerCd",
						title : "Sub-Ledger Code",
						width : '120px'
					}, {
						id : "subLedgerDesc",
						title : "Sub-Ledger Description",
						width : '345px'
					} ],
					draggable : true,
					autoSelectOneRecord : true,
					filterText : filter,
					onSelect : function(row) {
						if (row != null || row != undefined) {
							$("txtSubLedgerTypeCd").value = unescapeHTML2(row.subLedgerCd);
							$("txtSubLedgerType").value = unescapeHTML2(row.subLedgerDesc);
						}
						resetTransactionType();
						resetSLName();
					}
				});
			} catch (e) {
				showErrorMessage("showSubLedgerLOV", e);
			}
		}

		function showTransactionLOV(filter) {
			try {
				LOV.show({
					controller : "ACGeneralLedgerReportsLOVController",
					urlParameters : {
						action : "getGiacs342TransactionCdLOV",
						ledgerCd : $F("txtLedgerTypeCd"),
						subLedgerCd : $F("txtSubLedgerTypeCd"),
						filterText : filter
					},
					title : "List of Transaction Types",
					width : 480,
					height : 386,
					columnModel : [ {
						id : "transactionCd",
						title : "Transaction Code",
						width : '120px'
					}, {
						id : "transactionDesc",
						title : "Transaction Description",
						width : '345px'
					} ],
					draggable : true,
					autoSelectOneRecord : true,
					filterText : filter,
					onSelect : function(row) {
						if (row != null || row != undefined) {
							$("txtTransactionTypeCd").value = unescapeHTML2(row.transactionCd);
							$("txtTransactionType").value = unescapeHTML2(row.transactionDesc);
						}
					}
				});
			} catch (e) {
				showErrorMessage("showTransactionLOV", e);
			}
		}

		function showSlNameLOV(filter) {
			try {
				LOV.show({
					controller : "ACGeneralLedgerReportsLOVController",
					urlParameters : {
						action : "getGiacs342SlCdLOV",
						ledgerCd : $F("txtLedgerTypeCd"),
						subLedgerCd : $F("txtSubLedgerTypeCd"),
						filterText : filter
					},
					title : "List of SL Name",
					width : 480,
					height : 386,
					columnModel : [ {
						id : "slCd",
						title : "SL Code",
						width : '120px'
					}, {
						id : "slName",
						title : "SL Name",
						width : '345px'
					} ],
					draggable : true,
					autoSelectOneRecord : true,
					filterText : filter,
					onSelect : function(row) {
						if (row != null || row != undefined) {
							$("txtSLCd").value = row.slCd;
							$("txtSLName").value = unescapeHTML2(row.slName);
						}
					}
				});
			} catch (e) {
				showErrorMessage("showSlNameLOV", e);
			}
		}

		$("imgCutOffDate").observe("click", function() {
			scwShow($("txtCutOffDate"), this, null);
		});

		$("imgLedgerTypeCd").observe("click", function() {
			showLedgerLOV("");
		});

		$("txtLedgerTypeCd").observe("change", function() {
			$("txtLedgerType").value = "ALL LEDGER";
			if ($F("txtLedgerTypeCd") != "") {
				showLedgerLOV($F("txtLedgerTypeCd"));
			}
			if ($F("txtLedgerType") == "ALL LEDGER") {
				resetLedgerType();
			}
		});
		
		$("imgSubLedgerTypeCd").observe("click", function() {
			showSubLedgerLOV("");				
		});

		$("txtSubLedgerTypeCd").observe("change", function() {
			$("txtSubLedgerType").value = "ALL SUB-LEDGER";
			if ($F("txtSubLedgerTypeCd") != "") {
				showSubLedgerLOV($F("txtSubLedgerTypeCd"));					
			}
			if ($F("txtSubLedgerType") == "ALL SUB-LEDGER") {
				resetSubLedgerType();
			}
		});

		$("imgTransactionTypeCd").observe("click", function() {
			showTransactionLOV("");
		});

		$("txtTransactionTypeCd").observe("change", function() {
			$("txtTransactionType").value = "ALL TRANSACTION";
			if ($F("txtTransactionTypeCd") != "") {
				showTransactionLOV($F("txtTransactionTypeCd"));
			}
			if ($F("txtTransactionType") == "ALL TRANSACTION") {
				resetTransactionType();
			}
		});

		$("imgSLCd").observe("click", function() {
				showSlNameLOV("");
		});

		$("txtSLCd").observe("change", function() {
			$("txtSLName").value = "ALL SL";
			if ($F("txtSLCd") != "") {
				showSlNameLOV($F("txtSLCd"));
			}
			if ($F("txtSLName") == "ALL SL") {
				resetSLName();
			}
		});
		
		//report type events
		$("rdoDetailed").observe("click", function() {
			$("rdoPerTransactionType").disable();
			$("rdoPerSL").disable();
			$("txtSLCd").readOnly = false;
			enableSearch("imgSLCd");
		});
		
		$("rdoSummary").observe("click", function() {
			$("rdoPerTransactionType").enable();
			$("rdoPerSL").enable();
			if ($("rdoPerTransactionType").checked) {
				resetSLName();
				$("txtSLCd").readOnly = true;
				disableSearch("imgSLCd");
			}
		});
		
		$("rdoPerTransactionType").observe("click", function() {
			resetSLName();
			$("txtSLCd").readOnly = true;
			disableSearch("imgSLCd");
		});
		
		$("rdoPerSL").observe("click", function() {
			resetSLName();
			$("txtSLCd").readOnly = false;
			enableSearch("imgSLCd");
		});
		
		//printing events
		function toggleRequiredFields(dest){
			if(dest == "printer"){			
				$("selPrinter").disabled = false;
				$("txtNoOfCopies").disabled = false;
				$("selPrinter").addClassName("required");
				$("txtNoOfCopies").addClassName("required");
				$("imgSpinUp").show();
				$("imgSpinDown").show();
				$("imgSpinUpDisabled").hide();
				$("imgSpinDownDisabled").hide();
				$("txtNoOfCopies").value = 1; 
				$("rdoPdf").disable();
				$("rdoCsv").disable();
			} else {
				if(dest == "file"){
					$("rdoPdf").enable();
					$("rdoCsv").enable();
				} else {
					$("rdoPdf").disable();
					$("rdoCsv").disable();
				}	
				$("selPrinter").value = "";
				$("txtNoOfCopies").value = "";
				$("selPrinter").disabled = true;
				$("txtNoOfCopies").disabled = true;
				$("selPrinter").removeClassName("required");
				$("txtNoOfCopies").removeClassName("required");
				$("imgSpinUp").hide();
				$("imgSpinDown").hide();
				$("imgSpinUpDisabled").show();
				$("imgSpinDownDisabled").show();			
			}
		}

		toggleRequiredFields("screen");
		
		$("txtNoOfCopies").observe("focus", function(){
			$("txtNoOfCopies").setAttribute("lastValidValue", $F("txtNoOfCopies"));
		});
		
		$("txtNoOfCopies").observe("change", function(){
			if($F("txtNoOfCopies").trim() != "" && (isNaN($F("txtNoOfCopies")) || parseInt($F("txtNoOfCopies")) <= 0 || parseInt($F("txtNoOfCopies")) > 100)){
				showWaitingMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", function(){
					$("txtNoOfCopies").value = $("txtNoOfCopies").readAttribute("lastValidValue"); 
				});			
			}
		});	
		
		$("imgSpinUp").observe("click", function(){
			var no = parseInt(nvl($F("txtNoOfCopies"), 0));
			if(no < 100){ 
				$("txtNoOfCopies").value = no + 1;
			}
		});
		
		$("imgSpinDown").observe("click", function(){
			var no = parseInt(nvl($F("txtNoOfCopies"), 0));
			if(no > 1){
				$("txtNoOfCopies").value = no - 1;
			}
		});
		
		$("imgSpinUp").observe("mouseover", function(){
			$("imgSpinUp").src = contextPath + "/images/misc/spinupfocus.gif";
		});
		
		$("imgSpinDown").observe("mouseover", function(){
			$("imgSpinDown").src = contextPath + "/images/misc/spindownfocus.gif";
		});
		
		$("imgSpinUp").observe("mouseout", function(){
			$("imgSpinUp").src = contextPath + "/images/misc/spinup.gif";
		});
		
		$("imgSpinDown").observe("mouseout", function(){
			$("imgSpinDown").src = contextPath + "/images/misc/spindown.gif";
		});

		$("txtNoOfCopies").observe("focus", function(){
			$("txtNoOfCopies").setAttribute("lastValidValue", $F("txtNoOfCopies"));
		});
		
		$("txtNoOfCopies").observe("change", function(){
			if($F("txtNoOfCopies").trim() != "" && (isNaN($F("txtNoOfCopies")) || parseInt($F("txtNoOfCopies")) <= 0 || parseInt($F("txtNoOfCopies")) > 100)){
				showWaitingMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", function(){
					$("txtNoOfCopies").value = $("txtNoOfCopies").readAttribute("lastValidValue"); 
				});			
			}
		});

		$("selDestination").observe("change", function(){
			var dest = $F("selDestination");
			toggleRequiredFields(dest);
		});

		function getParams() {
			var periodTag = $("rdoPostingDate").checked ? "P" : "T";
			var params = "&periodTag=" + periodTag
					   + "&cutOffDate=" + $F("txtCutOffDate")
					   + "&ledgerCd=" + $F("txtLedgerTypeCd")
					   + "&subLedgerCd=" + $F("txtSubLedgerTypeCd")
					   + "&transactionCd=" + $F("txtTransactionTypeCd")
					   + "&slCd=" + $F("txtSLCd");
			return params;
		}
		
		function printReport() {
			try {
				var reportId = "GIACR343A";
				
				if($("rdoSummary").checked) {
					if($("rdoPerTransactionType").checked) {
						reportId = "GIACR343B";
					} else {
						reportId = "GIACR343C";
					}
				}

				var dest = $F("selDestination");
				var content = contextPath + "/GeneralLedgerPrintController?action=printReport"
										  + "&reportId=" + reportId
										  + getParams()
										  + "&noOfCopies=" + $F("txtNoOfCopies")
										  + "&printerName=" + $F("selPrinter")
										  + "&destination=" + dest;
				if(dest == "screen") {
					showPdfReport(content, "");
				} else if(dest == "printer") {
					new Ajax.Request(content, {
						parameters : {noOfCopies : $F("txtNoOfCopies"),
							printerName : $F("selPrinter")},
						onCreate: showNotice("Processing, please wait..."),				
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								showWaitingMessageBox("Printing complete.", "S", "");
							}
						}
					});
				} else if(dest == "file") {
					new Ajax.Request(content, {
						method: "POST",
						parameters : {destination : "file",
									  fileType    : $("rdoPdf").checked ? "PDF" : "CSV"}, 
						evalScripts: true,
						asynchronous: true,
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								if ($("rdoCsv").checked){
									copyFileToLocal(response, "csv");
									deleteCSVFileFromServer(response.responseText);
								} else 
									copyFileToLocal(response);
							}
						}
					});
				} else if(dest == "local"){
					new Ajax.Request(content, {
						parameters : {destination : "local"},
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								var message = printToLocalPrinter(response.responseText);
								if(message != "SUCCESS"){
									showMessageBox(message, imgMessage.ERROR);
								}
							}
						}
					});
				}
			} catch (e){
				showErrorMessage("printReport", e);
			}
		}
		
		$("btnPrint").observe("click", function(){
			if($F("txtCutOffDate") == "") {
				customShowMessageBox("Required fields must be entered.", "I", "txtCutOffDate");
			} else {
				if($F("selDestination") == "printer") {
					if(checkAllRequiredFieldsInDiv("printDiv")) {
						printReport();
					}
				} else {
					printReport();
				}
			}
		});
		
		function resetForm() {
			toggleRequiredFields("screen");
			$("selDestination").value = "screen";
			$("rdoTranDate").checked = true;
			$("rdoDetailed").checked  = true;
			fireEvent($("rdoDetailed"), "click");
			$("txtCutOffDate").clear();
			initGIACS342();
		}
		
		$("btnReloadForm").observe("click", resetForm);

		initGIACS342();
	} catch (e) {
		showErrorMessage("Outstanding AP/AR Accounts", e);
	}
</script>