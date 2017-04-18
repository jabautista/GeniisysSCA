<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="paytRequestListMainDiv" name="paytRequestListMainDiv">
	<div id="paytRequestListReportMenu">
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
			<label>Payment Request List</label>
		</div>
	</div>
	<div class="sectionDiv" id="paytRequestListReportBody" >
		<div class="sectionDiv" id="paytRequestListReport" style="width: 70%; margin: 40px 138px 40px 138px;">
			<div class="sectionDiv" id="paytRequestListReportInnerDiv" style="width: 97%; margin: 8px 8px 2px 8px;">
				<table align="center" style="padding: 20px;">
					<tr>
						<td class="rightAligned">From</td>
						<td>
							<div style="float: left; width: 160px;" class="withIconDiv required">
								<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon required" readonly="readonly" style="width: 135px;"/>
								<img id="imgFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"/>
							</div>
						</td>
						<td class="rightAligned" width="68px">To</td>
						<td>
							<div style="float: left; width: 160px;" class="withIconDiv required">
								<input type="text" id="txtToDate" name="txtToDate" class="withIcon required" readonly="readonly" style="width: 135px;"/>
								<img id="imgToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Branch</td>
						<td colspan="5">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="rightAligned"  type="text" id="branchCd" name="branchCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchCd" name="searchBranchCd" alt="Go" style="float: right;"/>
							</span>
							<input  class="leftAligned"  type="text" id="branchName" name="branchName"  value="ALL BRANCHES" readonly="readonly" style="width: 325px; float: left; margin-right: 4px; height: 14px;"/>
							<%-- <span class="lovSpan" style="width:331px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="leftAligned"  type="text" id="branchName" name="branchName"  value="ALL BRANCHES" readonly="readonly" style="width: 300px; float: left; margin-right: 4px; border: none; height: 13px;"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchName" name="searchBranchName" alt="Go" style="float: right;"/>
							</span> --%>								
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Request</td>
						<td colspan="5">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="rightAligned"  type="text" id="requestCd" name="requestCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchRequestCd" name="searchRequestCd" alt="Go" style="float: right;"/>
							</span>
							<input  class="leftAligned" type="text" id="requestName" name="requestName"  value="ALL REQUESTS" readonly="readonly" style="width: 325px; float: left; margin-right: 4px; height: 14px;"/>
							<%-- <span class="lovSpan" style="width:331px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="leftAligned"  type="text" id="requestName" name="requestName"  value="ALL REQUESTS" readonly="readonly" style="width: 300px; float: left; margin-right: 4px; border: none; height: 13px;"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchRequestName" name="searchRequestName" alt="Go" style="float: right;"/>
							</span>	 --%>							
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Status</td>
						<td colspan="5">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="rightAligned"  type="text" id="statusCd" name="statusCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchStatusCd" name="searchStatusCd" alt="Go" style="float: right;"/>
							</span>
							<input  class="leftAligned"  type="text" id="statusName" name="statusName"  value="ALL STATUS" readonly="readonly" style="width: 325px; float: left; margin-right: 4px; height: 14px;"/>
							<%-- <span class="lovSpan" style="width:331px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="leftAligned"  type="text" id="statusName" name="statusName"  value="ALL STATUS" readonly="readonly" style="width: 300px; float: left; margin-right: 4px; border: none; height: 13px;"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchStatusName" name="searchStatusName" alt="Go" style="float: right;"/>
							</span> --%>								
						</td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="printDiv" style="width: 97%; margin: 8px 8px 2px 8px;">
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
									<td style="padding-left: 20px;"><input value="rdoCSV" title="CSV" type="radio" id="rdoCSV" name="rdoFileType" disabled="disabled"></td>
									<td><label for="rdoCSV"> CSV</label></td>
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
				<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width:90px;" />
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	setModuleId("GIACS057");
	setDocumentTitle("Payment Request List");
	initializeAll();
	checkUserAccess();
	togglePrintFields("screen");
	
	$("btnPrint").observe("click", function(){
		validateBeforePrint();
	});
	
	function validateBeforePrint() {
		if ($F("txtFromDate") == "" && $F("txtToDate") == "") {
			showMessageBox("Required fields must be entered.","I");
		}else if ($F("txtFromDate") == "") {
			showMessageBox("Required fields must be entered.","I");
		}else if ($F("txtToDate") == "") {
			showMessageBox("Required fields must be entered.","I");
		}else if (compareDatesIgnoreTime(Date.parse($F("txtFromDate")),Date.parse($("txtToDate").value)) == -1) {
			showMessageBox("From Date should be earlier than To Date.","I");
		}else{
			var dest = $F("selDestination");
			
			if(dest == "printer"){
				if(checkAllRequiredFieldsInDiv("printDiv")){
					printReport();
				}
			}else{
				printReport();
			}	
		}
	}
	
	function printReport(){
		try {
			var content = contextPath + "/PaymentRequestListPrintController?action=printReport"
            + "&reportId=" + "GIACR057"
            + getParams();
			
			if("screen" == $F("selDestination")){
				showPdfReport(content, "");
			} else if($F("selDestination") == "printer"){
				new Ajax.Request(content,{
					parameters : {
						noOfCopies : $F("txtNoOfCopies"),
						printerName : $F("printerName")
					},
					onCreate: showNotice("Processing, please wait..."),				
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing Completed.", "I");
						}
					}
				});
			} else if("file" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "file",
								  fileType : $("rdoPdf").checked ? "PDF" : "CSV"},
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							copyFileToLocal(response, $("rdoPdf").checked ? "reports" : "csv");
							deleteCSVFileFromServer(response.responseText);
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
		var params = "&branchCd=" + $("branchCd").value
		+ "&documentCd=" + $("requestCd").value
		+ "&status=" + $("statusCd").value
		+ "&fromDate=" + $("txtFromDate").value
		+ "&toDate=" + $("txtToDate").value;
		
		return params;
	}
	
	$("imgFromDate").observe("click", function(){
		scwShow($("txtFromDate"), this, null);
	});
	
	$("imgToDate").observe("click", function(){
		if($F("txtFromDate") == ""){
			customShowMessageBox("Please enter FROM date first.", "I", "txtFromDate");
		} else {
			scwShow($("txtToDate"), this, null);
		}
	});
	
	$("txtFromDate").observe("focus", function(){
		if ($("imgFromDate").disabled == true) return;
		
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) :"";
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
		
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("From Date should be earlier than To Date.", "I", "txtFromDate");
			$("txtFromDate").clear();
			return false;
		}
	});
 	
 	$("txtToDate").observe("focus", function(){
		if ($("imgToDate").disabled == true) return;
		
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) :"";
		
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("From Date should be earlier than To Date.", "I", "txtToDate");
			$("txtToDate").clear();
			return false;
		}
	});
	
 	$("branchCd").setAttribute("lastValidValue", "");
 	$("searchBranchCd").observe("click", showGiacs057BranchLOV);
 	$("branchCd").observe("change", function() {		
 		if($F("branchCd").trim() == "") {
 			$("branchCd").value = "";
 			$("branchCd").setAttribute("lastValidValue", "");
 			$("branchName").value = "ALL BRANCHES";
 		} else {
 			if($F("branchCd").trim() != "" && $F("branchCd") != $("branchCd").readAttribute("lastValidValue")) {
 				showGiacs057BranchLOV();
 			}
 		}
 	});
 	$("branchCd").observe("keyup", function(){
 		$("branchCd").value = $F("branchCd").toUpperCase();
 	});
 	
 	function showGiacs057BranchLOV(){
 		LOV.show({
 			controller: "AccountingLOVController",
 			urlParameters: {action : "getGeneralBranchLOV",
 							moduleId :  "GIACS057",
 							filterText : ($("branchCd").readAttribute("lastValidValue").trim() != $F("branchCd").trim() ? $F("branchCd").trim() : ""),
 							page : 1},
 			title: "List of Branches",
 			width: 500,
 			height: 400,
 			columnModel : [
 							{
 								id : "branchCd",
 								title: "Code",
 								width: '100px',
 								filterOption: true
 							},
 							{
 								id : "branchName",
 								title: "Branch",
 								width: '325px',
 								renderer: function(value) {
 									return unescapeHTML2(value);
 								}
 							}
 						],
 				autoSelectOneRecord: true,
 				filterText : ($("branchCd").readAttribute("lastValidValue").trim() != $F("branchCd").trim() ? $F("branchCd").trim() : ""),
 				onSelect: function(row) {
 					$("branchCd").value = row.branchCd;
 					$("branchName").value = row.branchName;
 					$("branchCd").setAttribute("lastValidValue", row.branchCd);								
 				},
 				onCancel: function (){
 					$("branchCd").value = $("branchCd").readAttribute("lastValidValue");
 				},
 				onUndefinedRow : function(){
 					showMessageBox("No record selected.", "I");
 					$("branchCd").value = $("branchCd").readAttribute("lastValidValue");
 				},
 				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
 		  });
 	}
 	
 	$("requestCd").setAttribute("lastValidValue", "");
 	$("searchRequestCd").observe("click", showGiacs057RequestLOV);
 	$("requestCd").observe("change", function() {		
 		if($F("requestCd").trim() == "") {
 			$("requestCd").value = "";
 			$("requestCd").setAttribute("lastValidValue", "");
 			$("requestName").value = "ALL REQUESTS";
 		} else {
 			if($F("requestCd").trim() != "" && $F("requestCd") != $("requestCd").readAttribute("lastValidValue")) {
 				showGiacs057RequestLOV();
 			}
 		}
 	});
 	$("requestCd").observe("keyup", function(){
 		$("requestCd").value = $F("requestCd").toUpperCase();
 	});
 	
 	function showGiacs057RequestLOV(){
 		LOV.show({
 			controller: "AccountingLOVController",
 			urlParameters: {action : "fetchRequestLOV",
 							branchCd:   $F("branchCd"),
 							filterText : ($("requestCd").readAttribute("lastValidValue").trim() != $F("requestCd").trim() ? $F("requestCd").trim() : ""),
 							page : 1},
 			title: "List of Documents",
 			width: 500,
 			height: 400,
 			columnModel : [
 							{
 								id: "documentCd",
 								title: "Document Code",
 								width: "100px"
 							},
 							{
 								id: "documentName",
 								title: "Document Name",
 								width: "310px",
 								renderer: function(value) {
 									return unescapeHTML2(value);
 								}
 							}
 						],
 				autoSelectOneRecord: true,
 				filterText : ($("requestCd").readAttribute("lastValidValue").trim() != $F("requestCd").trim() ? $F("requestCd").trim() : ""),
 				onSelect: function(row) {
 					$("requestCd").value = row.documentCd;
 					$("requestName").value = row.documentName;
 					$("requestCd").setAttribute("lastValidValue", row.documentCd);								
 				},
 				onCancel: function (){
 					$("requestCd").value = $("requestCd").readAttribute("lastValidValue");
 				},
 				onUndefinedRow : function(){
 					showMessageBox("No record selected.", "I");
 					$("requestCd").value = $("requestCd").readAttribute("lastValidValue");
 				},
 				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
 		  });
 	}
 	
 	$("statusCd").setAttribute("lastValidValue", "");
 	$("searchStatusCd").observe("click", showGiacs057StatusLOV);
 	$("statusCd").observe("change", function() {		
 		if($F("statusCd").trim() == "") {
 			$("statusCd").value = "";
 			$("statusCd").setAttribute("lastValidValue", "");
 			$("statusName").value = "ALL STATUS";
 		} else {
 			if($F("statusCd").trim() != "" && $F("statusCd") != $("statusCd").readAttribute("lastValidValue")) {
 				showGiacs057StatusLOV();
 			}
 		}
 	});
 	$("statusCd").observe("keyup", function(){
 		$("statusCd").value = $F("statusCd").toUpperCase();
 	});
 	
 	function showGiacs057StatusLOV(){
 		LOV.show({
 			controller: "AccountingLOVController",
 			urlParameters: {action : "fetchStatusLOV",
 							filterText : ($("statusCd").readAttribute("lastValidValue").trim() != $F("statusCd").trim() ? $F("statusCd").trim() : ""),
 							page : 1},
 			title: "List of Status",
 			width: 500,
 			height: 400,
 			columnModel : [
 							{
 								id: "rvLowValue",
 								title: "Status",
 								width: "100px"
 							},
 							{
 								id: "rvMeaning",
 								title: "Status Name",
 								width: "310px",
 								renderer: function(value) {
 									return unescapeHTML2(value);
 								}
 							}
 						],
 				autoSelectOneRecord: true,
 				filterText : ($("statusCd").readAttribute("lastValidValue").trim() != $F("statusCd").trim() ? $F("statusCd").trim() : ""),
 				onSelect: function(row) {
 					$("statusCd").value = row.rvLowValue;
 					$("statusName").value = row.rvMeaning;
 					$("statusCd").setAttribute("lastValidValue", row.rvLowValue);								
 				},
 				onCancel: function (){
 					$("statusCd").value = $("statusCd").readAttribute("lastValidValue");
 				},
 				onUndefinedRow : function(){
 					showMessageBox("No record selected.", "I");
 					$("statusCd").value = $("statusCd").readAttribute("lastValidValue");
 				},
 				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
 		  });
 	}
	
	function checkUserAccess(){
		try{
			new Ajax.Request(contextPath+"/GIACAccTransController?action=checkUserAccess2", {
				method: "POST",
				parameters: {
					moduleName: "GIACS057"
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
			$("rdoCSV").disable();
		} else {
			if(destination == "file"){
				$("rdoPdf").enable();
				$("rdoCSV").enable();
			} else {
				$("rdoPdf").disable();
				$("rdoCSV").disable();
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
</script>