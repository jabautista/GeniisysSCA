<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="prodRegisterPerPerilMainDiv" name="prodRegisterPerPerilMainDiv">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
	   		<label>Production Register with Peril Breakdown</label>
	   	</div>
	</div>
	<div class="sectionDiv" id="prodRegisterPerPerilBody" >
		<div class="sectionDiv" id="prodRegisterPerPeril" style="width: 70%; margin: 40px 138px 40px 138px;">
			<div class="sectionDiv" id="prodRegisterPerPerilInnerDiv" style="width: 97%; margin: 8px 8px 2px 8px;">
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
						<td class="rightAligned">Branch</td>
						<td colspan="3">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="allCaps"  type="text" id="txtBranchCd" name="txtBranchCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;" lastValidValue="" ignoreDelKey="true"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchCd" name="searchBranchCd" alt="Go" style="float: right;"/>
							</span>
							<input type="text" id="txtBranchName" name="txtBranchName" style="width: 324px; float: left; text-align: left;" value="ALL BRANCHES" readonly="readonly"/>								
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Line</td>
						<td colspan="3">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="allCaps"  type="text" id="txtLineCd" name="txtLineCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;" lastValidValue="" ignoreDelKey="true"/>		
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" name="searchLineCd" alt="Go" style="float: right;"/>
							</span>
							<input type="text" id="txtLineName" name="txtLineName" style="width: 324px; float: left; text-align: left;" value="ALL LINES" readonly="readonly"/>								
						</td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="rdoIssCdDiv" style="width: 46%; height:100px; margin: 0 0 2px 8px;">
				<table align = "left" style="padding: 20px 0 0 30px;">
					<tr>
						<td><input type="radio" name="byIssCd" id="rdoCredBranch" title="Crediting Branch" style="float: left; margin-right: 7px;"/><label for="rdoCredBranch" style="float: left; height: 20px; padding-top: 3px;">Crediting Branch</label></td>
					</tr>
					<tr height="40px">
						<td><input type="radio" checked="checked"  name="byIssCd" id="rdoIssSource" title="Issuing Source" style="float: left; margin-right: 7px;"/><label for="rdoIssSource" style="float: left; height: 20px; padding-top: 3px;">Issuing Source</label></td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="rdoBusinessDiv" style="width: 50%; height:100px; margin: 0 0 2px 4px;">
				<table align = "left" style="padding: 20px 0 0 30px;">
					<tr>
						<td><input type="radio" checked="checked" id="rdoDirectBus" name="byBusiness" title="Direct Business" style="float: left; margin-right: 7px;"/><label for="rdoDirectBus" style="float: left; height: 20px; padding-top: 3px;">Direct Business</label></td>
					</tr>
					<tr height="40px">
						<td><input type="radio" id="rdoInwardFacul" name="byBusiness" title="Inward Facultative" style="float: left; margin-right: 7px;"/><label for="rdoInwardFacul" style="float: left; height: 20px; padding-top: 3px;">Inward Facultative</label></td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="rdoPolicyDiv" style="width: 46%; height:130px; margin: 0 0 8px 8px;">
				<table align = "left" style="padding: 15px 0 0 30px;">
					<tr>
						<td><input type="radio" checked="checked" id="rdoPolicyEndt" name="byPolicy" title="Policy Endorsement" style="float: left; margin-right: 7px;"/><label for="rdoPolicyEndt" style="float: left; height: 20px; padding-top: 3px;">Policy Endorsement</label></td>
					</tr>
					<tr height="40px">
						<td><input type="radio" id="rdoEndt" name="byPolicy" title="Endorsement Only" style="float: left; margin-right: 7px;"/><label for="rdoEndt" style="float: left; height: 20px; padding-top: 3px;">Endorsement Only</label></td>
					</tr>
					<tr>
						<td><input type="radio" id="rdoPolicy" name="byPolicy" title="Policy Only" style="float: left; margin-right: 7px;"/><label for="rdoPolicy" style="float: left; height: 20px; padding-top: 3px;">Policy Only</label></td>
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
	setModuleId("GIACS111");
	setDocumentTitle("Production Register with Peril Breakdown");
	toggleRequiredFields("screen");
	
	function printReport() {
		try {
			var reportId = null;
			var reportTitle = null;
			var policyType = null;
			var fileType = $("rdoPdf").checked ? "PDF" : "XLS";
			var chkIssueCode = $("rdoCredBranch").checked ? "C" : "";
		
			if($("rdoDirectBus").checked){
				reportId = 'GIACR213';
				reportTitle = 'Production Register (Direct Bussiness)';
			}else {
				reportId = 'GIACR216';
				reportTitle = 'Production Register ( Assumed Business)';
			}
			if ($("rdoPolicyEndt").checked) {
				policyType = "A";
			} else if ($("rdoEndt").checked) {
				policyType = "E"; 
			}else{
				policyType = "P"; 
			}
			var content = contextPath+"/EndOfMonthPrintReportController?action=printReport"
						+"&noOfCopies="+$F("txtNoOfCopies")
						+"&printerName="+$F("selPrinter")
						+"&destination="+$F("selDestination")
						+"&reportId="+reportId
						+"&reportTitle="+reportTitle
						+"&issCd="+$F("txtBranchCd")
						+"&lineCd="+$F("txtLineCd")
						+"&fromDate="+$F("txtFromDate")	
						+"&toDate="+$F("txtToDate")
						+"&fileType="+fileType
						+"&chkIssueCode="+chkIssueCode
						+"&policyType="+policyType
						+"&moduleId="+"GIACS111"; 
			printGenericReport(content, reportTitle);
		} catch (e) {
			showErrorMessage("printReport",e);
		}
	}
	
	function validateBeforePrint() {
		var dest = $F("selDestination");
		if (checkAllRequiredFieldsInDiv("prodRegisterPerPerilInnerDiv")) {
			if(dest == "printer"){
				if(checkAllRequiredFieldsInDiv("printDiv")){
					if((isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0)){
						showMessageBox("Invalid number of copies.", "I");
					}else{
						printReport();
					}
				}
			}else{
				printReport();
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
	
	function showGiacs111BranchLov(){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
								 action   : "getGiacs111BranchLOV",
								 findText2 : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : "%"),
								 page : 1
				},
				title: "List of Branches",
				width: 400,
				height: 400,
				columnModel: [
					{
						id : 'branchCd',
						title: 'Branch Code',
						width : '100px',
						align: 'right'
					},
					{
						id : 'branchName',
						title: 'Branch Name',
					    width: '280px',
					    align: 'left'
					}
				],
				draggable: true,
				autoSelectOneRecord: true,
				filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : ""),
				onSelect: function(row) {
					$("txtBranchCd").value = row.branchCd;
					$("txtBranchName").value = unescapeHTML2(row.branchName);
					$("txtBranchCd").setAttribute("lastValidValue", row.branchCd);
					$("txtLineCd").focus();
				},
				onCancel: function (){
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
		}catch(e){
			showErrorMessage("showGiacs111BranchLov",e);
		}
	}
	
	function showGiacs111LineLov(){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
								 action   : "getGiacs111LineLOV",
								 issCd : $F("txtBranchCd"),
								 findText2 : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : "%"),
								 page : 1
				},
				title: "List of Lines",
				width: 400,
				height: 400,
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
			showErrorMessage("showGiacs111LineLov",e);
		}
	}
	
	/* observe */
	$("searchBranchCd").observe("click", showGiacs111BranchLov);
	$("searchLineCd").observe("click", showGiacs111LineLov);
	
	$("txtBranchCd").observe("change", function() {
		if($F("txtBranchCd").trim() == "") {
			$("txtBranchCd").value = "";
			$("txtBranchCd").setAttribute("lastValidValue", "");
			$("txtBranchName").value = "ALL BRANCHES";
		} else {
			if($F("txtBranchCd").trim() != "" && $F("txtBranchCd") != $("txtBranchCd").readAttribute("lastValidValue")) {
				showGiacs111BranchLov();
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
				showGiacs111LineLov();
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