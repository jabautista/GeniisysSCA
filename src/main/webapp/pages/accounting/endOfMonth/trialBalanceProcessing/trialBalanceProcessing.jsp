<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="mainNav" name="mainNav">
	<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
		<ul>
			<li><a id="trialBalanceProcessingExit">Exit</a></li>
		</ul>
	</div>
</div>
<div id="trialBalanceProcessingMainDiv" name="trialBalanceProcessingMainDiv">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
   			<label>Trial Balance Processing</label>
   			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	<div class="sectionDiv" id="trialBalanceProcessingDiv" name="trialBalanceProcessingDiv" style="height: 300px;">
		<div class="sectionDiv" id="trialBalanceProcessingBody" name="trialBalanceProcessingBody" style="height: 195px; width: 60%; margin-left: 185px; margin-top: 30px;" >
			<div id="transactionDateDiv">
				<table border="0" style="height: 60px; margin-top: 5px; width: 100%;">
					<tr>
						<td class="rightAligned" style="width: 202px;">Transaction Date</td>
						<td class="leftAligned">
							<div class="required withIconDiv">
								<input type="text" id="txtTransactionDate" name="txtTransactionDate" class="required withIcon" readonly="readonly" style="width: 156px;"/>
								<img id="hrefTransactionDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Transaction Date"/>
							</div>
						</td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="paramaterDiv" style="height: 100px; width: 490px; margin-left: 30px; margin-top: 0px;">
				<table border="0" style="height: 50; width: 98%; margin-top: 15px; margin-left: 5px">
					<tr height="20px">
						<td class="rightAligned" style="width: 50px;"><input type="checkbox" id="includePreviousMonths" name="includePreviousMonths" title="Include Previous Months"/></td>
						<td class="leftAligned"><label id="includePreviousMonthsLabel" for="includePreviousMonths"  title="Include Previous Months">Include Previous Month/s</label></td>
						<td class="rightAligned"><input type="checkbox" id="includePreviousYears" name="includePreviousYears" title="Include Previous Years"/></td>
						<td class="leftAligned"><label id="includePreviousYearsLabel" for="includePreviousYears"  title="Include Previous Years">Include Previous Year/s</label></td>
					</tr>
				</table>
				<table border="0" style="height: 50; width: 98%; margin-top: 15px; margin-left: 5px">
					<tr>
						<td class="rightAligned" style="width: 160px;"><input type="checkbox" id="adjustingEntriesOnly" name="adjustingEntriesOnly" title="Adjusting Entries Only"/></td>
						<td class="leftAligned"><label id="adjustingEntriesOnlyLabel" for="adjustingEntriesOnly"  title="Adjusting Entries Only">Adjusting Entries Only</label></td>
					</tr>
				</table>
			</div>
		</div>
		<div class="buttonDiv" style="float: left; width: 100%">
			<table align="center">
				<tbody>
					<tr>
						<td>
							<input id="btnGenerate" class="button" type="button" style="width: 100px;" value="Generate" name="btnGenerate">
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>

<script type="text/javascript">

	setModuleId("GIACS500");
	setDocumentTitle("Trial Balance Processing");
	initializeAll();
	initializeAccordion();
	checkUserAccess();
	disableButton("btnGenerate");
	setAdjustingEntries("X");
	$("includePreviousMonths").checked = true;
	$("includePreviousYears").checked = true;
	
	var includeMonths;
	var includeYears;
	var adjustingEntries;
	var updateActionOpt;
	
	observeReloadForm("reloadForm", showTrialBalanceProcessing);
	
	function checkUserAccess(){
		try{
			new Ajax.Request(contextPath+"/GIACAccTransController?action=checkUserAccess2", {
				method: "POST",
				parameters: {
					moduleName: "GIACS500"
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(response.responseText == 0){
						showWaitingMessageBox('You are not allowed to access this module.', imgMessage.ERROR, 
								function(){
							goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
						});  
						
					}
				}
			});
		}catch(e){
			showErrorMessage('checkUserAccess', e);
		}
	}
	
	function setAdjustingEntries(exist){
		if (exist == "1") {
			$("adjustingEntriesOnly").disabled = false;
			$("adjustingEntriesOnly").checked = true;
			enableButton("btnGenerate");
		} else if (exist == "0") {
			$("adjustingEntriesOnly").disabled = true;
			$("adjustingEntriesOnly").checked = false;
			enableButton("btnGenerate");
		} else {
			$("adjustingEntriesOnly").disabled = true;
			$("adjustingEntriesOnly").checked = false;
			disableButton("btnGenerate");
		}
	}
	
	$("txtTransactionDate").observe("focus", function(){
		if($F("txtTransactionDate") != ""){
			validateDate();	
		}
	});
	
	function validateDate(){
		new Ajax.Request(contextPath + "/GIACTrialBalanceController", {
			method : "POST",
			parameters : {
				action : "validateTransactionDate",
				transactionDate : $F("txtTransactionDate")
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response) {
				setAdjustingEntries(response.responseText);
			}
		});
	}
	
	$("btnGenerate").observe("click", function(){
		generateTrialBalance();
	});
	
	function generateTrialBalance(){
		readyCheckedParams();
		checkTranOpen();
	}
	
	function readyCheckedParams(){
		if ($("includePreviousMonths").checked) {
			includeMonths = "Y";
		} else {
			includeMonths = "N";
		}
		
		if ($("includePreviousYears").checked) {
			includeYears = "Y";
		} else {
			includeYears = "N";
		}
		
		if ($("adjustingEntriesOnly").checked) {
			adjustingEntries = "Y";
		} else {
			adjustingEntries = "N";
		}
	}
	
	function checkTranOpen(){
		new Ajax.Request(contextPath + "/GIACTrialBalanceController", {
			method : "POST",
			parameters : {
				action : "checkTranOpen",
				transactionDate : $F("txtTransactionDate"),
				includeMonths   : includeMonths,
				includeYears    : includeYears
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response) {
				if (response.responseText != "0") {
					showConfirmBox2("Confirmation", "There are still " + response.responseText + " OPEN transactions. Do you like to continue with Trial Balance Processing?", "Ok", "Cancel", 
							function() {
								checkDate();
							}
							, /*exitForm*/""); //benjo 11.03.2015 GENQA-SR-5148 replaced exitForm -> ""
				} else {
					checkSelect();
				};
			}
		});
	}
	
	function checkDate(){
		new Ajax.Request(contextPath + "/GIACTrialBalanceController", {
			method : "POST",
			parameters : {
				action : "checkDate",
				transactionDate : $F("txtTransactionDate")
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response) {
				if (response.responseText == "CLOSEDGL") {
					customShowMessageBox("Trial balance processing is no longer allowed since the GL for this month is already closed.", imgMessage.INFO, "txtTransactionDate");
					return false;
				} else if (response.responseText == "CLOSEDTB") {
					customShowMessageBox("Trial balance has been closed for the current date.", imgMessage.INFO, "txtTransactionDate");
					return false;
				} else if (response.responseText == "RERUN") {
					showConfirmBox2("Confirmation", "Trial Balance Processing has been done for this month. This will be an additional run. Do you wish to continue? ", "Ok", "Cancel", 
							function() {
								backUpGiacMonthlyTotals();
								checkSelect();
							}
							, /*exitForm*/""); //benjo 11.10.2015 GENQA-SR-5160 replaced exitForm -> ""
				} else if (response.responseText == "PROCEED") {
					checkSelect();
				}
			}
		});
	}
	
	function backUpGiacMonthlyTotals(){
		new Ajax.Request(contextPath + "/GIACTrialBalanceController", {
			method : "POST",
			parameters : {
				action : "backUpGiacMonthlyTotals",
				transactionDate : $F("txtTransactionDate")
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response) {
				
			}
		});
	}
	
	function checkSelect(){
		if (includeMonths == "N" && includeYears == "N"){
			if (adjustingEntries == "N"){
				updateActionOpt = "updateAcctrans";
			} else if (adjustingEntries == "Y"){
				updateActionOpt = "updateAcctransAe";
			}
		} else if (includeMonths == "Y" && includeYears == "N"){
			if (adjustingEntries == "N"){
				updateActionOpt = "updateAcctrans1";
			} else if (adjustingEntries == "Y"){
				updateActionOpt = "updateAcctransAe1";
			}
		} else if (includeMonths == "Y" && includeYears == "Y"){
			if (adjustingEntries == "N"){
				updateActionOpt = "updateAcctrans2";
			} else if (adjustingEntries == "Y"){
				updateActionOpt = "updateAcctransAe2";
			}
		} else{
			customShowMessageBox("Selection not allowed. Please include previous month in your selection in order to proceed.", imgMessage.INFO, "includePreviousMonths");
			return false;
		}
		
		if(updateActionOpt != ""){
			updateAcctransAe();
		}
	}
	
	function updateAcctransAe(){
		new Ajax.Request(contextPath + "/GIACTrialBalanceController", {
			method : "POST",
			parameters : {
				action : "updateAcctransAe",
				transactionDate : $F("txtTransactionDate"),
				updateActionOpt : updateActionOpt
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response) {
				genTrialBalance();
			}
		});
	}
	
	function genTrialBalance(){
		new Ajax.Request(contextPath + "/GIACTrialBalanceController", {
			method : "POST",
			parameters : {
				action : "genTrialBalance",
				transactionDate : $F("txtTransactionDate")
			},
			asynchronous : false,
			evalScripts : true,
			onCreate: showNotice("Working... Inserting record..."),
			onComplete : function(response) {
				hideNotice();
				if (response.responseText != "0"){
					showConfirmBox2("Confirmation", response.responseText + " record/s inserted. Do you want to print Trial Balance?", "Ok", "Cancel", 
							function() {
								printTrialBalance();
							}
							, /*exitForm*/""); //benjo 11.10.2015 GENQA-SR-5160 replaced exitForm -> ""
				}
			}
		});
	}
	
	function printTrialBalance(){
		showGenericPrintDialog("Print Distribution", onOkPrintGiacs500, onLoadPrintGiacs500, true);
	}
	
	var reports = [];
	function onOkPrintGiacs500(){
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
		
		var reportId;
		var reportTitle = "TRIAL BALANCE";
		var pMonth;
		var pYear;
		
		pMonth = $F("txtTransactionDate").substring(0,2);
		pYear = $F("txtTransactionDate").substr($F("txtTransactionDate").length-4);

		if($("byBranch").checked){
			reportId = 'GIACR500';
		} else {
			reportId = 'GIACR500A';
		}
		
		var content;
		content = contextPath+"/GIACTrialBalanceController?action=printReportGiacs500&reportId=" + reportId
				+ "&pMonth=" + pMonth
				+ "&pYear=" + pYear
				+ "&reportTitle=" + reportTitle;
		
		if($F("selDestination") == "screen"){
			reports.push({reportUrl : content, reportTitle : reportTitle});			
		}else if($F("selDestination") == "printer"){
			new Ajax.Request(content, {
				method: "GET",
				parameters : {
					noOfCopies : $F("txtNoOfCopies"),
					printerName : $F("selPrinter")
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						showMessageBox("Printing Complete.", "I");
					}
				}
			});
		}else if($F("selDestination") == "file"){
			//added by clperello | 06.05.2014
			 var fileType = "PDF";
		
			if($("rdoPdf").checked)
				fileType = "PDF";
			else if ($("rdoCsv").checked)
				fileType = "CSV"; 
			//end here clperello | 06.05.2014
			
			new Ajax.Request(content, {
				method: "POST",
				parameters : {destination : "file",
							  fileType    : fileType}, //$("rdoPdf").checked ? "PDF" : "XLS"}, //modified clperello 06.05.2014 
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Generating report, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						 if (fileType == "CSV"){ //added by clperello | 06.05.2014
							copyFileToLocal(response, "csv");
							deleteCSVFileFromServer(response.responseText);
						}else {  
							copyFileToLocal(response);
						}
					}
				}
			});
		}else if("local" == $F("selDestination")){
			new Ajax.Request(content, {
				method: "POST",
				parameters : {destination : "local"},
				evalScripts: true,
				asynchronous: true,
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
		if ("screen" == $F("selDestination")) {
			showMultiPdfReport(reports);
			reports = [];
		}
	}
	
	function onLoadPrintGiacs500(){
		var content = "<div class='sectionDiv' style='height: 35px; border: none;'>"+
		"<input type='checkbox' id='byBranch' name='byBranch' checked='checked' title='By Branch' style='margin-left: 115px; margin-top: 6px; float: left;'/>"+ 
		"<label for='byBranch' style='margin-top: 7px;'>By Branch</label>"+
		"</div>";
		
		$("printDialogFormDiv2").update(content); 
		$("printDialogFormDiv2").show();
		$("printDialogMainDiv").up("div",1).style.height = "210px";
		$($("printDialogMainDiv").up("div",1).id).up("div",0).style.height = "242px";
		$("csvOptionDiv").show(); //marco - 07.21.2014
	}
	
	function exitForm(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	}
	
	$("hrefTransactionDate").observe("click", function(){
		scwShow($('txtTransactionDate'), this, null);
	});
	
	$("trialBalanceProcessingExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});	
	
</script>