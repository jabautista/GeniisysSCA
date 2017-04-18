<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="soaFaculRiMainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothMenu1" name="smoothMenu1" class="ddsmoothmenu">
			<ul> 
				<li><a id="btnExit">Exit</a></li>
			</ul>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>RI Commission Income and Expense</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	<div id="soaFaculRiSectionDiv" class="sectionDiv" style="width: 920px; height: 500px;">
		<div class="sectionDiv" style="width: 617px; height:400px; margin: 40px 20px 20px 150px;">
			<div id="rdoDiv" class="sectionDiv" style="width: 535px; height: 30px; margin: 10px 0px 0px 10px; padding: 20px 30px 20px 30px;">
				<table align="center" style="height: 20px">
				<tr>
					<td> 
						<input id="rdoCommInc" name="rdoComm" type="radio" checked="checked"  value="CI" style="float: left;" tabindex="101"/>
					</td>
					<td>
						<label style="margin-left: 7px;" for="rdoCommInc" >Commission Income</label>
					</td>
					<td>
						<input id="rdoCommExp" name="rdoComm" type="radio" style="margin-left: 80px; float: left;" value="CE" tabindex="103"/>
					</td>
					<td>
						<label style="margin-left: 7px;" for="rdoCommExp">Commission Expense</label>
					</td>					
				</tr>
			</table>
			</div>
			
			<div id="fieldDiv" class="sectionDiv" style="width: 575px; height: 60px; margin: 2px 10px 0px 10px; padding: 20px 10px 25px 10px;"/>
				<table align="left" cellpadding="1">	
					<tr>
						<td class="rightAligned" style="width: 70px;">From</td>
						<td>
							<div id="fromDateDiv" style="float: left; border: 1px solid gray; width: 185px; height: 20px;">
								<input id="txtFromDate" name="From Date." readonly="readonly" type="text" class="date required" maxlength="10" style="border: none; float: left; width: 160px; height: 13px; margin: 0px;" value="" tabindex="101"/>
								<img id="imgFromDate" alt="imgFromDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtFromDate'),this, null);" />
							</div>
						</td> 
						<td align="right" style="width: 70px;">To</td>
						<td>
							<div id="toDateDiv" style="float: left; border: 1px solid gray; width: 185px; height: 20px;">
								<input id="txtToDate" name="To Date." readonly="readonly" type="text" class="date required" maxlength="10" style="border: none; float: left; width: 160px; height: 13px; margin: 0px;" value="" tabindex="102"/>
								<img id="imgToDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtToDate'),this, null);" />
							</div>
						</td>
					</tr>
				</table>
				<table align="left" cellpadding="0">
					<tr>
						<td class="rightAligned" style="width: 68px;">Line</td>
						<td class="leftAligned">
							<span class="lovSpan" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
								<input type="text" id="txtLineCd" name="txtLineCd" style="width: 43px; float: left; border: none; height: 13px;" class="disableDelKey allCaps" maxlength="2" tabindex="107" />
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLine" name="searchLine" alt="Go" style="float: right;">
							</span> 
							<span class="lovSpan" style="border: none; width: 379px; height: 21px; margin: 0 2px 0 2px; float: left;">
								<input type="text" id="txtLineName" name="txtLineName" style="width: 369px; float: left; height: 15px;" class="disableDelKey allCaps" maxlength="500" readonly="readonly" value="ALL LINES"/>
							</span>	
						</td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" style="width: 30%; height: 110px; margin: 2px 2px 10px 10px; padding: 8px 0 22px 0;">				
				<div align="center" style="padding-top: 20px;">
					<table>
						<tr>	
							<td style="padding-left: 10px; padding-bottom: 5px;">
								<input type="radio" id="rdoCreditBranch" name="source" checked="checked" value="C" tabindex="301"/>
							</td>
							<td>
								<label for="rdoCreditBranch">Crediting Branch</label>
							</td>
						</tr>
						<tr style="height: 1px;"><td>&nbsp;</td></tr>
						<tr>
							<td style="padding-left: 10px; padding-bottom: 8px;">
								<input type="radio" id="rdoIssueSource" name="source" value="I" tabindex="302"/>
							</td>
							<td>
								<label for="rdoIssueSource">Issue Source</label>
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div class="sectionDiv" style="width: 20%; height: 110px; margin: 2px 0px 0px 0px; padding: 8px 0 22px 0;">
				<div align="center" style="padding-top: 20px;">
					<table>
						<tr>	
							<td style="padding-left: 10px; padding-bottom: 5px;">
								<input type="radio" id="rdoSummary" name="type" value="S" tabindex="301"/>
							</td>
							<td>
								<label for="rdoSummary">Summary</label>
							</td>
						</tr>
						<tr style="height: 1px;"><td>&nbsp;</td></tr>
						<tr>
							<td style="padding-left: 10px; padding-bottom: 8px;">
								<input type="radio" id="rdoDetailed" name="type" value="D" checked="checked" tabindex="302"/>
							</td>
							<td>
								<label for="rdoDetailed">Detailed</label>
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div id="printDialogFormDiv" class="sectionDiv" style="width: 40.5%; height: 110px; margin: 2px 0 0 1px; padding: 15px 22px 15px 8px;" align="center">
				<table style="float: left; padding: 1px 0px 0px 15px;">
					<tr>
						<td class="rightAligned" style="width: 80px;">&nbsp;&nbsp;&nbsp;&nbsp;Destination</td>
						<td class="leftAligned">
							<select id="selDestination" style="width: 150px;" tabindex="401">
								<option value="screen">Screen</option>
								<option value="printer">Printer</option>
								<option value="file">File</option>
								<option value="local">Local Printer</option>
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="rdoFileType" style="margin: 2px 5px 4px 90px; float: left;" checked="checked" disabled="disabled" tabindex="402"><label for="rdoPdf" style="margin: 2px 0 4px 0">PDF</label>
							<!-- <input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="rdoFileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="403"><label for="rdoExcel" style="margin: 2px 0 4px 0">Excel</label> --> <!-- Removed by Kevin SR-18635 6-17-2016 -->
							<input value="CSV" title="CSV" type="radio" id="rdoCsv" name="rdoFileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="403"><label for="rdoCsv" style="margin: 2px 0 4px 0">CSV</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 80px;">Printer</td>
						<td class="leftAligned">
							<select id="printerName" style="width: 150px;" tabindex="404">
								<option></option>
								<c:forEach var="p" items="${printers}">
									<option value="${p.name}">${p.name}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 80px;">No. of Copies</td>
						<td class="leftAligned">
							<input type="text" id="txtNoOfCopies" maxlength="3" style="float: left; text-align: right; width: 126px;" class="integerNoNegativeUnformattedNoComma" tabindex="405"/>
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
			
			<div id="buttonsDiv" class="buttonsDiv" align="center">
				<input id="btnExtract" type="button" class="button" value="Extract" style="width: 100px;" tabindex="501"/>
				<input id="btnPrint" type="button" class="button" value="Print" style="width: 100px;" tabindex="502"/>
			</div>
		</div>	
	</div>
</div>
<script type="text/javascript">
	initializeAll();
	setModuleId("GIACS276");
	setDocumentTitle("RI Commission Income and Expense");
	$("txtLineCd").focus();
	observeBackSpaceOnDate("txtFromDate");
	observeBackSpaceOnDate("txtToDate");
	var repTitle = "";
	
	observeReloadForm("reloadForm", showRiCommIncAndExp);
	
	function togglePrintFields(destination) {
		if ($("selDestination").value == "printer") {
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
			/* $("rdoExcel").disable(); */
			$("rdoCsv").disable();
		} else {
			if ($("selDestination").value == "file") {
				$("rdoPdf").enable();
				/* $("rdoExcel").enable(); */
				$("rdoCsv").enable();
			} else {	
				$("rdoPdf").disable();
				/* $("rdoExcel").disable(); */
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
	
	function validateFromAndToDate(field) {
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g, "/")) : "";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g, "/")) : "";
		
		if (fromDate > toDate && toDate != "") {
			if (field == "txtFromDate") {
				customShowMessageBox("From Date should not be later than To Date.", "I", "txtFromDate");
			} else {
				customShowMessageBox("From Date should not be later than To Date.", "I", "txtToDate");
			}
			$(field).clear();
			return false;
		}
	}
	
	function showLineLOV(x, y){
		try{
			LOV.show({
				controller: "AccountingLOVController",
				urlParameters: {
					action: "getGIACS276LineLOV",
					moduleId: "GIACS276",
					searchString : y
				},
				title: "List of Lines",
				width: 375,
				height: 386,
				columnModel:[
								{	id: "lineCd",
									title: "Line Code",
									width: "120px",
								},
				             	{	id: "lineName",
									title: "Line Name",
									width: "240px"
								}
							],
				draggable: true,
				showNotice: true,
				filterText: x,
				autoSelectOneRecord: true,
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						$("txtLineCd").value = unescapeHTML2(row.lineCd);
						$("txtLineName").value = unescapeHTML2(row.lineName);
					}
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
					$("txtLineCd").value = "";
					$("txtLineName").value = "ALL LINES";
				}
			});
		}catch(e){
			showErrorMessage("searchLine", e);
		}
	}
	
	function validateLineCd(){
		new Ajax.Request(contextPath+"/GIISLineController", {
			method: "GET",
			parameters: {
				action: "validateGIACS102LineCd",
				lineCd: $F("txtLineCd"),
				lineName: $F("txtLineName") == "ALL LINES" ? "" : $F("txtLineName")
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(nvl(obj.lineCd, "") == ""){
						showLineLOV($("txtLineCd").value, $("txtLineCd").value);
						/* showWaitingMessageBox("No record selected.", "I", function(){
						$("txtLineCd").focus();
						$("txtLineCd").value = "";
						$("txtLineName").value = "ALL LINES"; 
						});*/
					}else if (obj.lineCd == "2"){
						showLineLOV($("txtLineCd").value,$("txtLineCd").value);
					}
					else{
						$("txtLineCd").value = obj.lineCd;
						$("txtLineName").value = obj.lineName;
					}
				}
			}
		});
	}
	
	function getParameters(){
		var params = "";
		params = "&fromDate="+$("txtFromDate").value +"&toDate="+$("txtToDate").value+"&lineCd="+$("txtLineCd").value+"&moduleId=GIACS276";
		if ($("rdoCreditBranch").checked){
			params = params + "&issParam=1";
		}
		else if ($("rdoIssueSource").checked){
			params = params + "&issParam=2";
		}
		return params;
	}
	
	function extractRecords(){
		try{
			var comm = "";
			var iss = "";
			if ($("rdoCommInc").checked){
				comm="1";
			}
			else if ($("rdoCommExp").checked){
				comm="2";
			}
			if ($("rdoCreditBranch").checked){
				iss = "1";
			}
			else if ($("rdoIssueSource").checked){
				iss = "2";
			}
			new Ajax.Request(contextPath+"/GIACReinsuranceReportsController",{
				parameters:{
					action:		"extractGiacs276",
					commParam:	comm,
					issParam :	iss,
					fromDate: 	$("txtFromDate").value,
					toDate:   	$("txtToDate").value,
					lineCd:  	$("txtLineCd").value
				},
				evalScript: true,
				asynchronous: true,
				onCreate: showNotice("Extracting records, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						var json = JSON.parse(response.responseText);
						if(json.recExtracted>0){
							showMessageBox("Extraction finished. " + json.recExtracted + " records extracted.", "I");
						} else if(json.recExtracted==0){
							showMessageBox("There were 0 records extracted for the date specified.", "I");
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("extractRecords", e);
		}		
	}
	
	function getReportId(){
		var reportId = "";
		if($("rdoCommInc").checked){
			if ($("rdoSummary").checked){
				reportId = "GIACR277A";
				repTitle = "SCHEDULE OF RI COMMISSION INCOME (SUMMARY)";
				return reportId;
			}
			else if ($("rdoDetailed").checked){
				reportId = "GIACR277";
				repTitle = "SCHEDULE OF RI COMMISSION INCOME";
				return reportId;
			}
		}else if($("rdoCommExp").checked){
			if ($("rdoSummary").checked){
				reportId = "GIACR276A";
				repTitle = "SCHEDULE OF RI COMMISSION EXPENSE (SUMMARY)";
				return reportId;
			}
			else if ($("rdoDetailed").checked){
				reportId = "GIACR276";
				repTitle = "SCHEDULE OF RI COMMISSION EXPENSE";
				return reportId;
			}
		}
	}
	
	function printReport(){
		try {
			var reportId = getReportId(); //added by Kevin SR-18635
			
			if("file" == $F("selDestination")){
				if($("rdoCsv").checked && reportId == "GIACR277"){
					reportId = reportId + "_CSV";
				}
			} //end SR-18635
			var content = contextPath + "/ReinsuranceReportController?action=printReport&reportId=" + reportId + getParameters(); // reportId Kevin SR-18635
			if ("screen" == $F("selDestination")) {
				showPdfReport(content, repTitle);
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
				var fileType = "PDF"; //Start Kevin SR-18635 6-17-2016
				
				if ($("rdoPdf").checked){
					fileType = "PDF";
				}
				else{
					fileType = "CSV2";
				}//End SR-18635
				new Ajax.Request(content, {
					parameters : {
						destination : "file",
						/* fileType : $("rdoPdf").checked ? "PDF" : "XLS" */
						fileType : fileType
					},
					onCreate : showNotice("Generating report, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)){
							if (fileType == "CSV2"){ //Start Kevin SR-18635
								copyFileToLocal(response, "csv");
							} else 
								copyFileToLocal(response);
						} //End SR-18635
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
	
	togglePrintFields($("selDestination").value);
	
	$("selDestination").observe("change",function(){
		togglePrintFields($("selDestination").value);
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
	
	$("txtNoOfCopies").observe("change", function() {
		if(isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0 || $F("txtNoOfCopies") > 100){
			showWaitingMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", function(){
				$("txtNoOfCopies").value = "1";
			});			
		}
	});
	
	//Date fields validation
	$("txtToDate").observe("focus", function() {
		validateFromAndToDate("txtToDate");
	});
	
	$("txtFromDate").observe("focus", function() {
		validateFromAndToDate("txtFromDate");
	});
	
	//Exit
	$("btnExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});
	
	//Line Code and Line Name fields
	$("txtLineCd").observe("change", function(){
		if($("txtLineCd").value != ""){
			validateLineCd();
		}else{
			$("txtLineName").value = "ALL LINES";
		}
	});
	
	$("searchLine").observe("click",function(){
		showLineLOV("","");
	});
	
	//Extract and Print button
	$("btnExtract").observe("click",function(){
		if($("txtFromDate").value == "" && $("txtToDate").value ==""){
			showMessageBox("Please Enter From and To Date.", "I");	
			return false;
		}else if($("txtFromDate").value == "" || $("txtToDate").value ==""){
			if($("txtFromDate").value == ""){
				showMessageBox("Please enter From Date.", "I");
				return false;
			} else if($("txtToDate").value ==""){
				showMessageBox("Please enter To Date.", "I");
				return false;
			}
		}
		extractRecords();
	});
	
	$("btnPrint").observe("click",function(){
		if($("txtFromDate").value == "" && $("txtToDate").value ==""){
			showMessageBox("Please Enter From and To Date.", "I");	
			return false;
		}else if($("txtFromDate").value == "" || $("txtToDate").value ==""){
			if($("txtFromDate").value == ""){
				showMessageBox("Please enter From Date.", "I");
				return false;
			} else if($("txtToDate").value ==""){
				showMessageBox("Please enter To Date.", "I");
				return false;
			}
		}
		if($("selDestination").value == "printer"){
			if($("txtNoOfCopies").value == ""){
				showMessageBox("Required fields must be entered.", "I");
				$("txtNoOfCopies").focus();
				return false;
			}
			if($("txtNoOfCopies").value > 100 || $("txtNoOfCopies").value < 1){
				showMessageBox("Invalid No. of Copies. Value should be in range 1-100.", "I");
				return false;
			}
			if($("printerName").value == ""){
				showMessageBox("Required fields must be entered.", "I");
				$("printerName").focus();
				return false;
			}
		}
		printReport();
	});
	
</script>