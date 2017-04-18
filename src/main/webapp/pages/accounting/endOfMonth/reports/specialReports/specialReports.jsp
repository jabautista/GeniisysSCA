<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="specialReportsMainDiv" name="specialReportsMainDiv">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
	   		<label>Special Reports</label>
	   	</div>
	</div>
	<div class="sectionDiv" id="specialReportsBody" >
		<div class="sectionDiv" id="specialReports" style="width: 70%; margin: 40px 138px 40px 138px;">
			<div class="sectionDiv" id="specialReportsInnerDiv" style="width: 97%; margin: 8px 8px 4px 8px;">
				<table align="center" style="padding: 20px;">
					<tr>
						<td class="rightAligned">From</td>
						<td>
							<div style="float: left; width: 160px;" class="withIconDiv required">
								<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon required" readonly="readonly" style="width: 135px;"/>
								<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"/>
							</div>
						</td>
						<td class="rightAligned" width="122px">To</td>
						<td>
							<div style="float: left; width: 160px;" class="withIconDiv required">
								<input type="text" id="txtToDate" name="txtToDate" class="withIcon required" readonly="readonly" style="width: 135px;"/>
								<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Report Title</td>
						<td colspan="3">
							<span class="lovSpan required" style="width:100px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input class="required" type="text" id="txtReportId" name="txtReportId" style="width: 70px; float: left; margin-right: 4px; border: none; height: 13px;" maxlength="12" lastValidValue=""/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchReportId" name="searchReportId" alt="Go" style="float: right;"/>
							</span>
							<input type="text" id="txtReportName" name="txtReportName" style="width: 344px; float: left; text-align: left;" readonly="readonly"/>								
						</td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="rdoReportDiv" style="width: 34%; height:130px; margin: 0 0 8px 8px;">
				<table align = "left" style="padding: 30px 0 0 30px;">
					<tr>
						<td><input type="radio" checked="checked" id="rdoRepByLine" name="byType" title="Report by Line" style="float: left; margin-right: 7px;"/><label for="rdoRepByLine" style="float: left; height: 20px; padding-top: 3px;">Report by Line</label></td>
					</tr>
					<tr height="40px">
						<td><input type="radio" id="rdoRepByBranch" name="byType" title="Report by Branch" style="float: left; margin-right: 7px;"/><label for="rdoRepByBranch" style="float: left; height: 20px; padding-top: 3px;">Report by Branch</label></td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="printDiv" style="width: 62%; height:130px; margin: 0 8px 6px 4px;">
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
				<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width: 100px; margin-bottom: 10px; margin-top: 10px;">
			</div>
		</div>
	</div>
</div>

<script>
	initializeAll();
	setModuleId("GIACS151");
	setDocumentTitle("Special Reports");
	toggleRequiredFields("screen");
	var reportExist = true;

	function printReport() {
		try {
			var reportId = null;
			var reportTitle = null;
			var fileType = $("rdoPdf").checked ? "PDF" : "XLS";
			if($("rdoRepByLine").checked){
				reportId = 'GIACR166';
				reportTitle = '';
			}else {
				reportId = 'GIACR165';
				reportTitle = '';
			}
			var content = contextPath+"/EndOfMonthPrintReportController?action=printReport"
						+"&noOfCopies="+$F("txtNoOfCopies")
						+"&printerName="+$F("selPrinter")
						+"&destination="+$F("selDestination")
						+"&reportId="+reportId
						+"&reportTitle="+reportTitle
						+"&reportId="+$F("txtReportId")
						+"&fromDate="+$F("txtFromDate")	
						+"&toDate="+$F("txtToDate")
						+"&fileType="+fileType
						+"&repId="+$F("txtReportId")
						+"&moduleId="+"GIACS151"; 
			printGenericReport(content, reportTitle);
		} catch (e) {
			showErrorMessage("printReport",e);
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
	
	function showGiacs151ReportLov(){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
								 action   : "getGiacs151ReportLOV",
								 findText2 : ($("txtReportId").readAttribute("lastValidValue").trim() != $F("txtReportId").trim() ? $F("txtReportId").trim() : "%"),
								 page : 1
				},
				title: "Report Title",
				width: 400,
				height: 380,
				columnModel: [
					{
						id : 'repCd',
						title: 'Report Cd.',
						width : '100px',
						align: 'left'
					},
					{
						id : 'repTitle',
						title: 'Report Name',
					    width: '250px',
					    align: 'left'
					}
				],
				draggable: true,
				autoSelectOneRecord: true,
				filterText: ($("txtReportId").readAttribute("lastValidValue").trim() != $F("txtReportId").trim() ? $F("txtReportId").trim() : ""),
				onSelect: function(row) {
					$("txtReportId").value = row.repCd;
					$("txtReportId").setAttribute("lastValidValue", row.repCd);	
					$("txtReportName").value = unescapeHTML2(row.repTitle);
				},
				onCancel: function(){
					$("txtReportId").value = $("txtReportId").readAttribute("lastValidValue");
		  		},
		  		onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtReportId").value = $("txtReportId").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
		}catch(e){
			showErrorMessage("showGiacs151ReportLov",e);
		}
	}
	
	/* observe */
	$("searchReportId").observe("click", showGiacs151ReportLov);
	$("txtReportId").observe("change", function() {
		if($F("txtReportId").trim() == "") {
			$("txtReportId").value = "";
			$("txtReportId").setAttribute("lastValidValue", "");
			$("txtReportName").value = "";
		} else {
			if($F("txtReportId").trim() != "" && $F("txtReportId") != $("txtReportId").readAttribute("lastValidValue")) {
				showGiacs151ReportLov();
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
		var dest = $F("selDestination");
		if(checkAllRequiredFieldsInDiv("specialReportsInnerDiv")){
			if(dest == "printer"){
				if(checkAllRequiredFieldsInDiv("printDiv")){
					printReport();
				}
			}else{
				printReport();
			}	
		}
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
		if(isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0 || $F("txtNoOfCopies") > 100){
			showWaitingMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", function(){
				$("txtNoOfCopies").value = "1";
			});			
		}
	});
	
	$("acExit").stopObserving();
	$("acExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});
</script>