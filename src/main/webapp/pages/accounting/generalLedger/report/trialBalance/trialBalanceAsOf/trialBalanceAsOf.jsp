<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="mainNavTrialBalanceAsOf">
 	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="trialBalanceAsOfExit">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Trial Balance As Of</label>
			<span class="refreshers" style="margin-top: 0;">
			 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	
	<div id="trialBalanceAsOfInput" class="sectionDiv" style="width: 740px; height: 380px; padding-top: 60px; padding-left: 180px;">
		<div class="sectionDiv" style="width: 563px; height:310px;">
			<div id="monthYear" class="sectionDiv" style="width: 478px; height: 58px; margin: 10px 0px 0px 13px; padding: 10px 30px 20px 30px;">
				<table align="center" style="height: 30px; padding-top: 5px;">
					<tr align="center">
						<td class="rightAligned" style="padding-right: 10px;">Cut-Off Date</td>
						<td>
							<select class="required" id="dDnMonth" name="dDnMonth" style="text-align: left; width: 200px; height: 21px;">
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
						<input class="required" type="text" id="txtYear" style="float: left; text-align: right; width: 100px;" class="integerNoNegativeUnformattedNoComma" maxlength="4" readonly="readonly" tabindex="219"/>
							<div style="float: left; width: 15px;">
								<img id="imgYrSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;"/>
								<img id="imgYrSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;"/>
								<img id="imgYrSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;"/>
								<img id="imgYrSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;"/>
							</div>	
						</td>
					</tr>
				</table>
				<table>
					<tr>
						<td class="rightAligned" style="padding-right: 10px; padding-left: 63px;">Branch</td>
						<td>
							<div style="height: 20px;">
								<div id="branchCdDiv" style="border: 1px solid gray; width: 90px; height: 20px; margin:0 5px 0 0;">
									<input id="txtBranchCd" name="txtBranchCd" type="text" maxlength="2" class="upper" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="" tabindex="207"/>
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchCdLOV" name="searchBranchCdLOV" alt="Go" style="float: right;"/>
								</div>
							</div>						
						</td>	
						<td>
							<!-- <div id="branchNameDiv" style="border: 1px solid gray; width: 225px; height: 20px; margin:0 5px 0 0;"> -->
								<input id="txtBranchName" name="txtBranchName" type="text" maxlength="30" class="upper" style="float: left; width: 218px; height: 14px; margin: 0px;" value="" tabindex="208"/>
								<%-- <img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchNameLOV" name="searchBranchNameLOV" alt="Go" style="float: right;"/> --%>
							<!-- </div> -->
						</td>
					</tr>
				</table>
			</div>
			
			<div class="sectionDiv" style="width: 35%; height: 115px; margin: 2px 2px 10px 13px; padding: 15px 0 15px 0;">				
				<table align="center" cellspacing="10">
					<tr>
						<td>
							<div>
								<input id="chkConsolidateAllBranches" type="checkbox" style="float: left;" value="" checked="checked" tabindex="202"/>
								<label style="margin-left: 7px;">Consolidate All Branches</label>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div>
								<input id="chkSummaryOfAccounts" type="checkbox" style="float: left;" value="" checked="checked" tabindex="202"/>
								<label style="margin-left: 7px;">Summary Accounts</label>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div>
								<input id="chkDetail" type="checkbox" style="float: left;" value="" tabindex="202"/>
								<label style="margin-left: 7px;">Detail</label>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div>
								<input id="chkWithAdjustingEntries" type="checkbox" style="float: left;" value="" tabindex="202"/>
								<label style="margin-left: 7px">With Adjusting Entries</label>
							</div>
						</td>
					</tr>
				</table>
			</div>
			
			<div id="printDialogFormDiv" class="sectionDiv" style="width: 53.2%; height: 115px; margin: 2px 0 0 1px; padding: 15px 22px 15px 15px;" align="center">
				<table align="center" style="padding: 1px 0px 0px 0px; margin-top: 2px;">
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
							<input value="CSV" title="CSV" type="radio" id="rdoCsv" name="rdoFileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="217"><label for="csvRB" style="margin: 2px 0 4px 0">CSV</label>
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
	setModuleId("GIACS502");
	setDocumentTitle("Trial Balance As Of");
	togglePrintFields("screen");
	$("txtYear").value = dateFormat(new Date(), 'yyyy');
	$("dDnMonth").value = dateFormat(new Date(), 'm');
	var reportId = null;
	var reportName = "Trial Balance";
	$("txtBranchName").value = "ALL BRANCHES";
	var branch = "";
 	consolidateAll();
 	summaryOfAccounts();
 	
 	
 	function consolidateAll(){
 		if ($("chkConsolidateAllBranches").checked == true){
 			$("txtBranchName").readOnly = true;
 			$("txtBranchCd").readOnly = true;
 			disableSearch("searchBranchCdLOV");
 			//disableSearch("searchBranchNameLOV");
 		}else{
 			$("txtBranchName").readOnly = false;
 			$("txtBranchCd").readOnly = false;
 			enableSearch("searchBranchCdLOV");
 			//enableSearch("searchBranchNameLOV");
 		}
 		$("txtBranchName").value = "ALL BRANCHES";
 		$("txtBranchCd").value = "";
 	}


 	function summaryOfAccounts(){ 
 		if($("chkSummaryOfAccounts").checked == true) {
 			$("chkWithAdjustingEntries").disabled = true;
		}else{
			if ($("chkDetail").checked == false){
				$("chkWithAdjustingEntries").disabled = true;
			}else{
				$("chkWithAdjustingEntries").disabled = false;
			}
		}
 	}
 	
	$("chkConsolidateAllBranches").observe("click", function() {
 		consolidateAll();
	});
 	$("chkSummaryOfAccounts").observe("click", function() {
 	 	summaryOfAccounts();
	});
 	$("chkDetail").observe("click", function() {
 	 	summaryOfAccounts();
	});
	
	//for year
	$("imgYrSpinUp").observe("click", function() {
		var no = parseInt(nvl($F("txtYear"), 0));
		$("txtYear").value = no + 1;
		if ($("txtYear").value > 9999){ 
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
			$("rdoCsv").disabled = true;
		} else {
			if (destination == "file") {
				$("rdoPdf").enable();
				$("rdoExcel").enable();
				$("rdoCsv").disabled = false;
			} else {
				$("rdoPdf").disable();
				$("rdoExcel").disable();
				$("rdoCsv").disabled = true;
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
	
	$("trialBalanceAsOfExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});
	
	function getReport(){
		if ($("chkDetail").checked == false){
			if ($("chkConsolidateAllBranches").checked == true){
				if($("chkSummaryOfAccounts").checked == true) {
					reportId = "GIACR502B";
				}else{
					reportId = "GIACR502A";
				}
			}else{
				if($("chkSummaryOfAccounts").checked == true) {
					reportId = "GIACR502C";
				}else{
					reportId = "GIACR502";
					reportName = "Trial Balance Report";
				}
			}
			extractAccounts("extractMotherAccounts");
		}else{
			if ($("chkConsolidateAllBranches").checked == true){
				if($("chkSummaryOfAccounts").checked == true) {
					reportId = "GIACR502F";
				}else{
					if($("chkWithAdjustingEntries").checked == true) {
						reportId = "GIACR502AE";
						reportName = "Trial Balance Report with adjusting entries";
					}else{
						reportId = "GIACR502D";
					}
				}
			}else{
				if($("chkSummaryOfAccounts").checked == true) {
					reportId = "GIACR502G";
				}else{
					if($("chkWithAdjustingEntries").checked == true) {
						reportId = "GIACR502AE";
						reportName = "Trial Balance Report with adjusting entries";
					}else{
						reportId = "GIACR502E";
					}
				}
			}
			extractAccounts("extractMotherAccountsDetail");
		}
	}
 
	function extractAccounts(action){
		try {
			new Ajax.Request(contextPath + "/GIACGeneralLedgerReportsController", {
				parameters : {
					action : action,
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
		}
	});
	
	//for printing
	function printReport() {
		if(reportId == "GIACR502AE"){
			if ($("chkConsolidateAllBranches").checked == true){
				branch = "N";
			}else{
				branch = "Y";
			}
		}
		try {
			var content = contextPath + "/GeneralLedgerPrintController?action=printReport" + "&reportId=" + reportId + 
			"&month=" + $F("dDnMonth") +
		    "&year=" + $F("txtYear") +
		    "&branchCd=" + $F("txtBranchCd") +
		    "&branch=" + branch;
			if ("screen" == $F("selDestination")) {
				showPdfReport(content, reportName);
			} else if ($F("selDestination") == "printer") {
				new Ajax.Request(content, {
					parameters : {
						noOfCopies : $F("txtNoOfCopies"),
						printerName : $F("printerName"),
						destination : $F("selDestination")
					},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {

						}
					}
				});
			} else if("file" == $F("selDestination")){
				var fileType = "PDF";
				
				if($("rdoPdf").checked)
					fileType = "PDF";
				else if ($("rdoExcel").checked)
					fileType = "XLS";
				else if ($("rdoCsv").checked)
					fileType = "CSV";
				
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "FILE",
				         	      fileType    : fileType},
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							if ($("rdoCsv").checked){
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
							if (checkAllRequiredFieldsInDiv("printDialogFormDiv")) {
								printReport();
							}
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
	
	function showBranchLov(branchCd) {
		try {
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGiacs502BranchLov",
					search : branchCd
				},
				width : 405,
				height : 386,
				autoSelectOneRecord : true,
				title : "List of Branches",
				filterText : branchCd,
				columnModel : [ {
					id : "branchCd",
					title : "Branch Code",
					width : '80px'
				}, {
					id : "branchName",
					title : "Branch Name",
					width : '310px'
				} ],
				draggable : true,
				onSelect : function(row) {
					$("txtBranchCd").value = row.branchCd;
					$("txtBranchName").value = row.branchName;
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		} catch (e) {
			showErrorMessage("showBranchLov", e);
		}
	}
	
	//LOV validation
	function checkLov(action, cd, desc, message, func, search, primary) {
		var output = validateTextFieldLOV("/AccountingLOVController?action=" + action + "&search=" + $(cd).value, $(cd).value, "Searching, please wait...");
		if (output == 2) {
			func($(search).value);
		} else if (output == 0) {
			$(primary).clear();
			$(desc).value = message;
			customShowMessageBox("There is no record found.", "I", cd);
		} else {
			func($(search).value);
		}
	}
	
	$("txtBranchName").observe("change", function() {
		checkLov("getGiacs502BranchLov", "txtBranchName", "txtBranchName", "ALL BRANCHES", showBranchLov, "txtBranchName", "txtBranchCd");
	});

	$("txtBranchCd").observe("change", function() {
		if ($("txtBranchCd").value == "") {
			$("txtBranchName").value = "ALL BRANCHES";
		}else{
			checkLov("getGiacs502BranchLov", "txtBranchCd", "txtBranchName", "ALL BRANCHES", showBranchLov, "txtBranchCd", "txtBranchCd");
		}
	}); 
	
	$("searchBranchCdLOV").observe("click", function() {
		showBranchLov($("txtBranchCd").value);
	});

	/* $("searchBranchNameLOV").observe("click", function() {
		showBranchLov($("txtBranchCd").value);
	}); */
	
	observeReloadForm("reloadForm", showTrialBalanceAsOf);
	
</script>