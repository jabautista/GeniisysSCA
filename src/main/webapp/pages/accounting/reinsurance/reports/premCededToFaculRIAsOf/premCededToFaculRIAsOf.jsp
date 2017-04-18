<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="premCededFaculRIAsOfMainDiv" name="premCededFaculRIAsOfMainDiv">
	<div id="officialReceiptRegisterMenu">
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
			<label>Schedule of Premiums Due to Facultative RI</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	<div class="sectionDiv" id="premCededFaculRIAsOfBody" >
		<div class="sectionDiv" id="premCededFaculRIAsOf" style="width: 70%; margin: 40px 138px 40px 138px;">
			<div class="sectionDiv" id="premCededFaculRIAsOfInnerDiv" style="width: 97%; margin: 8px 8px 2px 8px;">
				<table align="center" style="padding: 20px;">
					<tr>
						<td class="rightAligned">From</td>
						<td>
							<div style="float: left; width: 160px;" class="required withIconDiv">
								<input type="text" id="txtFromDate" name="txtFromDate" class="required withIcon" readonly="readonly" style="width: 135px;"/>
								<img id="imgFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"/>
							</div>
						</td>
						<td class="rightAligned" width="68px">To</td>
						<td>
							<div style="float: left; width: 160px;" class="required withIconDiv">
								<input type="text" id="txtToDate" name="txtToDate" class="required withIcon" readonly="readonly" style="width: 135px;"/>
								<img id="imgToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Cut Off Date</td>
						<td>
							<div style="float: left; width: 160px;" class="required withIconDiv">
								<input type="text" id="txtCutOffDate" name="txtCutOffDate" class="required withIcon" readonly="readonly" style="width: 135px;"/>
								<img id="imgCutOffDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Reinsurer</td>
						<td colspan="5">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="rightAligned"  type="text" id="reinsurerCd" name="reinsurerCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchReinsurerCd" name="searchReinsurerCd" alt="Go" style="float: right;"/>
							</span>
							<input  class="leftAligned"  type="text" id="reinsurerName" name="reinsurerName"  value="ALL REINSURERS" readonly="readonly" style="width: 325px; float: left; margin-right: 4px;"/>							
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Line</td>
						<td colspan="5">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="rightAligned"  type="text" id="lineCd" name="lineCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" name="searchLineCd" alt="Go" style="float: right;"/>
							</span>
							<input  class="leftAligned"  type="text" id="lineName" name="lineName"  value="ALL LINES" readonly="readonly" style="width: 325px; float: left; margin-right: 4px;"/>								
						</td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="rdoDiv" style="width: 43%; height:130px; margin: 0 0 8px 8px;">
				<table align = "center" style="padding: 10px;">
					<tr>
						<td>
							<input type="radio" checked="" name="summary" id="summary" title="Summary" style="float: left;"/>
							<label for="summary" style="float: left; height: 20px; padding-top: 3px;">Summary</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="radio" checked="" name="detailed" id="detailed" title="Detailed" style="float: left;"/>
							<label for="detailed" style="float: left; height: 20px; padding-top: 3px;">Detailed</label>
						</td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="printDiv" style="width: 53%; height:130px; margin: 0 8px 6px 4px;">
				<table id="printDialogMainTab" name="printDialogMainTab" align="center" style="padding: 10px;">
					<tr>
						<td style="text-align:right; width: 27%;">Destination</td>
						<td style="width: 73%;">
							<select id="selDestination" style="margin-left:5px; width:70%;" >
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
									<td><input type="radio" id="rdoExcel" name="rdoFileType" value="XLS" title="Excel" disabled="disabled" /></td>
									<td><label for="rdoExcel"> Excel</label></td>
								</tr>									
							</table>
						</td>
					</tr>
					<tr>
						<td style="text-align:right; width: 27%;">Printer Name</td>
						<td style="width: 73%;">
							<select id="printerName" style="margin-left:5px; width:70%;">
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
							<input type="text" id="txtNoOfCopies" style="margin-left:5px;float:left; text-align:right; width:136px;" class="integerNoNegativeUnformattedNoComma">
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
	//marco - 07.30.2014 - load last extract parameters upon page load
	var giacs182Variables = JSON.parse('${variables}');
	$("txtFromDate").value = nvl(giacs182Variables.fromDate, "");
	$("txtToDate").value = nvl(giacs182Variables.toDate, "");
	$("txtCutOffDate").value = nvl(giacs182Variables.cutOffDate, "");

	setModuleId("GIACS182");
	setDocumentTitle("Schedule of  Premiums Ceded to Facultative RI (as of)");
	initializeAll();
	checkUserAccess();
	togglePrintFields("screen");
	$("summary").checked = true;
	$("detailed").checked = false;
	var riExist = true;
	var lineExist = true;
	var fromDate = $F("txtFromDate"); //marco - 07.30.2014 - added initial values
	var toDate = $F("txtToDate");
	var cutOffDate = $F("txtCutOffDate");
	var reportId;
	
	observeReloadForm("reloadForm", showGIACS182);
	
	$("btnPrint").observe("click", function(){
		validateBeforePrint();
	});
	
	function validateBeforePrint() {
		if ($F("txtFromDate") == "" || $F("txtToDate") == "" || $F("txtCutOffDate") == "") {
			showMessageBox("Required fields must be entered.","I");
			return false;
		}else if (compareDatesIgnoreTime(Date.parse($F("txtFromDate")),Date.parse($("txtToDate").value)) == -1) {
			showMessageBox("From Date should be earlier than To Date","I");
			return false;
		}else if(validateExtract() == 'E') {
			//marco - 07.20.2014 - added condition
			if(($F("txtFromDate") != fromDate && fromDate != "") || ($F("txtToDate") != toDate && toDate != "") ||
				($F("txtCutOffDate") != cutOffDate && cutOffDate != "")){
				showConfirmBox("Confirmation", "The specified parameter/s has not been extracted. Do you want to extract the data using the specified parameter/s?", "Yes", "No",
					function() {
						extractGIACS182();
					}, "");
			}else{
				showMessageBox("Please extract records first.", "I");
			}
			return false;
		}
		
		if ($F("txtFromDate") == fromDate && $F("txtToDate") == toDate && $F("txtCutOffDate") == cutOffDate) {
			if ($("summary").checked) {
				reportId = "GIACR182";
			} else {
				reportId = "GIACR188";
			}
			
			var dest = $F("selDestination");
			
			if(dest == "printer"){
				if(checkAllRequiredFieldsInDiv("printDiv")){
					printReport();
				}
			} else {
				printReport();
			}
		} else {
			if ($F("txtFromDate") != fromDate || $F("txtToDate") != toDate || $F("txtCutOffDate") != cutOffDate){
				showConfirmBox("Confirmation", "The specified parameter/s has not been extracted. Do you want to extract the data using the specified parameter/s?", "Yes", "No",
						function() {
							extractGIACS182();
						}, "");
			} else if ($F("txtCutOffDate") != cutOffDate) {
				showConfirmBox("Confirmation", "The cut-off date has changed.You have to re-extract to get the correct data. Continue?", "Yes", "No",
						function() {
							extractGIACS182();
						}, "");
			}
		}
	}
	
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
			
			var content = contextPath + "/ReinsuranceReportController?action=printReport"
            + "&reportId=" + reportId
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
							
						}
					}
				});
			} else if("file" == $F("selDestination")){
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
			} else if("local" == $F("selDestination")){
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
	
	function getParams(){
		var params = "&riCd=" + $("reinsurerCd").value
		+ "&lineCd=" + $("lineCd").value
		+ "&fromDate=" + $("txtFromDate").value
		+ "&toDate=" + $("txtToDate").value
		+ "&cutOffDate=" + $("txtCutOffDate").value;
		
		return params;
	}
	
	$("btnExtract").observe("click", function(){
		validateBeforeExtract();
	});
	
	function validateBeforeExtract() {
		try{
			if ($F("txtFromDate") == "" || $F("txtToDate") == "" || $F("txtCutOffDate") == "") {
				showMessageBox("Required fields must be entered.","I");
				return false;
			}else if (compareDatesIgnoreTime(Date.parse($F("txtFromDate")),Date.parse($("txtToDate").value)) == -1) {
				showMessageBox("From Date should be earlier than To Date","I");
				return false;
			}else{
				if (validateExtract() == 'Y') {
					fromDate = $F("txtFromDate");
					toDate = $F("txtToDate");
					cutOffDate = $F("txtCutOffDate");
					showConfirmBox("Confirmation", "Data has been extracted within the specified parameter/s. Do you wish to continue extraction?", "Yes", "No",
							function() {
								extractGIACS182();
							}, "");
				} else {
					extractGIACS182();
				}
			}
		}catch (e) {
			showErrorMessage("validateBeforeExtract",e);
		}
	}
	
	function validateExtract() {
		try {
			var result = 'N';
			new Ajax.Request(contextPath+"/GIACReinsuranceReportsController",{
				method: "POST",
				parameters : {action : "giacs182ValidateDateParams",
							 fromDate : $F("txtFromDate"),
							 toDate : $F("txtToDate"),
							 cutOffDate : $F("txtCutOffDate"),
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Loading, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						result = response.responseText;
					}
				}
			});
			return result;
		} catch (e) {
			showErrorMessage("validateExtract",e);
		}
	}
	
	function extractGIACS182(){
		try {
			new Ajax.Request(contextPath+"/GIACReinsuranceReportsController",{
				method: "POST",
				parameters : {action : "extractGIACS182",
							 fromDate : $F("txtFromDate"),
							 toDate : $F("txtToDate"),
							 cutOffDate : $F("txtCutOffDate"),
							 riCd : $F("reinsurerCd"),
							 lineCd : $F("lineCd")
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
						}else{
							showMessageBox("Extraction finished. " + result.exist + " records extracted.", "I");
						}
					}
					fromDate = $F("txtFromDate");
					toDate = $F("txtToDate");
					cutOffDate = $F("txtCutOffDate");
				}
			});
		} catch (e) {
			showErrorMessage("extractGIACS182",e);
		}
	}
	
	$("summary").observe("click", function(){
		$("detailed").checked = false;
	});
	
	$("detailed").observe("click", function(){
		$("summary").checked = false;
	});
	
	$("imgFromDate").observe("click", function(){
		scwShow($('txtFromDate'),this, null);
	});	
	
	$("imgToDate").observe("click", function(){
		scwShow($('txtToDate'),this, null);
	});	
	
	$("imgCutOffDate").observe("click", function(){
		scwShow($('txtCutOffDate'),this, null);
	});
	
	$("txtFromDate").observe("focus", function(){
		if ($("txtToDate").value != "" && this.value != "") {
			if (compareDatesIgnoreTime(Date.parse($F("txtFromDate")),Date.parse($("txtToDate").value)) == -1) {
				customShowMessageBox("From Date should not be later than To Date.","I","txtFromDate");
				this.clear();
			}
		}
	});
	
	$("txtToDate").observe("focus", function(){
		if ($("txtFromDate").value != ""&& this.value != "") {
			if (compareDatesIgnoreTime(Date.parse($F("txtFromDate")),Date.parse($("txtToDate").value)) == -1) {
				customShowMessageBox("From Date should not be later than To Date.","I","txtToDate");
				this.clear();
			}
		}
	});
	
	function validateFromToDate(elemNameFr, elemNameTo, currElemName){
		var isValid = true;		
		var elemDateFr = Date.parse($F(elemNameFr), "mm-dd-yyyy");
		var elemDateTo = Date.parse($F(elemNameTo), "mm-dd-yyyy");
		
		var output = compareDatesIgnoreTime(elemDateFr, elemDateTo);
		if(output < 0){
			if(currElemName == elemNameFr){
				showMessageBox("The date you entered is LATER THAN the TO DATE.", "I");
				$("txtToDate").value = "";
				$("txtFromDate").value = "";
			} else {
				showMessageBox("The date you entered is EARLIER THAN the FROM DATE.", "I");
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
	
	function checkUserAccess(){
		try{
			new Ajax.Request(contextPath+"/GIACAccTransController?action=checkUserAccess2", {
				method: "POST",
				parameters: {
					moduleName: "GIACS182"
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(response.responseText == 0){
						showWaitingMessageBox('You are not allowed to access this module.', imgMessage.ERROR, 
								function(){
							goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
						});  
						
					}
				}
			});
		}catch(e){
			showErrorMessage('checkUserAccess', e);
		}
	}
	
	$("selDestination").observe("change", function(){
		var destination = $F("selDestination");
		togglePrintFields(destination);
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
			$("rdoExcel").disable();
		} else {
			if(destination == "file"){
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
	
	$("btnExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	});
	
	$("reinsurerCd").setAttribute("lastValidValue", "");
	$("searchReinsurerCd").observe("click", showGiacs182RiLov);
	$("reinsurerCd").observe("change", function() {		
		if($F("reinsurerCd").trim() == "") {
			$("reinsurerCd").value = "";
			$("reinsurerCd").setAttribute("lastValidValue", "");
			$("reinsurerName").value = "";
		} else {
			if($F("reinsurerCd").trim() != "" && $F("reinsurerCd") != $("reinsurerCd").readAttribute("lastValidValue")) {
				showGiacs182RiLov();
			}
		}
	});
	$("reinsurerCd").observe("keyup", function(){
		$("reinsurerCd").value = $F("reinsurerCd").toUpperCase();
	});
	
	function showGiacs182RiLov(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action : "showGiacs182RiLov",
				filterText : ($("reinsurerCd").readAttribute("lastValidValue").trim() != $F("reinsurerCd").trim() ? $F("reinsurerCd").trim() : ""),
				page : 1
			},
			title: "List of Valid Values for Reinsurers",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "riCd",
								title: "RI Code",
								width: '100px',
								filterOption: true
							},
							{
								id : "riName",
								title: "RI Name",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("reinsurerCd").readAttribute("lastValidValue").trim() != $F("reinsurerCd").trim() ? $F("reinsurerCd").trim() : ""),
				onSelect: function(row) {
					$("reinsurerCd").value = row.riCd;
					$("reinsurerName").value = row.riName;
					$("reinsurerCd").setAttribute("lastValidValue", row.riCd);								
				},
				onCancel: function (){
					$("reinsurerCd").value = $("reinsurerCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("reinsurerCd").value = $("reinsurerCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("lineCd").setAttribute("lastValidValue", "");
	$("searchLineCd").observe("click", showGiacs182LineLov);
	$("lineCd").observe("change", function() {		
		if($F("lineCd").trim() == "") {
			$("lineCd").value = "";
			$("lineCd").setAttribute("lastValidValue", "");
			$("lineName").value = "";
		} else {
			if($F("lineCd").trim() != "" && $F("lineCd") != $("lineCd").readAttribute("lastValidValue")) {
				showGiacs182LineLov();
			}
		}
	});
	$("lineCd").observe("keyup", function(){
		$("lineCd").value = $F("lineCd").toUpperCase();
	});
	
	function showGiacs182LineLov(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action : "showGiacs182LineLov",
				filterText : ($("lineCd").readAttribute("lastValidValue").trim() != $F("lineCd").trim() ? $F("lineCd").trim() : ""),
				page : 1
			},
			title: "List of Valid Values for Line",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "lineCd",
								title: "Line Code",
								width: '100px',
								filterOption: true
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
				filterText : ($("lineCd").readAttribute("lastValidValue").trim() != $F("lineCd").trim() ? $F("lineCd").trim() : ""),
				onSelect: function(row) {
					$("lineCd").value = row.lineCd;
					$("lineName").value = row.lineName;
					$("lineCd").setAttribute("lastValidValue", row.lineCd);								
				},
				onCancel: function (){
					$("lineCd").value = $("lineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("lineCd").value = $("lineCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
</script>