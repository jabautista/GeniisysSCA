<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="billingStatementMainDiv" name="billingStatementMainDiv">
	<div id="billingStatementReportMenu">
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
			<label>Billing for Salary Deduction</label>
		</div>
	</div>
	<div class="sectionDiv" id="billingStatementReportBody" >
		<div class="sectionDiv" id="billingStatementReport" style="width: 70%; margin: 40px 138px 40px 138px;">
			<div class="sectionDiv" id="billingStatementInnerDiv" style="width: 97%; margin: 8px 8px 2px 8px;">
				<table align="center" style="padding: 20px;">
					<tr>
						<td class="rightAligned">As Of</td>
						<td>
							<div style="float: left; width: 160px;" class="withIconDiv">
								<input type="text" id="txtAsOfDate" name="txtAsOfDate" class="withIcon required" readonly="readonly" style="width: 135px;"/>
								<img id="imgAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Issuing Source</td>
						<td colspan="5">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="rightAligned"  type="text" id="branchCd" name="branchCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px; text-align: left;" maxlength="2"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchCd" name="searchBranchCd" alt="Go" style="float: right;"/>
							</span>
							<span class="lovSpan" style="width:331px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="leftAligned"  type="text" id="branchName" name="branchName"  value="ALL ISSUING SOURCES" readonly="readonly" style="width: 300px; float: left; margin-right: 4px; border: none; height: 13px;"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchName" name="searchBranchName" alt="Go" style="float: right;"/>
							</span>								
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Company</td>
						<td colspan="5">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="rightAligned integerNoNegativeUnformattedNoComma"  type="text" id="companyCd" name="companyCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px; text-align: right;" maxlength="12"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCompanyCd" name="searchCompanyCd" alt="Go" style="float: right;"/>
							</span>
							<span class="lovSpan" style="width:331px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="leftAligned"  type="text" id="companyName" name="companyName"  value="ALL COMPANIES" readonly="readonly" style="width: 300px; float: left; margin-right: 4px; border: none; height: 13px;"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCompanyName" name="searchCompanyName" alt="Go" style="float: right;"/>
							</span>	
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Employee</td>
						<td colspan="5">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="rightAligned"  type="text" id="employeeCd" name="employeeCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px; text-align: left;" maxlength="12"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchEmployeeCd" name="searchEmployeeCd" alt="Go" style="float: right;"/>
							</span>
							<span class="lovSpan" style="width:331px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="leftAligned"  type="text" id="employeeName" name="employeeName"  value="ALL EMPLOYEES" readonly="readonly" style="width: 300px; float: left; margin-right: 4px; border: none; height: 13px;"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchEmployeeName" name="searchEmployeeName" alt="Go" style="float: right;"/>
							</span>	
						</td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="rdoDiv" style="width: 43%; height:130px; margin: 0 0 8px 8px;">
				<table align = "center" style="padding: 10px; margin-left: 70px; margin-top: 10px;">
					<tr>
						<td>
							<input type="checkbox" checked="" name="perEmployee" id="perEmployee" title="Billing Per Employee" style="float: left;"/>
							<label for="perEmployee" style="float: left; height: 20px; padding-top: 0px;">&nbsp; Billing Per Employee</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" checked="" name="perCompany" id="perCompany" title="Billing Per Company" style="float: left;"/>
							<label for="perCompany" style="float: left; height: 20px; padding-top: 0px;">&nbsp; Billing Per Company</label>
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
	setModuleId("GIACS480");
	setDocumentTitle("Billing Statement (Salary Deduction)");
	initializeAll();
	checkUserAccess();
	togglePrintFields("screen");
	$("perEmployee").checked = false;
	$("perCompany").checked = false;
	var extractDate = "";
	
	$("btnPrint").observe("click", function(){
		if(extractDate != ""){
			if(extractDate != $F("txtAsOfDate")){
				showConfirmBox("Confirmation", "The specified parameter/s has not been extracted. Do you want to extract the data using the specified parameter/s?", "Yes", "No",
						function() {
							extractGIACS480();
						}, "");
			} else {
				validateBeforePrint();				
			}
		} else {
			validateBeforePrint();
		}
	});
	
	function validateBeforePrint(){
		try{
			if (validateExtract() == 'Y') {
				if ($("perEmployee").checked && $("perCompany").checked) {
					var reportList = new Array("GIACR480A", "GIACR480B");
					for(var i = 0; i<reportList.length; i++){
						printReport(reportList[i]);
					} 
				} else if ($("perEmployee").checked) {
					printReport("GIACR480A");
				} else if ( $("perCompany").checked){
					printReport("GIACR480B");
				} else {
					showMessageBox("No report selected.","I");
			 		return false;
				}
			} else {
				showMessageBox("Please extract records first.","I");
				return false;
			}
		} catch (e) {
			showErrorMessage("validateBeforePrint",e);
		}
	}
	
	function printReport(reportId){
		try {
			var content = contextPath + "/CreditAndCollectionReportPrintController?action=printReport"
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
							showMessageBox("Printing Complete.", "I");
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
		var params = "&issCd=" + $("branchCd").value
		+ "&employeeCd=" + $("employeeCd").value
		+ "&companyCd=" + $("companyCd").value
		+ "&asOfDate=" + $("txtAsOfDate").value;
		
		return params;
	}
	
	$("btnExtract").observe("click", function(){
		validateBeforeExtract();
	});
	
	function validateBeforeExtract() {
		try{
		 	if ($F("txtAsOfDate") == "") {
				showMessageBox("Required fields must be entered.","I");
				return false;
			}
		 	
		 	if ($F("companyCd") == "" && $F("employeeCd") != ""){
		 		showMessageBox("Please enter Company CD.","I");
		 		return false;
		 	}
		 	
		 	if (validateExtract() == 'Y') {
				showConfirmBox("Confirmation", "Data has been extracted within this specified parameter/s. Do you wish to continue extraction?", "Yes", "No",
						function() {
							extractGIACS480();
						}, "");
			} else {
				extractGIACS480();
			}
		}catch (e) {
			showErrorMessage("validateBeforeExtract",e);
		}
	}
	
	function validateExtract() {
		try {
			var result = 'N';
			new Ajax.Request(contextPath+"/GIACCreditAndCollectionReportsController",{
				method: "POST",
				parameters : {action : "giacs480ValidateDateParams",
							  asOfDate : $F("txtAsOfDate"),
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
	
	function extractGIACS480(){
		try {
			new Ajax.Request(contextPath+"/GIACCreditAndCollectionReportsController",{
				method: "POST",
				parameters : {action : "extractGIACS480",
							  asOfDate : $F("txtAsOfDate"),
							  issCd : $F("branchCd"),
							  companyCd : $F("companyCd"),
							  employeeCd : $F("employeeCd")
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
							showMessageBox("Extraction finished. " + result.exist + " records extracted.", imgMessage.SUCCESS);
							extractDate = $F("txtAsOfDate");
						}
					}
				}
			});
		} catch (e) {
			showErrorMessage("extractGIACS480",e);
		}
	}
	
	/* $("searchBranchCd").observe("click", function(){
		fetchBranchLOV();
	});
	
	$("searchBranchName").observe("click", function(){
		fetchBranchLOV();
	});
	
	function fetchBranchLOV(){
		LOV.show({
			controller: 'AccountingLOVController',
			urlParameters: {
				action:		"fetchSimpleBranchLOV",
				moduleId:   "GIACS480"  
			},
			title: "Valid Values for Issuing Source",
			width: 405,
			height: 386,
			draggable: true,
			columnModel: [
				{
					id: "branchCd",
					title: "Branch Code",
					width: "100px"
				},
				{
					id: "branchName",
					title: "Branch Name",
					width: "310px"
				}
			],
			onSelect: function(row){
				if(row != undefined){
					$("branchCd").value = row.branchCd;
					$("branchName").value = row.branchName;
				}
			}
		});
	}
	
	$("searchCompanyCd").observe("click", function(){
		fetchCompanyLOV();
	});
	
	$("searchCompanyName").observe("click", function(){
		fetchCompanyLOV();
	});
	
	function fetchCompanyLOV(){
		LOV.show({
			controller: 'AccountingLOVController',
			urlParameters: {
				action:	"fetchCompanyLOV"
			},
			title: "Valid Values for Companies",
			width: 405,
			height: 386,
			draggable: true,
			columnModel: [
				{
					id: "payeeNo",
					title: "Company Code",
					width: "100px"
				},
				{
					id: "payeeLastName",
					title: "Company Name",
					width: "310px"
				}
			],
			onSelect: function(row){
				if(row != undefined){
					$("companyCd").value = row.payeeNo;
					$("companyName").value = row.payeeLastName;
				}
			}
		});
	}
	
	$("searchEmployeeCd").observe("click", function(){
		fetchEmployeeLOV();
	});
	
	$("searchEmployeeName").observe("click", function(){
		fetchEmployeeLOV();
	});
	
	function fetchEmployeeLOV(){
		LOV.show({
			controller: 'AccountingLOVController',
			urlParameters: {
				action:	"fetchEmployeeLOV",
				companyCd: $("companyCd").value
			},
			title: "Valid Values for Employees",
			width: 405,
			height: 386,
			draggable: true,
			columnModel: [
				{
					id: "refPayeeCd",
					title: "Employee Code",
					width: "100px"
				},
				{
					id: "empName",
					title: "Employee Name",
					width: "310px"
				}
			],
			onSelect: function(row){
				if(row != undefined){
					$("employeeCd").value = row.refPayeeCd;
					$("employeeName").value = row.empName;
				}
			}
		});
	} */
	
	$("imgAsOfDate").observe("click", function(){
		scwShow($('txtAsOfDate'),this, null);
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
	
	function checkUserAccess(){
		try{
			new Ajax.Request(contextPath+"/GIACAccTransController?action=checkUserAccess2", {
				method: "POST",
				parameters: {
					moduleName: "GIACS480"
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
	
	$("btnExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	});
	
	/* Modified lov standard here..*/
	
	$("branchCd").setAttribute("lastValidValue", "");
	$("branchName").setAttribute("lastValidValue", "ALL ISSUING SOURCES");
	$("searchBranchCd").observe("click", showGiacs480BranchLov);
	$("branchCd").observe("change", function() {		
		if($F("branchCd").trim() == "") {
			$("branchCd").value = "";
			$("branchCd").setAttribute("lastValidValue", "");
			$("branchName").value = "ALL ISSUING SOURCES";
			$("branchName").setAttribute("lastValidValue", "ALL ISSUING SOURCES");
		} else {
			if($F("branchCd").trim() != "" && $F("branchCd") != $("branchCd").readAttribute("lastValidValue")) {
				showGiacs480BranchLov();
			}
		}
	});
	$("branchCd").observe("keyup", function(){
		$("branchCd").value = $F("branchCd").toUpperCase();
	});
	
	function showGiacs480BranchLov(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "showGiacs480BranchLov",
							filterText : ($("branchCd").readAttribute("lastValidValue").trim() != $F("branchCd").trim() ? $F("branchCd").trim() : ""),
							page : 1},
			title: "List of Issuing Sources",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "branchCd",
								title: "Branch Cd.",
								width: '100px',
							},
							{
								id : "branchName",
								title: "Branch Name",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("branchCd").readAttribute("lastValidValue").trim() != $F("branchCd").trim() ? $F("branchCd").trim() : ""),
				onSelect: function(row) {
					$("branchCd").value = unescapeHTML2(row.branchCd);
					$("branchName").value = unescapeHTML2(row.branchName);
					$("branchCd").setAttribute("lastValidValue", $F("branchCd"));
					$("branchName").setAttribute("lastValidValue", $F("branchName"));
				},
				onCancel: function (){
					$("branchCd").value = $("branchCd").readAttribute("lastValidValue");
					$("branchName").value = $("branchName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("branchCd").value = $("branchCd").readAttribute("lastValidValue");
					$("branchName").value = $("branchName").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
	}
	
	$("companyCd").setAttribute("lastValidValue", "");
	$("companyName").setAttribute("lastValidValue", "ALL COMPANIES");
	$("searchCompanyCd").observe("click", showGiacs480CompanyLov);
	$("companyCd").observe("change", function() {		
		if($F("companyCd").trim() == "") {
			$("companyCd").value = "";
			$("companyCd").setAttribute("lastValidValue", "");
			$("companyName").value = "ALL COMPANIES";
			$("companyName").setAttribute("lastValidValue", "ALL COMPANIES");
			$("employeeCd").value = "";
			$("employeeCd").setAttribute("lastValidValue", "");
			$("employeeName").value = "ALL EMPLOYEES";
			$("employeeName").setAttribute("lastValidValue", "ALL EMPLOYEES");
		} else {
			if($F("companyCd").trim() != "" && $F("companyCd") != $("companyCd").readAttribute("lastValidValue")) {
				showGiacs480CompanyLov();
			}
		}
	});
	$("companyCd").observe("keyup", function(){
		$("companyCd").value = $F("companyCd").toUpperCase();
	});
	
	function showGiacs480CompanyLov(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "showGiacs480CompanyLov",
							filterText : ($("companyCd").readAttribute("lastValidValue").trim() != $F("companyCd").trim() ? $F("companyCd").trim() : ""),
							page : 1},
			title: "List of Companies",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "payeeNo",
								title: "Company Cd.",
								width: '100px',
							},
							{
								id : "payeeLastName",
								title: "Company Name",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("companyCd").readAttribute("lastValidValue").trim() != $F("companyCd").trim() ? $F("companyCd").trim() : ""),
				onSelect: function(row) {
					$("companyCd").value = row.payeeNo;
					$("companyName").value = unescapeHTML2(row.payeeLastName);
					$("companyCd").setAttribute("lastValidValue", $F("companyCd"));
					$("companyName").setAttribute("lastValidValue", $F("companyName"));
					
					$("employeeCd").value = "";
					$("employeeCd").setAttribute("lastValidValue", "");
					$("employeeName").value = "ALL EMPLOYEES";
					$("employeeName").setAttribute("lastValidValue", "ALL EMPLOYEES");
				},
				onCancel: function (){
					$("companyCd").value = $("companyCd").readAttribute("lastValidValue");
					$("companyName").value = $("companyName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("companyCd").value = $("companyCd").readAttribute("lastValidValue");
					$("companyName").value = $("companyName").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
    		});
	}
	
	$("employeeCd").setAttribute("lastValidValue", "");
	$("employeeName").setAttribute("lastValidValue", "ALL EMPLOYEES");
	$("searchEmployeeCd").observe("click", showGiacs480EmployeeLov);
	$("employeeCd").observe("change", function() {		
		if($F("employeeCd").trim() == "") {
			$("employeeCd").value = "";
			$("employeeCd").setAttribute("lastValidValue", "");
			$("employeeName").value = "ALL EMPLOYEES";
			$("employeeName").setAttribute("lastValidValue", "ALL EMPLOYEES");
		} else {
			if($F("employeeCd").trim() != "" && $F("employeeCd") != $("employeeCd").readAttribute("lastValidValue")) {
				showGiacs480EmployeeLov();
			}
		}
	});
	$("employeeCd").observe("keyup", function(){
		$("employeeCd").value = $F("employeeCd").toUpperCase();
	});
	
	function showGiacs480EmployeeLov(){
		if($F("companyCd") == ""){
			showMessageBox("Please input company code first.");
			$("employeeCd").value = "";
			return;
		}
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "showGiacs480EmployeeLov",
				            companyCd : $F("companyCd"),
							filterText : ($("employeeCd").readAttribute("lastValidValue").trim() != $F("employeeCd").trim() ? $F("employeeCd").trim() : ""),
							page : 1},
			title: "List of Employees",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "refPayeeCd",
								title: "Employee Cd.",
								width: '100px',
							},
							{
								id : "empName",
								title: "Employee Name",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("employeeCd").readAttribute("lastValidValue").trim() != $F("employeeCd").trim() ? $F("employeeCd").trim() : ""),
				onSelect: function(row) {
					$("employeeCd").value = unescapeHTML2(row.refPayeeCd);
					$("employeeName").value = unescapeHTML2(row.empName);
					$("employeeCd").setAttribute("lastValidValue", $F("employeeCd"));
					$("employeeName").setAttribute("lastValidValue", $F("employeeName"));
				},
				onCancel: function (){
					$("employeeCd").value = $("employeeCd").readAttribute("lastValidValue");
					$("employeeName").value = $("employeeName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("employeeCd").value = $("employeeCd").readAttribute("lastValidValue");
					$("employeeName").value = $("employeeName").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
    		});
	}
	
	$("searchBranchName").hide();
	$("searchCompanyName").hide();
	$("searchEmployeeName").hide();
	
	whenNewFormInstanceGIACS480();
	
	function whenNewFormInstanceGIACS480(){
		new Ajax.Request(contextPath+"/GIACCreditAndCollectionReportsController?action=whenNewFormInstanceGIACS480",{
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				if (checkErrorOnResponse(response)){
					var res = JSON.parse(response.responseText);
					$("txtAsOfDate").value = res.vAsOfDate;
				}
			}
		});
	}
</script>