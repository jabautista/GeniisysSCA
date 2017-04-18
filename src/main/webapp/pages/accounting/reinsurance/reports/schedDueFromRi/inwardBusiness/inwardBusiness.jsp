<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="inwardBusinessMainDiv" name="inwardBusinessMainDiv">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
	   		<label>Print Incoming Facultative RI Subsidiary Ledger</label>
	   	</div>
	</div>
	<div class="sectionDiv" id="inwardBusinessBody" >
		<div class="sectionDiv" id="inwardBusiness" style="width: 70%; margin: 40px 138px 40px 138px;">
			<div class="sectionDiv" id="inwardBusinessInnerDiv" style="width: 97%; margin: 8px 8px 2px 8px;">
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
								<input  class="rightAligned allCaps"  type="text" id="txtRiCd" name="txtRiCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;" lastValidValue = "" maxlength="5"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchRiCd" name="searchRiCd" alt="Go" style="float: right;"/>
							</span>
							<input type="text" id="txtRiName" name="txtRiName" style="width: 325px; float: left; text-align: left;" value="ALL REINSURERS" readonly="readonly"/>								
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Line</td>
						<td colspan="3">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="leftAligned allCaps"  type="text" id="txtLineCd" name="txtLineCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;" lastValidValue = "" maxlength="2"/>		
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" name="searchLineCd" alt="Go" style="float: right;"/>
							</span>
							<input class="allCaps" type="text" id="txtLineName" name="txtLineName" style="width: 325px; float: left; text-align: left;" value="ALL LINES" readonly="readonly"/>								
						</td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="rdoDiv" style="width: 38%; height:130; margin: 0 0 8px 8px;">
				<table align = "center" style="padding: 10px;">
					<tr>
						<td><input type="radio" checked="checked" name="byDateType" id="rdoInceptDate" title="Effectivity Date" style="float: left;"/><label for="rdoInceptDate" style="float: left; height: 20px; padding-top: 3px;">Effectivity Date</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="byDateType" id="rdoIssueDate" title="Issue Date" style="float: left;"/><label for="rdoIssueDate" style="float: left; height: 20px; padding-top: 3px;">Issue Date</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="byDateType" id="rdoAccDate" title="Acctg Entry Date" style="float: left;"/><label for="rdoAccDate" style="float: left; height: 20px; padding-top: 3px;">Acctg Entry Date</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="byDateType" id="rdoBookingDate" title="Booking Date" style="float: left;"/><label for="rdoBookingDate" style="float: left; height: 20px; padding-top: 3px;">Booking Date</label></td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="printDiv" style="width: 58%; height:130px; margin: 0 8px 6px 4px;">
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
							<input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="fileType" style="margin: 2px 4px 4px 25px; float: left;display:none" disabled="disabled"><label for="rdoExcel" style="margin: 2px 0 4px 0;display:none">Excel</label>   <!-- jhing hide excel - GENQA  5269 -->
							<input value="CSV" title="CSV" type="radio" id="csvRB" name="fileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="csvRB" style="margin: 2px 0 4px 0">CSV</label>
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
				<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width: 100px; margin-bottom: 10px; margin-top: 10px;">
			</div>
		</div>
	</div>
</div>

<script>
	initializeAll();
	setModuleId("GIACS105");
	setDocumentTitle("Print Incoming Facultative RI Subsidiary Ledger");
	toggleRequiredFields("screen");
	var riExist = true;
	var lineExist = true;

	function printReport() {
		try {
			var dateType = null;
			if($("rdoInceptDate").checked){
				dateType = 2;
			}else if ($("rdoIssueDate").checked) {
				dateType = 1;
			}else if ($("rdoAccDate").checked) {
				dateType = 3;
			}else {
				dateType = 4;
			}
			var fileType = null;
			var withCsv = null;
			if($("rdoPdf").checked){
				fileType = "PDF";
			}else if ($("rdoExcel").checked){
				fileType = "XLS";
			}else if ($("csvRB").checked){
				fileType = "CSV";
				withCsv = "Y";
			}
			
			var content = contextPath+"/ReinsuranceReportController?action=printReport"
						+"&noOfCopies="+$F("txtNoOfCopies")
						+"&printerName="+$F("selPrinter")
						+"&destination="+$F("selDestination")
						+"&reportId=GIACR105"
						+"&reportTitle=OUTGOING REINSURANCE SUBSIDIARY LEDGER"
						+"&riCd="+$F("txtRiCd")
						+"&lineCd="+$F("txtLineCd")
						+"&dateType="+dateType
						+"&fromDate="+$F("txtFromDate")
						+"&toDate="+$F("txtToDate")
						+"&fileType="+fileType
						+"&moduleId="+"GIACS105"; 
			printGenericReport(content, "INCOMING REINSURANCE SUBSIDIARY LEDGER",null,withCsv); 
		} catch (e) {
			showErrorMessage("printReport",e);
		}
	}
	
	function validateBeforePrint() {
		if (checkAllRequiredFieldsInDiv("inwardBusiness")) {
			printReport();
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
			$("csvRB").disable(); 
		} else {
			if(dest == "file"){
				$("rdoPdf").enable();
				$("rdoExcel").enable();
				$("csvRB").enable(); 
			} else {
				$("rdoPdf").disable();
				$("rdoExcel").disable();
				$("csvRB").disable(); 
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
	
	function showGiacs105RiLov(){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
								 action   : "getGiacs105RiLOV",
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
					    width: '270px',
					    align: 'left'
					}
				],
				draggable: true,
				autoSelectOneRecord: true,
				filterText : ($("txtRiCd").readAttribute("lastValidValue").trim() != $F("txtRiCd").trim() ? $F("txtRiCd").trim() : ""),
				onSelect: function(row) {
					if(row != undefined){
						$("txtRiCd").value = row.riCd;
						$("txtRiCd").setAttribute("lastValidValue", row.riCd);
						$("txtRiName").value = unescapeHTML2(row.riName);
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
			showErrorMessage("showGiacs105RiLov",e);
		}
	}
	
	function showGiacs105LineLov(){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
								 action   : "getGiacs105LineLOV",
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
					    width: '270px',
					    align: 'left'
					}
				],
				draggable: true,
				autoSelectOneRecord: true,
				filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
				onSelect: function(row) {
					if(row != undefined){
						$("txtLineCd").value = row.lineCd;
						$("txtLineCd").setAttribute("lastValidValue", row.lineCd);
						$("txtLineName").value = unescapeHTML2(row.lineName);
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
			showErrorMessage("showGiacs105LineLov",e);
		}
	}
	/* observe */
	$("searchRiCd").observe("click", showGiacs105RiLov);
	$("searchLineCd").observe("click", showGiacs105LineLov);
	
	$("txtRiCd").observe("change", function() {
		if($F("txtRiCd").trim() == "") {
			$("txtRiCd").value = "";
			$("txtRiCd").setAttribute("lastValidValue", "");
			$("txtRiName").value = "ALL REINSURERS";
		} else {
			if($F("txtRiCd").trim() != "" && $F("txtRiCd") != $("txtRiCd").readAttribute("lastValidValue")) {
				showGiacs105RiLov();
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
				showGiacs105LineLov();
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