<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div id="premMainDiv" name="premMainDiv">
  	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="premCededTreatyExit">Exit</a></li>
			</ul>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
   			<label>Print Premium Ceded on Treaty</label>
	   	</div>
	</div>
	
	<div id="premSectionDiv" class="sectionDiv" style="height: 420px;">
		<div id="premSubSectionDiv" class="sectionDiv" align="center" style="width:650px; margin-top: 50px; margin-left: 138px; margin-bottom: 40px;">
			<div id="paramsDiv" class="sectionDiv" style="width:628px; margin-top: 10px; margin-left: 10px; margin-right: 10px;">
				<table align="center" style="margin-top: 20px; margin-bottom: 20px;">
					<tr>
						<td class="rightAligned">Quarter / Year</td>
						<td class="leftAligned">
							<span>
								<input type="text" class="required integerNoNegativeUnformattedNoComma" id="txtQuarter" name="txtQuarter" maxlength="2" style="width: 70px;" tabindex="101" lastValidValue=""/>
							</span>
							<input type="text" class="required integerNoNegativeUnformattedNoComma" id="txtYear" name="txtYear" maxlength="4" style="width: 140px;" tabindex="102" lastValidValue=""/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Treaty Name</td>
						<td class="leftAligned" colspan="">
							<span class="lovSpan" style="width: 76px; margin-right: 4px; margin-top: 2px;"> 
								<input type="text" id="txtShareCd" name="treaty" style="width: 50px; float: left; border: none; height: 14px; margin: 0;"  lastValidValue="" tabindex="103" maxlength="3" />  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="shareCd" name="imgSearchTreaty" alt="Go" style="float: right;" tabindex="104"/>
							</span>
							<input id="txtTreatyName" name="treaty" type="text" class="" style="width: 310px; height: 14px;" value="ALL TREATIES" readonly="readonly" tabindex="105" lastValidValue="ALL TREATIES"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Line</td>
						<td class="leftAligned" colspan="">
							<span class="lovSpan" style="width: 76px; margin-right: 4px; margin-top: 2px;">
								<input type="text" id="txtLineCd" name="line" style="width: 50px; float: left; border: none; height: 14px; margin: 0;" class="" tabindex="107" maxlength="2" />  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lineCd" name="imgSearchLine" alt="Go" style="float: right;" tabindex="108"/>
							</span>
							<input id="txtLineName" name="line" type="text" class="" style="width: 310px; height: 14px;" value="ALL LINES" readonly="readonly" tabindex="109" lastValidValue="ALL LINES"/>
						</td>
					</tr>					
				</table>
			</div>
			<div id="subParamsDiv" class="sectionDiv" style="height: 130px; width: 220px; margin-left: 10px; margin-bottom: 10px;">
				<table align="center" style="margin-top: 20px; margin-bottom: 20px;">
					<tr><td>
							<input type="radio" name="premComm" id="rdoPremiumCeded" style="float: left; margin: 3px 5px 3px 5px;" tabindex="201" />
							<label for="rdoPremiumCeded" style="float: left; height: 20px; padding-top: 3px;" title="Premium Ceded">Premium Ceded</label>
					</td></tr>
					<tr><td>
							<input type="radio" name="premComm" id="rdoCommission" style="float: left; margin: 3px 5px 3px 5px;" tabindex="202" />
							<label for="rdoCommission" style="float: left; height: 20px; padding-top: 3px;" title="Commission">Commission</label>
					</td></tr>
					<tr><td>
							<input type="checkbox" name="chkBreak" id="chkBreak" style="float: left; margin: 3px 5px 3px 5px;" tabindex="203" />
							<label for="chkBreak" style="float: left; margin-left:2px; height: 20px; padding-top: 3px;" title="Break on Commission Rate">Break on Commission Rate</label>
					</td></tr>
				</table>
			</div>
			<div id="sortByDiv" class="sectionDiv" style="height: 130px; width: 100px; margin-bottom: 10px;">
				<table style="margin-bottom: 20px; margin-top: 20px;">
					<tr style="height: 40px;">
						<td>
							<input type="radio" name="layout" id="rdoLayout1" value="1" style="float: left; margin: 3px 5px 3px 5px;" tabindex="301"/>
							<label for="rdoLayout1" style="float: left; height: 20px; padding-top: 3px;" title="Layout 1">Layout 1</label>
						</td>
					</tr>
					<tr style="height: 40px;">
						<td>
							<input type="radio" name="layout" id="rdoLayout2" value="2" style="float: left; margin: 3px 5px 3px 5px;" tabindex="302" />
							<label for="rdoLayout2" style="float: left; height: 20px; padding-top: 3px;" title="Layout 2">Layout 2</label>
						</td>
					</tr>					
				</table>
			</div>
			<div id="printDiv"class="sectionDiv" style="width: 300px; margin-left: 2px;">
				<div style="float: left;" id="printDialogFormDiv">
					<table id="printDialogMainTab" name="printDialogMainTab" align="center" style="padding: 10px;">
						<tr>
							<td class="rightAligned">Destination</td>
							<td class="leftAligned">
								<select id="selDestination" style="width: 200px;">
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
								<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="fileType" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled"><label for="rdoPdf" style="margin: 2px 0 4px 0">PDF</label>
								<input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="fileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoExcel" style="margin: 2px 0 4px 0">Excel</label>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Printer</td>
							<td class="leftAligned">
								<select id="selPrinter" style="width: 200px;" class="required">
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
								<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma" lastValidValue="" maxlength="3">
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
			<div id="buttonsDiv" style="width: 100%; float: left;">
				<input type="button" class="button" id="btnExtract" name="btnExtract" value="Extract" style="width: 100px; margin-bottom: 10px;">
				<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width: 100px; margin-bottom: 10px;">
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
try {
	initializeAll();
	var sysQuarter = "";
	var extracted = false;
	var checkUser = true;
	var dspQuarter = "";
	var dspYear = "";
	var dspShareCd = "";
	var dspTreatyName = "";
	var dspLineCd = "";
	var dspLineName = "";
	var messageToggle = "";
	
	function checkPrevParams() {		 
		var bool = false;
		new Ajax.Request(contextPath+"/GIACReinsuranceReportsController", {
			parameters: {action: "getPrevParams"},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					var res = JSON.parse(response.responseText);
					checkUser = JSON.stringify(res) == "{}" ? false : true;
					dspQuarter = JSON.stringify(res.cessionMm).replace(/"/g, "");
					dspYear = JSON.stringify(res.cessionYear).replace(/"/g, "");
					dspShareCd = JSON.stringify(res.shareCd).replace(/"/g, "") == "null" ? "" : JSON.stringify(res.shareCd).replace(/"/g, "");
					dspTreatyName = JSON.stringify(res.treatyName).replace(/"/g, "");
					dspLineCd = JSON.stringify(res.lineCd).replace(/"/g, "") == "null" ? "" : JSON.stringify(res.lineCd).replace(/"/g, "");
					dspLineName = JSON.stringify(res.lineName).replace(/"/g, "");
					if (dspQuarter == $F("txtQuarter") && dspYear == $F("txtYear") && dspShareCd == $F("txtShareCd") && dspLineCd == $F("txtLineCd")) {
						bool = true;
					}
				}
			}
		});
		return bool;
	}
	
	function getSysQuarter() {
		var sysMonth = parseInt('${sysMonth}') + 1;
		if (sysMonth >= 1 && sysMonth <= 3) {
			sysQuarter = "1";
		}else if (sysMonth >= 4 && sysMonth <= 6 ) {
			sysQuarter = "2";
		}else if (sysMonth >= 7 && sysMonth <= 9) {
			sysQuarter = "3";
		}else {
			sysQuarter = "4";
		}
		return sysQuarter;
	}
	
	function initializeOnLoad() {
		setModuleId("GIACS136");
		setDocumentTitle("Print Premium Ceded on Treaty");
		checkPrevParams();
		if (!checkUser) {
			$("txtQuarter").value = getSysQuarter();
			$("txtYear").value = parseInt('${sysYear}');
			$("txtLineName").value = $("txtLineName").getAttribute("value");
			$("txtTreatyName").value = $("txtTreatyName").getAttribute("value");
		}else {
			$("txtQuarter").value = dspQuarter;
			$("txtYear").value = dspYear;
			$("txtShareCd").value = dspShareCd;
			$("txtTreatyName").value = dspTreatyName;
			$("txtLineCd").value = dspLineCd;
			$("txtLineName").value = dspLineName;
		}
		
		if (dspLineCd != "") {
			if (dspLineCd == "null") {
				$("txtLineCd").value = "";
				$("txtLineName").value = $("txtLineName").getAttribute("value");
			}else {
				$("txtLineName").value = dspLineName;	
			}
		}else {
			$("txtLineCd").value = "";
			$("txtLineName").value = $("txtLineName").getAttribute("value");
		}
		
		if (dspShareCd != "") {
			if (dspShareCd == "null") {
				$("txtShareCd").value = "";
				$("txtTreatyName").value = $("txtTreatyName").getAttribute("value");
			}else {
				$("txtTreatyName").value = dspTreatyName;
			}
		}else {
			$("txtShareCd").value = "";
			$("txtTreatyName").value = $("txtTreatyName").getAttribute("value");
		}
		
		$("txtQuarter").setAttribute("lastValidValue", $F("txtQuarter"));
		$("rdoPremiumCeded").checked = true;
		$("chkBreak").checked = true;
		$("rdoLayout1").checked = true;
		toggleRequiredFields("screen");
		
		if ($F("txtShareCd") == "" && $F("txtLineCd") == "") {
			enableDisableTreaty(false);
		}else {
			enableDisableTreaty(true);
		}
	}

	function enableDisableTreaty(enable) {
		if (nvl(enable,false) == false) {
			disableInputField("txtShareCd");
			disableSearch("shareCd");
		}else {
			enableInputField("txtShareCd");
			enableSearch("shareCd");
		}
	}
	
	function showTreatyLOV(text) {
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action : "getPremCededTreatyLOV",
				quarter : $F("txtQuarter"),
				year : $F("txtYear"),
				lineCd : $F("txtLineCd"),
				search : ($F("txtTreatyName") == "ALL TREATIES" && $F("txtShareCd") == "") ? "%" : text
			},
			title : "List of Treaty Names",
			width : 370,
			height : 390,
			columnModel : [ 
			    {
					id : "shareCd",
					title : "Share Code",
					width : '100px'
				}, 
				{
					id : "treatyName",
					title : "Treaty Name",
					width : '250px'
				}
			],
			draggable : true,
			autoSelectOneRecord : true,
			filterText : ($F("txtTreatyName") == "ALL TREATIES" && $F("txtShareCd") == "") ? "%" : text,
			onSelect : function(row) {
				$("txtShareCd").value 	 = unescapeHTML2(row.shareCd);
				$("txtTreatyName").value = unescapeHTML2(row.treatyName);
				$("txtShareCd").setAttribute("lastValidValue", $F("txtShareCd"));
				$("txtTreatyName").setAttribute("lastValidValue", $F("txtTreatyName"));
			},
			onCancel : function() {
				$("txtShareCd").value = $("txtShareCd").readAttribute("lastValidValue");
				$("txtTreatyName").value = $("txtTreatyName").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtShareCd");
				$("txtShareCd").value = $("txtShareCd").readAttribute("lastValidValue");
				$("txtTreatyName").value = $("txtTreatyName").readAttribute("lastValidValue");
			}
		});		
	}	
	
	function showLineLOV(text) {
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action : "getPremCededLineLOV",
				quarter : $F("txtQuarter"),
				year : $F("txtYear"),
				search : ($F("txtLineName") == "ALL LINES" && $F("txtLineCd") == "") ? "%" : text 
			},
			title : "List of Lines",
			width : 370,
			height : 390,
			columnModel : [ 
			    {
					id : "lineCd",
					title : "Line Code",
					width : '100px'
				}, 
				{
					id : "lineName",
					title : "Line Name",
					width : '250px'
				}
			],
			draggable : true,
			autoSelectOneRecord : true,
			filterText : ($F("txtLineName") == "ALL LINES" && $F("txtLineCd") == "") ? "%" : text,
			onSelect : function(row) {
				$("txtLineCd").value 	= unescapeHTML2(row.lineCd);
				$("txtLineName").value 	= unescapeHTML2(row.lineName);
				$("txtLineCd").setAttribute("lastValidValue", $F("txtLineCd"));
				$("txtLineName").setAttribute("lastValidValue", $F("txtLineName"));
				enableDisableTreaty(true);
			},
			onCancel : function() {
				$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				$("txtLineName").value = $("txtLineName").readAttribute("lastValidValue");
				if ($F("txtLineCd") == "") {
					enableDisableTreaty(false);
				}
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
				$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				$("txtLineName").value = $("txtLineName").readAttribute("lastValidValue");
				if ($F("txtLineCd") == "") {
					enableDisableTreaty(false);
				}
			}
		});		
	}	
	
	function extractRecordsToTable() {
		new Ajax.Request(contextPath+"/GIACReinsuranceReportsController", {
			parameters: {
				action: "extractRecordsToTable",
				quarter: $F("txtQuarter"),
				year: $F("txtYear"),
				shareCd : $F("txtShareCd"),
				lineCd : $F("txtLineCd")
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function() {
				showNotice("Please wait...processing extract.");
			},
			onComplete: function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					extracted = true;
					messageToggle = $F("btnExtract");
					showMessageBox(response.responseText, imgMessage.INFO);
				}
			}
		});		
	}
	
	function validateBeforeExtract() {
		new Ajax.Request(contextPath+"/GIACReinsuranceReportsController", {
			parameters: {
				action: "validateBeforeInsert",
				quarter: $F("txtQuarter"),
				year: $F("txtYear")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					extractRecordsToTable();
				}
			}
		});		
	}
	
	function deletePrevExtractedRecords() {
		new Ajax.Request(contextPath+"/GIACReinsuranceReportsController", {
			parameters: {
				action: "deletePrevExtractedRecords",
				quarter: $F("txtQuarter"),
				year: $F("txtYear")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					validateBeforeExtract();
				}
			}
		});	
	}	
	
	function validateIfExisting() {
		new Ajax.Request(contextPath+"/GIACReinsuranceReportsController", {
			parameters: {
				action: "validateIfExisting",
				quarter: $F("txtQuarter"),
				year: $F("txtYear"),
				shareCd: $F("txtShareCd"),
				lineCd: $F("txtLineCd")
			},
			asynchronous: false,
			onCreate: function() {
				showNotice("Please wait...validating if records exists.");
			},
			onComplete: function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					if (checkPrevParams()) {
						showConfirmBox("Print Premium Ceded on Treaty",
										"Data has been extracted within the specified parameter/s. Do you wish to continue extraction?",
											"Yes", "No", deletePrevExtractedRecords, "","");
					}else {
						deletePrevExtractedRecords();
					}
				}
			}
		});
	}
	
	function getReportTitle(reportId) {
		var title = "";
		if (reportId == "GIACR136") {
			title = "Schedule of Premium Ceded on Treaty";
		}else if (reportId == "GIACR136A") {
			title = "Schedule of Premium Ceded on Treaty";
		}else if (reportId == "GIACR136B") {
			title = "Schedule of Premium Ceded on Treaty";
		}else if (reportId == "GIACR136B") {
			title = "Schedule of Premium Ceded on Treaty";
		}else if (reportId == "GIACR136C") {
			title = "Schedule of Premium Ceded on Treaty";
		}else if (reportId == "GIACR137") {
			title = "Schedule of Commission Ceded on Treaty";
		}else if (reportId == "GIACR137A") {
			title = "Schedule of Commission Ceded on Treaty";
		}else if (reportId == "GIACR137B") {
			title = "Schedule of Commission Earned on Treaty";
		}else if (reportId == "GIACR137C") {
			title = "Schedule of Commission Earned on Treaty";
		}
		return title;
	}
	
	function printReport(reportId){
		try {
			var content = contextPath + "/ReinsuranceReportController?action=printReport"
							+"&reportId="+ reportId
							+"&quarter="+ $F("txtQuarter")
							+"&year="+ $F("txtYear")
							+"&lineCd="+ $F("txtLineCd")
							+"&shareCd="+ $F("txtShareCd");
			
			if("screen" == $F("selDestination")){
				showPdfReport(content, getReportTitle(reportId));
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {noOfCopies : $F("txtNoOfCopies"),
						  	      printerName : $F("selPrinter")},
					evalScripts: true,
					asynchronous: true,					
					onCreate: showNotice("Processing, please wait..."),	
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing complete.", imgMessage.SUCCESS);
						}
					}
				});
			}else if("file" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "file",
								  fileType : $("rdoPdf").checked ? "PDF" : "XLS"},
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							copyFileToLocal(response);
						}
					}
				});
			}else if("local" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "local"},
					evalScripts: true,
					asynchronous: true,
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
	
	function checkPrinting() {
		if (checkAllRequiredFieldsInDiv("paramsDiv")) {
			if (checkPrevParams()) {	
				printReinsuranceReport();
			} else {
				if (messageToggle == "Print" && !checkUser) {
					showMessageBox("Please extract records first.", imgMessage.INFO);
				}else if (messageToggle == "Print" && checkUser) {
					showConfirmBox("Print Schedule of RI Premiums Assumed From Facul",
							"The specified parameter/s has not been extracted.\nDo you want to extract the data using the specified parameter/s?",
							"Yes", "No", validateIfExisting, "", "");
				}
			}
		}
	}
	
	function printReinsuranceReport() {
		if ($("chkBreak").checked == true) {
			if ($("rdoPremiumCeded").checked == true) {
				if ($("rdoLayout1").checked == true) {
					printReport("GIACR136A");
				}else if ($("rdoLayout2").checked == true) {
					printReport("GIACR136C");
				}
			}else if ($("rdoCommission").checked == true) {
				if ($("rdoLayout1").checked == true) {
					printReport("GIACR137A");
				}else if ($("rdoLayout2").checked == true) {
					printReport("GIACR137B");
				}
			}
		}else {
			if ($("rdoPremiumCeded").checked == true) {
				if ($("rdoLayout1").checked == true) {
					printReport("GIACR136");
				}else if ($("rdoLayout2").checked == true) {
					printReport("GIACR136B");
				}
			}else if ($("rdoCommission").checked == true) {
				if ($("rdoLayout1").checked == true) {
					printReport("GIACR137");
				}else if ($("rdoLayout2").checked == true) {
					printReport("GIACR137C");
				}
			}
		}
	}
	
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
		} else {
			if(dest == "file"){
				$("rdoPdf").enable();
				$("rdoExcel").enable();
			} else {
				$("rdoPdf").disable();
				$("rdoExcel").disable();
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
	
	function validateLOV(input, showLOV) {
		if ($(input).value != "") {
			showLOV();
		}else {
			if (input.getAttribute("name") == "treaty") {
				$("txtTreatyName").value = $("txtTreatyName").getAttribute("value");
				$("txtShareCd").clear();
				$("txtShareCd").setAttribute("lastValidValue", $F("txtShareCd"));
				$("txtTreatyName").setAttribute("lastValidValue", $F("txtTreatyName"));
			}else {
				$("txtLineName").value = $("txtLineName").getAttribute("value");
				$("txtLineCd").clear();
				$("txtLineCd").setAttribute("lastValidValue", $F("txtLineCd"));
				$("txtLineName").setAttribute("lastValidValue", $F("txtLineName"));
			}
			if ($F("txtLineCd") == "") {
				$("txtTreatyName").value = $("txtTreatyName").getAttribute("value");
				$("txtShareCd").clear();
				$("txtShareCd").setAttribute("lastValidValue", $F("txtShareCd"));
				$("txtTreatyName").setAttribute("lastValidValue", $F("txtTreatyName"));
				enableDisableTreaty(false);
			}
		}
	}
	
	$("btnExtract").observe("click", function() {
		if (checkAllRequiredFieldsInDiv("paramsDiv")) {
			validateIfExisting();
		}
	});
	
	$("btnPrint").observe("click", function() {
		messageToggle = $F("btnPrint");
		var dest = $F("selDestination");
		if(dest == "printer"){
			if(checkAllRequiredFieldsInDiv("printDialogFormDiv")){
				checkPrinting();
			}
		}else{
			checkPrinting();
		}
	});
	
	$("txtQuarter").observe("change", function() {
		if (parseInt($F("txtQuarter")) > 4 || parseInt($F("txtQuarter")) < 1) {
			customShowMessageBox("Invalid Quarter. Valid value should be from 1 - 4.", imgMessage.INFO, "txtQuarter");
			$("txtQuarter").value = $("txtQuarter").readAttribute("lastValidValue");
		}else {
			$("txtQuarter").setAttribute("lastValidValue", $F("txtQuarter"));
		}
	}); 
	
	$$("img[name='imgSearchTreaty']").each(function(search) {
		search.observe("click", function() {
			if (search.id == "shareCd") {
				showTreatyLOV("%");
			}
		});
	});
	
	$$("input[name='treaty']").each(function(input) {
		input.observe("change", function() {
			if (input.id == "txtShareCd") {
				validateLOV(input, function() {
					showTreatyLOV($F("txtShareCd"));
				});
			}
		});
	});
	
	$$("img[name='imgSearchLine']").each(function(search) {
		search.observe("click", function() {
			if (search.id == "lineCd") {
				showLineLOV("%");
			}
		});
	});
	
	$$("input[name='line']").each(function(input) {
		input.observe("change", function() {
			if (input.id == "txtLineCd") {
				validateLOV(input, function() {
					showLineLOV($F("txtLineCd"));
				});
			}
		});
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
	
	$("imgSpinUp").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		$("txtNoOfCopies").value = no + 1;
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
	
	$("selDestination").observe("change", function(){
		var dest = $F("selDestination");
		toggleRequiredFields(dest);
	});	
	
	observeCancelForm("premCededTreatyExit", "", function(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	});	
	
	getSysQuarter();
	initializeOnLoad();
} catch (e) {
	showErrorMessage("premCededTreaty ",e);
}	
</script>