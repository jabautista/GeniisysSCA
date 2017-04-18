<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="schedOfAppliedCommMainDiv" name="schedOfAppliedCommMainDiv">
	<div id="bookedUnbookedCollectionReportMenu">
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
			<label>Schedule of Applied Commission</label>
		</div>
	</div>
	<div class="sectionDiv" id="scheduleOfAppliedCommissionReportBody" >
		<div class="sectionDiv" id="scheduleOfAppliedCommissionReport" style="width: 70%; margin: 40px 138px 40px 138px;">
			<div class="sectionDiv" id="scheduleOfAppliedCommissionReportInnerDiv" style="width: 97%; margin: 8px 8px 2px 8px;">
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
							<!-- <input type="text" id="branchName" name="branchName" style="width: 324px; float: left; height: 15px; text-align: left;" value="ALL BRANCHES" readonly="readonly"/> -->
							<%-- <span class="lovSpan" style="width:331px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="leftAligned"  type="text" id="branchName" name="branchName"  value="ALL BRANCHES" readonly="readonly" style="width: 300px; float: left; margin-right: 4px; border: none; height: 13px;"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchName" name="searchBranchName" alt="Go" style="float: right;"/>
							</span>	 --%>	
							<input  class="leftAligned"  type="text" id="branchName" name="branchName"  value="ALL BRANCHES" readonly="readonly" style="width: 325px; float: left; margin-right: 4px; height: 15px;"/>						
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
									<td><input value="CSV" title="CSV" type="radio" id="rdoCsv" name="rdoFileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="303"></td> <!--added by carlo rubenecia 04.29.2016 SR 5354 -->
									<td><label for="rdoCsv" style="margin: 2px 0 4px 0">CSV</label></td><!--added by carlo rubenecia 04.29.2016 SR 5354 -->
									<td style="width:30px;">&nbsp;</td>
									<!-- removed print to excel option by robert SR 5227 02.04.16
									<td><input type="radio" id="rdoExcel" name="rdoFileType" value="XLS" title="Excel" disabled="disabled" /></td> 
									<td><label for="rdoExcel"> Excel</label></td> -->
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

	setModuleId("GIACS414");
	setDocumentTitle("Schedule of Applied Commission");
	initializeAll();
	checkUserAccess();
	togglePrintFields("screen");
	var resetBranch = false;
	var branchExist = true;
	
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
			showMessageBox("From Date should be earlier than To Date","I");
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
			
			var content = contextPath + "/SchedOfAppliedCommPrintController?action=printReport"
            + "&reportId=" + "GIACR414"
            + getParams();
			
			if("screen" == $F("selDestination")){
				showPdfReport(content, "");
			} else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {printerName : $F("printerName"),
						          noOfCopies : $F("txtNoOfCopies"),
						          destination: "printer"}, //marco - 07.24.2014 - added
					onCreate: showNotice("Processing, please wait..."),				
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							
						}
					}
				});
			} else if("file" == $F("selDestination")){
				var fileType = "PDF"; //added by carlo rubenecia SR 5354 04.29.2016 -START
				
				if($("rdoPdf").checked){
					fileType = "PDF";
				}else if ($("rdoCsv").checked){
					fileType = "CSV";
				}	 //added by carlo rubenecia SR 5354 04.29.2016 -END
				new Ajax.Request(content, {
					parameters : {destination : "file",
								//fileType : $("rdoPdf").checked ? "PDF" : "XLS"},  //Removed by carlo rubenecia SR 5354 04.29.2016
								  fileType    : fileType}, //added by carlo rubenecia SR 5354 04.29.2016
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							if ($("rdoCsv").checked){  //added by carlo rubenecia SR 5354 04.29.2016 --start
								copyFileToLocal(response, "csv");
								deleteCSVFileFromServer(response.responseText);
							}else{ //added by carlo rubenecia SR 5354 04.29.2016 --end
								copyFileToLocal(response, "reports");
							}
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
		+ "&toDate=" + $("txtToDate").value;
		
		return params;
	}
	
	$("imgFromDate").observe("click", function(){
		scwShow($('txtFromDate'),this, null);
	});	
	
	$("imgToDate").observe("click", function(){
		scwShow($('txtToDate'),this, null);
	});	
	
	$("txtFromDate").observe("blur", function(){
		if($F("txtFromDate") != "" && validateDateFormat($F("txtFromDate"), "txtFromDate")){
			if($F("txtToDate") != "" && validateDateFormat($F("txtToDate"), "txtToDate")){
				validateFromToDate("txtFromDate", "txtFromDate", "txtFromDate");
			}
		}
	});
	
	$("txtToDate").observe("blur", function(){
		if($F("txtToDate") != "" && validateDateFormat($F("txtToDate"), "txtToDate")){
			if($F("txtFromDate") != "" && validateDateFormat($F("txtFromDate"), "txtFromDate")){
				validateFromToDate("txtFromDate", "txtToDate", "txtToDate");
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
	
	$("branchCd").observe("change", function(){
		if (this.value.trim() == "") {
			$("branchCd").clear();
			$("branchName").value = "ALL BRANCHES";
			return;
		}
		resetBranch = false;
		lovOnChangeEvent("branchCd",function(findText) {
			showGiacs414BranchLov(findText, "branchCd");
			}, function(obj) {
					$("branchCd").value = obj.rows[0].branchCd;
					$("branchName").value = unescapeHTML2(obj.rows[0].branchName);
					resetBranch = true;
			}, function() {
					/* $("branchCd").clear();	
					$("branchName").value = "ALL BRANCHES";
					branchExist = false;
					showWaitingMessageBox("Query caused no record to be retrieved. Re-enter.", imgMessage.INFO, function() {
																													branchExist = true;		
																												}); */
				showGiacs414BranchLov($F("branchCd"), "branchCd");
				$("branchCd").value = "";
				$("branchName").value = "ALL BRANCHES";
    		}, "/AccountingLOVController?action=getGiacs414BranchLOV" ,null);
	});
	
	$("searchBranchCd").observe("click", function(){
		var searchVal = null;
		if (resetBranch) {
			searchVal = "%";
		}
		if (branchExist) {
			lovOnChangeEvent("branchCd",function(findText) {
										showGiacs414BranchLov(findText, "branchCd");
									}, function(obj) {
							 				$("branchCd").value = obj.rows[0].branchCd;
											$("branchName").value = unescapeHTML2(obj.rows[0].branchName);
											resetBranch = true;
									}, function() {
										/* $("branchCd").clear();
										$("branchName").value = "ALL BRANCHES";
										showWaitingMessageBox("Query caused no record to be retrieved. Re-enter.", imgMessage.INFO, function() {
																																					branchExist = true;		
																																				}); */
										showGiacs414BranchLov($F("branchCd"), "branchCd");
										$("branchCd").value = "";
										$("branchName").value = "ALL BRANCHES";
								    }, "/AccountingLOVController?action=getGiacs414BranchLOV"
								     ,searchVal);
		}
	});
	
	function showGiacs414BranchLov(findText2,id){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
								 action   : "getGiacs414BranchLOV",
								 findText2 : findText2,
								 page : 1
				},
				title: "List of Branches",
				width: 400,
				height: 380,
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
					    width: '250px',
					    align: 'left'
					}
				],
				draggable: true,
				filterText : findText2,
				onSelect: function(row) {
					if(row != undefined){
						$("branchCd").value = row.branchCd;
						$("branchName").value = unescapeHTML2(row.branchName);
						resetBranch = true;
					}
				},
				onCancel: function(){
		  			$(id).focus();
		  		}
			});
		}catch(e){
			showErrorMessage("showGiacs128BranchLov",e);
		}
	}
	
	function checkUserAccess(){
		try{
			new Ajax.Request(contextPath+"/GIACAccTransController?action=checkUserAccess2", {
				method: "POST",
				parameters: {
					moduleName: "GIACS414"
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
			$("rdoCsv").disable(); //added by carlo rubenecia 04.29.2016 SR 5354
			//$("rdoExcel").disable(); removed print to excel option by robert SR 5227 02.04.16
		} else {
			if(destination == "file"){
				$("rdoPdf").enable();
				$("rdoCsv").enable(); //added by carlo rubenecia 04.29.2016 SR 5354
				//$("rdoExcel").enable(); removed print to excel option by robert SR 5227 02.04.16
			} else {
				$("rdoPdf").disable();
				$("rdoCsv").disable(); //added by carlo rubenecia 04.29.2016 SR 5354
				//$("rdoExcel").disable(); removed print to excel option by robert SR 5227 02.04.16
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
	
	$("txtNoOfCopies").observe("blur", function(){
		if($("txtNoOfCopies").value == "0"){
			customShowMessageBox("Invalid No. of Copies.", imgMessage.INFO, "txtNoOfCopies");
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