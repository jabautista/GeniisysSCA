<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="mainNavMonthlyTrialBalance">
 	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="monthlyTrialBalanceExit">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Monthly Trial Balance</label>
			<span class="refreshers" style="margin-top: 0;">
			 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	
	<div id="monthlyTrialBalanceInput" class="sectionDiv" style="width: 920px; height: 405px;">
		<div class="sectionDiv" style="width: 620px; height:310px; margin: 40px 20px 20px 150px;">
			<div id="monthYear" class="sectionDiv" style="width: 535px; height: 30px; margin: 10px 0px 0px 13px; padding: 10px 30px 20px 30px;">
				<table align="center " style="height: 30px; padding-top: 5px;">
					<tr align="center">
						<td class="rightAligned" style="padding-right: 10px; padding-left: 35px;">Month & Year</td>
						<td>
							<select class="required" id="dDnMonth" name="dDnMonth" style="text-align: left; width: 175px;">
								<option></option>
								<option value="1">January</option>
								<option value="2">February</option>
								<option value="3">March</option>
								<option value="4">April</option>
								<option value="5">May</option>
								<option value="6">June</option>
								<option value="7">July</option>
								<option value="8">August</option>
								<option value="9">September</option>
								<option value="10">October</option>
								<option value="11">November</option>
								<option value="12">December</option>
							</select>
						</td> 
						<td>
						<input type="text" id="txtYear" style="float: left; text-align: right; width: 160px;" class="required integerNoNegativeUnformattedNoComma" maxlength="4" tabindex="219"/>
							<div style="float: left; width: 15px;">
								<img id="imgYrSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;"/>
								<img id="imgYrSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;"/>
								<img id="imgYrSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;"/>
								<img id="imgYrSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;"/>
							</div>	
						</td>
					</tr>
				</table>
			</div>
			
			<div class="sectionDiv" style="width: 40%; height: 138px; margin: 2px 2px 10px 13px; padding: 15px 0 15px 0;">				
				<table align="center" cellspacing="10">
					<tr>
						<td>
							<div>
								<input id="chkConsolidateAllBranches" type="checkbox" style="float: left;" value="" checked="checked" tabindex="202"/>
								<label style="margin-left: 7px;" for="chkConsolidateAllBranches">Consolidate All Branches</label>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div>
								<input id="chkSummaryOfAccounts" type="checkbox" style="float: left;" value="" checked="checked" tabindex="202"/>
								<label style="margin-left: 7px;" for="chkSummaryOfAccounts">Summary of Accounts</label>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div>
								<input id="chkBreakByBranch" type="checkbox" style="float: left;" value="" tabindex="202"/>
								<label style="margin-left: 7px;" for="chkBreakByBranch">Break by Branch</label>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div>
								<input id="chkAdjustingEntries" type="checkbox" style="float: left;" value="" tabindex="202"/>
								<label style="margin-left: 7px" for="chkAdjustingEntries">Adjusting Entries</label>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div>
								<input id="chkIncludeSubTotals" type="checkbox" style="float: left;" value="" tabindex="202"/>
								<label style="margin-left: 7px;" for="chkIncludeSubTotals">Include Sub Totals</label>
							</div>
						</td>
					</tr>
				</table>
			</div>
			
			<div id="printDialogFormDiv" class="sectionDiv" style="width: 50.4%; height: 138px; margin: 2px 0 0 1px; padding: 15px 22px 15px 8px;" align="center">
				<table style="float: left; padding: 1px 0px 0px 20px; margin-top: 15px;">
					<tr>
						<td class="rightAligned">Destination</td>
						<td class="leftAligned">
							<select id="selDestination" style="width: 200px;" tabindex="215">
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
							<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="rdoFileType" style="margin: 2px 5px 4px 15px; float: left;" checked="checked" disabled="disabled" tabindex="216"><label for="pdfRB" style="margin: 2px 0 4px 0">PDF</label>
							<input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="rdoFileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="217"><label for="excelRB" style="margin: 2px 0 4px 0">Excel</label>
							<input value="CSV" title="CSV" type="radio" id="rdoCsv" name="rdoFileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="217"><label for="rdoCsv" style="margin: 2px 0 4px 0">CSV</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Printer</td>
						<td class="leftAligned">
							<select id="printerName" style="width: 200px;" tabindex="218">
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
							<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="integerNoNegativeUnformattedNoComma" tabindex="219"/>
							<div style="float: left; width: 15px;">
								<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;"/>
								<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;"/>
								<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;"/>
								<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;"/>
							</div>					
						</td>
					</tr>
				</table>
			</div> 
			
			<div id="buttonsDiv" class="buttonsDiv" align="center" style="bottom: 10px;">
				<input id="btnPrint" type="button" class="button" value="Print" style="width: 100px;" tabindex="221"/>
			</div>
			
		</div>	
	</div>
	<input id="hidLastValidYear" type="hidden" value="" style="width: 100px;" tabindex="221"/>
</div>

<script>
	initializeAll();
	setModuleId("GIACS501");
	setDocumentTitle("Monthly Trial Balance");
	togglePrintFields("screen");
	$("txtYear").value = dateFormat(new Date(), 'yyyy');
	$("dDnMonth").value = dateFormat(new Date(), 'm');
	var reportId = null;
	var reportName = "Trial Balance";
	var branch = 'Y';
 	consolidateAll();
 	summaryOfAccounts();
 	
 	function consolidateAll(){
 		if ($("chkConsolidateAllBranches").checked == true){
 			$("chkBreakByBranch").disabled = true;
 			$("chkIncludeSubTotals").disabled = true;
 		}else{
 			if($("chkSummaryOfAccounts").checked == true) {
	 			$("chkBreakByBranch").disabled = true;
	 			$("chkAdjustingEntries").disabled = true;
	 			$("chkIncludeSubTotals").disabled = true;
 			}else{
 				$("chkBreakByBranch").disabled = false;
	 			$("chkAdjustingEntries").disabled = false;
	 			$("chkIncludeSubTotals").disabled = false;
 			}
 		}
 	}
 	
 	function summaryOfAccounts(){ 
 		if($("chkSummaryOfAccounts").checked == true) {
 			$("chkBreakByBranch").disabled = true;
 			$("chkAdjustingEntries").disabled = true;
 			$("chkIncludeSubTotals").disabled = true;
		}else{
			if ($("chkConsolidateAllBranches").checked == true){
				$("chkBreakByBranch").disabled = true;
			}else{
				$("chkBreakByBranch").disabled = false;
	 			$("chkIncludeSubTotals").disabled = false;
			}
			$("chkAdjustingEntries").disabled = false;
		}
 		
 	}
 	
	$("chkConsolidateAllBranches").observe("click", function() {
 		consolidateAll();
	});
 	$("chkSummaryOfAccounts").observe("click", function() {
 	 	summaryOfAccounts();
	});
 	
	$("txtYear").observe("change", function() {
		validateYear();
	});
	
	//for year
	$("imgYrSpinUp").observe("click", function() {
		var no = parseInt(nvl($F("txtYear"), 0));
		$("txtYear").value = no + 1;
		if ($("txtYear").value > 9999){ 
			customShowMessageBox("Invalid Year. Valid value should be from 1990 to 9999.", imgMessage.INFO, "txtYear");
			$("txtYear").value = parseInt($F("txtYear")) - 1;
		}
		$("hidLastValidYear").value = $F("txtYear");
	});

	$("imgYrSpinDown").observe("click", function() {
		var no = parseInt(nvl($F("txtYear"), 0));
		if (no > 1) {
			$("txtYear").value = no - 1;
		}
		if ($("txtYear").value < 1990){ 
			customShowMessageBox("Invalid Year. Valid value should be from 1990 to 9999.", imgMessage.INFO, "txtYear");
			$("txtYear").value = parseInt($F("txtYear")) + 1;
		}
		$("hidLastValidYear").value = $F("txtYear");
	});

	$("imgYrSpinUp").observe("mouseover", function() {
		$("imgYrSpinUp").src = contextPath + "/images/misc/spinupfocus.gif";
	});

	$("imgYrSpinDown").observe("mouseover", function() {
		$("imgYrSpinDown").src = contextPath + "/images/misc/spindownfocus.gif";
	});
	
	function togglePrintFields(destination) {
		if (destination == "printer") {
			$("printerName").disabled = false;
			$("txtNoOfCopies").disabled = false;
			$("printerName").addClassName("required");
			$("txtNoOfCopies").addClassName("required");
			$("imgSpinUp").show();
			$("imgSpinDown").show();
			$("imgSpinUpDisabled").hide();
			$("imgSpinDownDisabled").hide();
			$("txtNoOfCopies").value = 1;
			$("rdoPdf").disable();
			$("rdoExcel").disable();
			$("rdoCsv").disable();
		} else {
			if (destination == "file") {
				$("rdoPdf").enable();
				$("rdoExcel").enable();
				$("rdoCsv").enable();
			} else {
				$("rdoPdf").disable();
				$("rdoExcel").disable();
				$("rdoCsv").disable();
			}
			$("printerName").value = "";
			$("txtNoOfCopies").value = "";
			$("printerName").disabled = true;
			$("txtNoOfCopies").disabled = true;
			$("printerName").removeClassName("required");
			$("txtNoOfCopies").removeClassName("required");
			$("imgSpinUp").hide();
			$("imgSpinDown").hide();
			$("imgSpinUpDisabled").show();
			$("imgSpinDownDisabled").show();
		}
	}
	
	$("selDestination").observe("change", function() {
		var destination = $F("selDestination");
		togglePrintFields(destination);
	});
	
	$("imgSpinUp").observe("click", function() {
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		$("txtNoOfCopies").value = no + 1;
	});

	$("imgSpinDown").observe("click", function() {
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if (no > 1) {
			$("txtNoOfCopies").value = no - 1;
		}
	});

	$("imgSpinUp").observe("mouseover", function() {
		$("imgSpinUp").src = contextPath + "/images/misc/spinupfocus.gif";
	});

	$("imgSpinDown").observe("mouseover", function() {
		$("imgSpinDown").src = contextPath + "/images/misc/spindownfocus.gif";
	});

	$("imgSpinUp").observe("mouseout", function() {
		$("imgSpinUp").src = contextPath + "/images/misc/spinup.gif";
	});

	$("imgSpinDown").observe("mouseout", function() {
		$("imgSpinDown").src = contextPath + "/images/misc/spindown.gif";
	});
	
	$("monthlyTrialBalanceExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});
	
	function validateYear(){
		var no = parseInt(nvl($F("txtYear"), 0));
		if (no > 9999 || no < 1990){ 
			customShowMessageBox("Invalid Year. Valid value should be from 1990 to 9999.", imgMessage.ERROR, "txtYear");
			$("txtYear").value = $F("hidLastValidYear");
		}else{
			$("hidLastValidYear").value = no;
		}
	}
	
	function getReport(){
		if ($("chkConsolidateAllBranches").checked == true){
			if($("chkSummaryOfAccounts").checked == true) {
				reportId = "GIACR500B";
			}else{
				if($("chkBreakByBranch").checked == true) {
					if($("chkAdjustingEntries").checked == true) {
						reportId = "GIACR500AE";
					}else{
						reportId = "GIACR500D";
					}
				}else{
					if($("chkAdjustingEntries").checked == true) {
						reportId = "GIACR500AE";
					}else{
						reportId = "GIACR500A";
					}
				}
			}
		}else{
			if($("chkSummaryOfAccounts").checked == true) {
				reportId = "GIACR500C";
			}else{
				if($("chkBreakByBranch").checked == true) {
					if($("chkAdjustingEntries").checked == true) {
						reportId = "GIACR500AE";
					}else{
						reportId = "GIACR500D";
					}
				}else{
					if($("chkAdjustingEntries").checked == true) {
						reportId = "GIACR500AE";
					}else{
						reportId = "GIACR500";
					}
					if($("chkIncludeSubTotals").checked == true) {
						reportId = "GIACR500E";
					}
				}
			}
		}
	}
 
	//extract - giac_trial_balance_summary
	function extractMotherAccounts(){
		try {
			new Ajax.Request(contextPath + "/GIACGeneralLedgerReportsController", {
				parameters : {
					action : "extractGiacs501",
					month : $("dDnMonth").value,
				    year : $("txtYear").value
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function() {
					showNotice("Working, please wait...");
				},
				onComplete : function(response) {
					hideNotice();
					if (checkErrorOnResponse(response)) {
						validateReportId();
					}
				}
			});
		} catch (e) {
			showErrorMessage("Error: extractMotherAccounts", e);
		}
	}
	
	$("btnPrint").observe("click", function() {
		if(checkAllRequiredFieldsInDiv("monthYear")){
			getReport();
			if(reportId == "GIACR500AE"){
				if ($("chkConsolidateAllBranches").checked == true){
					branch = "N";
				}else{
					branch = "Y";
				}
			}
			extractMotherAccounts();
		}
	});
	
	//for printing
	function printReport() {
		try {
			var content = contextPath + "/GeneralLedgerPrintController?action=printReport" + "&reportId=" + reportId + 
			"&month=" + $("dDnMonth").value +
		    "&year=" + $("txtYear").value +
		    "&branch=" + branch;
			if ("screen" == $F("selDestination")) {
				showPdfReport(content, reportName);
			} else if ($F("selDestination") == "printer") {
				new Ajax.Request(content, {
					parameters : {
						noOfCopies : $F("txtNoOfCopies"),
						printerName : $F("printerName")
					},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							showMessageBox("Printing complete.", "S");
						}
					}
				});
			} else if ("file" == $F("selDestination")) {
				//added by clperello | 06.06.2014
				var fileType = "PDF";
			
				if($("rdoPdf").checked)
					fileType = "PDF";
				else if ($("rdoExcel").checked)
					fileType = "XLS";
				else if ($("rdoCsv").checked)
					fileType = "CSV";
				//end here clperello | 06.06.2014
				
				new Ajax.Request(content, {
					parameters : {
						destination : "file",
						fileType : fileType //$("rdoPdf").checked ? "PDF" : "XLS" //modified clperello 06.06.2014
					},
					onCreate : showNotice("Generating report, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							if ($("rdoCsv").checked){ //added by clperello | 06.06.2014
								copyFileToLocal(response, "csv");
								deleteCSVFileFromServer(response.responseText);
							}else
								copyFileToLocal(response);
						}
					}
				});
			} else if ("local" == $F("selDestination")) {
				new Ajax.Request(content, {
					parameters : {
						destination : "local"
					},
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							var message = printToLocalPrinter(response.responseText);
							if (message != "SUCCESS") {
								showMessageBox(message, imgMessage.ERROR);
							}
						}
					}
				});
			}
		} catch (e) {
			showErrorMessage("printReport", e);
		}
	}
	
	function validateReportId(){
		try {
			new Ajax.Request(contextPath+"/GIACGeneralLedgerReportsController",{
				parameters: {
					action:		"validateReportId",
					reportId:	reportId
				},
				ashynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if (response.responseText == "Y"){
							printReport();
						}else{
							showMessageBox("No existing records found in GIIS_REPORTS for report_id " + reportId + ".", "E");
						}
					}
				}
			});
		} catch(e){
			showErrorMessage("validateReportId",e);
		}
	}
	
	observeReloadForm("reloadForm", showMonthlyTrialBalance);
	
</script>