<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>

<div id="generalDisbursementsMainDiv" name="generalDisbursementsMainDiv">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
   			<label>Contingent Profit Commission</label>
   			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	
	<div id="moduleDiv" name="moduleDiv" class="sectionDiv" >
		
		<div id="paramsDiv" name="paramsDiv" class="sectionDiv" style="width:65%; margin: 40px 120px 40px 160px;">
			<div id="searchParamsDiv" name="searchParamsDiv" class="sectionDiv" align="center" style="width:96.7%; margin:10px 10px 2px 10px;">
				<table border="0" align="center" style="margin:10px 0 10px 14px; width:100%;">
					<tr>
						<td class="rightAligned">CPC for the Year</td>
						<td class="leftAligned">
							<input type="text" id="txtYear" name="txtYear" style="width: 145px; text-align: right;" maxlength="4"  tabindex="101" class="integerNoNegativeUnformattedNoComma" />
						</td>
						<td class="rightAligned">Cut-Off Date</td>
						<td class="leftAligned">
							<div style="float:left; width:145px;" class="withIconDiv">
								<input type="text" id="txtCutOffDate" name="txtCutOffDate" class="withIcon" readonly="readonly" style="width: 120px;" tabindex="102" />
								<img id="hrefCutOffDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" />
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Intermediary</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan" style="width: 76px; margin-right: 2px;">
								<input type="text" id="txtIntmNo" name="txtIntmNo" style="width: 50px; float: left; border: none; height: 14px; margin: 0;" class="upper" maxlength="30" tabindex="105" lastValidValue="" />  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osIntmNo" name="osIntmNo" alt="Go" style="float: right;" tabindex="106"/>
							</span>
							<input type="text" id="txtIntmName" name="txtIntmName" style="width: 350px; float: left; height: 14px; margin: 0;" class="upper" maxlength="50" readonly="readonly" tabindex="107"/>												
						</td>
					</tr>
				</table>
			</div> <!-- end: searchParamsDiv -->
			
			<div id="extractParamsDiv" name="extractParamsDiv" class="sectionDiv" style="width:48%; height:110px; margin: 0 0 2px 10px;" >
				<table align="center" style="margin:10px 0 20px 5px;">
					<tr style="height:20px;"><td style="text-align:left;"><font style="margin-left:15px"><b>Extract:</b></font></td></tr>
					<tr style="height:20px;">
						<td><input type="checkbox" id="chkPremComm" name="chkPremComm" style="margin-left:30px; float:left;"/>
							<label for="chkPremComm" id="lblChkPremComm" style="float:left;">&nbsp; Paid Premium with Commission</label></td>				
					</tr>
					<tr style="height:20px;">
						<td><input type="checkbox" id="chkOsLoss" name="chkOsLoss" style="margin-left:30px; float:left;" />
							<label for="chkOsLoss" id="lblChkOsLoss" style="float:left;">&nbsp; Outstanding Loss</label></td>
					</tr>
					<tr style="height:20px;">
						<td><input type="checkbox" id="chkLossPaid" name="chkLossPaid" style="margin-left:30px; float:left;" />
							<label for="chkLossPaid" id="lblChkLossPaid" style="float:left;">&nbsp; Losses Paid</label></td>
					</tr>
				</table>
			</div> <!-- end: extractParamsDiv -->
			<div id="printParamsDiv" name="printParamsDiv" class="sectionDiv" style="width:48%; height:110px; margin: 0 0 2px 2px;" >
				<table align="center" style="margin:10px 0 20px 5px;">
					<tr style="height:20px;"><td style="text-align:left;"><font style="margin-left:15px"><b>Print Report/s:</b></font></td></tr>
					<tr style="height:20px;">
						<td><input type="checkbox" id="chkPremCommRep" name="chkPremCommRep" style="margin-left:30px; float:left;"/>
							<label for="chkPremCommRep" id="lblChkPremCommRep" style="float:left;">&nbsp; Paid Premium with Commission</label></td>
					</tr>
					<tr style="height:20px;">
						<td><input type="checkbox" id="chkOsLossRep" name="chkOsLossRep" style="margin-left:30px; float:left;" />
							<label for="chkOsLossRep" id="lblChkOsLossRep" style="float:left;">&nbsp; Outstanding Loss</label></td>
					</tr>
					<tr style="height:20px;">
						<td><input type="checkbox" id="chkLossPaidRep" name="chkLossPaidRep" style="margin-left:30px; float:left;" />
							<label for="chkLossPaidRep" id="lblChkLossPaidRep" style="float:left;">&nbsp; Losses Paid</label></td>
					</tr>			
				</table>
			</div> <!-- end: printParamsDiv -->
				
			<div id="printDiv"class="sectionDiv" style="width:96.7%; height:150px; margin:0 10px 10px 10px;">
				<div style="float:left; margin-left:24%;" id="printDialogFormDiv">
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
			</div> <!-- end: printDiv -->
			
			<div id="printBtnDiv" name="printButtonDiv" class="buttonsDiv" style="margin: 0 0 10px 0;">
				<input type="button" class="button" id="btnExtract" name="btnExtract" value="Extract" style="width:90px;" />
				<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width:90px;" />
			</div>
		</div> <!-- end: paramsDiv -->
	</div> <!-- end: moduleDiv -->

</div>

<script>
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
	
	function initializeDefaultValues(){
		disableButton("btnExtract");
		disableButton("btnPrint");
		$("txtIntmNo").value = "";
		$("txtIntmName").value = "ALL INTERMEDIARIES";
	}
	
	function validateReportId(reportId, reportTitle){
		try {
			new Ajax.Request(contextPath+"/GIACGeneralDisbursementReportsController",{
				parameters: {
					action:		"validateReportId",
					reportId:	reportId
				},
				ashynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if (response.responseText == "Y"){
							printReport(reportId, reportTitle);
						}else{
							$("chkPremComm").checked = false;
							$("chkOsLoss").checked = false;
							$("chkLossPaid").checked = false;
							showMessageBox("No existing records found in GIIS_REPORTS.", "E");
						}
					}
				}
			});
		} catch(e){
			showErrorMessage("validateReportId",e);
		}
	}
	
	//function printReport(reportId, reportTitle){
	function printReport(reports){
		try {
			if(checkAllRequiredFieldsInDiv("printDiv")){
				var fileType = "";
				
				if($("rdoPdf").disabled == false && $("rdoExcel").disabled == false){
					fileType = $("rdoPdf").checked ? "PDF" : "XLS"; 
				}
				
				if(reports.length > 0){
					var reportsToPrint = [];
					for(var i=0; i<reports.length; i++){
						var reportId = reports[i].reportId;
						var reportTitle = reports[i].reportTitle;
						var content = contextPath+"/GeneralDisbursementPrintController?action=printGiacs512Reports"
									+ "&noOfCopies=" + $F("txtNoOfCopies")
									+ "&printerName=" + $F("selPrinter")
									+ "&destination=" + $F("selDestination")
									+ "&reportId=" + reportId
									+ "&reportTitle=" + reportTitle
									+ "&fileType=" + fileType
									+ "&moduleId=" + "GIACS512"							
									+ "&year=" + $F("txtYear")
									+ "&intmNo=" + $F("txtIntmNo");
						reportsToPrint.push({reportUrl : content, reportTitle : reportTitle});
						printGenericReport2(content, reportTitle); 
						
						if (i == reports.length-1){
							if ("screen" == $F("selDestination")){
								showMultiPdfReport(reportsToPrint); 
							}
						}  
					}
				}
			}
		} catch(e){
			showErrorMessage("printReport", e);
		}
	}
	
	function getIntmLOV(){
		var searchString = ($("txtIntmNo").readAttribute("lastValidValue").trim() != $F("txtIntmNo").trim() ? $F("txtIntmNo").trim() : ""); 
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action : "getGIACS512IntmNoLOV",
				searchString : searchString, //+"%",
				moduleId: 'GIACS512',
				page : 1
			},
			title : "Valid Values For Intermediary",
			width : 480,
			height : 386,
			columnModel : [ {
				id : "intmNo",
				title : "Intm No",
				width : '120px',
			}, {
				id : "intmName",
				title : "Intermediary Name",
				width : '345px'
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			filterText: escapeHTML2(searchString),
			onSelect : function(row) {
				if(row != null || row != undefined){
					$("txtIntmNo").value = row.intmNo;
					$("txtIntmName").value = unescapeHTML2(row.intmName);
					$("txtIntmNo").setAttribute("lastValidValue", row.intmNo);	
				}			
			},
			onCancel: function (){
				$("txtIntmNo").value = $("txtIntmNo").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtIntmNo").value = $("txtIntmNo").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});
	}
	
	function getCutOffDate(){
		try {
			new Ajax.Request(contextPath+"/GIACGeneralDisbursementReportsController", {
				parameters: {
					action:	"getGiacs512CutOffDate",
					year: $F("txtYear")
				},
				ashynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						$("txtCutOffDate").value = response.responseText;
						$("txtCutOffDate").focus();
					}
				}
			});
		} catch(e){
			showErrorMessage("getCutOffDate", e);
		}
	}
	
	function validateBeforeExtract(alertId){
		var extract1_alert = "You have already extracted paid premium records using the same transaction year. Extract again? (Doing so will erase your previous extract data and replace it with a new one)";
		var extract2_alert = "You have already extracted outstanding loss records using the same transaction year. Extract again? (Doing so will erase your previous extract data and replace it with a new one)";
		var extract3_alert = "You have already extracted losses paid records using the same transaction year. Extract again? (Doing so will erase your previous extract data and replace it with a new one)";
		var displayMessage = alertId == "chkPremComm" ? extract1_alert : (alertId == "chkOsLoss" ? extract2_alert : extract3_alert);
		var title = alertId == "chkLossPaid" ? "Warning" : "Information";
		var fieldId = alertId; //== "1" ? "chkPremComm" : (alertId == "2" ? "chkOsLoss" : "chkLossPaid");
		
		try {
			new Ajax.Request(contextPath+"/GIACGeneralDisbursementReportsController", {
				parameters: {
					action:	"validateGiacs512BeforeExtract",
					year: $F("txtYear"),
					intmNo: $F("txtIntmNo"),
					type: alertId
				},
				ashynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if(response.responseText == "Y"){
							showConfirmBox(title, displayMessage, "Yes", "No", 
											function(){
												enableButton("btnExtract");
												enableButton("btnPrint");
												$("btnExtract").focus();
											}, // onOkFunc 
											function(){
												$(fieldId).checked = false;
												disableButton("btnExtract");
												disableButton("btnPrint");
											}, // onCancelFunc
											2);
						} else {
							enableButton("btnExtract");
							enableButton("btnPrint");
						}
					}
				}
			});
		} catch(e){
			showErrorMessage("validateBeforeExtract", e);
		}
	}
	
	function validateBeforePrint(fieldId){
		try {
			new Ajax.Request(contextPath+"/GIACGeneralDisbursementReportsController", {
				parameters: {
					action:	"validateGiacs512BeforePrint",
					type: fieldId,
					year: $F("txtYear")
				},
				ashynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if(response.responseText == "Y"){
							enableButton("btnPrint");
						} else {
							$(fieldId).checked = false;
							disableButton("btnPrint");
							showMessageBox("Please extract first before printing the report.", "I");
						}
					}
				}
			});
		} catch(e){
			showErrorMessage("validateBeforePrint", e);
		}
	}
	
	function validatePrintChks(fieldId){
		if($F("txtYear") == ""){
			$(fieldId).checked = false;
			customShowMessageBox("Please specify the year of extraction.", "I", "txtYear");
		}
		if($("chkPremCommRep").checked || $("chkOsLossRep").checked || $("chkLossPaidRep").checked){
			enableButton("btnPrint");
			validateBeforePrint(fieldId);
		} else {
			disableButton("btnPrint");			
		}
	}
	
	function validateExtractChks(fieldId){
		if($("chkOsLoss").checked || $("chkLossPaid").checked || $("chkPremComm").checked){
			enableButton("btnExtract");
			enableButton("btnPrint");
			
			if($(fieldId).checked){
				validateBeforeExtract(fieldId);
			}
		} else {
			disableButton("btnExtract");
			disableButton("btnPrint");
		}
	}
	
	function extractCPC(action1, action2, action3){
		try {
			var message = action1 == "cpcExtractPremComm" ? "Extracting claim records based on Paid Premium with Commission" : 
				(action1 == "cpcExtractOsDtl" ? "Extracting claim records based on Outstanding Loss" : "Extracting claim records based on Losses Paid");
			
			new Ajax.Request(contextPath+"/GIACGeneralDisbursementReportsController", {
				parameters: {
					action		: action1,
					year		: $F("txtYear"),
					cutOffDate	: $F("txtCutOffDate"),
					intmNo		: $F("txtIntmNo")/*,
					chkPremComm	: ($("chkPremComm").checked ? "Y" : "N"),
					chkOsLoss	: ($("chkOsLoss").checked ? "Y" : "N"),
					chkLossPaid	: ($("chkLossPaid").checked ? "Y" : "N")*/
				},
				ashynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice(message+", please wait...");
				},
				onComplete: function(response){
					hideNotice();
					var resp = JSON.parse(response.responseText);
					if(checkErrorOnResponse(response)){
						var message = "";
						if(parseInt(resp.recordCount) > 0){
							message = "Extraction finished. " + resp.recordCount +" records extracted.";
						} else {
							message = "Extraction finished. No records extracted.";
						}
						
						if(action2 != null && action2 != ""){
							action1 = action2;
							action2 = action3;
							action3 = "";
							showWaitingMessageBox(message, "I", function(){ proceedToNextAction(action1, action2, action3); });
						} else {							
							showMessageBox(message, "I");
						}
					}
				}
			});
		} catch(e){
			showErrorMessage("extractCPC", e);
		}
	}
	
	function proceedToNextAction(action1, action2, action3){
		var message = action1 == "cpcExtractPremComm" ? "Extracting claim records based on Paid Premium with Commission." : 
			(action1 == "cpcExtractOsDtl" ? "Extracting claim records based on Outstanding Loss." : "Extracting claim records based on Losses Paid.");

		showWaitingMessageBox(message, "I", function(){ extractCPC(action1, action2, action3); });
	}
	
	observeReloadForm("reloadForm", showContingentProfitCommission);	
		
	$("txtYear").observe("change", function(){
		if($F("txtYear").length < 4 ){
			$("txtYear").value = "2" + lpad($F("txtYear"),3,'0');
		}
		$("txtCutOffDate").clear();
		$("chkPremComm").checked = false;
		$("chkOsLoss").checked = false;
		$("chkLossPaid").checked = false;
	});
	
	$("hrefCutOffDate").observe("click", function(){
		scwShow($('txtCutOffDate'),this, null);
	});
	
	$("osIntmNo").observe("click", getIntmLOV);
	
	$("txtIntmNo").observe("change", function() {		
		if($F("txtIntmNo").trim() == "") {
			$("txtIntmNo").value = "";
			$("txtIntmNo").setAttribute("lastValidValue", "");
			$("txtIntmName").value = "ALL INTERMEDIARIES";
		} else {
			if($F("txtIntmNo").trim() != "" && $F("txtIntmNo") != $("txtIntmNo").readAttribute("lastValidValue")) {
				getIntmLOV();
			}
		}
	});
	
	$("chkPremComm").observe("click", function(){
		if($F("txtYear") == ""){
			$("chkPremComm").checked = false;
			showWaitingMessageBox("Please specify the year of extraction.", "I", function(){$("txtYear").focus();});
		}
		if($F("txtCutOffDate") == ""){
			$("chkPremComm").checked = false;
			showWaitingMessageBox("Please specify the cut-off date of extraction.", "I", getCutOffDate);
		}
		validateExtractChks("chkPremComm");
	});
	
	$("chkOsLoss").observe("click", function(){
		if($F("txtYear") == ""){
			$("chkOsLoss").checked = false;
			showWaitingMessageBox("Please specify the year of extraction.", "I", function(){$("txtYear").focus();});
		}
		validateExtractChks("chkOsLoss");
	});
	
	$("chkLossPaid").observe("click", function(){
		if($F("txtYear") == ""){
			$("chkLossPaid").checked = false;
			showWaitingMessageBox("Please specify the year of extraction.", "I", function(){$("txtYear").focus();});
		}
		validateExtractChks("chkLossPaid");
	});
	
	$("chkPremCommRep").observe("click", function(){
		validatePrintChks("chkPremCommRep");
	});
	$("chkOsLossRep").observe("click", function(){
		validatePrintChks("chkOsLossRep");
	});
	$("chkLossPaidRep").observe("click", function(){
		validatePrintChks("chkLossPaidRep");
	});
	
	$("btnExtract").observe("click", function(){
		if($("chkPremComm").checked && !$("chkOsLoss").checked && !$("chkLossPaid").checked){
			showWaitingMessageBox("Extracting claim records based on Paid Premium with Commission.", "I", function(){ extractCPC("cpcExtractPremComm", "", ""); });					
		} else if(!$("chkPremComm").checked && $("chkOsLoss").checked && !$("chkLossPaid").checked){			
			showWaitingMessageBox("Extracting claim records based on Outstanding Loss.", "I", function(){ extractCPC("cpcExtractOsDtl", "", ""); });						
		} else if(!$("chkPremComm").checked && !$("chkOsLoss").checked && $("chkLossPaid").checked){			
			showWaitingMessageBox("Extracting claim records based on Losses Paid.", "I", function(){ extractCPC("cpcExtractLossPaid", "", ""); }); 			
		} else if($("chkPremComm").checked && $("chkOsLoss").checked && !$("chkLossPaid").checked){			
			showWaitingMessageBox("Extracting claim records based on Paid Premium with Commission.", "I", function(){ extractCPC("cpcExtractPremComm", "cpcExtractOsDtl", ""); });
		} else if($("chkPremComm").checked && !$("chkOsLoss").checked && $("chkLossPaid").checked){			
			showWaitingMessageBox("Extracting claim records based on Paid Premium with Commission.", "I", function(){ extractCPC("cpcExtractPremComm", "cpcExtractLossPaid", ""); });
		} else if(!$("chkPremComm").checked && $("chkOsLoss").checked && $("chkLossPaid").checked){			
			showWaitingMessageBox("Extracting claim records based on Outstanding Loss.", "I", function(){ extractCPC("cpcExtractOsDtl", "cpcExtractLossPaid", ""); });
		} else if($("chkPremComm").checked && $("chkOsLoss").checked && $("chkLossPaid").checked){			
			showWaitingMessageBox("Extracting claim records based on Paid Premium with Commission.", "I", function(){ extractCPC("cpcExtractPremComm", "cpcExtractOsDtl", "cpcExtractLossPaid"); });
		}
	});
	
	$("btnPrint").observe("click", function(){
		if(!$("chkPremCommRep").checked && !$("chkOsLossRep").checked && !$("chkLossPaidRep").checked){
			showMessageBox("Please choose the reports you want to print.", "I");
		}
		var reports = [];
		if($("chkPremCommRep").checked){
			reports.push({reportId: "GIACR512" , reportTitle : "Paid Premium"});
		}
		if($("chkOsLossRep").checked){
			reports.push({reportId: "GIACR512A" , reportTitle : "Outstanding Loss"});
		}
		if($("chkLossPaidRep").checked){
			reports.push({reportId: "GIACR512B" , reportTitle : "Losses Paid"});
		}
		printReport(reports);
		/*if($("chkPremCommRep").checked && !$("chkOsLossRep").checked && !$("chkLossPaidRep").checked){
			validateReportId("GIACR512","Paid Premium");					
		} else if(!$("chkPremCommRep").checked && $("chkOsLossRep").checked && !$("chkLossPaidRep").checked){			
			validateReportId("GIACR512A","Outstanding Loss");						
		} else if(!$("chkPremCommRep").checked && !$("chkOsLossRep").checked && $("chkLossPaidRep").checked){			
			validateReportId("GIACR512B","Losses Paid"); 			
		} else if($("chkPremCommRep").checked && $("chkOsLossRep").checked && !$("chkLossPaidRep").checked){			
			validateReportId("GIACR512","Paid Premium");
			validateReportId("GIACR512A","Outstanding Loss");
		} else if($("chkPremCommRep").checked && !$("chkOsLossRep").checked && $("chkLossPaidRep").checked){			
			validateReportId("GIACR512","Paid Premium");
			validateReportId("GIACR512B","Losses Paid"); 
		} else if(!$("chkPremCommRep").checked && $("chkOsLossRep").checked && $("chkLossPaidRep").checked){			
			validateReportId("GIACR512A","Outstanding Loss");
			validateReportId("GIACR512B","Losses Paid"); 
		} else if($("chkPremCommRep").checked && $("chkOsLossRep").checked && $("chkLossPaidRep").checked){			
			validateReportId("GIACR512","Paid Premium");
			validateReportId("GIACR512A","Outstanding Loss");
			validateReportId("GIACR512B","Losses Paid");
		}		*/
	});
	
	// PRINT
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
	
	$("selDestination").observe("change", function(){
		var dest = $F("selDestination");
		toggleRequiredFields(dest);
	});
	
	$("txtNoOfCopies").observe("change", function(){
		if(parseInt($F("txtNoOfCopies")) > 100 || parseInt(nvl($F("txtNoOfCopies"), "0")) == 0 ){
			customShowMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", "txtNoOfCopies");
			$("txtNoOfCopies").value = "";
		}
	});
	
	setModuleId("GIACS512");
	setDocumentTitle("Contingent Profit Commission");
	initializeAll();
	makeInputFieldUpperCase();
	toggleRequiredFields("screen");
	initializeDefaultValues();
	
</script>