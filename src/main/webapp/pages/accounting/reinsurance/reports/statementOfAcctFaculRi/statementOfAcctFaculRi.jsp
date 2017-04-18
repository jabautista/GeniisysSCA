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
				<li><a id="soaFaculRiExit">Exit</a></li>
			</ul>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Print Incoming Facultative RI Statement of Accounts</label>
		</div>
	</div>
	<div id="soaFaculRiSectionDiv" class="sectionDiv" style="width: 920px; height: 500px;">
		<div class="sectionDiv" style="width: 617px; height:400px; margin: 40px 20px 20px 150px;">
			<div id="rdoDiv" class="sectionDiv" style="width: 535px; height: 10px; margin: 10px 0px 0px 10px; padding: 10px 30px 20px 30px;">
				<table align="center" style="height: 20px">
					<tr>
						<td> 
							<div>
								<input id="rdoAcctEntryDate" name="rdo" type="radio" value="AC" style="float: left;" tabindex="101"/>
								<label style="margin-left: 7px;" for="rdoAcctEntryDate" >Acct Entry Date</label>
							</div>
						</td>
						<td>
							<div>
								<input id="rdoBookingDate" name="rdo" type="radio" style="margin-left: 80px; float: left;" value="BK" tabindex="102"/>
								<label style="margin-left: 7px;" for="rdoBookingDate">Booking Date</label>
							</div>
						</td>
						<td>
							<div>
								<input id="rdoInceptionDate" name="rdo" type="radio" style="margin-left: 80px; float: left;" value="IN" tabindex="103"/>
								<label style="margin-left: 7px;" for="rdoInceptionDate">Inception Date</label>
							</div>
						</td>					
					</tr>
				</table>
			</div>
			
			<div id="fieldDiv" class="sectionDiv" style="width: 575px; height: 100px; margin: 2px 10px 0px 10px; padding: 10px 10px 25px 10px;"/>
				<table align="left" style="padding-left: 25px;">	
					<tr>
						<td class="rightAligned" style="padding-right: 10px;">From</td>
						<td>
							<div id="fromDateDiv" style="float: left; border: 1px solid gray; width: 155px; height: 20px;" class="required">
								<input id="txtFromDate" name="From date." readonly="readonly" type="text" class="rightAligned date required" maxlength="10" style="border: none; float: left; width: 130px; height: 13px; margin: 0px;" value="" tabindex="201"/>
								<img id="imgFromDate" alt="imgFromDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtFromDate'),this, null);" tabindex="202"/>
							</div>
						</td> 
						<td class="rightAligned" style="padding-left: 80px; padding-right: 10px;">To</td>
						<td>
							<div id="toDateDiv" style="float: left; border: 1px solid gray; width: 155px; height: 20px;" class="required">
								<input id="txtToDate" name="To date." readonly="readonly" type="text" class="rightAligned date required" maxlength="10" style="border: none; float: left; width: 130x; height: 13px; margin: 0px;" value="" tabindex="203"/>
								<img id="imgToDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtToDate'),this, null);" tabindex="204"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="padding-right: 10px;">Cut Off Date</td>
						<td>
							<div style="float: left; width: 155px;" class="withIconDiv required">
								<input type="text" id="txtCutOffDate" name="txtCutOffDate" class="rightAligned withIcon date required" readonly="readonly" style="width: 130px;" title="Cut Off Date" tabindex="205"/>
								<img id="hrefCutOffDate" alt="hrefCutOffDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtCutOffDate'),this, null);" tabindex="206"/>
							</div>
						</td>
					</tr>
				</table>
				<table align="left" style="padding-left: 43px;">	
					<tr>
						<td class="rightAligned" style="padding-right: 10px;" id="">Line</td>
						<td class="" colspan="3">
							<span class="lovSpan" style="float: left; width: 105px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input id="txtLineCd" name="Line" type="text" maxlength="2" class="upper" style="width: 80px; float: left; border: none; height: 13px; margin: 0;" tabindex="207"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchLineCdLOV" name="imgSearchLine" alt="Go" style="float: right;" tabindex="208"/>
							</span>
							<input id="txtLineName" name="Line" type="text"  maxlength="20" class="upper" style="width: 307px;" value="" readonly="readonly" tabindex="209"/>
						</td>					
<!-- 						<td class="rightAligned" style="padding-right: 10px;">Line</td> -->
<!-- 						<td style="padding-top: 0px;"> -->
<!-- 							<div style="height: 20px;"> -->
<!-- 								<div id="lineCdDiv" style="border: 1px solid gray; width: 105px; height: 20px; margin:0 5px 0 0;"> -->
<!-- 									<input id="txtLineCd" name="Line" type="text" maxlength="2" class="upper" style="border: none; float: left; width: 80px; height: 13px; margin: 0px;" value="" tabindex="207"/> -->
<%-- 									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchLineCdLOV" name="imgSearchLine" alt="Go" style="float: right;" tabindex="208"/> --%>
<!-- 								</div> -->
<!-- 							</div>						 -->
<!-- 						</td>	 -->
<!-- 						<td> -->
<!-- 							<div id="lineNameDiv" style="border: 1px solid gray; width: 310px; height: 20px; margin:0 5px 0 0;"> -->
<!-- 								<input id="txtLineName" name="Line" type="text" maxlength="20" class="upper" style="border: none; float: left; width: 280px; height: 13px; margin: 0px;" value="" tabindex="209"/> -->
<%-- 								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchLineNameLOV" name="imgSearchLine" alt="Go" style="float: right;" tabindex="210"/> --%>
<!-- 							</div> -->
<!-- 						</td> -->
					</tr>
					<tr>
						<td class="rightAligned" style="padding-right: 10px;" id="">Reinsurer</td>
						<td class="" colspan="3">
							<span class="lovSpan" style="float: left; width: 105px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input id="txtRiCd" name="Reinsurer" type="text" maxlength="5" class="upper integerNoNegativeUnformattedNoComma" style="width: 80px; float: left; border: none; height: 13px; margin: 0;" tabindex="211"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchRiCdLOV" name="imgSearchRi" alt="Go" style="float: right;" tabindex="212"/>
							</span>
							<input id="txtRiName" name="Reinsurer" type="text" maxlength="50" class="upper" style="width: 307px;" value="" readonly="readonly" tabindex="213"/>
						</td>						
<!-- 						<td class="rightAligned" style="padding-right: 10px;">Reinsurer</td> -->
<!-- 						<td style="padding-top: 0px;"> -->
<!-- 							<div style="height: 20px;"> -->
<!-- 								<div id="reinsurerDiv" style="border: 1px solid gray; width: 105px; height: 20px; margin:0 5px 0 0;"> -->
<!-- 									<input id="txtRiCd" name="Reinsurer" type="text" maxlength="5" class="upper" style="border: none; float: left; width: 80px; height: 13px; margin: 0px;" value="" tabindex="211"/> -->
<%-- 									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchRiCdLOV" name="imgSearchRi" alt="Go" style="float: right;" tabindex="212"/> --%>
<!-- 								</div> -->
								
<!-- 							</div>						 -->
<!-- 						</td>	 -->
<!-- 						<td> -->
<!-- 							<div id="riNameDiv" style="border: 1px solid gray; width: 310px; height: 20px; margin:0 5px 0 0;"> -->
<!-- 								<input id="txtRiName" name="Reinsurer" type="text" maxlength="50" class="upper" style="border: none; float: left; width: 280px; height: 13px; margin: 0px;" value="" tabindex="213"/> -->
<%-- 								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchRiNameLOV" name="imgSearchRi" alt="Go" style="float: right;" tabindex="214"/> --%>
<!-- 							</div> -->
<!-- 						</td> -->
					</tr>
				</table>
			</div>
			<div class="sectionDiv" style="width: 40%; height: 110px; margin: 2px 2px 10px 10px; padding: 8px 0 22px 0;">				
				<div>
					<table style="padding-left: 20px;">
						<tr>	
							<td style="padding-left: 30px; padding-bottom: 5px;">
								<input type="radio" id="rdoWithComm" name="commission" checked="checked" value="C" tabindex="301"/>
							</td>
							<td>
								<label for="rdoWithComm">With Commission</label>
							</td>
						</tr>
						<tr>
							<td style="padding-left: 30px; padding-bottom: 8px;">
								<input type="radio" id="rdoWithoutComm" name="commission" value="D" tabindex="302"/>
							</td>
							<td>
								<label for="rdoWithoutComm">Without Commission</label>
							</td>
						</tr>
						<tr>
							<td style="padding-left: 30px; padding-bottom: 8px;">
								<input type="checkbox" id="chkSummary" name="chk" value="Y" tabindex="303"/>
							</td>
							<td>
								<label for="chkSummary">Summary</label>
							</td>
						</tr>
						<tr>
							<td style="padding-left: 30px; padding-bottom: 8px;">
								<input type="checkbox" id="chkCurrency" name="chk" value="Y" tabindex="304"/>
							</td>
							<td>
								<label for="chkCurrency">By Currency</label>
							</td>
						</tr>
						<tr>
							<td style="padding-left: 30px; padding-bottom: 8px;">
								<input type="checkbox" id="chkAging" name="chk" value="Y" tabindex="305"/>
							</td>
							<td>
								<label for="chkAging">By Aging</label>
							</td>
						</tr>						
					</table>
				</div>
			</div>
			
			<div id="printDialogFormDiv" class="sectionDiv" style="width: 50.8%; height: 110px; margin: 2px 0 0 1px; padding: 15px 22px 15px 8px;" align="center">
				<table style="float: left; padding: 1px 0px 0px 15px;">
					<tr>
						<td class="rightAligned">Destination</td>
						<td class="leftAligned">
							<select id="selDestination" style="width: 200px;" tabindex="401">
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
							<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="rdoFileType" style="margin: 2px 5px 4px 40px; float: left;" checked="checked" disabled="disabled" tabindex="402"><label for="rdoPdf" style="margin: 2px 0 4px 0">PDF</label>
							<!-- removed print to excel option by robert SR 5291 02.10.2016
							<input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="rdoFileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="403"><label for="excelRB" style="margin: 2px 0 4px 0">Excel</label> -->
							<input value="CSV" title="CSV" type="radio" id="rdoCsv" name="rdoFileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="403"><label for="rdoCsv" style="margin: 2px 0 4px 0">CSV</label> <!-- CarloR SR-5346 06.27.2016 -->
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Printer</td>
						<td class="leftAligned">
							<select id="printerName" style="width: 200px;" tabindex="404">
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
							<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="integerNoNegativeUnformattedNoComma" tabindex="405"/>
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
	setModuleId("GIACS121");
	setDocumentTitle("Print Incoming Facultative RI Statement of Accounts");
	var dateTag = "";
	var currTag = "";
	var commTag = "";
	var agingTag = "";
	var printTag = false;
	
	function initializeSOAFaculRi() {
		togglePrintFields("screen");
		$("rdoAcctEntryDate").checked = true;
		dateTag = "AC";
		commTag = "D";
		agingTag = "N";
		currTag = "N";
		$("rdoWithoutComm").checked = true;
		$("txtLineName").value = "ALL LINES";
		$("txtRiName").value = "ALL REINSURERS";
		$("txtFromDate").value = dateFormat('${lastExtractSOAFaculRi.fromDate}', 'mm-dd-yyyy');
		$("txtToDate").value = dateFormat('${lastExtractSOAFaculRi.toDate}', 'mm-dd-yyyy');
		$("txtCutOffDate").value = dateFormat('${lastExtractSOAFaculRi.toDate}', 'mm-dd-yyyy');
	}
	
	function extractSOAFaculRi() {
		new Ajax.Request(contextPath+"/GIACReinsuranceReportsController", {
			parameters: {
				action: "extractSOAFaculRi",
				dateTag: dateTag,
				currTag: currTag,
				fromDate: $F("txtFromDate"),
				toDate: $F("txtToDate"),
				cutOffDate: $F("txtCutOffDate"),
				lineCd: $F("txtLineCd"),
				riCd: $F("txtRiCd"),
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function() {
				showNotice("Please wait...processing extract.");
			},
			onComplete: function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					showMessageBox(response.responseText, imgMessage.INFO);
				}
			}
		});
	}	
	
	function showLineLOV(text) {
		try {
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getSOAFaculRiLineLOV",
					  riCd : $("txtRiCd").value,
					search : ($F("txtLineName") == "ALL LINES" && $F("txtLineCd") == "") ? "%" : text 
				},
				title : "List of Available Lines",
				width : 370,
				height : 390,
				autoSelectOneRecord : true,
				filterText : $F("txtLineCd") != "" ? $F("txtLineCd") : "%",
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
				onSelect : function(row) {
					$("txtLineCd").value = row.lineCd;
					$("txtLineName").value = row.lineName;
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		} catch (e) {
			showErrorMessage("Line LOV", e);
		}
	}
	
	function showRiLOV(text) {
		try {
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getSOAFaculRiLOV",
					search : ($F("txtRiName") == "ALL REINSURERS" && $F("txtRiCd") == "") ? "%" : text//text.value == "ALL REINSURERS" ? "" : text.value
				},
				width : 370,
				height : 390,
				autoSelectOneRecord : true,
				filterText : $F("txtRiCd") != "" ? $F("txtRiCd") : "%",
				columnModel : [ 
				    {
						id : "riCd",
						title : "RI Code",
						width : '100px'
					}, 
					{
						id : "riName",
						title : "RI Name",
						width : '250px'
					}
				],
				draggable : true,
				onSelect : function(row) {
					$("txtRiCd").value = row.riCd;
					$("txtRiName").value = row.riName;
					if ($F("txtLineCd") == "") {
						$("txtLineCd").value = "";
						$("txtLineName").value = "ALL LINES";
					}
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		} catch (e) {
			showErrorMessage("RI LOV", e);
		}
	}
	
	function checkAllDates() {
		check = true;
		$$("input[type='text'].date").each(function(m) {
			if (m.value == "") {
				check = false;
				customShowMessageBox(objCommonMessage.REQUIRED, "I", m.id);
				return false;
			}
		});
		return check;
	}
	
	function validateDates(field) {
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g, "/")) : "";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g, "/")) : "";

		if (fromDate > toDate && toDate != "") {
			if (field == "txtFromDate") {
				customShowMessageBox("From Date should not be later than To Date.", "I", "txtFromDate");
				//customShowMessageBox("From date must not be later than to date.", "I", "txtFromDate");
			} else {
				customShowMessageBox("From Date should not be later than To Date.", "I", "txtToDate");
				//customShowMessageBox("To date must not be earlier than the from date.", "I", "txtToDate");
			}
			$(field).clear();
			return false;
		}
	}
	
	function getParams() {
		var params = "&lineCd=" + $("txtLineCd").value 
			+ "&riCd=" + $("txtRiCd").value 
			+ "&fromDate=" + $("txtFromDate").value
			+ "&toDate=" + $("txtToDate").value 
			+ "&cutOffDate=" + $("txtCutOffDate").value 
			+ "&comm=" + commTag
			+ "&aging=" + agingTag;
		return params;
	}
	
	function printReport(reportId, reportTitle){
		try {
			var content = contextPath + "/ReinsuranceReportController?action=printReport"
							+"&reportId="+ reportId
							+ getParams();
			
			if("screen" == $F("selDestination")){
				showPdfReport(content, reportTitle);
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {noOfCopies : $F("txtNoOfCopies"),
						  	      printerName : $F("printerName")},
					onCreate: showNotice("Processing, please wait..."),				
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							
						}
					}
				});
			}else if("file" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "file",
						fileType : $("rdoPdf").checked ? "PDF" : "CSV2"}, //modified by Daniel Marasigan SR 5347 07.05.2016
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							copyFileToLocal(response, $("rdoPdf").checked ? "reports" : "csv");
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
	
	function printSOAFaculRiReport() {
		if ($("chkSummary").checked == true) {
			if($("rdoPdf").checked){ //modified by Daniel Marasigan SR 5348 07.07.2016
				printReport("GIACR121B", "Aging of Premium Receivables - Facultative");
			}else if ($("rdoCsv").checked && $F("selDestination") == "file"){
				printReport("GIACR121B_CSV", "Aging of Premium Receivables - Facultative"); 
			}
		}else {
			if (commTag == "C" && agingTag == "Y" && currTag == "N"){
				printReport("GIACR164", "Facultative Premium (w/aging)");
			}else if (commTag == "C" && agingTag == "Y" && currTag == "Y"){
				printReport("GIACR164C", "Facultative RI Statement of Account with Aging (By Currency)");
			}else {
				if (commTag == "C" && agingTag == "N" && currTag == "Y") {
					printReport("GIACR224C", "Facultative RI Statement of Account (With Commission, By Currency)");
				}else if (commTag == "C" && agingTag == "N" && currTag == "N") { //modified by Daniel Marasigan SR 5347 07.05.2016
					if ($("rdoPdf").checked){
						printReport("GIACR224", "Facultative Premiums Statement of Accounts With Commission");
					} else if ($("rdoCsv").checked && $F("selDestination") == "file"){
						printReport("GIACR224_CSV", "Facultative Premiums Statement of Accounts With Commission");
					}
				}else if (commTag == "D" && agingTag == "N" && currTag == "Y") {
					printReport("GIACR121C", "Facultative RI Statement of Account (Without Commission, By Currency)");
				}else if (commTag == "D" && agingTag == "N" && currTag == "N") {
					printReport("GIACR121", "Facultative Premiums Statement of Accounts");
				}else if (commTag == "D" && agingTag == "Y" && currTag == "Y") {
					printReport("GIACR164C", "Facultative RI Statement of Account with Aging (By Currency)");
				}else if (commTag == "D" && agingTag == "Y" && currTag == "N") {
					printReport("GIACR164", "Facultative Premium (w/aging)");
				}
			}
		}
	}
	
	function checkLastExtract2() { //Added by Jerome 10.19.2016 SR 5674
		new Ajax.Request(contextPath + "/GIACReinsuranceReportsController", {
			parameters : {
				action : "checkLastExtractSOAFaculRi"
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response) {
				if (checkErrorOnResponse(response)) {
					var lastExtract = JSON.parse(response.responseText);
						if ($("txtFromDate").value == dateFormat(lastExtract.fromDate, 'mm-dd-yyyy') && 
							$("txtToDate").value == dateFormat(lastExtract.toDate, 'mm-dd-yyyy') &&
							$("txtCutOffDate").value == dateFormat(lastExtract.cutOff, 'mm-dd-yyyy')) {
							showConfirmBox("Re-extract", "Data has been extracted within this specified period. Do you wish to continue extraction?", "Yes", "No",
									extractSOAFaculRi, null, null);
						} else {
							extractSOAFaculRi();
						}
				}
			}
		});
	}
	
	function checkLastExtract() {
		try {
			new Ajax.Request(contextPath + "/GIACReinsuranceReportsController", {
				parameters : {
					action : "checkLastExtractSOAFaculRi"
				},
				asynchronous : false,
				evalScripts : true,
				onComplete : function(response) {
					if (checkErrorOnResponse(response)) {
						var lastExtract = JSON.parse(response.responseText);
						if (printTag) {
							if ($("txtFromDate").value == dateFormat(lastExtract.fromDate, 'mm-dd-yyyy') && 
								$("txtToDate").value == dateFormat(lastExtract.toDate, 'mm-dd-yyyy') &&
								$("txtCutOffDate").value == dateFormat(lastExtract.cutOff, 'mm-dd-yyyy')) {
									printSOAFaculRiReport();
							} else {
								showConfirmBox("Extract", "The specified period has not been extracted. Do you want to extract the data using the specified period?", "Yes", "No", function() {
										new Ajax.Request(contextPath+"/GIACReinsuranceReportsController", {
											parameters: {
												action: "extractSOAFaculRi",
												dateTag: dateTag,
												currTag: currTag,
												fromDate: $F("txtFromDate"),
												toDate: $F("txtToDate"),
												cutOffDate: $F("txtCutOffDate"),
												lineCd: $F("txtLineCd"),
												riCd: $F("txtRiCd"),
											},
											asynchronous: false,
											evalScripts: true,
											onCreate: function() {
												showNotice("Please wait...processing extract.");
											},
											onComplete: function(response) {
												hideNotice();
												if (checkErrorOnResponse(response)) {
													showWaitingMessageBox(response.responseText, imgMessage.INFO, printSOAFaculRiReport);
												}
											}
										});
					 			}, null, null);
							} 
							printTag = false;
						}else {
							if ($("txtFromDate").value == dateFormat(lastExtract.fromDate, 'mm-dd-yyyy') && 
								 	 $("txtToDate").value == dateFormat(lastExtract.toDate, 'mm-dd-yyyy') &&
									 $("txtCutOffDate").value == dateFormat(lastExtract.cutOff, 'mm-dd-yyyy')) {
									showConfirmBox("Re-extract", "Data has been extracted within this specified period. Do you wish to continue extraction?", "Yes", "No",
										extractSOAFaculRi, null, null);
								} else {
									extractSOAFaculRi();
								} 
							}
						}
				}
			});
		} catch (e) {
			showErrorMessage("checkLastExtract", e);
		}
	}
	
	function checkLov(action, cd, desc, func, message) {
		if ($(cd).value == "") {
			$(desc).value = message;
		} else {
			var output = validateTextFieldLOV("/AccountingLOVController?action=" + action + "&search=" + $(cd).value + "&riCd=" + $("txtRiCd").value, $(cd).value, "Searching, please wait...");
			if (output == 2) {
				func();
			} else if (output == 0) {
				//$(cd).clear();
				//$(desc).value = message;
				//customShowMessageBox($(cd).getAttribute("name") + " does not exist.", "I", cd);
				$(desc).value = "";
				func();
				if ($(cd).value == "ALL LINES") {
					$("txtLineCd").clear();
				}else if ($(cd).value == "ALL REINSURERS") {
					$("txtRiCd").clear();
				}
			} else {
				func();
			}
		}
	}
	
	$("imgSearchLineCdLOV").observe("click", function() {
		showLineLOV("%");
	});
	
// 	$("imgSearchLineNameLOV").observe("click", function() {
// 		showLineLOV($("txtLineName"));
// 	});
	
	$("imgSearchRiCdLOV").observe("click", function() {
		showRiLOV("%");
	});
	
// 	$("imgSearchRiNameLOV").observe("click", function() {
// 		showRiLOV($("txtRiName"));
// 	});
	
	$("txtLineCd").observe("change", function() {
		checkLov("getSOAFaculRiLineLOV", "txtLineCd", "txtLineName", function() {
			showLineLOV($F("txtLineCd"));	
		}, "ALL LINES");
	});
	
	$("txtLineName").observe("change", function() {
		if ($("txtLineName").value == "ALL LINES" || $("txtLineName").value == "") {
			$("txtLineCd").clear();
		}
		
		checkLov("getSOAFaculRiLineLOV", "txtLineName", "txtLineName", function() {
			showLineLOV($F("txtLineName"));	
		}, "ALL LINES");
	});
	
	$("txtRiCd").observe("change", function() {
// 		if (isNaN($F("txtRiCd"))) {
// 			showMessageBox("RI Code must be a number.", imgMessage.INFO);
// 			$("txtRiCd").clear();
// 		}else {
			checkLov("getSOAFaculRiLOV", "txtRiCd", "txtRiName", function() {
				showRiLOV($F("txtRiCd"));
			}, "ALL REINSURERS");
// 		}
	});
	
	$("txtRiName").observe("change", function() {
		if ($("txtRiName").value == "ALL REINSURERS" || $("txtRiName").value == "") {
			$("txtRiCd").clear();
		}
		
		checkLov("getSOAFaculRiLOV", "txtRiName", "txtRiName", function() {
			showRiLOV($F("txtRiName"));
		}, "ALL REINSURERS");
	});
	
	$("txtFromDate").observe("focus", function() {
		if ($("imgFromDate").disabled == true) return;
		validateDates("txtFromDate");
	});
	
	$("txtToDate").observe("focus", function() {
		if ($("imgToDate").disabled == true) return;
		validateDates("txtToDate");
	});
	
	$("chkCurrency").observe("click", function() {
		if ($("chkCurrency").checked == true) {
			currTag = $F("chkCurrency");
		}else {
			currTag = "N";
		}
	});
	
	$("chkAging").observe("click", function() {
		if ($("chkAging").checked == true) {
			agingTag = $F("chkAging");
		}else {
			agingTag = "N";
		}
	});
	
	$$("input[name='commission']").each(function(comm) {
		comm.observe("click", function() {
			if ($(comm).checked == true) {
				commTag = $F(comm);
			}
		});
	});
	
	$$("input[name='rdo']").each(function(radio) {
		radio.observe("click", function() {
			if ($(radio).checked == true) {
				dateTag = $F(radio);
			}
		});
	});
	
	function togglePrintFields(dest) {
		if (dest == "printer") {
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
			$("rdoCsv").disable(); //added CSV option by Daniel Marasigan SR 5347 07.05.2016
			//$("rdoExcel").disable(); removed print to excel option by robert SR 5291 02.10.2016
		} else {
			if (dest == "file") {
				$("rdoPdf").enable();
				$("rdoCsv").enable(); //added CSV option by Daniel Marasigan SR 5347 07.05.2016
				//$("rdoExcel").enable(); removed print to excel option by robert SR 5291 02.10.2016
			} else {
				$("rdoPdf").disable();
				$("rdoCsv").disable(); //added CSV option by Daniel Marasigan SR 5347 07.05.2016
				//$("rdoExcel").disable(); removed print to excel option by robert SR 5291 02.10.2016
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
		togglePrintFields(dest);
	});	
	
	$("btnExtract").observe("click", function() {
		if (checkAllDates()) {
			//extractSOAFaculRi();
			//checkLastExtract();
			checkLastExtract2();
		}
	});
	
	$("btnPrint").observe("click", function() {
		printTag = true;
		var dest = $F("selDestination");
		if(dest == "printer"){
			if(checkAllRequiredFieldsInDiv("printDialogFormDiv")){
				if (checkAllDates()) {
					checkLastExtract();
				}
			}
		}else{
			if (checkAllDates()) {
				checkLastExtract();		
			}
		}
	});

	$("soaFaculRiExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});
	
	initializeSOAFaculRi();
	observeBackSpaceOnDate("txtFromDate");
	observeBackSpaceOnDate("txtToDate");
	observeBackSpaceOnDate("txtCutOffDate");
</script>