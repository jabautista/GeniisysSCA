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
				<li><a id="premAssmdFromFaculRIExit">Exit</a></li>
			</ul>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
   			<label>Print Schedule of RI Premiums Assumed From Facul</label>
	   	</div>
	</div>
	
	<div id="premSectionDiv" class="sectionDiv" style="height: 420px;">
		<div id="premSubSectionDiv" class="sectionDiv" align="center" style="width:650px; margin-top: 50px; margin-left: 138px; margin-bottom: 40px;">
			<div id="paramsDiv" class="sectionDiv" style="width:628px; margin-top: 10px; margin-left: 10px; margin-right: 10px;">
				<table align="center" style="margin-top: 20px; margin-bottom: 20px;">
					<tr>
						<td class="rightAligned">From</td>
						<td class="leftAligned">
							<div style="float: left; width: 165px;" class="withIconDiv required">
								<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon required rightAligned" readonly="readonly" style="width: 140px;" tabindex="101"/>
								<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" tabindex="102"/>
							</div>
						</td>
						<td class="rightAligned" style="width: 48px;">To</td>
						<td class="leftAligned">
							<div style="float: left; width: 165px;" class="withIconDiv required">
								<input type="text" id="txtToDate" name="txtToDate" class="withIcon required rightAligned" readonly="readonly" style="width: 140px;" tabindex="103"/>
								<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex="104"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Reinsurer</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan" style="width: 76px; margin-right: 2px; margin-top: 2px;">
								<input type="text" id="txtRiCd" name="ri" class="rightAligned integerNoNegativeUnformattedNoComma" style="width: 50px; float: left; border: none; height: 14px; margin: 0;" class="" tabindex="105" lastValidValue=""/>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="riCd" name="imgSearchRi" alt="Go" style="float: right;" tabindex="106"/>
							</span>
							<input id="txtRiName" name="ri" type="text" class="" style="width: 310px; height: 14px;" value="ALL REINSURERS" readonly="readonly" tabindex="107" lastValidValue="ALL REINSURERS"/>
<!-- 							<span class="lovSpan" style="width: 340px; margin-right: 30px;"> -->
<!-- 								<input type="text" id="txtRiName" name="ri" value="ALL REINSURERS" style="width: 314px; float: left; border: none; height: 14px; margin: 0;" class="" tabindex="107"/>   -->
<%-- 								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="riName" name="imgSearchRi" alt="Go" style="float: right;" tabindex="108"/> --%>
<!-- 							</span> -->
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Line</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan" style="width: 76px; margin-right: 2px;">
								<input type="text" id="txtLineCd" name="line" style="width: 50px; float: left; border: none; height: 14px; margin: 0;" class="" tabindex="109" lastValidValue=""/>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lineCd" name="imgSearchLine" alt="Go" style="float: right;" tabindex="110"/>
							</span>
							<input id="txtLineName" name="line" type="text" class="" style="width: 310px; height: 14px; margin-top: 0px;" value="ALL LINES" readonly="readonly" tabindex="111" lastValidValue="ALL LINES" />
<!-- 							<span class="lovSpan" style="width: 340px; margin-right: 30px;"> -->
<!-- 								<input type="text" id="txtLineName" name="line" value="ALL LINES" style="width: 314px; float: left; border: none; height: 14px; margin: 0;" class="" tabindex="103"/>   -->
<%-- 								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lineName" name="imgSearchLine" alt="Go" style="float: right;" tabindex="111"/> --%>
<!-- 							</span> -->
						</td>
					</tr>					
				</table>
			</div>
			<div id="subParamsDiv" class="sectionDiv" style="height: 130px; width: 160px; margin-left: 10px; margin-bottom: 10px;">
				<table align="center" style="margin-top: 20px; margin-bottom: 20px;">
					<tr style="height: 40px;">
						<td>
							<input type="radio" name="sumOrDet" id="rdoSummary" style="float: left; margin: 3px 2px 3px 20px;" tabindex="201" />
							<label for="rdoSummary" style="float: left; height: 20px; padding-top: 3px;" title="Summary">Summary</label>
						</td>
					</tr>
					<tr style="height: 40px;">
						<td>
							<input type="radio" name="sumOrDet" id="rdoDetailed" style="float: left; margin: 3px 2px 3px 20px;" tabindex="202" />
							<label for="rdoDetailed" style="float: left; height: 20px; padding-top: 3px;" title="Detailed">Detailed</label>
						</td>
					</tr>
				</table>
			</div>
			<div id="sortByDiv" class="sectionDiv" style="height: 130px; width: 160px; margin-bottom: 10px; margin-left: 2px;">
				<label style="margin-left: 5px; margin-top: 5px;">Sort by:</label>
				<table align="center" style="margin-bottom: 20px; margin-top: 20px;">
					<tr style="height: 40px;">
						<td>
							<input type="radio" name="sortBy" id="rdoBookingDate" style="float: left; margin: 3px 2px 3px 20px;" tabindex="301" />
							<label for="rdoBookingDate" style="float: left; height: 20px; padding-top: 3px;" title="Booking Date">Booking Date</label>
						</td>
					</tr>
					<tr style="height: 40px;">
						<td>
							<input type="radio" name="sortBy" id="rdoReinsurer" style="float: left; margin: 3px 2px 3px 20px;" tabindex="302" />
							<label for="rdoReinsurer" style="float: left; height: 20px; padding-top: 3px;" title="Reinsurer">Reinsurer</label>
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
	setModuleId("GIACS171");
	setDocumentTitle("Premiums Assumed from Facultative RI");
	var extracted = false;
	var dspFromDate = "";
	var dspToDate = "";
	var dspRiCd = "";
	var dspRiName = "";
	var dspLineCd = "";
	var dspLineName = "";
	var messageToggle = "";
	
	function initializeOnLoad() {
		toggleRequiredFields("screen");
		$("rdoDetailed").checked = true;
		$("rdoBookingDate").checked = true;	
		checkDates();
		$("txtFromDate").value = dspFromDate;
		$("txtToDate").value = dspToDate;
		$("txtRiCd").value = dspRiCd;
		$("txtLineCd").value = dspLineCd;
		
		if (dspRiCd != "") {
			if (dspRiCd == "null") {
				$("txtRiCd").value = "";
				$("txtRiName").value = $("txtRiName").getAttribute("value");
			}else {
				$("txtRiName").value = dspRiName;
			}
		}else {
			$("txtRiCd").value = "";
			$("txtRiName").value = $("txtRiName").getAttribute("value");
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
	}
	
	function showRiLOV(text) {
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action : "getPremAssumedRiLOV",
				search : ($F("txtRiName") == "ALL REINSURERS" && $F("txtRiCd") == "") ? "%" : text
			},
			title : "List of Reinsurers",
			width : 370,
			height : 390,
			columnModel : [ 
			    {
					id : "riCd",
					title : "RI Code",
					width : '100px',
					align : 'right'
				}, 
				{
					id : "riName",
					title : "Reinsurer Name",
					width : '250px'
				}
			],
			draggable : true,
			autoSelectOneRecord : true,
			filterText : ($F("txtRiName") == "ALL REINSURERS" && $F("txtRiCd") == "") ? "%" : text,
			onSelect : function(row) {
				$("txtRiCd").value 	 = row.riCd;
				$("txtRiName").value = unescapeHTML2(row.riName);
				$("txtRiCd").setAttribute("lastValidValue", $F("txtRiCd"));
				$("txtRiName").setAttribute("lastValidValue", $F("txtRiName"));
			},
			onCancel : function() {
				$("txtRiCd").value = $("txtRiCd").readAttribute("lastValidValue");
				$("txtRiName").value = $("txtRiName").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtRiCd");
				$("txtRiCd").value = $("txtRiCd").readAttribute("lastValidValue");
				$("txtRiName").value = $("txtRiName").readAttribute("lastValidValue");
				
			}
		});		
	}
	
	function showLineLOV(text) {
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action : "getPremAssumedLineLOV",
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
			},
			onCancel : function() {
				$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				$("txtLineName").value = $("txtLineName").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
				$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				$("txtLineName").value = $("txtLineName").readAttribute("lastValidValue");
			}
		});		
	}	
	
	checkUser = true;
	function checkDates() {		//returns from and to dates of extracted records 
		var bool = false;
		new Ajax.Request(contextPath+"/GIACReinsuranceReportsController", {
			parameters: {action: "getDates",
				riCd : $F("txtRiCd"),
				lineCd : $F("txtLineCd")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					var res = JSON.parse(response.responseText);
					checkUser = JSON.stringify(res) == "{}" ? false : true;
					dspFromDate = JSON.stringify(res.fromDate).replace(/"/g, "");
					dspToDate = JSON.stringify(res.toDate).replace(/"/g, "");
					dspRiCd = JSON.stringify(res.riCd).replace(/"/g, "") == "null" ? "" : JSON.stringify(res.riCd).replace(/"/g, "");
					dspRiName = JSON.stringify(res.riName).replace(/"/g, "");
					dspLineCd = JSON.stringify(res.lineCd).replace(/"/g, "") == "null" ? "" : JSON.stringify(res.lineCd).replace(/"/g, "");
					dspLineName = JSON.stringify(res.lineName).replace(/"/g, "");
					if (dspFromDate == $F("txtFromDate") && dspToDate == $F("txtToDate") && dspLineCd == $F("txtLineCd") && dspRiCd == $F("txtRiCd")) {
						bool = true;
					}
				}
			}
		});
		return bool;
	}
	
	function extractToTable() {		//inserts extracted records to giac_assumed_ri_ext
		new Ajax.Request(contextPath+"/GIACReinsuranceReportsController", {
			parameters: {
				action: "extractToTable",
				fromDate: $F("txtFromDate"),
				toDate:  $F("txtToDate"),
				lineCd: $F("txtLineName") == "ALL LINES" ? "" : $F("txtLineCd"),
				riCd: $F("txtRiCd") == "ALL REINSURERS" ? "" : $F("txtRiCd")
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
	
	function getReportTitle(reportId) {
		var title = "";
		if (reportId == "GIACR171") {
			title = "Schedule of Premiums Assumed From Facultative RI(Summary)";
		}else if (reportId == "GIACR171A") {
			title = "Premium Assumed From Facultative RI (by Booking Date)";
		}else if (reportId == "GIACR171B") {
			title = "Premium Assumed From Facultative RI (by Reinsurer)";
		}
		return title;
	}
	
	function printReport(reportId){
		try {
			var content = contextPath + "/ReinsuranceReportController?action=printReport"
							+"&reportId="+ reportId
							+"&fromDate="+ $F("txtFromDate")
							+"&toDate="+ $F("txtToDate")
							+"&lineCd="+ $F("txtLineCd")
							+"&riCd="+ $F("txtRiCd");
			
			if("screen" == $F("selDestination")){
				showPdfReport(content, getReportTitle(reportId));
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {noOfCopies : $F("txtNoOfCopies"),
						  	      printerName : $F("selPrinter")},
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
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							copyFileToLocal(response, "reports");
						}
					}
				});
			}else if("local" == $F("selDestination")){
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
	
	function printReinsuranceReport() {
		if (checkAllRequiredFieldsInDiv("paramsDiv")) {
			if (checkDates()) {	
				if ($F("txtFromDate") != "" || $F("txtToDate") != "") {
					if ($("rdoSummary").checked) {
						printReport("GIACR171");
					}else if ($("rdoDetailed").checked) {
						if ($("rdoBookingDate").checked) {
							printReport("GIACR171A");
						}else if ($("rdoReinsurer").checked) {
							printReport("GIACR171B");
						}
					}	
				}
			}else{
				if (messageToggle == "Print" && !checkUser) {
					showMessageBox("Please extract records first.", imgMessage.INFO);
				}else if (messageToggle == "Print" && checkUser) {
					showConfirmBox("Print Schedule of RI Premiums Assumed From Facul",
							"The specified parameter/s has not been extracted.\nDo you want to extract the data using the specified parameter/s?",
							"Yes", "No", extractToTable, "", "");
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
			if (input.id.contains("Ri")) {
				$("txtRiName").value = $("txtRiName").getAttribute("value");
				$("txtRiCd").clear();
				$("txtRiCd").setAttribute("lastValidValue", $F("txtRiCd"));
				$("txtRiName").setAttribute("lastValidValue", $F("txtRiName"));
			}else {
				$("txtLineName").value = $("txtLineName").getAttribute("value");
				$("txtLineCd").clear();
				$("txtLineCd").setAttribute("lastValidValue", $F("txtLineCd"));
				$("txtLineName").setAttribute("lastValidValue", $F("txtLineName"));
			}
		}
	}
	
	$("btnExtract").observe("click", function() {
		if (checkAllRequiredFieldsInDiv("paramsDiv")) {
			if (checkDates()) {
				showConfirmBox("Print Schedule of RI Premiums Assumed From Facul",
								"Data has been extracted within the specified parameter/s. Do you wish to continue extraction?",
								"Yes", "No", extractToTable, "", "");
			}else{
				extractToTable();
			}
		}
	});
	
	$("btnPrint").observe("click", function(){
		messageToggle = $F("btnPrint");
		var dest = $F("selDestination");
		if(dest == "printer"){
			if(checkAllRequiredFieldsInDiv("printDialogFormDiv")){
				printReinsuranceReport();
			}
		}else{
			printReinsuranceReport();
		}
	});
	
	$("txtFromDate").observe("focus", function(){
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) :"";
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("From date should be earlier than To date.", "I", "txtToDate");
			$("txtFromDate").clear();
			return false;
		}
	});	
	
	$("txtToDate").observe("focus", function(){
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) :"";
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("From date should be earlier than To date.", "I", "txtToDate");
			$("txtToDate").clear();
			return false;
		}
	});	
	
	$("rdoSummary").observe("click", function() {
		$("rdoBookingDate").disabled = true;
		$("rdoReinsurer").disabled = true;
	});
	
	$("rdoDetailed").observe("click", function() {
		$("rdoBookingDate").disabled = false;
		$("rdoReinsurer").disabled = false;
	});
	
	$("hrefFromDate").observe("click", function(){
		if ($("hrefFromDate").disabled == true) return;
		scwShow($('txtFromDate'),this, null);
	});
	
	$("hrefToDate").observe("click", function(){
		if ($("hrefToDate").disabled == true) return;
		scwShow($('txtToDate'),this, null);
	});	

	$$("img[name='imgSearchRi']").each(function(search) {
		search.observe("click", function() {
			if (search.id == "riCd") {
				showRiLOV("%");
			}
		});
	});
	
	$$("input[name='ri']").each(function(input) {
		input.observe("change", function() {
			if (input.id == "txtRiCd") {
				validateLOV(input, function() {
					showRiLOV($F("txtRiCd"));
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
	
	observeCancelForm("premAssmdFromFaculRIExit", "", function(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	});	
	
	initializeOnLoad();
} catch (e) {
	showErrorMessage("premAssumedFromFaculRI ",e);
}
</script>