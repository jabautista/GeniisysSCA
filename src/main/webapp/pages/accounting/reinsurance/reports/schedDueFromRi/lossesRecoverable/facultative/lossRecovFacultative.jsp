<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="lossRecovFacultativeMainDiv" name="lossRecovFacultativeMainDiv">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
	   		<label>Losses Recoverable</label>
	   	</div>
	</div>
	<div class="sectionDiv" id="lossRecovFacultativeBody" >
		<div class="sectionDiv" id="lossRecovFacultative" style="width: 70%; margin: 40px 138px 40px 138px;">
			<div class="sectionDiv" id="lossRecovFacultativeInnerDiv" style="width: 97%; margin: 8px 8px 2px 8px;">
				<table align="center" style="padding: 20px;">
					<tr>
						<td class="rightAligned">From</td>
						<td>
							<div style="float: left; width: 160px;" class="withIconDiv">
								<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon" readonly="readonly" style="width: 135px;"/>
								<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"/>
							</div>
						</td>
						<td class="rightAligned" width="68px">To</td>
						<td>
							<div style="float: left; width: 160px;" class="withIconDiv">
								<input type="text" id="txtToDate" name="txtToDate" class="withIcon" readonly="readonly" style="width: 135px;"/>
								<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="leftAligned">
							<input type="radio" checked="checked" name="byFilter" id="rdoPerLine" title="Per Line" style="float: left;"/><label for="rdoPerLine" style="float: left; height: 20px; padding-top: 3px;">Per Line</label>
						</td>
						<td colspan="3">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="rightAligned allCaps"  type="text" id="txtLineCd" name="txtLineCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;" lastValidValue=""/>		
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" name="searchLineCd" alt="Go" style="float: right;"/>
							</span>
							<input class="allCaps" type="text" id="txtLineName" name="txtLineName" style="width: 324px; float: left; text-align: left;" value="ALL LINES" readonly="readonly"/>								
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Filter by RI</td>
						<td colspan="3">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="rightAligned"  type="text" id="txtFilterRiCd" name="txtFilterRiCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;" lastValidValue=""/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchFilterRiCd" name="searchFilterRiCd" alt="Go" style="float: right;"/>
							</span>
							<input type="text" id="txtFilterRiName" name="txtFilterRiName" style="width: 324px; float: left; text-align: left;" value="ALL REINSURERS" readonly="readonly"/>								
						</td>
					</tr>
					<tr>
						<td class="leftAligned">
							<input type="radio" name="byFilter" id="rdoPerRi" title="Per Reinsurer" style="float: left;"/><label for="rdoPerRi" style="float: left; height: 20px; padding-top: 3px;">Per Reinsurer</label>
						</td>
						<td colspan="3">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="rightAligned"  type="text" id="txtRiCd" name="txtRiCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;" lastValidValue=""/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchRiCd" name="searchRiCd" alt="Go" style="float: right;"/>
							</span>
							<input type="text" id="txtRiName" name="txtRiName" style="width: 324px; float: left; text-align: left;" readonly="readonly"/>								
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Filter by Line</td>
						<td colspan="3">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="rightAligned allCaps"  type="text" id="txtFilterLineCd" name="txtFilterLineCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;" lastValidValue=""/>		
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchFilterLineCd" name="searchFilterLineCd" alt="Go" style="float: right;"/>
							</span>
							<input class="allCaps" type="text" id="txtFilterLineName" name="txtFilterLineName" style="width: 324px; float: left; text-align: left;" readonly="readonly"/>								
						</td>
					</tr>
					<tr height="35px" valign="bottom">
						<td></td>
						<td colspan="3">
							<input type="checkbox" checked="checked"  id="chkClmPayments" title="with Claim Payments only" style="float: left;"/><label for="chkClmPayments" style="float: left; height: 20px; padding-left: 3px;">with Claim Payments only</label>
						</td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="printDiv" style="width: 97%; height:130px; margin: 0 8px 2px 8px;">
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
	giacs119NewFormInstance();
	setModuleId("GIACS119");
	setDocumentTitle("Losses Recoverable");
	toggleRequiredFields("screen");
	var riExist = true;
	var lineExist = true;

	function printReport() {
		try {
			//report to print GIACR119 and GIACR120
			var reportId = null;
			var riCd = null;
			var lineCd = null;
			var chkClmPayments = $("chkClmPayments").checked ? 1 : 0;
			if($("rdoPerLine").checked){
				reportId = 'GIACR119';
				riCd = $F("txtFilterRiCd");
				lineCd = $F("txtLineCd");
			}else {
				reportId = 'GIACR120';
				riCd = $F("txtRiCd");
				lineCd = $F("txtFilterLineCd");
			}
			var fileType = $("rdoPdf").checked ? "PDF" : "XLS";
			var content = contextPath+"/ReinsuranceReportController?action=printReport"
						+"&noOfCopies="+$F("txtNoOfCopies")
						+"&printerName="+$F("selPrinter")
						+"&destination="+$F("selDestination")
						+"&reportId="+reportId
						+"&reportTitle=SCHEDULE OF LOSSES RECOVERABLE FROM FACULTATIVE RI"
						+"&riCd="+riCd
						+"&lineCd="+lineCd
						+"&fromDate="+$F("txtFromDate")
						+"&toDate="+$F("txtToDate")
						+"&fileType="+fileType
						+"&chkClmPayments="+chkClmPayments
						+"&moduleId="+"GIACS119"; 
			printGenericReport(content, "SCHEDULE OF LOSSES RECOVERABLE FROM FACULTATIVE RI");
		} catch (e) {
			showErrorMessage("printReport",e);
		}
	}
	
	function validateBeforePrint() {
		if ($F("txtFromDate") == "" && $F("txtToDate") == "") {
			showMessageBox("Please enter From Date and To Date.","E");
		}else if ($F("txtFromDate") == "") {
			showMessageBox("Please enter From Date.","E");
		}else if ($F("txtToDate") == "") {
			showMessageBox("Please enter To Date.","E");
		}else if (compareDatesIgnoreTime(Date.parse($F("txtFromDate")),Date.parse($("txtToDate").value)) == -1) {
			showMessageBox("From Date should be earlier than To Date","E");
		}else{
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
	
	function rdoChangeEvent() {
		if ($("rdoPerLine").checked) {
			$("txtRiCd").clear();
			$("txtRiName").clear();
			$("txtFilterLineCd").clear();
			$("txtFilterLineName").clear();
			$("txtRiCd").readOnly = true;
			$("txtRiName").readOnly = true;
			$("txtFilterLineCd").readOnly = true;
			$("txtFilterLineName").readOnly = true;
			$("txtLineCd").readOnly = false;
			$("txtLineName").readOnly = false;
			$("txtFilterRiCd").readOnly = false;
			$("txtFilterRiName").readOnly = false;
			disableSearch("searchRiCd");
			disableSearch("searchFilterLineCd");
			enableSearch("searchLineCd");
			enableSearch("searchFilterRiCd");
			$("txtLineName").value = "ALL LINES";
			$("txtFilterRiName").value = "ALL REINSURERS";
			$("txtRiCd").setAttribute("lastValidValue", "");
			$("txtFilterLineCd").setAttribute("lastValidValue", "");
		} else {
			$("txtLineCd").clear();
			$("txtLineName").clear();
			$("txtFilterRiCd").clear();
			$("txtFilterRiName").clear();
			$("txtLineCd").readOnly = true;
			$("txtLineName").readOnly = true;
			$("txtFilterRiCd").readOnly = true;
			$("txtFilterRiName").readOnly = true;
			$("txtRiCd").readOnly = false;
			$("txtRiName").readOnly = false;
			$("txtFilterLineCd").readOnly = false;
			$("txtFilterLineName").readOnly = false;
			disableSearch("searchLineCd");
			disableSearch("searchFilterRiCd");
			enableSearch("searchRiCd");
			enableSearch("searchFilterLineCd");
			$("txtRiName").value = "ALL REINSURERS";
			$("txtFilterLineName").value = "ALL LINES";
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtFilterRiCd").setAttribute("lastValidValue", "");
		}
	}
	
	function giacs119NewFormInstance() {
		$("txtRiCd").readOnly = true;
		$("txtRiName").readOnly = true;
		$("txtFilterLineCd").readOnly = true;
		$("txtFilterLineName").readOnly = true;
		disableSearch("searchRiCd");
		disableSearch("searchFilterLineCd");
		$("txtFromDate").value = dateFormat(new Date(),'mm-01-yyyy');
		$("txtToDate").value = dateFormat(new Date(),'mm-dd-yyyy');
	}
	
	function showGiacs119RiLov(){
		try{
			var id = null;
			if ($("rdoPerLine").checked) {
				id = "txtFilterRiCd";
			} else {
				id = "txtRiCd";
			}
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
								 action   : "getGiacs119RiLOV",
								 findText2 : ($(id).readAttribute("lastValidValue").trim() != $F(id).trim() ? $F(id).trim() : "%"),
								 page : 1
				},
				title: "Lists of Reinsurers",
				width: 400,
				height: 380,
				columnModel: [
					{
						id : 'riCd',
						title: 'Code',
						width : '60px',
						align: 'right'
					},
					{
						id : 'riSname',
						title: 'Alias',
					    width: '100px',
					    align: 'left'
					},
					{
						id : 'riName',
						title: 'Reinsurer Name',
					    width: '190px',
					    align: 'left'
					}
				],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: ($(id).readAttribute("lastValidValue").trim() != $F(id).trim() ? $F(id).trim() : ""),
				onSelect: function(row) {
					if ($("rdoPerLine").checked) {
						$("txtFilterRiCd").value = row.riCd;
						$("txtFilterRiName").value = unescapeHTML2(row.riSname);
					} else {
						$("txtRiCd").value = row.riCd;
						$("txtRiName").value = unescapeHTML2(row.riSname);
					}
					$(id).setAttribute("lastValidValue", row.riCd);	
				},
				onCancel: function(){
					$(id).value = $(id).readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$(id).value = $(id).readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
		}catch(e){
			showErrorMessage("showGiacs119RiLov",e);
		}
	}
	
	function showGiacs119LineLov(){
		try{
			var id = null;
			if ($("rdoPerLine").checked) {
				id = "txtLineCd";
			} else {
				id = "txtFilterLineCd";
			}
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
								 action   : "getGiacs119LineLOV",
								 findText2 : ($(id).readAttribute("lastValidValue").trim() != $F(id).trim() ? $F(id).trim() : "%"),
								 page : 1
				},
				title: "Lists of Available Lines",
				width: 400,
				height: 380,
				columnModel: [
					{
						id : 'lineCd',
						title: 'Code',
						width : '100px',
						align: 'left'
					},
					{
						id : 'lineName',
						title: 'Line',
					    width: '250px',
					    align: 'left'
					}
				],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: ($(id).readAttribute("lastValidValue").trim() != $F(id).trim() ? $F(id).trim() : ""),
				onSelect: function(row) {
					if ($("rdoPerLine").checked) {
						$("txtLineCd").value = unescapeHTML2(row.lineCd);
						$("txtLineName").value = unescapeHTML2(row.lineName);
					}else{
						$("txtFilterLineCd").value = unescapeHTML2(row.lineCd);
						$("txtFilterLineName").value = unescapeHTML2(row.lineName);
					}
					$(id).setAttribute("lastValidValue", row.lineCd);	
				},
				onCancel: function(){
					$(id).value = $(id).readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$(id).value = $(id).readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
		}catch(e){
			showErrorMessage("showGiacs119LineLov",e);
		}
	}
	/* observe */
	$("rdoPerLine").observe("click",rdoChangeEvent);
	$("rdoPerRi").observe("click",rdoChangeEvent);
	$("searchRiCd").observe("click", showGiacs119RiLov);
	$("searchFilterRiCd").observe("click", showGiacs119RiLov);
	$("searchLineCd").observe("click", showGiacs119LineLov);
	$("searchFilterLineCd").observe("click", showGiacs119LineLov);
	
	$("txtRiCd").observe("change", function() {
		if($F("txtRiCd").trim() == "") {
			$("txtRiCd").value = "";
			$("txtRiCd").setAttribute("lastValidValue", "");
			$("txtRiName").value = "";
		} else {
			if($F("txtRiCd").trim() != "" && $F("txtRiCd") != $("txtRiCd").readAttribute("lastValidValue")) {
				showGiacs119RiLov();
			}
		}
	});
	
	$("txtFilterRiCd").observe("change", function() {
		if($F("txtFilterRiCd").trim() == "") {
			$("txtFilterRiCd").value = "";
			$("txtFilterRiCd").setAttribute("lastValidValue", "");
			$("txtFilterRiName").value = "";
		} else {
			if($F("txtFilterRiCd").trim() != "" && $F("txtFilterRiCd") != $("txtFilterRiCd").readAttribute("lastValidValue")) {
				showGiacs119RiLov();
			}
		}
	});
	
	$("txtLineCd").observe("change", function() {
		if($F("txtLineCd").trim() == "") {
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").value = "";
		} else {
			if($F("txtLineCd").trim() != "" && $F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue")) {
				showGiacs119LineLov();
			}
		}
	});
	
	$("txtFilterLineCd").observe("change", function() {
		if($F("txtFilterLineCd").trim() == "") {
			$("txtFilterLineCd").value = "";
			$("txtFilterLineCd").setAttribute("lastValidValue", "");
			$("txtFilterLineName").value = "";
		} else {
			if($F("txtFilterLineCd").trim() != "" && $F("txtFilterLineCd") != $("txtFilterLineCd").readAttribute("lastValidValue")) {
				showGiacs119LineLov();
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
		if(dest == "printer"){
			if(checkAllRequiredFieldsInDiv("printDiv")){
				validateBeforePrint();
			}
		}else{
			validateBeforePrint();
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