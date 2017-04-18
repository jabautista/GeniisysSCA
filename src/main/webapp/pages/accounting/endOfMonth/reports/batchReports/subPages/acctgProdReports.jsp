<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="mainNavProdReports">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Production Report for Direct Business</label>
		</div>
	</div>
	<div style="height: 600px;">
		<div id="prodReportsInput" class="sectionDiv" style="width: 920px; height: 530px;">
			<div class="sectionDiv" style="width: 650px; height: 430px; margin: 40px 20px 20px 140px;">
				<div id="fromToDiv" class="sectionDiv" style="width: 630px; height: 220px; margin: 10px 0px 5px 10px;" align="center">
					<table align="center " style="height: 30px; padding-top: 10px;">
						<tr>
						<td class="rightAligned" style="padding-right: 10px; padding-left: 0px;">From</td>
						<td>
							<div id="fromDateDiv" style="float: left; border: 1px solid gray; width: 150px; height: 20px;">
								<input id="txtFromDate" name="txtFromDate" readonly="readonly" type="text" class="required leftAligned" maxlength="10" style="border: none; float: left; width: 125px; height: 13px; margin: 0px;" value="" tabindex="215"/>
								<img id="imgFromDate" alt="imgFromDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtFromDate'),this, null);" />
							</div>
						</td> 
						<td class="rightAligned" style="padding-left: 42px; padding-right: 10px;">To</td>
						<td>
							<div id="toDateDiv" style="float: left; border: 1px solid gray; width: 150px; height: 20px;">
								<input id="txtToDate" name="txtToDate" readonly="readonly" type="text" class="required leftAligned" maxlength="10" style="border: none; float: left; width: 125px; height: 13px; margin: 0px;" value="" tabindex="216"/>
								<img id="imgToDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtToDate'),this, null);" />
							</div>
						</td>
					</tr>
					</table>
					
					<div id="tabComponentsDiv1" class="tabComponents1" style="margin-top: 5px;">
						<ul>
							<li class="tab1 selectedTab1"><a id="positiveInclusionTab">Positive Inclusion</a></li>
							<li class="tab1"><a id="negativeInclusionTab">Negative Inclusion</a></li>
						</ul>
					</div>
					
					<div class="tabBorderBottom1"></div>
					 <div id="positiveInclusionMenu" name="subMenuDiv" class="subMenuDivs" style="width: 600px; height: 120px; margin: 50px 0px 0px 3px;">				
						<table style="margin-top: 10px; margin-left: 0px;">
							<tr height="20px">
								<td>Per Line & Subline</td>
								<td style="padding-left: 80px;">Per Source of Business</td>
							</tr>
							<tr height="20px">
								<td align="left">
									<input type="radio" id="rdoLineSummary" name="rdoProduction" value="GIACR127" style="float: left;"/>
									<label for="rdoLineSummary" style="padding-left: 5px;">Summary</label>
								</td>
								<td align="left" style="padding-left: 80px;">
									<input type="radio" id="rdoBusinessSummary" name="rdoProduction" value="GIACR130" style="float: left;"/>
									<label for="rdoBusinessSummary" style="padding-left: 5px;">Summary</label>
								</td>
							</tr>
							<tr height="20px">
								<td align="left">
									<input type="radio" id="rdoLineSummaryPerBranch" name="rdoProduction" value="GIACR128" style="float: left;"/>
									<label for="rdoLineSummaryPerBranch" style="padding-left: 5px;">Summary Per Branch</label>
								</td>
								<td align="left" style="padding-left: 80px;">
									<input type="radio" id="rdoBusinessSummaryPerBranch" name="rdoProduction" value="GIACR131" style="float: left;"/>
									<label for="rdoBusinessSummaryPerBranch" style="padding-left: 5px;">Summary Per Branch</label>
								</td>
							</tr>
							<tr height="20px">
								<td align="left">
									<input type="radio" id="rdoLineDetailed" name="rdoProduction" value="GIACR129" style="float: left;"/>
									<label for="rdoLineDetailed" style="padding-left: 5px;">Detailed</label>
								</td>
								<td align="left" style="padding-left: 80px;">
									<input type="radio" id="rdoBusinessDetailed" name="rdoProduction" value="GIACR132" style="float: left;"/>
									<label for="rdoBusinessDetailed" style="padding-left: 5px;">Detailed</label>
								</td>
							</tr>
							<tr height="20px">
								<td align="left">
									<input type="radio" id="rdoLineOverridingComm" name="rdoProduction" value="GIACR209" style="float: left;"/>
									<label for="rdoLineOverridingComm" style="padding-left: 5px;">Overriding commission</label>
								</td>
								<td align="left" style="padding-left: 80px;">
									<input type="radio" id="rdoBusinessProductionReport" name="rdoProduction" value="GIACR134" style="float: left;"/>
									<label for="rdoBusinessProductionReport" style="padding-left: 5px;">Production Report</label>
								</td>
							</tr>
						</table>
					</div> 
					<div id="negativeInclusionMenu" name="subMenuDiv" class="subMenuDivs" style="width: 600px; height: 120px; margin: 50px 0px 0px 3px;">				
						<table style="margin-top: 10px; margin-left: 0px;">
							<tr height="20px">
								<td>Per Line & Subline</td>
								<td style="padding-left: 20px;">Per Source of Business</td>
							</tr>
							<tr height="20px">
								<td align="left">
									<input type="radio" id="rdoSpoiledLineSummary" name="rdoSpoiled" value="2" style="float: left;"/>
									<label for="rdoSpoiledLineSummary" style="padding-left: 2px;">Negative - Summary</label>
								</td>
								<td align="left" style="padding-left: 20px;">
									<input type="radio" id="rdoSpoiledBusinessSummary" name="rdoSpoiled" value="5" style="float: left;"/>
									<label for="rdoSpoiledBusinessSummary" style="padding-left: 2px;">Negative - Summary per Source of Business</label>
								</td>
							</tr>
							<tr height="20px">
								<td align="left">
									<input type="radio" id="rdoSpoiledLineSummaryPerBranch" name="rdoSpoiled" value="3" style="float: left;"/>
									<label for="rdoSpoiledLineSummaryPerBranch" style="padding-left: 2px;">Negative - Summary per Branch</label>
								</td>
								<td align="left" style="padding-left: 20px;">
									<input type="radio" id="rdoSpoiledBusinessSummaryPerBranch" name="rdoSpoiled" value="6" style="float: left;"/>
									<label for="rdoSpoiledBusinessSummaryPerBranch" style="padding-left: 2px;">Negative - Summary per Branch/ Source of Business</label>
								</td>
							</tr>
							<tr height="20px">
								<td align="left">
									<input type="radio" id="rdoSpoiledLineDetailed" name="rdoSpoiled" value="4" style="float: left;"/>
									<label for="rdoSpoiledLineDetailed" style="padding-left: 2px;">Negative - Detailed</label>
								</td>
								<td align="left" style="padding-left: 20px;">
									<input type="radio" id="rdoSpoiledBusinessDetailed" name="rdoSpoiled" value="7" style="float: left;"/>
									<label for="rdoSpoiledBusinessDetailed" style="padding-left: 2px;">Negative - Detailed per Source of Business</label>
								</td>
							</tr>
							<tr height="20px">
								<td align="left">
									<input type="radio" id="rdoSpoiledLineOverridingComm" name="rdoSpoiled" value="8" style="float: left;"/>
									<label for="rdoSpoiledLineOverridingComm" style="padding-left: 2px;">Overriding commission</label>
								</td>
							</tr>
						</table>
					</div> 
				</div>
				<div id="printDialogFormDiv" class="sectionDiv" style="width: 630px; height: 138px; margin: 0px 0px 3px 10px;" align="center">
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
								<input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="rdoFileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="217"><label for="excelRB" style="margin: 2px 0 4px 0">Excel</label>
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
					<input id="btnExtract" type="button" class="button" value="Extract" style="width: 100px;" tabindex="221"/>
					<input id="btnPrint" type="button" class="button" value="Print" style="width: 100px;" tabindex="221"/>
				</div>
				</div>
				<input type="hidden" id="hidFromDate" value=""/>
				<input type="hidden" id="hidToDate" value=""/>
			</div>	
		</div>
	</div>		
</div>

<script type="text/javascript">
	initializeProductionReports();
	$("acExit").stopObserving("click");
	$("acExit").observe("click", showBatchReports);
	firstDayOfMonth = dateFormat(new Date(), 'mm-01-yyyy');
	currentDay = dateFormat(new Date(), 'mm-dd-yyyy');
	$("txtFromDate").value = firstDayOfMonth;
	positive = 0;
	negative = 0;
	reportId = null;

	function rdoAttribute(name, bool) {
		$$("input[name='" + name + "']").each(function(btn) {
			btn.disabled = bool;
		});
	}

	function uncheckAll() {
		$$("input[name='rdoProduction']").each(function(btn) {
			btn.checked = false;
		});
		$$("input[name='rdoSpoiled']").each(function(btn) {
			btn.checked = false;
		});
		reportId = null;
	}

	function initializeProductionReports() {
		setModuleId("GIACS124");
		setDocumentTitle("Production Report for Direct Business");
		initializeAll();
		initializeTabs();
		initializeAccordion();
		observeBackSpaceOnDate("txtToDate");
		observeBackSpaceOnDate("txtFromDate");
		togglePrintFields("screen");
		$("positiveInclusionMenu").show();
		$("negativeInclusionMenu").hide();
		rdoAttribute("rdoProduction", true);
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
			$("rdoExcel").disable();
		} else {
			if (destination == "file") {
				$("rdoPdf").enable();
				$("rdoExcel").enable();
			} else {
				$("rdoPdf").disable();
				$("rdoExcel").disable();
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

	function validateFromAndTo(field) {
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g, "/")) : "";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g, "/")) : "";

		if (fromDate > toDate && toDate != "") {
			customShowMessageBox("From date must not be later than to date.", "I", field);
			$(field).clear();
			return false;
		}
	}

	function deleteGiacProdExt() {
		try {
			if (checkAllRequiredFieldsInDiv("fromToDiv")) {
				if (checkAllRequiredFieldsInDiv("printDialogFormDiv")) {
					new Ajax.Request(contextPath + "/GIACEndOfMonthReportsController",{
						parameters : {
							action : "deleteGiacProdExt"
						},
						asynchronous : false,
						evalScripts : true,
						onComplete : function(response) {
							if (checkErrorOnResponse(response)) {
								insertGiacProdExt();
							}
						}
					});	
				}
			}
		} catch (e) {
			showErrorMessage("deleteGiacProdExt", e);
		}
	}

	function customErrorOnResponse(response, func) {
		if (response.responseText.include("Geniisys Exception")) {
			var message = response.responseText.split("#");
			showWaitingMessageBox(message[2], message[1], function() {
				showWaitingMessageBox(message[4], message[3], function() {
					showMessageBox("END of extraction. Please pick a report to print.", "I");
				});
			});
			positive = message[5];
			negative = message[6];
			$("hidFromDate").value = $F("txtFromDate");
			$("hidToDate").value = $F("txtToDate");
			rdoAttribute("rdoProduction", false);
			uncheckAll();
			if (func != null)
				func();
			return false;
		} else {
			return true;
		}
	}

	function insertGiacProdExt() {
		try {
			new Ajax.Request( contextPath + "/GIACEndOfMonthReportsController", {
				parameters : {
					action : "insertGiacProdExt",
					fromDate : $("txtFromDate").value,
					toDate : $("txtToDate").value
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function() {
					showNotice("Extracting Production Report, please wait...");
				},
				onComplete : function(response) {
					hideNotice();
					if (checkErrorOnResponse(response) && customErrorOnResponse(response)) {

					}
				}
			});
		} catch (e) {
			showErrorMessage("insertGiacProdExt", e);
		}
	}

	function printReport() {
		try {
			var content = contextPath
					+ "/EndOfMonthPrintReportController?action=printReport&reportId="
					+ reportId + "&dateParam=" + $F("txtToDate")
					+ "&reportTitle=" + reportId + "&fromDate="
					+ $F("txtFromDate") + "&toDate=" + $F("txtToDate");
			if ("screen" == $F("selDestination")) {
				showPdfReport(content, reportId);
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

						}
					}
				});
			} else if ("file" == $F("selDestination")) {
				new Ajax.Request(content, {
					parameters : {
						destination : "file",
						fileType : $("rdoPdf").checked ? "PDF" : "XLS"
					},
					onCreate : showNotice("Generating report, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							copyFileToLocal(response);
						}
					}
				});
			} else if ("local" == $F("selDestination")) {
				new Ajax.Request(
						content,
						{
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

	$$("input[name='rdoProduction']").each(function(btn) {
		btn.observe("click", function() {
			reportId = btn.value;
		});
	});

	$$("input[name='rdoSpoiled']").each(function(btn) {
		btn.observe("click", function() {
			reportId = btn.value;
		});
	});

	$("positiveInclusionTab").observe("click", function() {
		$("positiveInclusionMenu").show();
		$("negativeInclusionMenu").hide();
		uncheckAll();
		rdoAttribute("rdoProduction", false);
	});

	$("negativeInclusionTab").observe("click", function() {
		$("negativeInclusionMenu").show();
		$("positiveInclusionMenu").hide();
		uncheckAll();
		if (negative != 0) {
			rdoAttribute("rdoSpoiled", false);
		} else {
			rdoAttribute("rdoSpoiled", true);
		}
	});

	$("selDestination").observe("change", function() {
		var destination = $F("selDestination");
		togglePrintFields(destination);
	});

	$("txtNoOfCopies").observe("change", function() {
		if ($F("txtNoOfCopies") == 0 || $F("txtNoOfCopies") > 100) {
			customShowMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", "txtNoOfCopies");
			$("txtNoOfCopies").value = "";
		}
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

	$("txtFromDate").observe("focus", function() {
		if ($("imgFromDate").disabled == true)
			return;
		if ($F("txtFromDate") == "") {
			$("txtFromDate").value = firstDayOfMonth;
		} else {
			validateFromAndTo("txtFromDate");
		}
	});

	$("txtToDate").observe("focus", function() {
		if ($("imgToDate").disabled == true)
			return;
		if ($F("txtToDate") == "") {
			$("txtToDate").value = currentDay;
		} else {
			validateFromAndTo("txtToDate");
		}
	});

	$("btnExtract").observe("click", function() {
		if ($F("txtFromDate") == $F("hidFromDate") && $F("txtToDate") == $F("hidToDate")) {
			showConfirmBox("Confirmation Message", "You have already extracted data using the same date parameters. Extract again?(Doing so will erase your previous extract data and replace it with a new one)", "Yes", "No", deleteGiacProdExt, null, null);
		} else {
			deleteGiacProdExt();
		}
	});

	$("btnPrint").observe("click", function() {
		if ($F("txtFromDate") != $F("hidFromDate") || $F("txtToDate") != $F("hidToDate")) {
			showConfirmBox("Confirmation Message", "The specified period has not been extracted. Do you want to extract the data using the specified period?", "Yes", "No", deleteGiacProdExt, null, null);
		} else {
			if (reportId == null || reportId == "") {
				showMessageBox("Please select a report to print.", "I");
			} else {
				if (positive != 0 || negative != 0) {
					printReport();
					uncheckAll();
				} else {
					showMessageBox("No data fetched in the specified period.", "I");
				}
			}
		}

	});
</script>