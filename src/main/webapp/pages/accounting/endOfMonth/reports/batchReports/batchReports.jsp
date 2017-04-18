<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="mainNavBatchReports">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Production Report</label>
		</div>
	</div>
	<div style="height: 700px;">
		<div id="batchReportsInput" class="sectionDiv" style="width: 920px; height: 600px;">
			<div class="sectionDiv" style="width: 500px; height: 495px; margin: 40px 20px 20px 210px;">
				<div id="monthYear" class="sectionDiv" style="width: 480px; height: 50px; margin: 10px 0px 5px 10px;" align="center">
					<table align="center " style="height: 30px; padding-top: 10px;">
						<tr>
							<td class="rightAligned" style="padding: 0px 10px 0px 0px;">Month & Year</td>
							<td>
								<select id="dDnMonth" name="dDnMonth" style="text-align: left; width: 150px;">
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
							<input type="text" id="txtYear" style="float: left; text-align: right; width: 50px;" class="integerNoNegativeUnformattedNoComma" maxlength="4" readonly="readonly"/>
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
				
				<div class="sectionDiv" style="width: 480px; height: 230px; margin: 0px 0px 0px 10px;">				
					<table style="margin-top: 10px; margin-left: 20px;">
						<tr height="20px">
							<td style="width: 250px;"></td>
							<td align="center" style="width: 80px;">Summary</td>
							<td align="center" style="width: 80px;">Detailed</td>
						</tr>
						<tr height="20px">
							<td align="left">
								<table>
									<tr>
										<td>
											<input type="radio" id="rdoProdAcctg" name="rdoPrintOption" value="1"/>
										</td>
										<td style="padding-left: 3px;">
											<label for="rdoProdAcctg">Production Accounting</label>
										</td>
										<td>
											<input id="btnProdAcctg" type="button" class="button" value=">>" style="width: 30px;"/>
										</td>
									</tr>
								</table>
							</td>
							<td></td>
							<td></td>
						</tr>
						<tr height="20px">
							<td align="left" style="padding-left: 4px;">
								<input type="radio" id="rdoTrtyDst" name="rdoPrintOption" value="2" style="float: left;"/>
								<label for="rdoTrtyDst" style="padding-left: 5px;">Treaty Distribution</label>
							</td>
							<td>
								<input type="radio" id="rdoTrtyDstSum" name="rdoTrtyDstOption" value="1" checked="checked"/>
							</td>
							<td>
								<input type="radio" id="rdoTrtyDstDtl" name="rdoTrtyDstOption" value="2"/>
							</td>
						</tr>
						<tr height="20px">
							<td align="left" style="padding-left: 4px;">
								<input type="radio" id="rdoOutFacul" name="rdoPrintOption" value="3" checked="checked" style="float: left;"/>
								<label for="rdoOutFacul" style="padding-left: 5px;">Outward Facultative Placements</label>
							</td>
							<td>
								<input type="radio" id="rdoOutFaculSum" name="rdoOutFaculOption" value="1" checked="checked"/>
							</td>
							<td>
								<input type="radio" id="rdoOutFaculDtl" name="rdoOutFaculOption" value="2"/>
							</td>
						</tr>
						<tr height="20px">
							<td align="left" style="padding-left: 4px;">
								<input type="radio" id="rdoInwFacul" name="rdoPrintOption" value="4" style="float: left;"/>
								<label for="rdoInwFacul" style="padding-left: 5px;">Inward Facultative Business</label>
							</td>
							<td>
								<input type="radio" id="rdoInwFaculSum" name="rdoInwFaculOption" value="1" checked="checked"/>
							</td>
							<td>
								<input type="radio" id="rdoInwFaculDtl" name="rdoInwFaculOption" value="2"/>
							</td>
						</tr>
						<tr height="20px">
							<td align="left" style="padding-left: 4px;">
								<input type="radio" id="rdoBatchAcctg" name="rdoPrintOption" value="5" style="float: left;"/>
								<label for="rdoBatchAcctg" style="padding-left: 5px;">Batch Accounting Entries</label>
							</td>
							<td></td>
							<td></td>
						</tr>
						<tr height="20px">
							<td align="left" style="padding-left: 25px;">
								<input type="checkbox" id="chkPerBranch" name="chkPerBranch" value="perBranch" style="float: left;"/>
								<label for="chkPerBranch" style="padding-left: 5px;">Per Branch</label>
							</td>
							<td></td>
							<td></td>
						</tr>
						<tr height="40px">
							<td align="left" style="padding-left: 50px;">
								<input id="btnBranch" type="button" class="button" value="Branch" style="width: 120px; vertical-align: bottom;"/>
							</td>
							<td></td>
							<td></td>
						</tr>
					</table>
				</div>
				
				<div id="printDialogFormDiv" class="sectionDiv" style="width: 480px; height: 138px; margin: 5px 0px 3px 10px;" align="center">
					<table style="margin-top: 15px;">
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
								<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="rdoFileType" style="margin: 2px 5px 4px 40px; float: left;" checked="checked" disabled="disabled" tabindex="216"><label for="pdfRB" style="margin: 2px 0 4px 0">PDF</label>
								<!--<input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="rdoFileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="217"><label for="excelRB" style="margin: 2px 0 4px 0">Excel</label>  comment out carlo de guzman 3.07.2016    --> 
								<input value="CSV" title="Csv" type="radio" id="rdoCsv" name="rdoFileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="217"><label for="csvRB" style="margin: 2px 0 4px 0">CSV</label> <!-- added by carlo de guzman 3.07.2016 -->
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
								<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="integerNoNegativeUnformattedNoComma" maxlength="3" tabindex="219"/>
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
	</div>		
</div>

<script type="text/javascript">
	initializeAll();
	initializeAccordion();
	initializeProductionRegister();
	var production =  $F("rdoOutFacul");
	var reportId = null;
	batchMonth = null;
	batchYear = null;
	objGiarpr001 = new Object();
	objGiarpr001.selectedBranches = new Array();
	var reports = [];
	
	function initializeProductionRegister(){
		setModuleId("GIARPR001");
		setDocumentTitle("Production Register Report");
		togglePrintFields("screen");
		$("txtYear").value = dateFormat(new Date(), 'yyyy');
		$("chkPerBranch").disabled = true;
		disableButton("btnBranch");
		disableAllRaidoButton(true);
		$("rdoOutFaculSum").disabled = false;
		$("rdoOutFaculDtl").disabled = false;
	}
	
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
			//$("rdoExcel").disable();  comment out carlo de guzman 3.07.2016
			$("rdoCsv").disable(); //added by carlo de guzman 3.07.2016
		} else {
			if (destination == "file") {
				$("rdoPdf").enable();
				//$("rdoExcel").enable();  comment out carlo de guzman 3.07.2016
				$("rdoCsv").enable(); //added by carlo de guzman 3.07.2016
			} else {
				$("rdoPdf").disable();
				//$("rdoExcel").disable();  comment out carlo de guzman 3.07.2016
				$("rdoCsv").disable(); //added by carlo de guzman 3.07.2016
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
	
	function disableAllRaidoButton(key){
		$("rdoTrtyDstSum").disabled = key;
		$("rdoTrtyDstDtl").disabled = key;
		$("rdoOutFaculSum").disabled = key;
		$("rdoOutFaculDtl").disabled = key;
		$("rdoInwFaculSum").disabled = key;
		$("rdoInwFaculDtl").disabled = key;
	}
	
	function checkUserAccess() {
		try {
			new Ajax.Request(contextPath + "/GIACAccTransController?action=checkUserAccess2", {
				method : "POST",
				parameters : {
					moduleName : "GIACS124"
				},
				asynchronous : false,
				evalScripts : true,
				onComplete : function(response) {
					if (response.responseText == 0) {
						showMessageBox("You are not allowed to access this module.", "I");
					}else{
						showAcctgProdReports();
					}
				}
			});
		} catch (e) {
			showErrorMessage('checkUserAccess', e);
		}
	}

	$("imgYrSpinUp").observe("click", function() {
		var no = parseInt(nvl($F("txtYear"), 0));
		$("txtYear").value = no + 1;
	});

	$("imgYrSpinDown").observe("click", function() {
		var no = parseInt(nvl($F("txtYear"), 0));
		if (no > 1) {
			$("txtYear").value = no - 1;
		}
	});

	$("imgYrSpinUp").observe("mouseover", function() {
		$("imgYrSpinUp").src = contextPath + "/images/misc/spinupfocus.gif";
	});

	$("imgYrSpinDown").observe(
			"mouseover",
			function() {
				$("imgYrSpinDown").src = contextPath
						+ "/images/misc/spindownfocus.gif";
			});

	$("imgSpinUp").observe("click", function() {
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if (no < 100) {
			$("txtNoOfCopies").value = no + 1;
		}
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

	$("btnProdAcctg").observe("click", function() {
		$("rdoProdAcctg").checked = true;
		production = $F("rdoProdAcctg");
		//showMessageBox(objCommonMessage.UNAVAILABLE_MODULE, imgMessage.INFO);
		checkUserAccess();
	});

	$$("input[name='rdoPrintOption']").each(function(btn) {
		btn.observe("click", function() {
			production = $F(btn);
			$("chkPerBranch").disabled = true;
			$("chkPerBranch").checked = false;
			disableButton("btnBranch");
			disableAllRaidoButton(true);
			$("chkPerBranch").disabled = true;
			reports = [];
			objGiarpr001.selectedBranches = [];
			if (production == 1) {
				//showMessageBox(objCommonMessage.UNAVAILABLE_MODULE, imgMessage.INFO);
				//showAcctgProdReports();
				checkUserAccess();
			} else if (production == 2) {
				$("rdoTrtyDstSum").disabled = false;
				$("rdoTrtyDstDtl").disabled = false;
			} else if (production == 3) {
				$("rdoOutFaculSum").disabled = false;
				$("rdoOutFaculDtl").disabled = false;
			} else if (production == 4) {
				$("rdoInwFaculSum").disabled = false;
				$("rdoInwFaculDtl").disabled = false;
			} else if (production == 5) {
				$("chkPerBranch").disabled = false;
			}
		});
	});

	$("chkPerBranch").observe("click", function() {
		if ($("chkPerBranch").checked == true) {
			enableButton("btnBranch");
		} else {
			disableButton("btnBranch");
		}
	});

	$("selDestination").observe("change", function() {
		var destination = $F("selDestination");
		togglePrintFields(destination);
	});

	$("txtNoOfCopies")
			.observe(
					"change",
					function() {
						if ($F("txtNoOfCopies") == 0
								|| $F("txtNoOfCopies") > 100) {
							customShowMessageBox(
									"Invalid No. of Copies. Valid value should be from 1 to 100.",
									"I", "txtNoOfCopies");
							$("txtNoOfCopies").value = "";
						}
					});

	$("btnBranch").observe(
			"click",
			function() {
				if ($("chkPerBranch").checked) {
					batchMonth = $("dDnMonth").value;
					batchYear = $("txtYear").value;
					objGiarpr001.selectedBranches = [];
					reports = [];
					try {
						overlayBranchList = Overlay.show(contextPath
								+ "/GIACEndOfMonthReportsController", {
							urlContent : true,
							urlParameters : {
								action : "getBatchBranchList",
								batchYear : $("txtYear").value,
								batchMonth : $("dDnMonth").value
							},
							title : "List of Branches",
							height : '310px',
							width : '385',
							draggable : true
						});
					} catch (e) {
						showErrorMessage("Error in showBranchListOverlay ", e);
					}
				}
			});

	$("btnPrint").observe("click", function() {
		if (checkAllRequiredFieldsInDiv("printDialogFormDiv")) {
			getReportId();
			reports = [];
			objGiarpr001.selectedBranches = [];
		}
	});

	function getReportId() {
		if (production == 2) {
			if ($("rdoTrtyDstSum").checked == true) {
				reportId = "GIACR226";
				content = contextPath
						+ "/GIACBatchReportsPrintController?action=printReport"
						+ "&reportId=" + reportId + "&issCd=" + "" + "&date="
						+ $F("dDnMonth") + "-1-" + $F("txtYear");
			} else {
				reportId = "GIACR227";
				content = contextPath
						+ "/GIACBatchReportsPrintController?action=printReport"
						+ "&reportId=" + reportId + "&issCd=" + "" + "&month="
						+ $F("dDnMonth") + "&year=" + $F("txtYear");
			}
		} else if (production == 3) {
			if ($("rdoOutFaculSum").checked == true) {
				reportId = "GIACB003S";
				content = contextPath
						+ "/GIACBatchReportsPrintController?action=printReport"
						+ "&reportId=" + reportId + "&date=" + $F("dDnMonth")
						+ "-1-" + $F("txtYear");
			} else {
				reportId = "GIACB003D";
				content = contextPath
						+ "/GIACBatchReportsPrintController?action=printReport"
						+ "&reportId=" + reportId + "&date=" + $F("dDnMonth")
						+ "-1-" + $F("txtYear");
			}
		} else if (production == 4) {
			if ($("rdoInwFaculSum").checked == true) {
				reportId = "GIACB004S";
				content = contextPath
						+ "/GIACBatchReportsPrintController?action=printReport"
						+ "&reportId=" + reportId + "&date=" + $F("dDnMonth")
						+ "-1-" + $F("txtYear");
			} else {
				reportId = "GIACB004D";
				content = contextPath
						+ "/GIACBatchReportsPrintController?action=printReport"
						+ "&reportId=" + reportId + "&date=" + $F("dDnMonth")
						+ "-1-" + $F("txtYear");
			}
		} else if (production == 5) {
			reportId = "GIACR225";
			content = "";
			if ($("chkPerBranch").checked == true) {
				if (objGiarpr001.selectedBranches.length == 0) {
					showMessageBox("Please select branch(es) to print.", "I");
				} else {
					for ( var i = 0; i < objGiarpr001.selectedBranches.length; i++) {
						content = contextPath
								+ "/GIACBatchReportsPrintController?action=printReport"
								+ "&reportId=" + reportId + "&date="
								+ $F("dDnMonth") + "-1-" + $F("txtYear")
								+ "&branchCd="
								+ objGiarpr001.selectedBranches[i].branchCd;

						reports.push({
							reportUrl : content,
							reportTitle : reportId
						});
					}
				}
			} else {
				branchCd = "";
				content = contextPath
						+ "/GIACBatchReportsPrintController?action=printReport"
						+ "&reportId=" + reportId + "&date=" + $F("dDnMonth")
						+ "-1-" + $F("txtYear") + "&branchCd=" + branchCd;
				repTitle = "Batch Accounting Entries";
			}
		}
		if (production == 5 && $("chkPerBranch").checked == true
				&& $F("selDestination") != "screen") {
			for ( var i = 0; i < reports.length; i++) {
				printReport(reports[i].reportUrl, reports[i].reportTitle);
			}
		} else {
			printReport(content, reportId);
		}
	}

	function printReport(content, repTitle) {
		try {
			if ("screen" == $F("selDestination")) {
				if (production == 5 && $("chkPerBranch").checked == true) {
					showMultiPdfReport(reports);
				} else {
					showPdfReport(content, repTitle);
				}

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
							showMessageBox("Printing complete.", "I");
						}
					}
				});
			} else if ("file" == $F("selDestination")) {
				var fileType = "PDF";				//added by carlo de guzman 3.07.2016	
					if($("rdoPdf").checked)
						fileType = "PDF";
					else if ($("rdoCsv").checked)
						fileType = "CSV"; 			//added by carlo de guzman 3.07.2016	
				
				new Ajax.Request(content, {
					parameters : {
						destination : "file",
						fileType : fileType},
					onCreate : showNotice("Generating report, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							if (fileType == "CSV"){                                   //added by carlo de guzman 3.07.2016
									copyFileToLocal(response, "csv");
									deleteCSVFileFromServer(response.responseText);   
									} else                                            //added by carlo de guzman 3.07.2016
							copyFileToLocal(response, "reports");
						}
					}
				});
			} else if ("local" == $F("selDestination")) {
				new Ajax.Request(
						content,
						{
							parameters : {
								destination : "local",
								reportTitle : repTitle
							},
							onComplete : function(response) {
								hideNotice();
								if (checkErrorOnResponse(response)) {
									var message = printToLocalPrinter(response.responseText);
									if (message != "SUCCESS") {
										showMessageBox(message,
												imgMessage.ERROR);
									}
								}
							}
						});
			}
		} catch (e) {
			showErrorMessage("printReport", e);
		}
	}

	$("acExit").stopObserving("click");
	$("acExit").observe(
			"click",
			function() {
				goToModule("/GIISUserController?action=goToAccounting",
						"Accounting Main", "");
			});
</script>