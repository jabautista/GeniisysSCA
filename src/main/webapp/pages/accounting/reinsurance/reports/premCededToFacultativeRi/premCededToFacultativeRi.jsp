<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="premCededToFacultativeRiMainDiv" name="premCededToFacultativeRiMainDiv">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
	   		<label>Schedule of Premiums Ceded to Facultative RI</label>
	   	</div>
	</div>
	<div class="sectionDiv" id="premCededToFacultativeRiBody" >
		<div class="sectionDiv" id="premCededToFacultativeRi" style="width: 70%; margin: 40px 138px 40px 138px;">
			<div class="sectionDiv" id="premCededToFacultativeRiInnerDiv" style="width: 97%; margin: 8px 8px 2px 8px;">
				<table align="center" style="padding: 20px;">
					<tr>
						<td class="rightAligned">From</td>
						<td>
							<div style="float: left; width: 160px;" class="withIconDiv required">
								<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon required" readonly="readonly" style="width: 135px;"/>
								<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"/>
							</div>
						</td>
						<td class="rightAligned" width="68px">To</td>
						<td>
							<div style="float: left; width: 160px;" class="withIconDiv required">
								<input type="text" id="txtToDate" name="txtToDate" class="withIcon required" readonly="readonly" style="width: 135px;"/>
								<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Reinsurer</td>
						<td colspan="3">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="rightAligned"  type="text" id="txtRiCd" name="txtRiCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;" lastValidValue=""/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchRiCd" name="searchRiCd" alt="Go" style="float: right;"/>
							</span>
							<input type="text" id="txtRiName" name="txtRiName" style="width: 305px; float: left; text-align: left;" value="ALL REINSURERS" readonly="readonly"/>								
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Line</td>
						<td colspan="3">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="rightAligned allCaps"  type="text" id="txtLineCd" name="txtLineCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;" lastValidValue=""/>		
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" name="searchLineCd" alt="Go" style="float: right;"/>
							</span>
							<input type="text" id="txtLineName" name="txtLineName" style="width: 305px; float: left; text-align: left;" value="ALL LINES" readonly="readonly"/>								
						</td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="rdoTypeDiv" style="width: 21%; height:130px; margin: 0 0 8px 8px;">
				<table align = "center" style="padding: 10px;">
					<tr height="60px">
						<td><input type="radio" id="rdoSummary" name="byDateType" title="Summary" style="float: left; margin-right: 7px;"/><label for="rdoSummary" style="float: left; height: 20px; padding-top: 3px;">Summary</label></td>
					</tr>
					<tr>
						<td><input type="radio" checked="checked" id="rdoDetailed" name="byDateType" title="Detailed" style="float: left; margin-right: 7px;"/><label for="rdoDetailed" style="float: left; height: 20px; padding-top: 3px;">Detailed</label></td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="rdoSortDiv" style="width: 24%; height:130px; margin: 0 0 8px 4px;">
				<label id="sortTitle" style="float: left; padding: 5px 0 0 5px; width: 100%;">Sort by:</label>
				<table align = "center" style="padding: 11px;">
					<tr height="41px" valign="top">
						<td><input type="radio" checked="checked" name="sortBy" id="rdoAccDate" title="Acctg Entry Date" style="float: left; margin-right: 7px;"/><label for="rdoAccDate" style="float: left; height: 20px; padding-top: 3px;">Acctg Entry Date</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="sortBy" id="rdoReinsurer" title="Reinsurer" style="float: left; margin-right: 7px;"/><label for="rdoReinsurer" style="float: left; height: 20px; padding-top: 3px;">Reinsurer</label></td>
					</tr>
					<tr>
						<td><input type="checkbox" id="rdoWithAging" title="With Aging" style="float: left; margin-right: 7px; margin-left: 4px;" disabled="disabled"/><label for="rdoWithAging" style="float: left; height: 20px;">With Aging</label></td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="printDiv" style="width: 50%; height:130px; margin: 0 8px 6px 4px;">
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
							<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma" maxlength="3">
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
	setModuleId("GIACS181");
	setDocumentTitle("Schedule of Premiums Ceded to Facultative RI");
	toggleRequiredFields("screen");
	var riExist = true;
	var lineExist = true;
	var intialParams = getInitialParams();
	if (intialParams.total != 0) {
		$("txtFromDate").value = intialParams.rows[0].fromDate;
		$("txtToDate").value = intialParams.rows[0].toDate;
	}

	function printReport() {
		try {
			var fileType = $("rdoPdf").checked ? "PDF" : "XLS";
			var reportId = null;
			var reportTitle = null;
			if ($("rdoSummary").checked) {
				if ($("rdoReinsurer").checked && $("rdoWithAging").checked) {
					reportId ='GIACR181A';
					reportTitle = 'SCHEDULE OF PREMIUMS CEDED TO FACULTATIVE RI (SUMMARY W/ AGING)';
				} else {
					reportId ='GIACR181';
					reportTitle = 'SCHEDULE OF PREMIUMS CEDED TO FACULTATIVE RI (SUMMARY)';
				}
			} else {
				if ($("rdoAccDate").checked) {
					reportId ='GIACR180';
					reportTitle = 'SCHEDULE OF PREMIUMS CEDED TO FACULTATIVE RI (BY BOOKING DATE)';
				} else {
					if ($("rdoWithAging").checked) {
						reportId ='GIACR181B';
						reportTitle = 'SCHEDULE OF PREMIUMS CEDED TO FACULTATIVE RI (SUMMARY W/ AGING)';
					} else {
						reportId ='GIACR184';
						reportTitle = 'SCHEDULE OF PREMIUMS CEDED TO FACULTATIVE RI (BY REINSURER)';
					}
				}
			}
			var content = contextPath+"/ReinsuranceReportController?action=printReport"
						+"&noOfCopies="+$F("txtNoOfCopies")
						+"&printerName="+$F("selPrinter")
						+"&destination="+$F("selDestination")
						+"&reportId="+reportId
						+"&reportTitle="+reportTitle
						+"&riCd="+$F("txtRiCd")
						+"&lineCd="+$F("txtLineCd")
						+"&fromDate="+$F("txtFromDate")
						+"&toDate="+$F("txtToDate")
						+"&fileType="+fileType
						+"&moduleId="+"GIACS181"; 
			printGenericReport(content, reportTitle); 
		} catch (e) {
			showErrorMessage("printReport",e);
		}
	}
	
	function validateBeforePrint() {
		try{
			if (checkAllRequiredFieldsInDiv("premCededToFacultativeRi")) {
				if (intialParams.total == 0) {
					showMessageBox("Please extract records first.","I");
					return;
				}
				if (validateExtract() == 'Y') {
					printReport();
				} else {
					showConfirmBox("Confirmation", "The specified parameter/s has not been extracted. Do you want to extract the data using the specified parameter/s?", "Yes", "No",
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
			if (checkAllRequiredFieldsInDiv("premCededToFacultativeRiInnerDiv")) {
				if (validateExtract() == 'Y') {
					showConfirmBox("Confirmation", "Data has been extracted within the specified parameter/s. Do you wish to continue extraction?", "Yes", "No",
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
				parameters : {action : "giacs181ValidateBeforeExtract",
							 fromDate : $F("txtFromDate"),
							 toDate : $F("txtToDate")
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
				parameters : {action : "giacs181ExtractToTable",
							 fromDate : $F("txtFromDate"),
							 toDate : $F("txtToDate")
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
							showMessageBox("Extraction finished. No records extracted","I");
						}else{
							showMessageBox("Extraction finished. "+result.exist +" records extracted.",imgMessage.SUCCESS);
						}
						intialParams = getInitialParams();
					}
				}
			});
		} catch (e) {
			showErrorMessage("extractToTable",e);
		}
	}
	
	function getInitialParams() {
		try {
			var result = null;
			new Ajax.Request(contextPath+"/GIACReinsuranceReportsController",{
				method: "POST",
				parameters : {action : "giacs181GetParams"},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						result = JSON.parse(response.responseText);
					}
				}
			});
			return result;
		} catch (e) {
			showErrorMessage("getInitialParams",e);
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
	
	function showGiacs181RiLov(findText2,id){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
								 action   : "getGiacs181RiLOV",
								 findText2 : ($("txtRiCd").readAttribute("lastValidValue").trim() != $F("txtRiCd").trim() ? $F("txtRiCd").trim() : "%"),
								 page : 1
				},
				title: "List of Reinsurers",
				width: 400,
				height: 390,
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
					    width: '280px',
					    align: 'left'
					}
				],
				draggable: true,
				autoSelectOneRecord: true,
				filterText : ($("txtRiCd").readAttribute("lastValidValue").trim() != $F("txtRiCd").trim() ? $F("txtRiCd").trim() : ""),
				onSelect: function(row) {
					$("txtRiCd").value = row.riCd;
					$("txtRiName").value = unescapeHTML2(row.riName);
					$("txtRiCd").setAttribute("lastValidValue", row.riCd);
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
			showErrorMessage("showGiacs181RiLov",e);
		}
	}
	
	function showGiacs181LineLov(){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
								 action   : "getGiacs181LineLOV",
								 findText2 : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : "%"),
								 page : 1
				},
				title: "List of Lines",
				width: 400,
				height: 390,
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
					    width: '280px',
					    align: 'left'
					}
				],
				draggable: true,
				autoSelectOneRecord: true,
				filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
				onSelect: function(row) {
					$("txtLineCd").value = unescapeHTML2(row.lineCd);
					$("txtLineName").value = unescapeHTML2(row.lineName);
					$("txtLineCd").setAttribute("lastValidValue", row.lineCd);
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
			showErrorMessage("showGiacs181LineLov",e);
		}
	}
	/* observe */
	$("searchRiCd").observe("click", showGiacs181RiLov);
	$("searchLineCd").observe("click", showGiacs181LineLov);
	$("txtRiCd").observe("change", function() {
		if (this.value.trim() == "") {
			$("txtRiCd").clear();
			$("txtRiName").value = "ALL REINSURERS";
			$("txtRiCd").setAttribute("lastValidValue", "");
		}else{
			if($F("txtRiCd").trim() != "" && $F("txtRiCd") != $("txtRiCd").readAttribute("lastValidValue")) {
				showGiacs181RiLov();
			}
		}
	});
	$("txtLineCd").observe("change", function() {
		if (this.value.trim() == "") {
			$("txtLineCd").clear();
			$("txtLineName").value = "ALL LINES";
			$("txtLineCd").setAttribute("lastValidValue", "");
		}else{
			if($F("txtLineCd").trim() != "" && $F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue")) {
				showGiacs181LineLov();
			}
		}
	});
	$("hrefFromDate").observe("click", function(){
		scwShow($('txtFromDate'),this, null);
	});
	$("hrefToDate").observe("click", function(){
		scwShow($('txtToDate'),this, null);
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
	$("rdoSummary").observe("change", function(){
		$("rdoAccDate").disable();
		$("rdoReinsurer").disable();	
		$("rdoWithAging").enable();
		document.getElementById("rdoWithAging").checked = false;
		//$("rdoWithAging").disable();
	});
	$("rdoDetailed").observe("change", function(){
		$("rdoAccDate").enable();
		$("rdoReinsurer").enable();
		document.getElementById("rdoWithAging").checked = false;	
			if ($("rdoDetailed").checked && $("rdoReinsurer").checked) {
				("rdoWithAging").enable();
			}else {
				$("rdoWithAging").disable();
			}				
		//$("rdoWithAging").enable();
		//$("rdoWithAging").disable();
	});
	$("rdoAccDate").observe("change", function(){
		$("rdoWithAging").disable();
	});
	$("rdoReinsurer").observe("change", function(){
		$("rdoWithAging").enable();
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
</script>