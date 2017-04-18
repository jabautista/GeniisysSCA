<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="biggestClaimsMainDiv" name="biggestClaimsMainDiv">
	<div id="biggestClaimsMenu">
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
			<label>Biggest Claims</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div class="sectionDiv" id="biggestClaimsBody" >
		<div class="sectionDiv" id="biggestClaims" style="width: 80%; margin-top: 20px; margin-left: 95px; margin-bottom: 50px;">
			<table align="center" style="padding: 10px;">
				<tr>
					<td class="leftAligned"><b>Loss Amount</b></td>
					<td>
						<input class="rightAligned money2" type="text" id="txtLossAmt" name="txtLossAmt" maxLength="30" style="width: 150px; text-align: right; border: 1px solid gray;"/>
					</td>
					<td class="leftAligned"><b>Biggest Claims</b></td>
					<td>
						<input class="rightAligned money2" type="text" id="txtBiggestClaims" name="txtBiggestClaims" maxLength="30" style="width: 150px; text-align: right; border: 1px solid gray;"/>
					</td>
				</tr>
			</table>
			<div class="sectionDiv" id="rdoDateDiv" style="width: 67%; height:110px; margin: 0 0 8px 8px; border: none;">
				<fieldset id="fsDateParameters">
					<legend><b>Date Parameters</b></legend>
					<table>
						<tr>
							<td>
								<input type="radio" id="rdoByPeriod" name="dateOption" style="margin-left: 15px; float: left;" checked="checked"/>
								<label for="rdoByPeriod" style="margin-top: 3px;">By Period</label>
							</td>
						</tr>
						<tr>
							<td>
								<label style="margin-left: 40px; margin-top: 8px;">From</label>
								<div id="txtFromDateDiv" style="float: left; border: solid 1px gray; width: 150px; height: 20px; margin-left: 10px; margin-top: 5px;">
									<input type="text" id="txtFromDate" style="float: left; margin-top: 0px; margin-right: 3px; width: 120px; border: none;" name="txtFromDate" readonly="readonly" />
									<img id="imgFromDate" alt="imgFromDate" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"/>
								</div>
							</td>
							<td>
								<label style="margin-left: 40px; margin-top: 8px;">To</label>
								<div id="txtToDateDiv" style="float: left; border: solid 1px gray; width: 150px; height: 20px; margin-left: 10px; margin-top: 5px;">
									<input type="text" id="txtToDate" style="float: left; margin-top: 0px; margin-right: 3px; width: 120px; border: none;" name="txtTodate" readonly="readonly" />
									<img id="imgToDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"/>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<input type="radio" id="rdoAsOf" name="dateOption" style="margin-left: 15px; margin-top: 10px; float: left;" checked="checked"/>
								<label for="rdoAsOf" style="margin-top: 10px;">As of</label>
								<div id="txtAsOfDiv" style="float: left; border: solid 1px gray; width: 150px; height: 20px; margin-left: 18.5px; margin-top: 5px;">
									<input type="text" id="txtAsOfDate" style="float: left; margin-top: 0px; margin-right: 3px; width: 120px; border: none;" name="txtAsOfDate" readonly="readonly" />
									<img id="imgAsOfDate" alt="imgAsOfDate" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"/>
								</div>
							</td>
						</tr>
					</table>
				</fieldset>
			</div>
			<div class="sectionDiv" id="rdoExtractTypeDiv" style="width: 30%; height:110px; margin: 0 0 8px 8px; border: none;">
				<fieldset id="fsExtractionType" style="height: 96px;">
					<legend><b>Extraction Type</b></legend>
					<table style="margin-top: 15px;">
						<tr>
							<td>
								<input type="radio" id="rdoNoOfClaims" name="extractOption" style="margin-left: 15px; float: left;" checked="checked"/>
								<label for="rdoNoOfClaims" style="margin-top: 3px;">Number of Claims</label>
							</td>
						</tr>
						<tr>
							<td>
								<input type="radio" id="rdoLossAmt" name="extractOption" style="margin-left: 15px; float: left;" checked="checked"/>
								<label for="rdoLossAmt" style="margin-top: 3px;">Loss Amount</label>
							</td>
						</tr>
					</table>
				</fieldset>
			</div>
			<div class="sectionDiv" id="paramsDiv" style="width: 67%; height:180px; padding-top: 0px; margin: 0 0 8px 8px; border: none;">
				<fieldset id="fsParameters">
					<legend><b>Parameters</b></legend>
					<table>
						<tr>
							<td>
								<div class="textDiv">
									<label style="margin-left: 52px; margin-top: 5px;">Line</label>
									<div id="lineCdDiv" class="lovSpan" style="width: 84px; margin-top: 2px; margin-left: 5px;">
										<input id="txtLineCd" name="txtLineCd" type="text" style="border: none; float: left; width: 54px; height: 14px; margin: 0px;" value="" maxlength="2">
										<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineLOV" name="searchLineLOV" alt="Go" style="float: right;"/>
									</div>
									<span class="lovSpanText">
										<input id="txtLineName" type="text" style="width: 280px; height: 14px; margin-bottom: 0px; margin-left: 1px;" readonly="readonly" value="ALL LINES">
									</span>
								</div>	
							</td>
						</tr>
						<tr>
							<td>
								<div class="textDiv">
									<label style="margin-left: 33px; margin-top: 5px;">Subline</label>
									<div id="sublineCdDiv" class="lovSpan" style="width: 84px; margin-top: 2px; margin-left: 5px;">
										<input id="txtSublineCd" name="txtSublineCd" type="text" style="border: none; float: left; width: 54px; height: 14px; margin: 0px;" value="" maxlength="7">
										<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSublineLOV" name="searchSublineLOV" alt="Go" style="float: right;"/>
									</div>
									<span class="lovSpanText">
										<input id="txtSublineName" type="text" style="width: 280px; height: 14px; margin-bottom: 0px; margin-left: 1px;" readonly="readonly" value="ALL SUBLINES">
									</span>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="textDiv">
									<label style="margin-left: 35px; margin-top: 5px;">Branch</label>
									<div id="branchDiv" class="lovSpan" style="width: 84px; margin-top: 2px; margin-left: 5px;">
										<input id="txtBranchCd" name="txtBranchCd" type="text" style="border: none; float: left; width: 54px; height: 14px; margin: 0px;" value="" maxlength="2">
										<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchCd" name="searchBranchCd" alt="Go" style="float: right;"/>
									</div>
									<span class="lovSpanText">
										<input id="txtBranchName" type="text" style="width: 280px; height: 14px; margin-bottom: 0px; margin-left: 1px;" readonly="readonly" value="ALL BRANCHES">
									</span>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="textDiv">
									<label style="margin-left: 0px; margin-top: 5px;">Intermediary</label>
									<div id="intmDiv" class="lovSpan" style="width: 84px; margin-top: 2px; margin-left: 5px;">
										<input id="txtIntmNo" name="txtIntmNo" type="text" style="border: none; float: left; width: 54px; height: 14px; margin: 0px;" value="" maxlength="12">
										<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmLOV" name="searchIntmLOV" alt="Go" style="float: right;"/>
									</div>
									<span class="lovSpanText">
										<input id="txtIntmName" type="text" style="width: 280px; height: 14px; margin-bottom: 0px; margin-left: 1px;" readonly="readonly" value="ALL INTERMEDIARIES">
									</span>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="textDiv">
									<label id="labelAssuredOrCedant" style="margin-left: 29px; margin-top: 5px;">Assured</label>
									<div id="assuredCedantDiv" class="lovSpan" style="width: 84px; margin-top: 2px; margin-left: 5px;">
										<input id="txtAssuredCedantNo" name="txtAssuredCedantNo" type="text" style="border: none; float: left; width: 54px; height: 14px; margin: 0px;" value="" maxlength="12">
										<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchAssuredCedantLOV" name="searchAssuredCedantLOV" alt="Go" style="float: right;"/>
									</div>
									<span class="lovSpanText">
										<input id="txtAssuredCedantName" type="text" style="width: 280px; height: 14px; margin-bottom: 0px; margin-left: 1px;" readonly="readonly" value="ALL ASSURED">
									</span>
								</div>
							</td>
						</tr>
					</table>
				</fieldset>
			</div>
			<div class="sectionDiv" id="statusDiv" style="width: 30%; height:180px; margin: 0 0 8px 8px; border: none;">
				<fieldset id="fsExtractionType" style="height: 163.5px;">
					<legend><b>Claim Status</b></legend>
					<table style="margin-top: 15px;">
						<tr>
							<td>
								<input type="checkbox" id="chkOpen" style="margin-left: 15px; float: left; "/>
								<label for="chkOpen" style="padding-left: 5px;">Open</label>
							</td>
						</tr>
						<tr>
							<td style="padding-top: 5px;">
								<input type="checkbox" id="chkClosed" style="margin-left: 15px; float: left; "/>
								<label for="chkClosed" style="padding-left: 5px;">Closed</label>
							</td>
						</tr>
						<tr>
							<td style="padding-top: 5px;">
								<input type="checkbox" id="chkCancelled" style="margin-left: 15px; float: left; "/>
								<label for="chkCancelled" style="padding-left: 5px;">Cancelled</label>
							</td>
						</tr>
						<tr>
							<td style="padding-top: 5px;">
								<input type="checkbox" id="chkDenied" style="margin-left: 15px; float: left; "/>
								<label for="chkDenied" style="padding-left: 5px;">Denied</label>
							</td>
						</tr>
						<tr>
							<td style="padding-top: 5px;">
								<input type="checkbox" id="chkWithdrawn" style="margin-left: 15px; float: left; "/>
								<label for="chkWithdrawn" style="padding-left: 5px;">Withdrawn</label>
							</td>
						</tr>
					</table>
				</fieldset>
			</div>
			<div class="sectionDiv" id="rdoBranchParameterDiv" style="width: 20%; height:120px; margin: 0 0 8px 8px; border: none;">
				<fieldset id="fsExtractionType" style="height: 96px;">
					<legend><b>Branch Parameter</b></legend>
					<table style="margin-top: 15px;">
						<tr>
							<td>
								<input type="radio" id="rdoClaimIssCd" name="branchOption" style="margin-left: 15px; float: left;" checked="checked"/>
								<label for="rdoClaimIssCd" style="margin-top: 3px;">Claim Iss Cd</label>
							</td>
						</tr>
						<tr>
							<td>
								<input type="radio" id="rdoPolicyIssCd" name="branchOption" style="margin-left: 15px; float: left;" checked="checked"/>
								<label for="rdoPolicyIssCd" style="margin-top: 3px;">Policy Iss Cd</label>
							</td>
						</tr>
					</table>
				</fieldset>
			</div>
			<div class="sectionDiv" id="chkClaimAmountDiv" style="width: 20%; height:120px; margin: 0 0 8px 8px; border: none;">
				<fieldset id="fsClaimAmount" style="height: 96px;">
					<legend><b>Claim Amount</b></legend>
					<table style="margin-top: 15px;">
						<tr>
							<td>
								<input type="checkbox" id="chkOutstanding" style="margin-left: 15px; float: left; "/>
								<label for="chkOutstanding" style="padding-left: 5px;">Outstanding</label>
							</td>
						</tr>
						<tr>
							<td style="padding-top: 3px;">
								<input type="checkbox" id="chkReserve" style="margin-left: 15px; float: left; "/>
								<label for="chkReserve" style="padding-left: 5px;">Reserve</label>
							</td>
						</tr>
						<tr>
							<td style="padding-top: 3px;">
								<input type="checkbox" id="chkSettlement" style="margin-left: 15px; float: left; "/>
								<label for="chkSettlement" style="padding-left: 5px;">Settlement</label>
							</td>
						</tr>
					</table>
				</fieldset>
			</div>
			<div class="sectionDiv" id="rdoLossExpenseDiv" style="width: 26%; height:120px; border: none;">
				<fieldset id="fsLossExpense" style="height: 90px; margin-top: 6px;">
					<table style="margin-top: 15px;">
						<tr>
							<td>
								<input type="radio" id="rdoLoss" name="LossExpenseOption" style="margin-left: 15px; float: left;" checked="checked"/>
								<label for="rdoLoss" style="margin-top: 3px;">Loss</label>
							</td>
						</tr>
						<tr>
							<td>
								<input type="radio" id="rdoExpense" name="LossExpenseOption" style="margin-left: 15px; float: left;" checked="checked"/>
								<label for="rdoExpense" style="margin-top: 3px;">Expense</label>
							</td>
						</tr>
						<tr>
							<td>
								<input type="radio" id="rdoLossExpense" name="LossExpenseOption" style="margin-left: 15px; float: left;" checked="checked"/>
								<label for="rdoLossExpense" style="margin-top: 3px;">Loss + Expense</label>
							</td>
						</tr>
					</table>
				</fieldset>
			</div>
			<div class="sectionDiv" id="rdoDateDiv" style="width: 30%; height:110px; margin: 0 0 8px 8px; border: none;">
				<fieldset id="fsDate" style="height: 96px;">
					<legend><b>Claim Date</b></legend>
					<table style="margin-top: 15px;">
						<tr>
							<td>
								<input type="radio" id="rdoClaimFileDate" name="claimOption" style="margin-left: 15px; float: left;" checked="checked"/>
								<label for="rdoClaimFileDate" style="margin-top: 3px;">File Date</label>
							</td>
						</tr>
						<tr>
							<td>
								<input type="radio" id="rdoClaimLossDate" name="claimOption" style="margin-left: 15px; float: left;" checked="checked"/>
								<label for="rdoClaimLossDate" style="margin-top: 3px;">Loss Date</label>
							</td>
						</tr>
						<tr>
							<td>
								<input type="radio" id="rdoClaimDatePaid" name="claimOption" style="margin-left: 15px; float: left;" checked="checked"/>
								<label for="rdoClaimDatePaid" style="margin-top: 3px;">Date Paid</label>
							</td>
						</tr>
					</table>
				</fieldset>
			</div>
			<div id="buttonDiv" align="center" style="height: 30px; width: 100%; margin-top: 7px; margin-left: 2px; float: left;">
				<input type="button" class="button" id="btnExtract" value="Extract" style="width: 120px;"/>
				<input type="button" class="button" id="btnPrint" value="Print" style="width: 120px;"/>
			</div>
			<div>
				<input type="hidden" id="hidRiIssCd" />
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	setModuleId("GICLS220");
	setDocumentTitle("Biggest Claims");
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	initializeGICLS220Parameters();
	var today = new Date();
	var claimStatusOP = 'N';
	var claimStatusCL = 'N';
	var claimStatusCC = 'N';
	var claimStatusDE = 'N';
	var claimStatusWD = 'N';
	var branchParam;
	var claimAmt;
	var claimAmtO = 'N';
	var claimAmtR = 'N'; 
	var claimAmtS = 'N';
	var lossExpense;
	var claimDate;
	var extractType;
	var sessionId = "0";
	var extractSw = "N";
	var extractType;
	
	$("btnPrint").observe("click", function(){
		if(extractSw == "N"){
			showMessageBox("Please extract records first.", "I");
			return false;
		}
		
		if(extractParametersExist() == '0') {
			showConfirmBox("Confirmation", "The specified parameter/s has not been extracted. Do you want to extract the data using the specified parameter/s?", "Yes", "No",
					function() {
						readyParams();
						extractGICLS220();
					}, "");
		} else {
			showGenericPrintDialog("Print Biggest Claims", onOkPrintGICLS220, "", true);	
			$("csvOptionDiv").show(); //Aliza G. GENQA SR 5362
		}
	});
	
	function onOkPrintGICLS220(){
		printReportGICLS220("GICLR220", "Top Claims");
	
		if ("screen" == $F("selDestination")) {
			showMultiPdfReport(reports);
			reports = [];
		}
		$("btnPrintCancel").value = "OK";
		$("btnPrintCancel").style.width = "80px";
	}
	
	var reports = [];
	function printReportGICLS220(reportId, reportTitle){
		try {
			if ($("chkOutstanding").checked){
				claimAmt = "O";
			} else {
				if ($("chkReserve").checked && $("chkSettlement").checked){
					claimAmt = "B";
				} else if ($("chkReserve").checked){
					claimAmt = "R";
				} else {
					claimAmt = "S";
				}
			}
			
			if($("rdoLoss").checked){
				lossExpense = "L";
			} else if ($("rdoExpense").checked){
				lossExpense = "E";
			} else if ($("rdoLossExpense").checked){
				lossExpense = "LE";
			}
			
			if($("rdoClaimFileDate").checked){
				claimDate = "F";
			} else if ($("rdoClaimLossDate").checked){
				claimDate = "L";
			} else if ($("rdoClaimDatePaid").checked){
				claimDate = "P";
			}
			
			var content = contextPath + "/PrintBiggestClaimsController?action=printReport"
            + "&reportId=" + 'GICLR220'
            + "&claimAmt=" + claimAmt
            + "&lossExpense=" + lossExpense	
            //+ "&claimDate=" + claimDate
            + getParams();
			
			if($F("selDestination") == "screen"){
				reports.push({reportUrl : content, reportTitle : reportTitle});			
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					method: "GET",
					parameters : {noOfCopies : $F("txtNoOfCopies"),
							 	 printerName : $F("selPrinter")
							 	 },
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing Complete.", imgMessage.SUCCESS);
						}
					}
				});
			}else if($F("selDestination") == "file"){
				var fileType = "PDF";				//start of codes added by aliza G. SR 5362
				
				if($("rdoPdf").checked)
					fileType = "PDF";
				else if ($("rdoCsv").checked)
					fileType = "CSV";				//end of codes added by aliza G. SR 5362
				
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "file",
								 //fileType    : $("rdoPdf").checked ? "PDF" : "XLS"}, //comment out by Aliza G. SR 5362								  
								  fileType		: fileType},
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						/*if (checkErrorOnResponse(response)){
							copyFileToLocal(response);
						}*/ //comment out by Aliza G. SR 5362
						if (checkErrorOnResponse(response)){
							if ($("rdoCsv").checked){
								copyFileToLocal(response, "csv");
								deleteCSVFileFromServer(response.responseText);
							}else
								copyFileToLocal(response);
						}
					}
				  //}
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
		} catch (e){
			showErrorMessage("printReportGICLS220", e);
		}
	}
	
	function getParams(){
		var params = "&sessionId=" + sessionId
 		+ "&lineCd=" + $F("txtLineCd") 
		+ "&sublineCd=" + $F("txtSublineCd")
		+ "&branchCd=" + $F("txtBranchCd")
		+ "&intmNo=" + $F("txtIntmNo")
		+ "&assdCedantNo=" + $F("txtAssuredCedantNo")
		+ "&asOfDate=" + $F("txtAsOfDate")
		+ "&dateFrom=" + $F("txtFromDate")
		+ "&dateTo=" + $F("txtToDate");
		
		return params;
	}
	
	$("btnExtract").observe("click", function(){
		validateBeforeExtract();			
	});
	
	function validateBeforeExtract(){
		if($("rdoNoOfClaims").checked){
			if($F("txtBiggestClaims") == ""){
				showMessageBox("Required fields must be entered.", "I");
				return false;
			} else if($F("txtBiggestClaims") < 1){
				showMessageBox("Specify the number of top claims for extraction.", "I");
				return false;
			}
		} else if($("rdoLossAmt").checked){
			if($F("txtLossAmt") == ""){
				showMessageBox("Required fields must be entered.", "I");
				return false;
			} else if (parseFloat(unformatCurrencyValue($F("txtLossAmt"))) < 1 || parseFloat(unformatCurrencyValue($F("txtLossAmt"))) > 99999999999999.99){
				customShowMessageBox("Invalid Loss Amount. Valid value should be from 1 to 99,999,999,999,999.99.", "I", "txtLossAmt");
				return false;
			}
		}
		
		if (($F("txtFromDate") == "" || $F("txtToDate") == "") && $F("txtAsOfDate") == "") {
			showMessageBox("Required fields must be entered.","I");
			return false;
		}
		
		if (extractParametersExist() == '0') {
			readyParams();
			extractGICLS220();
		} else {
			showConfirmBox("Confirmation", "Data has been extracted within the specified parameter/s. Do you wish to continue extraction?", "Yes", "No",
					function() {
						readyParams();
						extractGICLS220();
					}, "");
		}
	}
	
	function extractParametersExist(){
		try {
			var existSessionId = '0';
			new Ajax.Request(contextPath+"/GICLBiggestClaimsController",{
				method: "POST",
				parameters : {
					action : "extractParametersExistGicls220",
					extractType : $("rdoNoOfClaims").checked ? "N" : "L",
				    lossAmt : unformatCurrencyValue($F("txtLossAmt")),
				    biggestClaims : unformatCurrencyValue($F("txtBiggestClaims")),
				    fromDate : $F("txtFromDate"),
				    toDate : $F("txtToDate"),
				    asOfDate : $F("txtAsOfDate")
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Loading, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						existSessionId = response.responseText;
						sessionId = response.responseText;
						extractSw = "Y";
					}
				}
			});
			return existSessionId;
		} catch (e) {
			showErrorMessage("extractParametersExist",e);
		}
	}
	
	function readyParams(){
		if($("chkOpen").checked){
			claimStatusOP = "OP";
		} else {
			claimStatusOP = "N";
		}
		if($("chkClosed").checked){
			claimStatusCL = "CL";
		} else {
			claimStatusCL = "N";
		}
		if($("chkCancelled").checked){
			claimStatusCC = "CC";
		} else {
			claimStatusCC = "N";
		}
 		if($("chkDenied").checked){
			claimStatusDE = "DE";
		} else {
			claimStatusDE = "N";
		}
		if($("chkWithdrawn").checked){
			claimStatusWD = "WD";
		} else {
			claimStatusWE = "N";
		}
		
		if($("rdoClaimIssCd").checked){
			branchParam = "C";
		} else if ($("rdoPolicyIssCd").checked){
			branchParam = "P";
		}
		
		if($("chkOutstanding").checked){
			claimAmtO = "Y";
		} else{
			claimAmtO = "N";
		}
		if ($("chkReserve").checked){
			claimAmtR = "Y";
		} else {
			claimAmtR = "N";
		}
		if ($("chkSettlement").checked){
			claimAmtS = "Y";
		} else {
			claimAmtS = "N";
		}
		
		
		if($("rdoLoss").checked){
			lossExpense = "L";
		} else if ($("rdoExpense").checked){
			lossExpense = "E";
		} else if ($("rdoLossExpense").checked){
			lossExpense = "LE";
		}
		
		if($("rdoClaimFileDate").checked){
			claimDate = "F";
		} else if ($("rdoClaimLossDate").checked){
			claimDate = "L";
		} else if ($("rdoClaimDatePaid").checked){
			claimDate = "D";
		}
		
		if($("rdoNoOfClaims").checked){
			extractType = 'N';
		} else {
			extractType = 'L';
		}
	}
	
	function extractGICLS220(){
		if($F("txtBiggestClaims") != ""){
			if(parseFloat(unformatCurrencyValue($F("txtBiggestClaims"))) < 1 || parseFloat(unformatCurrencyValue($F("txtBiggestClaims"))) > 99999999999999.99){
				customShowMessageBox("Invalid Biggest Claims. Valid value should be from 1 to 99,999,999,999,999.99.", "I", "txtBiggestClaims");
				return false;
			}
			
			if(isNaN(unformatCurrencyValue($F("txtBiggestClaims")))){
				customShowMessageBox("Invalid Biggest Claims. Valid value should be from 1 to 99,999,999,999,999.99.", "I", "txtBiggestClaims");
				return false;
			}
		}
		
		try {
			new Ajax.Request(contextPath+"/GICLBiggestClaimsController",{
				method: "POST",
				parameters : {action : "extractGICLS220",
							  lossAmt : unformatCurrencyValue($F("txtLossAmt")),
							  biggestClaims : unformatCurrencyValue($F("txtBiggestClaims")),
							  asOfDate : $F("txtAsOfDate"),
							  fromdate : $F("txtFromDate"),
							  todate : $F("txtToDate"),
							  lineCd : $F("txtLineCd"),
							  sublineCd : $F("txtSublineCd"),
							  branchCd : $F("txtBranchCd"),
							  intmNo : $F("txtIntmNo"),
							  assdCedantNo : $F("txtAssuredCedantNo"),
							  claimStatusOP : claimStatusOP,
							  claimStatusCL : claimStatusCL,
							  claimStatusCC : claimStatusCC,
							  claimStatusDE : claimStatusDE,
							  claimStatusWD : claimStatusWD,
							  branchParam : branchParam,
							  claimAmtO : claimAmtO,
							  claimAmtR : claimAmtR,
							  claimAmtS : claimAmtS,
							  lossExpense : lossExpense,
							  claimDate : claimDate,
							  hidRiIssCd : $F("hidRiIssCd"),
							  extractType : extractType,
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
							sessionId = result.sessionId;
						}
					}
				}
			});
		} catch (e) {
			showErrorMessage("extractGICLS220",e);
		}		
	}
	
	function validateFromToDate(elemNameFr, elemNameTo, currElemName){
		var isValid = true;		
		var elemDateFr = Date.parse($F(elemNameFr), "mm-dd-yyyy");
		var elemDateTo = Date.parse($F(elemNameTo), "mm-dd-yyyy");
		
		var output = compareDatesIgnoreTime(elemDateFr, elemDateTo);
		if(output < 0){
			if(currElemName == elemNameFr){
				showMessageBox("The date you entered is LATER THAN the TO DATE.", "E");
				$("txtToDate").value = "";
				$("txtFromDate").value = "";
			} else {
				showMessageBox("The date you entered is EARLIER THAN the FROM DATE.", "E");
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
	
	/* $("txtFromDate").observe("blur", function(){
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
	}); */
	
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
	
	function whenNewFormInstanceGICLS220(){
		new Ajax.Request(contextPath+"/GICLBiggestClaimsController?action=whenNewFormInstanceGICLS220",{
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				var res = JSON.parse(response.responseText);
				$("hidRiIssCd").value = res.riIssCd;
			}
		});
	}
	
	function initializeGICLS220Parameters(){
		$("rdoByPeriod").checked = false;
		$("rdoAsOf").checked = true;
		$("txtFromDate").addClassName("disabled");
		$("txtFromDateDiv").addClassName("disabled");
		$("txtToDate").addClassName("disabled");
		$("txtToDateDiv").addClassName("disabled");
		disableDate("imgFromDate");
		disableDate("imgToDate");
		$("txtAsOfDate").value = dateFormat(today, 'mm-dd-yyyy');
		$("chkOpen").checked = true;
		$("chkOpen").disabled = true;
		$("chkClosed").disabled = true;
		$("chkClosed").checked = false;
		$("chkCancelled").disabled = true;
		$("chkCancelled").checked = false;
		$("chkDenied").disabled = true;
		$("chkDenied").checked = false;
		$("chkWithdrawn").disabled = true;
		$("chkWithdrawn").checked = false;
		$("rdoClaimIssCd").checked = true;
		$("rdoPolicyIssCd").checked = false;
		$("chkOutstanding").disabled = false;
		$("chkOutstanding").checked = true;
		$("chkReserve").disabled = true;
		$("chkReserve").checked = false;
		$("chkSettlement").disabled = true;
		$("chkSettlement").checked = false;
		$("rdoLoss").checked = true;
		$("rdoExpense").checked = false;
		$("rdoLossExpense").checked = false;
		$("rdoClaimFileDate").checked = true;
		$("rdoClaimLossDate").checked = false;
		$("rdoClaimDatePaid").checked = false;
		$("rdoClaimFileDate").disabled = true;
		$("rdoClaimLossDate").disabled = true;
		$("rdoClaimDatePaid").disabled = true;
	}
	
	function observeGICLS220Checkboxes(option, div){
		if (div == "ClaimStatus"){
			if ($("chkOpen").checked || $("chkClosed").checked || $("chkCancelled").checked || $("chkDenied").checked || $("chkWithdrawn").checked){
				return true;
			} else {
				customShowMessageBox("There should be at least one claim status.", "I", "");
				if (option == "Open"){
					$("chkOpen").checked = true;
				} else if (option == "Closed"){
					$("chkClosed").checked = true;
				} else if (option == "Cancelled"){
					$("chkCancelled").checked = true;
				} else if (option == "Denied"){
					$("chkDenied").checked = true;
				} else if (option == "Withdrawn"){
					$("chkWithdrawn").checked = true;
				}
			}
		} else if (div == "ClaimAmount"){
			if ($("chkOutstanding").checked || $("chkReserve").checked || $("chkSettlement").checked){
				if($("chkOutstanding").checked == false && $("chkReserve").checked == false){
					$("rdoClaimFileDate").disabled = true;
					$("rdoClaimLossDate").disabled = true;
					$("rdoClaimDatePaid").disabled = false;
					$("rdoClaimDatePaid").checked = true;
					
					$("chkCancelled").disabled = true;
					$("chkDenied").disabled = true;
					$("chkWithdrawn").disabled = true;
				} else{
					$("rdoClaimFileDate").disabled = false;
					$("rdoClaimFileDate").checked = true;
					$("rdoClaimLossDate").disabled = false;
					$("rdoClaimDatePaid").disabled = true;
					
					$("chkCancelled").disabled = false;
					$("chkDenied").disabled = false;
					$("chkWithdrawn").disabled = false;
				}
			} else {
				customShowMessageBox("Please choose one of the ff. claim amount.", "I", "");
				if (option == "Outstanding"){
					$("chkOutstanding").checked = true;
				} else if (option == "Reserve"){
					$("chkReserve").checked = true;
				} else if (option == "Settlement"){
					$("chkSettlement").checked = true;
				}
			}
		}
	}
	
	$("chkOpen").observe("click", function(){
		observeGICLS220Checkboxes("Open", "ClaimStatus");
	});
	
	$("chkClosed").observe("click", function(){
		observeGICLS220Checkboxes("Closed", "ClaimStatus");
	});
	
	$("chkCancelled").observe("click", function(){
		observeGICLS220Checkboxes("Cancelled", "ClaimStatus");
	});
	
	$("chkDenied").observe("click", function(){
		observeGICLS220Checkboxes("Denied", "ClaimStatus");
	});
	
	$("chkWithdrawn").observe("click", function(){
		observeGICLS220Checkboxes("Withdrawn", "ClaimStatus");
	});
	
	$("chkOutstanding").observe("click", function(){
		observeGICLS220Checkboxes("Outstanding", "ClaimAmount");
	});
	
	$("chkReserve").observe("click", function(){
		observeGICLS220Checkboxes("Reserve", "ClaimAmount");
	});
	
	$("chkSettlement").observe("click", function(){
		observeGICLS220Checkboxes("Settlement", "ClaimAmount");
	});
	
	$("txtLineCd").setAttribute("lastValidValue", "");
	$("txtLineName").setAttribute("lastValidValue", "ALL LINES");
	$("searchLineLOV").observe("click", getGICLS220LineLOV);
	$("txtLineCd").observe("change", function() {		
		if($F("txtLineCd").trim() == "") {
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").value = "ALL LINES";
			$("txtLineName").setAttribute("lastValidValue", "ALL LINES");
			$("txtSublineCd").value = "";
			$("txtSublineName").value = "ALL SUBLINES";
			$("txtSublineName").setAttribute("lastValidValue", "ALL SUBLINES");
		} else {
			if($F("txtLineCd").trim() != "" && $F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue")) {
				getGICLS220LineLOV();
			}
		}
	});
	$("txtLineCd").observe("keyup", function(){
		if($F("txtLineCd").trim() == ""){
			$("txtSublineCd").value = "";
			$("txtSublineName").value = "ALL SUBLINES";
			$("txtLineName").value = "ALL LINES";
		}
		$("txtLineCd").value = $F("txtLineCd").toUpperCase(); 
	});
	
	function getGICLS220LineLOV(){
		LOV.show({
			controller: 'ClaimsLOVController',
			urlParameters: {
				action:		"getGICLS220LineLOV",
				moduleId:   "GICLS220",
				branchCd:   $F("txtBranchCd"),
				filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
				page : 1
			},
			title: "List of Lines",
			width: 405,
			height: 386,
			draggable: true,
			columnModel: [
				{
					id: "lineCd",
					title: "Line Code",
					width: "100px",
					filterOption: true
				},
				{
					id: "lineName",
					title: "Line Name",
					width: "290px",
					renderer: function(value) {
						return unescapeHTML2(value);
					}
				}
			],
			autoSelectOneRecord: true,
			filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
			onSelect: function(row) {
				$("txtLineCd").value = row.lineCd;
				$("txtLineName").value = unescapeHTML2(row.lineName);
				$("txtLineCd").setAttribute("lastValidValue", row.lineCd);
				$("txtLineName").setAttribute("lastValidValue", row.lineName);
			},
			onCancel: function (){
				$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				$("txtLineName").value = unescapeHTML2($("txtLineName").readAttribute("lastValidValue"));
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				$("txtLineName").value = unescapeHTML2($("txtLineName").readAttribute("lastValidValue"));
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	$("txtSublineCd").setAttribute("lastValidValue", "");
	$("txtSublineName").setAttribute("lastValidValue", "ALL SUBLINES");
	$("searchSublineLOV").observe("click", getGICLS220SublineLOV);
	$("txtSublineCd").observe("change", function() {	
		if($F("txtLineCd") == ""){
			$("txtSublineCd").value = "";
			$("txtSublineCd").setAttribute("lastValidValue", "");
			$("txtSublineName").value = "ALL SUBLINES";
			$("txtSublineName").setAttribute("lastValidValue", "ALL SUBLINES");
			
			showMessageBox("Subline code cannot be entered if line code is not specified.", "I");
			return;
		}
		
		if($F("txtSublineCd").trim() == "") {
			$("txtSublineCd").value = "";
			$("txtSublineCd").setAttribute("lastValidValue", "");
			$("txtSublineName").value = "ALL SUBLINES";
			$("txtSublineName").setAttribute("lastValidValue", "ALL SUBLINES");
		} else {
			if($F("txtSublineCd").trim() != "" && $F("txtSublineCd") != $("txtSublineCd").readAttribute("lastValidValue")) {
				getGICLS220SublineLOV();
			}
		}
	});
	$("txtSublineCd").observe("keyup", function(){
		$("txtSublineCd").value = $F("txtSublineCd").toUpperCase(); 
	});
	
	function getGICLS220SublineLOV(){
		if($F("txtLineCd") == ""){
			showMessageBox("Option not allowed for ALL LINES.", "I");
			return;
		}
		
		LOV.show({
			controller: 'ClaimsLOVController',
			urlParameters: {
				action:		"getGICLS220SublineLOV",
				lineCd:     $F("txtLineCd"),
				filterText : ($("txtSublineCd").readAttribute("lastValidValue").trim() != $F("txtSublineCd").trim() ? $F("txtSublineCd").trim() : ""),
				page : 1
			},
			title: "List of Sublines",
			width: 405,
			height: 386,
			draggable: true,
			columnModel: [
				{
					id: "sublineCd",
					title: "Subline Code",
					width: "100px",
					filterOption: true
				},
				{
					id: "sublineName",
					title: "Subline Name",
					width: "290px",
					renderer: function(value) {
						return unescapeHTML2(value);
					}
				}
			],
			autoSelectOneRecord: true,
			filterText : ($("txtSublineCd").readAttribute("lastValidValue").trim() != $F("txtSublineCd").trim() ? $F("txtSublineCd").trim() : ""),
			onSelect: function(row) {
				$("txtSublineCd").value = row.sublineCd;
				$("txtSublineName").value = unescapeHTML2(row.sublineName);
				$("txtSublineCd").setAttribute("lastValidValue", row.sublineCd);								
				$("txtSublineName").setAttribute("lastValidValue", row.sublineName);
			},
			onCancel: function (){
				$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
				$("txtSublineName").value = unescapeHTML2($("txtSublineName").readAttribute("lastValidValue"));
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
				$("txtSublineName").value = unescapeHTML2($("txtSublineName").readAttribute("lastValidValue"));
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	$("txtBranchCd").setAttribute("lastValidValue", "");
	$("txtBranchName").setAttribute("lastValidValue", "ALL BRANCHES");
	$("searchBranchCd").observe("click", getGICLS220BranchLOV);
	$("txtBranchCd").observe("change", function() {		
		if($F("txtBranchCd").trim() == "") {
			$("txtBranchCd").value = "";
			$("txtBranchCd").setAttribute("lastValidValue", "");
			$("txtBranchName").value = "ALL BRANCHES";
			$("txtBranchName").setAttribute("lastValidValue", "ALL BRANCHES");
		} else {
			if($F("txtBranchCd").trim() != "" && $F("txtBranchCd") != $("txtBranchCd").readAttribute("lastValidValue")) {
				getGICLS220BranchLOV();
			}
		}
	});
	$("txtBranchCd").observe("keyup", function(){
		$("txtBranchCd").value = $F("txtBranchCd").toUpperCase(); 
	});
	
	function getGICLS220BranchLOV(){
		LOV.show({
			controller: 'ClaimsLOVController',
			urlParameters: {
				action:		"getGICLS220BranchLOV",
				lineCd:     $F("txtLineCd"),
				moduleId:   "GICLS220",
				filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : ""),
				page : 1
			},
			title: "List of Branches",
			width: 405,
			height: 386,
			draggable: true,
			columnModel: [
				{
					id: "issCd",
					title: "Branch Code",
					width: "100px"
				},
				{
					id: "issName",
					title: "Branch Name",
					width: "290px",
					renderer: function(value) {
						return unescapeHTML2(value);
					}
				}
			],
			autoSelectOneRecord: true,
			filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : ""),
			onSelect: function(row) {
				$("txtBranchCd").value = row.issCd;
				$("txtBranchCd").setAttribute("lastValidValue", row.issCd);
				$("txtBranchName").value = unescapeHTML2(row.issName);
				$("txtBranchName").setAttribute("lastValidValue", row.issName);
				if($F("txtBranchCd") == $F("hidRiIssCd")){
					document.getElementById('labelAssuredOrCedant').style.marginLeft = "34px"; 
					document.getElementById('labelAssuredOrCedant').innerHTML = 'Cedant';
				} else {
					document.getElementById('labelAssuredOrCedant').style.marginLeft = "29px"; 
					document.getElementById('labelAssuredOrCedant').innerHTML = 'Assured';
				}							
			},
			onCancel: function (){
				$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
				$("txtBranchName").value = unescapeHTML2($("txtBranchName").readAttribute("lastValidValue"));
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
				$("txtBranchName").value = unescapeHTML2($("txtBranchName").readAttribute("lastValidValue"));
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	$("txtIntmNo").setAttribute("lastValidValue", "");
	$("txtIntmName").setAttribute("lastValidValue", "ALL INTERMEDIARIES");
	$("searchIntmLOV").observe("click", getGICLS220IntmLOV);
	$("txtIntmNo").observe("change", function() {		
		if($F("txtIntmNo").trim() == "") {
			$("txtIntmNo").value = "";
			$("txtIntmNo").setAttribute("lastValidValue", "");
			$("txtIntmName").value = "ALL INTERMEDIARIES";
			$("txtIntmName").setAttribute("lastValidValue", "ALL INTERMEDIARIES");
		} else {
			if($F("txtIntmNo").trim() != "" && $F("txtIntmNo") != $("txtIntmNo").readAttribute("lastValidValue")) {
				getGICLS220IntmLOV();
			}
		}
	});
	$("txtIntmNo").observe("keyup", function(){
		$("txtIntmNo").value = $F("txtIntmNo").toUpperCase(); 
	});
	
	function getGICLS220IntmLOV(){
		LOV.show({
			controller: 'ClaimsLOVController',
			urlParameters: {
				action:		"getGICLS220IntmLOV",
				filterText : ($("txtIntmNo").readAttribute("lastValidValue").trim() != $F("txtIntmNo").trim() ? $F("txtIntmNo").trim() : ""),
				page : 1
			},
			title: "List of Intermediaries",
			width: 405,
			height: 386,
			draggable: true,
			columnModel: [
				{
					id: "intmNo",
					title: "Intm Number",
					width: "100px"
				},
				{
					id: "intmName",
					title: "Intm Name",
					width: "290px",
					renderer: function(value) {
						return unescapeHTML2(value);
					}
				}
			],
			autoSelectOneRecord: true,
			filterText : ($("txtIntmNo").readAttribute("lastValidValue").trim() != $F("txtIntmNo").trim() ? $F("txtIntmNo").trim() : ""),
			onSelect: function(row) {
				$("txtIntmNo").value = row.intmNo;
				$("txtIntmName").value = unescapeHTML2(row.intmName);
				$("txtIntmNo").setAttribute("lastValidValue", row.intmNo);
				$("txtIntmName").setAttribute("lastValidValue", row.intmName);
			},
			onCancel: function (){
				$("txtIntmNo").value = $("txtIntmNo").readAttribute("lastValidValue");
				$("txtIntmName").value = unescapeHTML2($("txtIntmName").readAttribute("lastValidValue"));
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtIntmNo").value = $("txtIntmNo").readAttribute("lastValidValue");
				$("txtIntmName").value = unescapeHTML2($("txtIntmName").readAttribute("lastValidValue"));
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	$("txtAssuredCedantNo").setAttribute("lastValidValue", "");
	$("txtAssuredCedantName").setAttribute("lastValidValue", "ALL ASSURED");
	$("searchAssuredCedantLOV").observe("click", getGICLS220AssuredLOV);
	$("txtAssuredCedantNo").observe("change", function() {		
		if($F("txtAssuredCedantNo").trim() == "") {
			$("txtAssuredCedantNo").value = "";
			$("txtAssuredCedantNo").setAttribute("lastValidValue", "");
			$("txtAssuredCedantName").value = "ALL ASSURED";
			$("txtAssuredCedantName").setAttribute("lastValidValue", "ALL ASSURED");
		} else {
			if($F("txtAssuredCedantNo").trim() != "" && $F("txtAssuredCedantNo") != $("txtAssuredCedantNo").readAttribute("lastValidValue")) {
				getGICLS220AssuredLOV();
			}
		}
	});
	$("txtAssuredCedantNo").observe("keyup", function(){
		$("txtAssuredCedantNo").value = $F("txtAssuredCedantNo").toUpperCase(); 
	});
	
	function getGICLS220AssuredLOV(){
		LOV.show({
			controller: 'ClaimsLOVController',
			urlParameters: {
				action:		"getGICLS220AssuredLOV",
				filterText : ($("txtAssuredCedantNo").readAttribute("lastValidValue").trim() != $F("txtAssuredCedantNo").trim() ? $F("txtAssuredCedantNo").trim() : ""),
				page : 1
			},
			title: "List of Assured",
			width: 405,
			height: 386,
			draggable: true,
			columnModel: [
				{
					id: "assdNo",
					title: "Assured Number",
					width: "100px"
				},
				{
					id: "assdName",
					title: "Assured Name",
					width: "290px",
					renderer: function(value) {
						return unescapeHTML2(value);
					}
				}
			],
			autoSelectOneRecord: true,
			filterText : ($("txtAssuredCedantNo").readAttribute("lastValidValue").trim() != $F("txtAssuredCedantNo").trim() ? $F("txtAssuredCedantNo").trim() : ""),
			onSelect: function(row){
				$("txtAssuredCedantNo").value = row.assdNo;
				$("txtAssuredCedantName").value = unescapeHTML2(row.assdName);
				$("txtAssuredCedantNo").setAttribute("lastValidValue", row.assdNo);
				$("txtAssuredCedantName").setAttribute("lastValidValue", unescapeHTML2(row.assdName));
			},
			onCancel: function (){
				$("txtAssuredCedantNo").value = $("txtAssuredCedantNo").readAttribute("lastValidValue");
				$("txtAssuredCedantName").value = unescapeHTML2($("txtAssuredCedantName").readAttribute("lastValidValue"));
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtAssuredCedantNo").value = $("txtAssuredCedantNo").readAttribute("lastValidValue");
				$("txtAssuredCedantName").value = unescapeHTML2($("txtAssuredCedantName").readAttribute("lastValidValue"));
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	$("rdoByPeriod").observe("click", function(){
		$("txtAsOfDate").addClassName("disabled");
		$("txtAsOfDiv").addClassName("disabled");
		disableDate("imgAsOfDate");
		$("txtAsOfDate").clear();
		$("txtFromDate").removeClassName("disabled");
		$("txtFromDateDiv").removeClassName("disabled");
		$("txtToDate").removeClassName("disabled");
		$("txtToDateDiv").removeClassName("disabled");
		enableDate("imgFromDate");
		enableDate("imgToDate");
		$("chkOpen").checked = true;
		$("chkOpen").disabled = false;
		$("chkClosed").disabled = false;
		$("chkClosed").checked = false;
		$("chkCancelled").disabled = false;
		$("chkCancelled").checked = false;
		$("chkDenied").disabled = false;
		$("chkDenied").checked = false;
		$("chkWithdrawn").disabled = false;
		$("chkWithdrawn").checked = false;
		$("chkOutstanding").disabled = true;
		$("chkOutstanding").checked = false;
		$("chkReserve").disabled = false;
		$("chkReserve").checked = true;
		$("chkSettlement").disabled = false;
		$("chkSettlement").checked = false;
		$("rdoClaimFileDate").disabled = false;
		$("rdoClaimLossDate").disabled = false;
		$("txtAsOfDate").removeClassName("required");
		$("txtAsOfDiv").removeClassName("required");
		$("txtFromDate").addClassName("required");
		$("txtFromDateDiv").addClassName("required");
		$("txtToDate").addClassName("required");
		$("txtToDateDiv").addClassName("required");
	});
	
	$("rdoAsOf").observe("click", function(){
		$("txtFromDate").clear();
		$("txtToDate").clear();
		$("txtAsOfDate").removeClassName("disabled");
		$("txtAsOfDiv").removeClassName("disabled");
		$("txtAsOfDate").addClassName("required");
		$("txtAsOfDiv").addClassName("required");
		$("txtFromDate").removeClassName("required");
		$("txtFromDateDiv").removeClassName("required");
		$("txtToDate").removeClassName("required");
		$("txtToDateDiv").removeClassName("required");
		enableDate("imgAsOfDate");
		initializeGICLS220Parameters();
	});
	
	$("rdoLossAmt").observe("click", function(){
		$("txtLossAmt").disabled = false;
		$("txtLossAmt").focus();
		$("txtLossAmt").addClassName("required");
		$("txtBiggestClaims").disabled = true;
		$("txtBiggestClaims").value = "";
		$("txtBiggestClaims").removeClassName("required");
	});
	
	$("rdoNoOfClaims").observe("click", function(){
		$("txtBiggestClaims").disabled = false;
		$("txtBiggestClaims").focus();
		$("txtBiggestClaims").addClassName("required");
		$("txtLossAmt").disabled = true;
		$("txtLossAmt").value = "";
		$("txtLossAmt").removeClassName("required");
	});
	
	$("imgAsOfDate").observe("click", function(){
		scwShow($('txtAsOfDate'),this, null);
	});
	
	$("imgFromDate").observe("click", function(){
		scwShow($('txtFromDate'),this, null);
	});
	
	$("imgToDate").observe("click", function(){
		scwShow($('txtToDate'),this, null);
	});
	
	function validateNumberFields(id, decimal, form){
		if($F(id) != ""){
			if(isNaN($F(id)) || parseFloat($F(id)) < 1 || parseFloat($F(id)) > 99999999999999.99){
				customShowMessageBox("Invalid Biggest Claims. Valid value should be from 1 to 99,999,999,999,999.99.", "I", id);
			} else {
				$(id).value = formatCurrency($F(id));
			}
		}
	}
	
	//$("txtBiggestClaims").observe("change", function(){validateNumberFields("txtBiggestClaims", "", "");});
	
	$("rdoNoOfClaims").checked = true;
	$("rdoLossAmt").checked = false;
	$("txtLossAmt").disabled = true;
	$("txtBiggestClaims").focus();
	$("txtBiggestClaims").addClassName("required");
	$("txtAsOfDate").addClassName("required");
	$("txtAsOfDiv").addClassName("required");
	
	observeReloadForm("reloadForm", showBiggestClaims);
	$("btnExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
	});
	
	whenNewFormInstanceGICLS220();
</script>