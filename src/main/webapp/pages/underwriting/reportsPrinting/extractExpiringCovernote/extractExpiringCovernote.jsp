<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="extractExpiringCovernoteMainDiv" name="extractExpiringCovernoteMainDiv">
	<div id="extractExpiringCovernoteMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Extract Expiring Covernote Records</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div class="sectionDiv" id="extractExpiringCovernoteBody">
		<div class="sectionDiv" id="extractExpiringCovernote" style="width: 70%; height: 430px; margin-top: 40px; margin-left: 135px; margin-bottom: 50px;">
			<div class="sectionDiv" id="dateParametersDiv" style="width: 97%; margin-left: 8px; margin-top: 9px; float: left;">
				<div id="byDateDiv" style="width: 100%; height: 85px;">
					<table>
						<tr>
							<td>
								<input type="radio" id="rdoByDate" name="dateOption" value="D" style="margin-left: 15px; float: left;" checked=""/>
								<label for="rdoByDate" style="margin-top: 3px;">By Date</label>
							</td>
							<td>
								<input type="radio" id="rdoByMonthYear" name="dateOption" value="M" style="margin-left: 15px; float: left; margin-left: 50px;" checked=""/>
								<label for="rdoByMonthYear" style="margin-top: 3px;">By Month/Year</label>
							</td>
						</tr>
						</tr>
						<tr>
							<td>
								<label style="margin-left: 40px; margin-top: 8px;">From</label>
								<div id="txtFromDateDiv" style="float: left; border: solid 1px gray; width: 180px; height: 20px; margin-left: 10px; margin-top: 5px;">
									<input type="text" id="txtFromDate" style="float: left; margin-top: 0px; margin-right: 3px; width: 150px; height: 14px; border: none;" name="txtFromDate" readonly="readonly" tabindex="1"/>
									<img id="imgFromDate" alt="imgFromDate" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"/>
								</div>
							</td>
							<td>
								<label style="margin-left: 80px; margin-top: 8px;">From</label>
								<div id="optionMonthDiv" style="float: left; width: 220px; height: 20px; margin-left: 10px; margin-top: 5px;">
									<select style="width: 128px;" id="fromMonth" name="fromMonth" class="mandatoryEnchancement" tabindex="2">
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
									<input class="integerNoNegativeUnformattedNoComma" type="text" id="txtFromYear" name="txtFromYear" maxlength="4" style="float: right; margin-top: 0px; margin-right: 40px; width: 40px; height: 13px; text-align: right;" tabindex="3" min="1" max="9999" errorMsg2="Entered Year is invalid. Valid value is from 1 to 9999."/>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<label style="margin-left: 55px; margin-top: 8px;">To</label>
								<div id="txtToDateDiv" style="float: left; border: solid 1px gray; width: 180px; height: 20px; margin-left: 10px; margin-top: 5px;">
									<input type="text" id="txtToDate" style="float: left; margin-top: 0px; margin-right: 3px; width: 150px; height: 14px; border: none; " name="txtTodate" readonly="readonly" tabindex="4"/>
									<img id="imgToDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"/>
								</div>
							</td>
							<td>
								<label style="margin-left: 95px; margin-top: 8px;">To</label>
								<div id="optionMonthDiv" style="float: left; width: 220px; height: 20px; margin-left: 10px; margin-top: 5px;">
									<select style="width: 128px;" id="toMonth" name="toMonth" class="mandatoryEnchancement" tabindex="5">
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
									<input class="integerNoNegativeUnformattedNoComma" type="text" id="txtToYear" name="txtToYear" maxlength="4" style="float: right; margin-top: 0px; margin-right: 40px; width: 40px; height: 13px;text-align: right;" tabindex="6" min="1" max="9999" errorMsg2="Entered Year is invalid. Valid value is from 1 to 9999."/>
								</div>
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div class="sectionDiv" id="otherParametersDiv" style="width: 97%; margin-left: 8px; margin-top: 5px; float: left;">
				<table align="center" style="padding: 10px;">
					<tr>
						<td>
							<input type="radio" id="rdoBySource" name="branchOption" value="Issuing Source" style="margin-left: 15px; float: left;" checked=""/>
							<label for="rdoBySource" style="margin-top: 3px;">Issuing Source</label>
						</td>
						<td>
							<input type="radio" id="rdoByCredBranch" name="branchOption" value="Crediting Branch" style="margin-left: 15px; float: left; margin-left: 50px;" checked=""/>
							<label for="rdoByCredBranch" style="margin-top: 3px;">Crediting Branch</label>
						</td>
					</tr>
				</table>
				<table align="center" style="padding: 5px; width: 100%;">
					<tr>
						<td class="rightAligned" style="width: 120px;">Line</td>
						<td colspan="5">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="rightAligned" ignoreDelKey="" type="text" id="txtLineCd" name="txtLineCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px; text-align: left;" tabindex="7" maxlength="2"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchLineCd" name="imgSearchLineCd" alt="Go" style="float: right;"/>
							</span>
							<span class="lovSpan" style="width:331px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="leftAligned" type="text" id="txtLineName" name="txtLineName"  value="ALL LINES" readonly="readonly" style="width: 300px; float: left; margin-right: 4px; border: none; height: 13px;" tabindex="8"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchLineName" name="imgSearchLineName" alt="Go" style="float: right;"/>
							</span>								
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 120px;">Subline</td>
						<td colspan="5">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="rightAligned" ignoreDelKey="" type="text" id="txtSublineCd" name="txtSublineCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px; text-align: left;" tabindex="9" maxlength="7"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchSublineCd" name="imgSearchSublineCd" alt="Go" style="float: right;"/>
							</span>
							<span class="lovSpan" style="width:331px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="leftAligned" type="text" id="txtSublineName" name="txtSublineName"  value="ALL SUBLINES" readonly="readonly" style="width: 300px; float: left; margin-right: 4px; border: none; height: 13px;" tabindex="10"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchSublineName" name="imgSearchSublineName" alt="Go" style="float: right;"/>
							</span>								
						</td>
					</tr>
					<tr>
						<td class="rightAligned" id="issCred" style="width: 120px;">Issuing Source</td>
						<td colspan="5">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="rightAligned" ignoreDelKey="" type="text" id="txtIssCd" name="txtIssCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px; text-align: left;" tabindex="11" maxlength="2"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchIssCd" name="imgSearchIssCd" alt="Go" style="float: right;"/>
							</span>
							<span class="lovSpan" style="width:331px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="leftAligned" type="text" id="txtIssName" name="txtIssName"  value="ALL ISSUING SOURCES" readonly="readonly" style="width: 300px; float: left; margin-right: 4px; border: none; height: 13px;" tabindex="12"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchIssName" name="imgSearchIssName" alt="Go" style="float: right;"/>
							</span>								
						</td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="otherParametersDiv" style="width: 97%; margin-left: 8px; margin-top: 5px; float: left;">
				<table id="printDialogMainTab" name="printDialogMainTab" align="center" style="padding: 10px;">
					<tr>
						<td style="text-align:right; width: 27%;">Destination</td>
						<td style="width: 73%;">
							<select id="selDestination" style="margin-left:5px; width:73%;" >
								<option value="screen">Screen</option>
								<option value="printer">Printer</option>
								<option value="file">File</option>
								<option value="local">Local Printer</option>
							</select>
						</td>
					</tr>
					<tr id="trRdoFileType">
						<td style="width: 27%;">&nbsp;</td>
						<td style="width: 73%;">
							<table border="0">
								<tr>
									<td><input type="radio" style="margin-left:0px;" id="rdoPdf" name="rdoFileType" value="PDF" title="PDF" checked="checked" disabled="disabled" style="margin-left:10px;"/></td>
									<td><label for="rdoPdf"> PDF</label></td>
									<td style="width:30px;">&nbsp;</td>
									<!-- <td><input type="radio" id="rdoExcel" name="rdoFileType" value="XLS" title="Excel" disabled="disabled" /></td>
									<td><label for="rdoExcel"> Excel</label></td> --> <!-- Alejandro Burgos SR-5327 -->
									<td><input type="radio" id="rdoCsv" name="rdoFileType" value="CSV" title="CSV" disabled="disabled" /></td>
									<td><label for="rdoCsv"> CSV</label></td> <!-- Alejandro Burgos SR-5327 -->									
								</tr>									
							</table>
						</td>
					</tr>
					<tr>
						<td style="text-align:right; width: 27%;">Printer Name</td>
						<td style="width: 73%;">
							<select id="printerName" style="margin-left:5px; width:73%;">
								<option></option>
									<c:forEach var="p" items="${printers}">
										<option value="${p.name}">${p.name}</option>
									</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<td style="text-align:right; width: 27%;">No. of Copies</td>
						<td style="width: 73%;">
							<input type="text" id="txtNoOfCopies" style="margin-left:5px;float:left; text-align:right; width:179px;" class="integerNoNegativeUnformattedNoComma">
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
			<div id="ButtonsDiv" name="ButtonsDiv" class="buttonsDiv" style="">
				<input type="button" class="button" id="btnExtract" name="btnExtract" value="Extract" style="width:90px;" />
				<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width:90px;" />
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	setModuleId("GIUTS031");
	setDocumentTitle("Extract Expiring Covernote");
	var fromMonth;
	var toMonth;
	var paramType = 'D';
	var credBranchParam = '1';
	var vFrom;
	var vTo;
	var noExtrDataFlag = "Y";
	
	$("btnPrint").observe("click", function(){
		checkParameters("P");
	});
	
	function printReport(){
		try {
			if($F("selDestination") == "printer"){
				if($F("printerName") == "" || $F("txtNoOfCopies") == ""){
					showMessageBox("Required fields must be entered.", "I");
					return false;
				}
				
				if(isNaN($F("txtNoOfCopies")) || ($F("txtNoOfCopies") < 1 || $F("txtNoOfCopies") > 100)){
					showMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I");
					$("txtNoOfCopies").value = "";
					return false;
				}
			}	
			
			var content = contextPath + "/GIUTSPrintReportController?action=printReport"
            + "&reportId=" + 'GIPIR198'
            + getParams();
			
			if("screen" == $F("selDestination")){
				showPdfReport(content, "");
			} else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
						parameters : {
							  printerName : $F("printerName"),
							  noOfCopies : $F("txtNoOfCopies")
					},
					onCreate: showNotice("Processing, please wait..."),				
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing complete.", "S");
						}
					}
				});
			} else if("file" == $F("selDestination")){
// 				new Ajax.Request(content, {
// 					parameters : {destination : "file",
// 								  fileType : $("rdoPdf").checked ? "PDF" : "XLS"},
// 					onCreate: showNotice("Generating report, please wait..."),
// 					onComplete: function(response){
// 						hideNotice();
// 						if (checkErrorOnResponse(response)){
// 							copyFileToLocal(response, "reports");
// 						}
// 					}
// 				});

				//added by Alejandro Burgos Jr. 02.09.2016
				var fileType = "PDF";
		
				if($("rdoPdf").checked)
					fileType = "PDF";
				else if ($("rdoCsv").checked)
					fileType = "CSV"; 
				//end add here
				
				new Ajax.Request(content, {
					parameters : {destination : "FILE",
					  fileType : /*$("rdoPdf").checked ? "PDF" : "XLS"*/fileType}, //comment by Alejandro Burgos Jr. 02.10.2016
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							if($("geniisysAppletUtil") == null || $("geniisysAppletUtil").copyFileToLocal == undefined){
								showMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", imgMessage.ERROR);
							} else {
								//added by Alejandro Burgos Jr. 02.10.2016
								if(fileType == "CSV") {
									var message = $("geniisysAppletUtil").copyFileToLocal(response.responseText, "csv");
									deleteCSVFileFromServer(response.responseText);
								}else{
									var message = $("geniisysAppletUtil").copyFileToLocal(response.responseText, "reports");
								}
								//end add here								
								//comment by Alejandro Burgos Jr. 02.10.2016
								/* var message = $("geniisysAppletUtil").copyFileToLocal(response.responseText, "reports"); */
								if(message.include("SUCCESS")){
									showMessageBox("Report file generated to " + message.substring(9), "I");	
								} else {
									showMessageBox(message, "E");
								}
							}
						}
					}
				});
			} else if("local" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "LOCAL"},
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
	
	function getParams(){
		var params = "&pStartingDate=" + vFrom
		+ "&pEndingDate=" + vTo;
		
		return params;
	}
	
	$("btnExtract").observe("click", function(){
		checkParameters("E");			
	});
	
	function checkParameters(func){
		if(paramType == 'M'){
			if($F("fromMonth") == "" || $F("toMonth") == "" || $F("txtFromYear") == "" || $F("txtToYear") == ""){
				showMessageBox("Required fields must be entered.","I");
				return false;
			}
			
			fromMonth = document.getElementById("fromMonth").value;
			toMonth = document.getElementById("toMonth").value;
			
			var paramFromDate = parseInt($F("txtFromYear")) + (parseInt(fromMonth) / 12);
			var paramToDate = parseInt($F("txtToYear")) + (parseInt(toMonth) / 12);
			
			if(paramFromDate > paramToDate){
				showMessageBox("From date must be earlier than To date.","I");
				return false;
			}
		} else if(paramType == 'D'){
			if($F("txtFromDate") == "" || $F("txtToDate") == ""){
				showMessageBox("Required fields must be entered.","I");
				return false;
			}
		}
		
		if(func == 'E'){
			if(validateExtractParameters() == 'N'){
				extractGIUTS031();	
			} else {
				showConfirmBox("Confirmation", "Data has been extracted within the specified parameter/s. Do you wish to continue extraction?", "Yes", "No",
						function() {
							extractGIUTS031();
						}, "");
			}
		} else if(func == 'P'){
			if(validateExtractParameters() == 'Y'){
				printReport();	
			} else {
				if(noExtrDataFlag == "Y"){
					showMessageBox("Please extract records first.","I");
					return false;
				} else {
					showConfirmBox("Confirmation", "The specified parameter/s has not been extracted. Do you want to extract the data using the specified parameter/s?", "Yes", "No",
							function() {
								extractGIUTS031();
							}, "");	
				}
			}
		}
		
	}
	
	function validateExtractParameters(){
		try {
			var result = 'N';
			new Ajax.Request(contextPath+"/ExtractExpiringCovernoteController",{
				method: "POST",
				parameters : {
					action : "validateExtractParameters"
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Loading, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						var res = JSON.parse(response.responseText);
						result = compareParameters(res);
					}
				}
			});
			
			return result;
		} catch (e) {
			showErrorMessage("validateExtract",e);
		}
	}
	
	function compareParameters(params){
		var result = "N";
		if(params.pUserId != null){
			if(params.pParamType == "D"){
				if(params.pFromDate == $F("txtFromDate") && params.pToDate == $F("txtToDate")){
					if(nvl(params.pLineCd, "") == $F("txtLineCd") && nvl(params.pSublineCd, "") == $F("txtSublineCd") && nvl(params.pIssCd, "") == $F("txtIssCd")){
						if((params.pCredBranchParam == "1" && $("rdoBySource").checked == true) || (params.pCredBranchParam == "2" && $("rdoByCredBranch").checked == true)){
							result = "Y";	
						}
					}
				}
			} else if(params.pParamType == "M"){
				if(params.pFromMonth == getSelectedText('fromMonth') && params.pFromYear == $F("txtFromYear") && 
				   params.pToMonth == getSelectedText('toMonth') && params.pToYear == $F("txtToYear")){
					if(nvl(params.pLineCd, "") == $F("txtLineCd") && nvl(params.pSublineCd, "") == $F("txtSublineCd") && nvl(params.pIssCd, "") == $F("txtIssCd")){
						if((params.pCredBranchParam == "1" && $("rdoBySource").checked == true) || (params.pCredBranchParam == "2" && $("rdoByCredBranch").checked == true)){
							result = "Y";	
						}
					}
				}
			}
		}
		
		return result;
	}
	
	function getSelectedText(elementId) {
	    var elt = document.getElementById(elementId);

	    if (elt.selectedIndex == -1)
	        return null;

	    return elt.options[elt.selectedIndex].text;
	}
	
	function extractGIUTS031(){
		try {
			new Ajax.Request(contextPath+"/ExtractExpiringCovernoteController",{
				method: "POST",
				parameters : {action : "extractGIUTS031",
							  paramType : paramType,
							  fromDate : $F("txtFromDate"),
							  toDate : $F("txtToDate"),
							  fromMonth : getSelectedText('fromMonth'),
							  fromYear : $F("txtFromYear"),
							  toMonth : getSelectedText('toMonth'),
							  toYear : $F("txtToYear"),
							  lineCd : $F("txtLineCd"),
							  sublineCd : $F("txtSublineCd"),
							  issCd : $F("txtIssCd"),
							  credBranchParam : credBranchParam
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Extracting, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					var result = JSON.parse(response.responseText);
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						if (result.exist == "0") {
							showMessageBox("Extraction finished. No records extracted.","I");
							noExtrDataFlag = "X";
						}else{
							showMessageBox("Extraction finished. " + result.exist + " records extracted.", imgMessage.SUCCESS);
							vFrom = result.vFrom;
							vTo = result.vTo;
							noExtrDataFlag = "N";
						}
					}
				}
			});
		} catch (e) {
			showErrorMessage("extractGIUTS031",e);
		}		
	}
	
	/* function getGIUTS031LineLOV(){
		LOV.show({
			controller: 'UnderwritingLOVController',
			urlParameters: {
				action:		"getGIUTS031LineLOV",
				moduleId:   "GIUTS031",
				issCd:      $F("txtIssCd")
			},
			title: "Valid Values Line",
			width: 405,
			height: 386,
			draggable: true,
			columnModel: [
				{
					id: "lineCd",
					title: "Line Code",
					width: "80px"
				},
				{
					id: "lineName",
					title: "Line Name",
					width: "227px"
				},
				{
					id: "packPolFlag",
					title: "Package",
					width: "80px"
				}
			],
			onSelect: function(row){
				if(row != undefined){
					$("txtLineCd").value = row.lineCd;
					$("txtLineName").value = row.lineName;
				}
			}
		});
	}
	
	$("imgSearchLineCd").observe("click", function(){
		getGIUTS031LineLOV();
	});
	
	$("imgSearchLineName").observe("click", function(){
		getGIUTS031LineLOV();
	});
	
	function getGIUTS031SublineLOV(){
		LOV.show({
			controller: 'UnderwritingLOVController',
			urlParameters: {
				action:		"getGIUTS031SublineLOV",
				moduleId:   "GIUTS031",
				lineCd:      $F("txtLineCd")
			},
			title: "Valid Values Subline",
			width: 405,
			height: 386,
			draggable: true,
			columnModel: [
				{
					id: "sublineCd",
					title: "Subline Code",
					width: "80px"
				},
				{
					id: "sublineName",
					title: "Subline Name",
					width: "310px"
				},
			],
			onSelect: function(row){
				if(row != undefined){
					$("txtSublineCd").value = row.sublineCd;
					$("txtSublineName").value = row.sublineName;
				}
			}
		});
	}
	
	$("imgSearchSublineCd").observe("click", function(){
		if($F("txtLineCd") == "" || $F("txtLineCd") == null || $F("txtLineName") == "" || $F("txtLineName") == null){
			showMessageBox("Insert a value to LINE_CD field first.","I");
		} else {
			getGIUTS031SublineLOV();	
		}
	});
	
	$("imgSearchSublineName").observe("click", function(){
		if($F("txtLineCd") == "" || $F("txtLineCd") == null || $F("txtLineName") == "" || $F("txtLineName") == null){
			showMessageBox("Insert a value to LINE_CD field first.","I");
		} else {
			getGIUTS031SublineLOV();	
		}
	});
	
	function getGIUTS031IssueLOV(){
		LOV.show({
			controller: 'UnderwritingLOVController',
			urlParameters: {
				action:		"getGIUTS031IssueLOV",
				moduleId:   "GIUTS031",
				lineCd:      $F("txtLineCd")
			},
			title: "Valid Values Issuing Code",
			width: 405,
			height: 386,
			draggable: true,
			columnModel: [
				{
					id: "issCd",
					title: "Subline Code",
					width: "80px"
				},
				{
					id: "issName",
					title: "Subline Name",
					width: "310px"
				},
			],
			onSelect: function(row){
				if(row != undefined){
					$("txtIssCd").value = row.issCd;
					$("txtIssName").value = row.issName;
				}
			}
		});
	} 
	
	$("imgSearchIssCd").observe("click", function(){
		getGIUTS031IssueLOV();
	});
	
	$("imgSearchIssName").observe("click", function(){
		getGIUTS031IssueLOV();
	}); */
	
	/* function validateFromToDate(elemNameFr, elemNameTo, currElemName){
		var isValid = true;		
		var elemDateFr = Date.parse($F(elemNameFr), "mm-dd-yyyy");
		var elemDateTo = Date.parse($F(elemNameTo), "mm-dd-yyyy");
		
		var output = compareDatesIgnoreTime(elemDateFr, elemDateTo);
		if(output < 0){
			if(currElemName == elemNameFr){
				showMessageBox("The date you entered is LATER THAN the TO DATE.", "E");
				$("txtToDate").value = "";
				$("txtFromDate").value = "";
			} else {
				showMessageBox("The date you entered is EARLIER THAN the FROM DATE.", "E");
				$("txtToDate").value = "";
				$("txtFromDate").value = "";
			}
			$(currElemName).focus();
			isValid = false;
		}
		return isValid;
	}
	
	function validateDateFormat(strValue, elemName){
		var text = strValue; 
		var comp = text.split('-');
		var m = parseInt(comp[0], 10);
		var d = parseInt(comp[1], 10);
		var y = parseInt(comp[2], 10);
		var status = true;
		var isMatch = text.match(/^(\d{1,2})-(\d{1,2})-(\d{4})$/);
		var date = new Date(y,m-1,d);
		
		if(isNaN(y) || isNaN(m) || isNaN(d) || y.toString().length < 4 || !isMatch ){
			customShowMessageBox("Date must be entered in a format like MM-DD-RRRR.", imgMessage.INFO, elemName);
			status = false;
		}
		if(0 >= m || 13 <= m){
			customShowMessageBox("Month must be between 1 and 12.", imgMessage.INFO, elemName);	
			status = false; 
		}
		if(date.getDate() != d){				
			customShowMessageBox("Day must be between 1 and the last of the month.", imgMessage.INFO, elemName);	
			status = false;
		}
		if(!status){
			$(elemName).value = "";
		}
		return status;
	}
	
	$("txtFromDate").observe("blur", function(){
		if($F("txtFromDate") != "" && validateDateFormat($F("txtFromDate"), "txtFromDate")){
			if($F("txtToDate") != "" && validateDateFormat($F("txtToDate"), "txtToDate")){
				validateFromToDate("txtFromDate", "txtFromDate", "txtFromDate");
			}
		}
	});
	
	$("txtToDate").observe("blur", function(){
		if($F("txtToDate") != "" && validateDateFormat($F("txtToDate"), "txtToDate")){
			if($F("txtFromDate") != "" && validateDateFormat($F("txtFromDate"), "txtFromDate")){
				validateFromToDate("txtFromDate", "txtToDate", "txtToDate");
			}
		}
	}); */
	
	$("txtFromDate").observe("focus", function(){
		if ($("txtToDate").value != "" && this.value != "") {
			if (compareDatesIgnoreTime(Date.parse($F("txtFromDate")),Date.parse($("txtToDate").value)) == -1) {
				customShowMessageBox("From date must be earlier than To date.","I","txtFromDate");
				this.clear();
			}
		}
	});
	
	$("txtToDate").observe("focus", function(){
		if ($("txtFromDate").value != ""&& this.value != "") {
			if (compareDatesIgnoreTime(Date.parse($F("txtFromDate")),Date.parse($("txtToDate").value)) == -1) {
				customShowMessageBox("From date must be earlier than To date.","I","txtToDate");
				this.clear();
			}
		}
	});
	
	$("fromMonth").observe("change", function(){
		if($F("txtFromYear") != ""){
			if($F("toMonth") != "" && $F("txtToYear") != ""){
				fromMonth = document.getElementById("fromMonth").value;
				toMonth = document.getElementById("toMonth").value;
				
				var paramFromDate = parseInt($F("txtFromYear")) + (parseInt(fromMonth) / 12);
				var paramToDate = parseInt($F("txtToYear")) + (parseInt(toMonth) / 12);
				
				if(paramFromDate > paramToDate){
					showMessageBox("From date must be earlier than To date.","I");
					this.clear();
				}
			}	
		}
	});
	
	$("txtFromYear").observe("change", function(){
// 		if($F("txtFromYear") != ""){
// 			showMessageBox("Entered Year is invalid. Valid value is from 1 to 9999.","I");
// 			this.clear();
// 		}
		
		if($F("fromMonth") != ""){
			if($F("toMonth") != "" && $F("txtToYear") != ""){
				fromMonth = document.getElementById("fromMonth").value;
				toMonth = document.getElementById("toMonth").value;
				
				var paramFromDate = parseInt($F("txtFromYear")) + (parseInt(fromMonth) / 12);
				var paramToDate = parseInt($F("txtToYear")) + (parseInt(toMonth) / 12);
				
				if(paramFromDate > paramToDate){
					showMessageBox("From date must be earlier than To date.","I");
					this.clear();
				}
			}	
		}
	});
	
	$("toMonth").observe("change", function(){
		if($F("txtToYear") != ""){
			if($F("fromMonth") != "" && $F("txtFromYear") != ""){
				fromMonth = document.getElementById("fromMonth").value;
				toMonth = document.getElementById("toMonth").value;
				
				var paramFromDate = parseInt($F("txtFromYear")) + (parseInt(fromMonth) / 12);
				var paramToDate = parseInt($F("txtToYear")) + (parseInt(toMonth) / 12);
				
				if(paramFromDate > paramToDate){
					showMessageBox("From date must be earlier than To date.","I");
					this.clear();
				}
			}	
		}
	});
	
	$("txtToYear").observe("change", function(){
// 		if($F("txtToYear") != ""){
// 			showMessageBox("Entered Year is invalid. Valid value is from 1 to 9999.","I");
// 			this.clear();
// 		}
		
		if($F("toMonth") != ""){
			if($F("fromMonth") != "" && $F("txtFromYear") != ""){
				fromMonth = document.getElementById("fromMonth").value;
				toMonth = document.getElementById("toMonth").value;
				
				var paramFromDate = parseInt($F("txtFromYear")) + (parseInt(fromMonth) / 12);
				var paramToDate = parseInt($F("txtToYear")) + (parseInt(toMonth) / 12);
				
				if(paramFromDate > paramToDate){
					showMessageBox("From date must be earlier than To date.","I");
					this.clear();
				}
			}	
		}
	});
	
	$("imgFromDate").observe("click", function(){
		scwShow($('txtFromDate'),this, null);
	});	
	
	$("imgToDate").observe("click", function(){
		scwShow($('txtToDate'),this, null);
	});
	
	$("selDestination").observe("change", function(){
		var destination = $F("selDestination");
		togglePrintFields(destination);
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
	
	function togglePrintFields(destination){
		if(destination == "printer"){
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
			//$("rdoExcel").disable(); //Alejandro Burgos SR-5327
			$("rdoCsv").disable(); //Alejandro Burgos SR-5327
		} else {
			if(destination == "file"){
				$("rdoPdf").enable();
				//$("rdoExcel").enable(); //Alejandro Burgos SR-5327
				$("rdoCsv").enable(); //Alejandro Burgos SR-5327	
			} else {
				$("rdoPdf").disable();
				//$("rdoExcel").disable(); //Alejandro Burgos SR-5327
				$("rdoCsv").disable(); //Alejandro Burgos SR-5327	
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
	
	observeReloadForm("reloadForm", showExtractExpiringCovernote);
	
	$("btnExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	function validateYear(year){
		var text = /^[0-9]+$/;
		if (year != "") {
			if ((year != "") && (!text.test(year))) {
				customShowMessageBox("Year must be a number.", imgMessage.INFO, year);
	        }
		}
	}
	
	$("txtFromYear").observe("blur", function(){
		validateYear($F("txtFromYear"));
	});
	
	$("txtToYear").observe("blur", function(){
		validateYear($F("txtToYear"));
	});
	
	function disableEnableSelect(option){
		if(option == "D"){
			month = document.getElementById("fromMonth").getElementsByTagName("option");
			for(var i = 0; i < month.length; i++){
				document.getElementById("fromMonth").options[i].disabled = true;
				document.getElementById("toMonth").options[i].disabled = true;
			}
		} else if(option == "E"){
			for(var i = 0; i < month.length; i++){
				document.getElementById("fromMonth").options[i].disabled = false;
				document.getElementById("toMonth").options[i].disabled = false;
			}
		}
	}
	
	function toggleDateOption(option){
		if(option == "D"){
			$("fromMonth").addClassName("disabled");
			$("fromMonth").removeClassName("required");
			$("toMonth").addClassName("disabled");
			$("toMonth").removeClassName("required");
			$("txtFromYear").addClassName("disabled");
			$("txtFromYear").removeClassName("required");
			$("txtToYear").addClassName("disabled");
			$("txtToYear").removeClassName("required");
			$("fromMonth").readOnly = true;
			$("toMonth").readOnly = true;
			$("txtFromYear").readOnly = true;
			$("txtToYear").readOnly = true;
			$("fromMonth").clear();
			$("toMonth").clear();
			$("txtFromYear").clear();
			$("txtToYear").clear();
			$("txtToDate").removeClassName("disabled");
			$("txtToDate").addClassName("required");
			$("txtFromDate").removeClassName("disabled");
			$("txtFromDate").addClassName("required");
			$("txtFromDateDiv").removeClassName("disabled");
			$("txtFromDateDiv").addClassName("required");
			document.getElementById("txtFromDateDiv").style.backgroundColor = '#FFFACD';
			$("txtToDateDiv").removeClassName("disabled");
			$("txtToDateDiv").addClassName("required");
			enableDate("imgFromDate");
			enableDate("imgToDate");
			disableEnableSelect("D");
		} else if(option == "M"){
			$("txtFromDate").addClassName("disabled");
			$("txtFromDate").removeClassName("required");
			$("txtToDate").addClassName("disabled");
			$("txtToDate").removeClassName("required");
			$("txtFromDate").clear();
			$("txtToDate").clear();
			$("txtFromDateDiv").addClassName("disabled");
			$("txtFromDateDiv").removeClassName("required");
			document.getElementById("txtFromDateDiv").style.backgroundColor = '#E0E0E0';
			$("txtToDateDiv").addClassName("disabled");
			$("txtToDateDiv").removeClassName("required");
			disableDate("imgFromDate");
			disableDate("imgToDate");
			$("fromMonth").removeClassName("disabled");
			$("fromMonth").addClassName("required");
			$("toMonth").removeClassName("disabled");
			$("toMonth").addClassName("required");
			$("txtFromYear").removeClassName("disabled");
			$("txtFromYear").addClassName("required");
			$("txtToYear").removeClassName("disabled");
			$("txtToYear").addClassName("required");
			$("fromMonth").readOnly = false;
			$("toMonth").readOnly = false;
			$("txtFromYear").readOnly = false;
			$("txtToYear").readOnly = false;
			disableEnableSelect("E");
		}
		$("txtLineCd").clear();
		$("txtLineName").value = "ALL LINES";
		$("txtSublineCd").clear();
		$("txtSublineName").value = "ALL SUBLINES";
		$("txtIssCd").clear();
		$("txtIssName").value = $("rdoBySource").checked == true ? "ALL ISSUING SOURCES" : "ALL CREDITING BRANCHES";
	}
	
	$$("input[name='dateOption']").each(function(radio){
		radio.observe("click", function(){
			toggleDateOption(radio.value);
			paramType = radio.value;
		});
	});
	
	$$("input[name='branchOption']").each(function(radio){
		radio.observe("click", function(){
			document.getElementById('issCred').innerHTML = radio.value;
			if(radio.value == 'Issuing Source'){
				credBranchParam = '1';
				$("txtIssCd").clear();
				$("txtIssName").value = "ALL ISSUING SOURCES";
			} else if(radio.value == 'Crediting Branch'){
				credBranchParam = '2';
				$("txtIssCd").clear();
				$("txtIssName").value = "ALL CREDITING BRANCHES";
			}
			$("txtLineCd").clear();
			$("txtLineName").value = "ALL LINES";
			$("txtSublineCd").clear();
			$("txtSublineName").value = "ALL SUBLINES";
			$("txtIssCd").clear();
			
			$("txtIssCd").setAttribute("lastValidValue", ""); //added by steve
			$("txtSublineCd").setAttribute("lastValidValue", "");
			$("txtSublineName").setAttribute("lastValidValue", "ALL SUBLINES");
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").setAttribute("lastValidValue", "ALL LINES");
		});
	});
	
	function whenNewFormInstanceGIUTS031(){
		/* new Ajax.Request(contextPath+"/ExtractExpiringCovernoteController?action=whenNewFormInstanceGIUTS031",{
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				if (checkErrorOnResponse(response)){
					//var res = JSON.parse(response.responseText);
				}
			}
		}); */
		new Ajax.Request(contextPath+"/ExtractExpiringCovernoteController",{
			method: "POST",
			parameters : {
				action : "validateExtractParameters"
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					var res = JSON.parse(response.responseText);
					if(res.pUserId != null){
						noExtrDataFlag = "N";
						setUpParameters(res);
					}
				}
			}
		});
	}

	function setUpParameters(params){
		toggleDateOption(params.pParamType);
		if(params.pParamType == "D"){
			$("rdoByDate").checked = true;
			$("txtFromDate").focus();
			$("txtFromDate").value = params.pFromDate;
			$("txtToDate").value = params.pToDate;
		} else if(params.pParamType == "M"){
			var pFromMonthNo = getMonthNo(params.pFromMonth);
			var pToMonthNo = getMonthNo(params.pToMonth);
			$("rdoByMonthYear").checked = true;
			$("fromMonth").focus();
			$("fromMonth").value = pFromMonthNo;
			$("txtFromYear").value = params.pFromYear;
			$("toMonth").value = pToMonthNo;
			$("txtToYear").value = params.pToYear;
		}
		
		paramType = params.pParamType;
		credBranchParam = params.pCredBranchParam;
		vFrom = params.pFrom;
		vTo = params.pTo;
		if(params.pCredBranchParam == "1"){
			$("rdoBySource").checked = true;
		} else {
			$("rdoByCredBranch").checked = true;
		}
		
		$("txtLineCd").value = unescapeHTML2(params.pLineCd);
		$("txtLineName").value = nvl(unescapeHTML2(params.pLineName), 'ALL LINES');
		$("txtSublineCd").value = unescapeHTML2(params.pSublineCd);
		$("txtSublineName").value = nvl(unescapeHTML2(params.pSublineName), 'ALL SUBLINES');
		$("txtIssCd").value = unescapeHTML2(params.pIssCd);
		$("txtIssName").value = nvl(unescapeHTML2(params.pIssName), $("rdoBySource").checked == true ? "ALL ISSUING SOURCES" : "ALL CREDITING BRANCHES");
		$("issCred").innerHTML = $("rdoByCredBranch").checked ? "Crediting Branch" : "Issuing Source";
	}
	
	function getMonthNo(month){
		switch(month)
		{
		case 'January':
		  	return '1';
		  	break;
		case 'February':
		  	return '2';
		  	break;
		case 'March':
	    	return '3';
			break;
		case 'April':
	    	return '4';
			break;
		case 'May':
	    	return '5';
			break;
		case 'June':
	    	return '6';
			break;
		case 'July':
	    	return '7';
			break;
		case 'August':
	    	return '8';
			break;
		case 'September':
	    	return '9';
			break;
		case 'October':
	    	return '10';
			break;
		case 'November':
	    	return '11';
			break;
		case 'December':
	    	return '12';
			break;
		}	
	}
	
	$("txtFromDate").focus();
	$("rdoByDate").checked = true;
	$("rdoBySource").checked = true;
	initializeAll();
	toggleDateOption("D");
	whenNewFormInstanceGIUTS031();
	
	$("imgSearchLineName").hide();
	$("imgSearchSublineName").hide();
	$("imgSearchIssName").hide();
	
	/* Standard LOV */
	
	$("txtLineCd").setAttribute("lastValidValue", "");
	$("txtLineName").setAttribute("lastValidValue", $F("txtLineName"));
	$("imgSearchLineCd").observe("click", showGiuts031LineCd);
	$("txtLineCd").observe("change", function() {		
		if($F("txtLineCd").trim() == "") {
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").value = "ALL LINES";
			$("txtLineName").setAttribute("lastValidValue", "ALL LINES");
			
			$("txtSublineCd").value = "";
			$("txtSublineCd").setAttribute("lastValidValue", "");
			$("txtSublineName").value = "ALL SUBLINES";
			$("txtSublineName").setAttribute("lastValidValue", "ALL SUBLINES");
		} else {
			if($F("txtLineCd").trim() != "" && $F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue")) {
				showGiuts031LineCd();
			}
		}
	});
	$("txtLineCd").observe("keyup", function(){
		$("txtLineCd").value = $F("txtLineCd").toUpperCase();
	});
	
	function showGiuts031LineCd(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "showGiuts031LineCd",
				            issCd : $F("txtIssCd"),
							filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
							page : 1},
			title: "List of Lines",
			width: 450,
			height: 400,
			columnModel : [
							{
								id : "lineCd",
								title: "Line Code",
								width: '100px',
								filterOption: true,
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							},
							{
								id : "lineName",
								title: "Line Name",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
				onSelect: function(row) {
					$("txtLineCd").value = unescapeHTML2(row.lineCd);
					$("txtLineName").value = unescapeHTML2(row.lineName);
					if($F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue")){
						$("txtSublineCd").value = "";
						$("txtSublineCd").setAttribute("lastValidValue", "");
						$("txtSublineName").value = "ALL SUBLINES";
						$("txtSublineName").setAttribute("lastValidValue", "ALL SUBLINES");
					}
					$("txtLineCd").setAttribute("lastValidValue", $("txtLineCd").value);
					$("txtLineName").setAttribute("lastValidValue", $("txtLineName").value);
				},
				onCancel: function (){
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
					$("txtLineName").value = $("txtLineName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
					$("txtLineName").value = $("txtLineName").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("txtSublineCd").setAttribute("lastValidValue", "");
	$("txtSublineName").setAttribute("lastValidValue", $F("txtSublineName"));
	$("imgSearchSublineCd").observe("click", showGiuts031SublineCd);
	$("txtSublineCd").observe("change", function() {		
		if($F("txtSublineCd").trim() == "") {
			$("txtSublineCd").value = "";
			$("txtSublineCd").setAttribute("lastValidValue", "");
			$("txtSublineName").value = "ALL SUBLINES";
			$("txtSublineName").setAttribute("lastValidValue", "ALL SUBLINES");
		} else {
			if($F("txtSublineCd").trim() != "" && $F("txtSublineCd") != $("txtSublineCd").readAttribute("lastValidValue")) {
				showGiuts031SublineCd();
			}
		}
	});
	$("txtSublineCd").observe("keyup", function(){
		$("txtSublineCd").value = $F("txtSublineCd").toUpperCase();
	});
	
	function showGiuts031SublineCd(){
		if($F("txtLineCd") == ""){
			showMessageBox("Please input line code first.", "I");
			$("txtSublineCd").clear();
			return;
		}
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "showGiuts031SublineCd",
				            lineCd : $F("txtLineCd"),
							filterText : ($("txtSublineCd").readAttribute("lastValidValue").trim() != $F("txtSublineCd").trim() ? $F("txtSublineCd").trim() : ""),
							page : 1},
			title: "List of Sublines",
			width: 450,
			height: 400,
			columnModel : [
							{
								id : "sublineCd",
								title: "Subline Code",
								width: '100px',
								filterOption: true,
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							},
							{
								id : "sublineName",
								title: "Subline Name",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtSublineCd").readAttribute("lastValidValue").trim() != $F("txtSublineCd").trim() ? $F("txtSublineCd").trim() : ""),
				onSelect: function(row) {
					$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
					$("txtSublineName").value = unescapeHTML2(row.sublineName);
					$("txtSublineCd").setAttribute("lastValidValue", $("txtSublineCd").value);
					$("txtSublineName").setAttribute("lastValidValue", $("txtSublineName").value);
				},
				onCancel: function (){
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
					$("txtSublineName").value = $("txtSublineName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
					$("txtSublineName").value = $("txtSublineName").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("txtIssCd").setAttribute("lastValidValue", "");
	$("txtIssName").setAttribute("lastValidValue", $F("txtIssName"));
	$("imgSearchIssCd").observe("click", showGiuts031IssCd);
	$("txtIssCd").observe("change", function() {		
		if($F("txtIssCd").trim() == "") {
			$("txtIssCd").value = "";
			$("txtIssCd").setAttribute("lastValidValue", "");
			$("txtIssName").value = $("rdoBySource").checked == true ? "ALL ISSUING SOURCES" : "ALL CREDITING BRANCHES";
			$("txtIssName").setAttribute("lastValidValue", $F("txtIssName"));
		} else {
			if($F("txtIssCd").trim() != "" && $F("txtIssCd") != $("txtIssCd").readAttribute("lastValidValue")) {
				showGiuts031IssCd();
			}
		}
	});
	$("txtIssCd").observe("keyup", function(){
		$("txtIssCd").value = $F("txtIssCd").toUpperCase();
	});
	
	function showGiuts031IssCd(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "showGiuts031IssCd",
				            lineCd : $F("txtLineCd"),
							filterText : ($("txtIssCd").readAttribute("lastValidValue").trim() != $F("txtIssCd").trim() ? $F("txtIssCd").trim() : ""),
							page : 1},
			title: $("rdoBySource").checked == true ? "List of Issuing Sources" : "List of Crediting Branches",
			width: 450,
			height: 400,
			columnModel : [
							{
								id : "issCd",
								//title: "Issue Code",
								title: $("rdoBySource").checked == true ? "Issue Code" : "Crediting Branch Code",
								width: '135px',
								filterOption: true,
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							},
							{
								id : "issName",
								//title: "Issue Name",
								title: $("rdoBySource").checked == true ? "Issuing Source" : "Crediting Branch Name",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtIssCd").readAttribute("lastValidValue").trim() != $F("txtIssCd").trim() ? $F("txtIssCd").trim() : ""),
				onSelect: function(row) {
					$("txtIssCd").value = unescapeHTML2(row.issCd);
					$("txtIssName").value = unescapeHTML2(row.issName);
					$("txtIssCd").setAttribute("lastValidValue", $("txtIssCd").value);
					$("txtIssName").setAttribute("lastValidValue", $("txtIssName").value);
				},
				onCancel: function (){
					$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
					$("txtIssName").value = $("txtIssName").readAttribute("lastValidValue");
					$("txtIssName").value = $("rdoBySource").checked == true ? "ALL ISSUING SOURCES" : "ALL CREDITING BRANCHES";
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
					$("txtIssName").value = $("txtIssName").readAttribute("lastValidValue");
					$("txtIssName").value = $("rdoBySource").checked == true ? "ALL ISSUING SOURCES" : "ALL CREDITING BRANCHES";
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$$("input[type='text'].integerNoNegativeUnformattedNoComma, input[type='hidden'].integerNoNegativeUnformattedNoComma").each(function (m){
		var previousValue = "";
		m.observe("focus", function(){
			previousValue = m.value;
		});
		m.observe("blur", function(){
			if(isNaN(m.value.replace(/,/g, "") || m.value.blank())){
				m.value = "";
			}else{				
				if(parseFloat(m.value.replace(/,/g, "")) < parseFloat(m.getAttribute("min")) || parseFloat(m.value.replace(/,/g, "")) > parseFloat(m.getAttribute("max"))){				
					//m.value = "";					
					showWaitingMessageBox(m.getAttribute("errorMsg2"), imgMessage.ERROR, function() {
						m.value = previousValue;
						m.focus();
					});					
				}
			}
			m.value = (m.value == "" ? "" : m.value); 
		});
		m.value = (m.value == "" ? "" : m.value); 
	});	
	
	togglePrintFields("screen");
</script>