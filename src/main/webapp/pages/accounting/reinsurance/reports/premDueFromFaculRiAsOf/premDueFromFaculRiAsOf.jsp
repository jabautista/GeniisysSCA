<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="premDueFromFaculRiAsOfMainDiv" name="premDueFromFaculRiAsOfMainDiv">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
	   		<label>Due from Facultative RI As Of</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadGIACS183" name="reloadGIACS183">Reload Form</label>
			</span>
	   	</div>
	</div>
	<div class="sectionDiv" id="premDueFromFaculRiAsOfBody" >
		<div class="sectionDiv" id="premDueFromFaculRiAsOf" style="width: 70%; margin: 40px 138px 40px 138px;">
			<div class="sectionDiv" id="premDueFromFaculRiAsOfInnerDiv" style="width: 97%; margin: 8px 8px 2px 8px;">
				<table align="center" style="padding: 20px;">
					<tr>
						<td class="rightAligned">From</td>
						<td>
							<div style="float: left; width: 160px;" class="withIconDiv required">
								<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon dateRequired required" readonly="readonly" style="width: 135px;" title="From Date"/>
								<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"/>
							</div>
						</td>
						<td class="rightAligned" width="68px">To</td>
						<td>
							<div style="float: left; width: 160px;" class="withIconDiv required">
								<input type="text" id="txtToDate" name="txtToDate" class="withIcon dateRequired required" readonly="readonly" style="width: 135px;" title="To Date"/>
								<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Cut Off Date</td>
						<td>
							<div style="float: left; width: 160px;" class="withIconDiv required">
								<input type="text" id="txtCutOffDate" name="txtCutOffDate" class="withIcon dateRequired required" readonly="readonly" style="width: 135px;" title="Cut Off Date"/>
								<img id="hrefCutOffDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Reinsurer</td>
						<td colspan="3">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="rightAligned allCaps"  type="text" id="txtRiCd" name="txtRiCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;" lastValidValue = ""/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchRiCd" name="searchRiCd" alt="Go" style="float: right;"/>
							</span>
							<input type="text" id="txtRiName" name="txtRiName" style="width: 325px; float: left; text-align: left;" value="ALL REINSURERS" readonly="readonly"/>								
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Line</td>
						<td colspan="3">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="rightAligned allCaps"  type="text" id="txtLineCd" name="txtLineCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;"  lastValidValue = ""/>		
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" name="searchLineCd" alt="Go" style="float: right;"/>
							</span>
							<input type="text" id="txtLineName" name="txtLineName" style="width: 325px; float: left; text-align: left;" value="ALL LINES" readonly="readonly"/>								
						</td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="rdoTypeDiv" style="width: 26.1%; height:130px; margin: 0 0 8px 8px;">
				<table align = "center" style="padding: 10px;">
					<tr height="60px">
						<td><input type="radio" checked="checked" id="rdoSummary" name="byDateType" title="Summary" style="float: left; margin-right: 7px;"/><label for="rdoSummary" style="float: left; height: 20px; padding-top: 3px;">Summary</label></td>
					</tr>
					<tr>
						<td><input type="radio" id="rdoDetailed" name="byDateType" title="Detailed" style="float: left; margin-right: 7px;"/><label for="rdoDetailed" style="float: left; height: 20px; padding-top: 3px;">Detailed</label></td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="printDiv" style="width: 70%; height:130px; margin: 0 8px 6px 4px;">
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
							<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma">
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
			<div id="buttonsDiv" style="width: 100%; height: 50px; float: left;">
				<input type="button" class="button" id="btnExtract" name="btnExtract" value="Extract" style="width: 100px; margin-bottom: 10px; margin-top: 10px;">
				<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width: 100px; margin-bottom: 10px; margin-top: 10px;">
			</div>
		</div>
	</div>
</div>

<script>
	initializeAll();
	setModuleId("GIACS183");
	setDocumentTitle("Due from Facultative RI As Of");
	toggleRequiredFields("screen");
	var riExist = true;
	var lineExist = true;
	initializeDateFields();

	function initializeDateFields() {
		try {
			var jsonDate = JSON.parse('${jsonDate}');
			$("txtFromDate").value 		= jsonDate.fromDate != undefined ? 		jsonDate.fromDate 	: '';
			$("txtToDate").value 		= jsonDate.toDate != undefined ? 		jsonDate.toDate 	: '';
			$("txtCutOffDate").value 	= jsonDate.cutOffDate != undefined ? 	jsonDate.cutOffDate : '';
		}catch (e) {
			showErrorMessage("initializeDateFields",e);
		}
	}
	
	function printReport() {
		try {
			var fileType = $("rdoPdf").checked ? "PDF" : "XLS";
			var reportId = null;
			var reportTitle = null;
			if ($("rdoSummary").checked) {
				reportId = 'GIACR183';
				reportTitle = 'Summary of Due from Facultative Reinsurer';
			} else {
				reportId = 'GIACR187';
				reportTitle = 'Premiums Ceded to Facultative RI(As Of)';
			}
			var content = contextPath+"/ReinsuranceReportController?action=printReport"
						+"&noOfCopies="+$F("txtNoOfCopies")
						+"&printerName="+$F("selPrinter")
						+"&destination="+$F("selDestination")
						+"&reportId="+reportId
						+"&reportTitle="+reportTitle
						+"&riCd="+$F("txtRiCd")
						//+"&lineCd="+$F("txtLineCd")
						+"&fromDate="+$F("txtFromDate")
						+"&toDate="+$F("txtToDate")
						+"&cutOffDate="+$F("txtCutOffDate")
						+"&fileType="+fileType
						+"&moduleId="+"GIACS183"; 
			printGenericReport(content, reportTitle,function(){
				if($F("selDestination") == "printer"){
					showMessageBox("Printing Completed.", "S");
				}
			}); 
		} catch (e) {
			showErrorMessage("printReport",e);
		}
	}
	
	function validateBeforePrint() {
		try{
		 	if (checkAllRequiredFieldsInDiv("premDueFromFaculRiAsOf")) {
				if (validateExtract() == 'Y') {
					printReport();
				} else {
					showConfirmBox("Confirmation", "Specified dates have not yet been extracted. Begin extraction? ", "Ok", "Cancel",
							function() {
								extractToTable();
							}, "");
				}
			}
		}catch (e) {
			showErrorMessage("validateBeforePrint",e);
		}
	}
	
	function validateBeforeExtract() {
		try{
		 	if (checkAllRequiredFieldsInDiv("premDueFromFaculRiAsOfInnerDiv")) {
				if (validateExtract() == 'Y') {
					showConfirmBox("Confirmation", "The specified dates have already been extracted. Would you like to begin extraction?", "Ok", "Cancel",
							function() {
								extractToTable();
							}, "");
				} else {
					extractToTable();
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
				parameters : {action : "giacs183ValidateBeforeExtract",
							 fromDate : $F("txtFromDate"),
							 toDate : $F("txtToDate"),
							 cutOfDate : $F("txtCutOffDate")
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
	
	function extractToTable() {
		try {
			new Ajax.Request(contextPath+"/GIACReinsuranceReportsController",{
				method: "POST",
				parameters : {action : "giacs183ExtractToTable",
							 fromDate : $F("txtFromDate"),
							 toDate : $F("txtToDate"),
							 cutOfDate : $F("txtCutOffDate"),
							 riCd : $F("txtRiCd"),
							 lineCd : $F("txtLineCd")
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
							showMessageBox("No Data Extracted.","I");
						}else{
							showMessageBox("Extraction Complete.",imgMessage.SUCCESS);
						}
					}
				}
			});
		} catch (e) {
			showErrorMessage("extractToTable",e);
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
			$("rdoPdf").disable();
			$("rdoExcel").disable(); 
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
	
	function lovOnChangeEvent(id,lovFunc,populateFunc,noRecordFunc,content,findText) {
		try{
			if (findText == null) {
				findText = $F(id).trim() == "" ? "%" : $F(id);
			}
			var cond = validateTextFieldLOV(content,findText,"Searching, please wait...");
			if (cond == 2) {
				lovFunc(findText);
			} else if(cond == 0) {
				noRecordFunc();				
			}else{
				populateFunc(cond);
			}
		}catch (e) {
			showErrorMessage("lovOnChangeEvent",e);
		}
	}
	
	function showGiacs183RiLov(){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
								 action   : "getGiacs183RiLOV",
								 findText2 : ($("txtRiCd").readAttribute("lastValidValue").trim() != $F("txtRiCd").trim() ? $F("txtRiCd").trim() : "%"),
								 page : 1
				},
				title: "Lists of Reinsurers",
				width: 400,
				height: 380,
				columnModel: [
					{
						id : 'riCd',
						title: 'RI Code',
						width : '100px',
						align: 'right'
					},
					{
						id : 'riName',
						title: 'Reinsurer Name',
					    width: '250px',
					    align: 'left'
					}
				],
				draggable: true,
				autoSelectOneRecord: true,
				filterText : ($("txtRiCd").readAttribute("lastValidValue").trim() != $F("txtRiCd").trim() ? $F("txtRiCd").trim() : ""),
				onSelect: function(row) {
					if(row != undefined){
						$("txtRiCd").value = row.riCd;
						$("txtRiName").value = unescapeHTML2(row.riName);
						$("txtRiCd").setAttribute("lastValidValue", row.riCd);
					}
				},
				onCancel: function (){
					$("txtRiCd").value = $("txtRiCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtRiCd").value = $("txtRiCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
		}catch(e){
			showErrorMessage("showGiacs183RiLov",e);
		}
	}
	
	function showGiacs183LineLov(){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
								 action   : "getGiacs183LineLOV",
								 findText2 : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : "%"),
								 page : 1
				},
				title: "Lists of Available Lines",
				width: 400,
				height: 380,
				columnModel: [
					{
						id : 'lineCd',
						title: 'Line Code',
						width : '100px',
						align: 'left'
					},
					{
						id : 'lineName',
						title: 'Line Name',
					    width: '250px',
					    align: 'left'
					}
				],
				draggable: true,
				autoSelectOneRecord: true,
				filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
				onSelect: function(row) {
					if(row != undefined){
						$("txtLineCd").value = unescapeHTML2(row.lineCd);
						$("txtLineName").value = unescapeHTML2(row.lineName);
						$("txtLineCd").setAttribute("lastValidValue", row.lineCd);
					}
				},
				onCancel: function (){
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
		}catch(e){
			showErrorMessage("showGiacs183LineLov",e);
		}
	}
	/* observe */
	$("searchRiCd").observe("click", showGiacs183RiLov);
	
	$("searchLineCd").observe("click", showGiacs183LineLov);
	
	$("txtRiCd").observe("change", function() {
		if($F("txtRiCd").trim() == "") {
			$("txtRiCd").value = "";
			$("txtRiCd").setAttribute("lastValidValue", "");
			$("txtRiName").value = "ALL REINSURERS";
		} else {
			if($F("txtRiCd").trim() != "" && $F("txtRiCd") != $("txtRiCd").readAttribute("lastValidValue")) {
				showGiacs183RiLov();
			}
		}
	});
	
	$("txtLineCd").observe("change", function() {
		if($F("txtLineCd").trim() == "") {
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").value = "ALL LINES";
		} else {
			if($F("txtLineCd").trim() != "" && $F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue")) {
				showGiacs183LineLov();
			}
		}
	});
	
	$("hrefFromDate").observe("click", function(){
		scwShow($('txtFromDate'),this, null);
	});
	$("hrefToDate").observe("click", function(){
		scwShow($('txtToDate'),this, null);
	});
	$("hrefCutOffDate").observe("click", function(){
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
	
	$("btnPrint").observe("click", function(){
		validateBeforePrint();
	});
	$("btnExtract").observe("click", function(){
		validateBeforeExtract();
	});

	//for the print div
	$("imgSpinUp").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if(no < 100){ 
			$("txtNoOfCopies").value = no + 1;
		}
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
	
	$("txtNoOfCopies").observe("change", function(){
		if($F("txtNoOfCopies").trim() != "" && (isNaN($F("txtNoOfCopies")) || parseInt($F("txtNoOfCopies")) <= 0 || parseInt($F("txtNoOfCopies")) > 100)){
			showWaitingMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", function(){
				$("txtNoOfCopies").value = "";
			});			
		}
	}); 	 
	
	$("acExit").stopObserving();
	$("acExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});
	
	$("reloadGIACS183").observe("click", function() {
		showPremDueFromFaculRiAsOf();
	});
</script>