<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="premiumCollectionsMainDiv" name="premiumCollectionsMainDiv">
	<div id="premiumCollectionsMenu">
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
			<label>Premium Collections</label>
		</div>
	</div>
	<div class="sectionDiv" id="premiumCollectionsBody" >
		<div class="sectionDiv" id="premiumCollections" style="width: 70%; margin: 40px 138px 40px 138px;">
			<div class="sectionDiv" id="premiumCollectionsInnerDiv" style="width: 97%; margin: 8px 8px 2px 8px;">
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
								<input class="rightAligned allCaps"  type="text" id="branchCd" name="branchCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchCd" name="searchBranchCd" alt="Go" style="float: right;"/>
							</span>
							<input type="text" id="branchName" name="branchName" style="width: 324px; float: left; height: 15px; text-align: left;" value="ALL BRANCHES" readonly="readonly"/>								
						</td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="rdoDiv" style="width: 43%; height:130px; margin: 0 0 8px 8px;">
				<table align = "center" style="padding: 10px;">
					<tr>
						<td>
							<input type="radio" checked="" name="premCollnPerBranch" id="premCollnPerBranch" title="premCollnPerBranch" style="float: left;"/>
							<label for="premCollnPerBranchRB" style="float: left; height: 20px; padding-top: 3px;">Premium Collections Per Branch</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="radio" name="premCollnbyOtherBranch" id="premCollnbyOtherBranch" title="premCollnbyOtherBranch" style="float: left;"/>
							<label for="premCollnbyOtherBranch" style="float: left; height: 20px; padding-top: 3px;">Premium Collections by Other Branches</label>
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
									<td><input type="radio" id="rdoCSV" name="rdoFileType" value="CSV" title="CSV" disabled="disabled" /></td> <!-- modified by Daniel Marasigan SR 5531 07.07.2016 -->
									<td><label for="rdoCSV"> CSV</label></td>
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
							<input type="text" id="txtNoOfCopies" style="margin-left:5px;float:left; text-align:right; width:136px;" class="integerNoNegativeUnformattedNoComma" maxlength="3">
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
	setModuleId("GIACS284");
	setDocumentTitle("Premium Collections");
	initializeAll();
	checkUserAccess();
	setDefaultParams();
	togglePrintFields("screen");
	var resetBranch = false;
	var branchExist = true;
	
	var dateParam = "1";
	var reportParam = "GIACR284";
	var reportName = "PREMIUM COLLECTIONS OF OTHER BRANCHES";
	
	function checkUserAccess(){
		try{
			new Ajax.Request(contextPath+"/GIACAccTransController?action=checkUserAccess2", {
				method: "POST",
				parameters: {
					moduleName: "GIACS284"
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
		$("premCollnPerBranch").checked = true;
		$("premCollnbyOtherBranch").checked = false;
		$("chkPostingDate").checked = false;
		$("chkTranDate").checked = true;
	}
	
	$("chkPostingDate").observe("click", function(){
		$("chkTranDate").checked = false;
		dateParam = "2";
		whenCheckBoxChangePT("P");
	});
	
	$("chkTranDate").observe("click", function(){
		$("chkPostingDate").checked = false;
		dateParam = "1";
		whenCheckBoxChangePT("T");
	});
	
	function whenCheckBoxChangePT(option){
		if ($("chkPostingDate").checked || $("chkTranDate").checked){
			null;
		} else {
			if (option == "P") {
				$("chkTranDate").checked = true;
			} else {
				$("chkPostingDate").checked = true;
			}
		}
	}
	
	$("premCollnPerBranch").observe("click", function(){
		$("premCollnbyOtherBranch").checked = false;
		reportParam = "GIACR284";
		reportName = "PREMIUM COLLECTIONS OF OTHER BRANCHES";
	});
	
	$("premCollnbyOtherBranch").observe("click", function(){
		$("premCollnPerBranch").checked = false;
		reportParam = "GIACR285";
		reportName = "PREMIUM COLLECTIONS BY OTHER BRANCHES";
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
				showMessageBox("From Date should be earlier than To Date.", "I");
				$("txtToDate").value = "";
				$("txtFromDate").value = "";
			} else {
				showMessageBox("From Date should be earlier than To Date.", "I");
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
	
	$("btnPrint").observe("click", function(){
		validateBeforePrint();
	});
	
	function validateBeforePrint() {
		if ($F("txtFromDate") == "" || $F("txtToDate") == "") {
			showMessageBox("Required fields must be entered.","E");
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
			
			if ($("rdoCSV").checked && "file" == $F("selDestination")){ //added by Daniel Marasigan SR 5531 & 5532 07.07.2016 
				reportParam = reportParam.split("_")[1] != "CSV" ? reportParam + "_CSV" : reportParam;
			} else {
				reportParam = reportParam.split("_")[0];
			}
			
			var content = contextPath + "/PremiumCollectionsPrintController?action=printReport"
            + "&reportId=" + reportParam
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
								  fileType : $("rdoPdf").checked ? "PDF" : "CSV2"}, //modified by Daniel Marasigan SR 5531 07.07.2016
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							copyFileToLocal(response, $("rdoPdf").checked ? "" : "csv");
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
		var dateOpt = dateParam;
		var params = "&branchCd=" + $("branchCd").value
		+ "&dateOpt=" + dateOpt
		+ "&fromDate=" + $("txtFromDate").value
		+ "&toDate=" + $("txtToDate").value;
		
		return params;
	}
	
	/* $("searchBranchCd").observe("click", function(){ //commented out by Daniel Marasigan 07.07.2016
		fetchBranchLOV();
	}); */
	
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
			//$("rdoExcel").disable();
			$("rdoCSV").disable(); //added by Daniel Marasigan SR 5531 & 5532 07.07.2016
		} else {
			if(destination == "file"){
				$("rdoPdf").enable();
				//$("rdoExcel").enable();
				$("rdoCSV").enable(); //added by Daniel Marasigan SR 5531 & 5532 07.07.2016
			} else {
				$("rdoPdf").disable();
				//$("rdoExcel").disable();
				$("rdoCSV").disable(); //added by Daniel Marasigan SR 5531 & 5532 07.07.2016
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
	$("searchBranchCd").observe("click", showGiacs284BranchLov);
	$("branchCd").observe("change", function() {		
		if($F("branchCd").trim() == "") {
			$("branchCd").value = "";
			$("branchCd").setAttribute("lastValidValue", "");
			$("branchName").value = "";
		} else {
			if($F("branchCd").trim() != "" && $F("branchCd") != $("branchCd").readAttribute("lastValidValue")) {
				showGiacs284BranchLov();
			}
		}
	});
	$("branchCd").observe("keyup", function(){
		$("branchCd").value = $F("branchCd").toUpperCase();
	});
	
	function showGiacs284BranchLov(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGeneralBranchLOV",
							moduleId :  "GIACS284",
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
</script>