<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="inputVatReportMainDiv" name="inputVatReportMainDiv">
	<div id="inputVatReportMenu">
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
			<label>Print Input VAT Accounting Entries</label>
		</div>
	</div>
	<div class="sectionDiv" id="inputVatReportBody" >
		<div class="sectionDiv" id="inputVatReport" style="width: 70%; margin: 40px 138px 40px 138px;">
			<div class="sectionDiv" id="inputVatReportInnerDiv" style="width: 97%; margin: 8px 8px 2px 8px;">
				<table align="center" style="padding: 20px;">
					<tr>
						<td class="rightAligned">
							<input type="checkbox" id="chkPostingDate" name="chkPostingDate" checked=""/>
						</td>
						<td class="leftAligned">
							<label for="lblChkPostingDate" id="lblChkPostingDate">&nbsp; Posting Date</label>
						</td>
						<td class="rightAligned">
							<input type="checkbox" id="chkTranDate" name="chkTranDate" checked=""/>
						</td>
						<td class="leftAligned">
							<label for="lblChkTranDate" id="lblChkTranDate">&nbsp; Tran Date</label>
						</td>
					</tr>
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
						<td class="rightAligned">Branch</td>
						<td colspan="5">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="rightAligned allCaps"  type="text" id="branchCd" name="branchCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchCd" name="searchBranchCd" alt="Go" style="float: right;"/>
							</span>
							<input type="text" id="branchName" name="branchName" style="width: 324px; float: left; height: 15px; text-align: left;" value="ALL BRANCHES" readonly="readonly"/>								
						</td>
					</tr>
					<%-- <tr>
						<td class="rightAligned">Line</td>
						<td colspan="5">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="rightAligned"  type="text" id="lineCd" name="lineCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" name="searchLineCd" alt="Go" style="float: right;"/>
							</span>
							<input type="text" id="lineName" name="lineName" style="width: 324px; float: left; height: 15px; text-align: left;" value="ALL LINES" readonly="readonly"/>
						</td>
					</tr> --%>
				</table>
			</div>
			<div class="sectionDiv" id="rdoDiv" style="width: 43%; height:130px; margin: 0 0 8px 8px;">
				<table align = "center" style="padding: 10px; margin-left: 70px; margin-top: 10px;">
					<tr>
						<td>
							<input type="checkbox" checked="" name="bySLName" id="bySLName" title="By SL Name" style="float: left;"/>
							<label for="bySLName" style="float: left; height: 20px; padding-top: 0px;">&nbsp; By SL Name</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" checked="" name="summary" id="summary" title="Summary" style="float: left;"/>
							<label for="summary" style="float: left; height: 20px; padding-top: 0px;">&nbsp; Summary</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" checked="" name="includeOpenTrans" id="includeOpenTrans" title="Include Open Transactions" style="float: left;"/>
							<label for="includeOpenTrans" style="float: left; height: 20px; padding-top: 0px;">&nbsp; Include Open Transactions</label>
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
									<!-- removed print to excel option by robert SR 5223 02.09.16
									<td><input type="radio" id="rdoExcel" name="rdoFileType" value="XLS" title="Excel" disabled="disabled" /></td>
									<td><label for="rdoExcel"> Excel</label></td> -->
									<td style="width:30px;">&nbsp;</td>
									<td><input type="radio" id="rdoCsv" name="rdoFileType" value="CSV" title="CSV" disabled="disabled" /></td>
									<td><label for="rdoCsv"> CSV</label></td>
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
				<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width:90px;" />
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">

	setModuleId("GIACS104");
	setDocumentTitle("Input VAT Accounting Entry Report Call");
	initializeAll();
	checkUserAccess();
	setDefaultParams();
	togglePrintFields("screen");
	var reportParam = "GIACR104";
	var tranPost = "T";
	var include = "I";
	
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
			
			if ($("bySLName").checked){
				if ($("summary").checked){
					reportParam = "GIACR214B";
				} else {
					reportParam = "GIACR214";
				}
			} else {
				reportParam = "GIACR104";	
			}
			
			if ($("includeOpenTrans").checked){
				include = "I";
			} else {
				include = "X";
			}
			
			var content = contextPath + "/InputVATPrintController?action=printReport"
            + "&reportId=" + reportParam
            + "&include=" + include
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
				var fileType = "PDF";
				
				if($("rdoPdf").checked)
					fileType = "PDF";
				//else if ($("rdoExcel").checked)
				//	fileType = "XLS"; removed print to excel option by robert SR 5223 02.09.16
				else if ($("rdoCsv").checked)
					fileType = "CSV";
				
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "FILE",
				         	      fileType    : fileType},
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							if ($("rdoCsv").checked){
								copyFileToLocal(response, "csv");
								deleteCSVFileFromServer(response.responseText);
							}else
								copyFileToLocal(response);
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
		+ "&fromDate=" + $("txtFromDate").value
		+ "&toDate=" + $("txtToDate").value
		+ "&tranPost=" + tranPost;
		
		return params;
	}
	
	function checkUserAccess(){
		try{
			new Ajax.Request(contextPath+"/GIACAccTransController?action=checkUserAccess2", {
				method: "POST",
				parameters: {
					moduleName: "GIACS104"
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
	
	function setDefaultParams(){
		$("includeOpenTrans").checked = true;
		$("summary").checked = true;
		$("summary").disabled = true;
		$("bySLName").checked = false;
		
		$("chkPostingDate").checked = false;
		$("chkTranDate").checked = true;
	}
	
	$("chkPostingDate").observe("click", function(){
		$("chkTranDate").checked = false;
		tranPost = "P";
		whenCheckBoxChangePT("P");
		$("includeOpenTrans").checked = false;
		$("includeOpenTrans").disabled = true;
	});
	
	$("chkTranDate").observe("click", function(){
		$("chkPostingDate").checked = false;
		tranPost = "T";
		whenCheckBoxChangePT("T");
		$("includeOpenTrans").checked = true;
		$("includeOpenTrans").disabled = false;
	});
	
	function whenCheckBoxChangePT(option){
		if ($("chkPostingDate").checked || $("chkTranDate").checked){
			null;
		} else {
			if (option == "P") {
				$("chkTranDate").checked = true;
				tranPost = "T";
			} else {
				$("chkPostingDate").checked = true;
				tranPost = "P";
			}
		}
	}
	
	$("bySLName").observe("click", function(){
		if ($("summary").disabled){
			$("summary").disabled = false;
		} else {
			$("summary").disabled = true;
		}
	});
	
	$("imgFromDate").observe("click", function(){
		scwShow($('txtFromDate'),this, null);
	});	
	
	$("imgToDate").observe("click", function(){
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
			//$("rdoExcel").disable(); removed print to excel option by robert SR 5223 02.09.16
			$("rdoCsv").disabled = true;
		} else {
			if(destination == "file"){
				$("rdoPdf").enable();
				//$("rdoExcel").enable(); removed print to excel option by robert SR 5223 02.09.16
				$("rdoCsv").disabled = false;
			} else {
				$("rdoPdf").disable();
				//$("rdoExcel").disable(); removed print to excel option by robert SR 5223 02.09.16
				$("rdoCsv").disabled = true;
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
	
	$("branchCd").setAttribute("lastValidValue", "");
	$("searchBranchCd").observe("click", showGiacs104BranchLov);
	$("branchCd").observe("change", function() {		
		if($F("branchCd").trim() == "") {
			$("branchCd").value = "";
			$("branchCd").setAttribute("lastValidValue", "");
			$("branchName").value = "";
		} else {
			if($F("branchCd").trim() != "" && $F("branchCd") != $("branchCd").readAttribute("lastValidValue")) {
				showGiacs104BranchLov();
			}
		}
	});
	
	function showGiacs104BranchLov(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "showGiacs104BranchLov",
							filterText : ($("branchCd").readAttribute("lastValidValue").trim() != $F("branchCd").trim() ? $F("branchCd").trim() : ""),
							page : 1},
			title: "Valid Values for Branches",
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
</script>