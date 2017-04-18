<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>



<div id="cashReceiptRegisterMainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothMenu1" name="smoothMenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="cashReceiptRegisterExit">Exit</a></li>
			</ul>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Cash Receipt Register</label>
		</div>
	</div>
	
	<div id="cashReceiptRegisterFieldsDiv" class="sectionDiv" style="width: 920px; height: 450px;">
		<div class="sectionDiv" id="dateDiv" align="center" style="width: 480px; height: 20px; margin: 40px 0 0 210px; padding: 10px 30px 10px 30px;">
			<table style="height: 20px">
				<tr>
					<td>
						<div>
							<label for="chkPostDate">Posting Date</label>
							<input id="chkPostDate" type="checkbox" style="margin-left: 20px;" value="0">
						</div>
					</td>
					<td>
						<div>
							<label style="margin-left: 90px;" for="chkTranDate">Transaction Date</label>
							<input id="chkTranDate" type="checkbox" checked="checked" style="margin-left: 20px;" value="1">
						</div>
					</td>
				</tr>
			</table>
		</div>
		
		<div id="fieldDiv" class="sectionDiv" style="width: 480px; height: 70px; margin: 10px 0 10px 210px; padding: 19px 17px 17px 45px;">
			<table style="height: 30px;">
				<tr>
					<td class="rightAligned" style="padding: 0 10px 0 10px;">From</td>
					<td>
						<div id="fromDateDiv" class="required" style="float: left; border: 1px solid gray; width: 150px; height: 20px;">
							<input id="txtFromDate" name="txtFromDate" readonly="readonly" type="text" class="required"  maxlength="10" style="border: none; float: left; width: 125px; height: 13px; margin: 0px;" value="" tabindex="101"/>
							<img id="imgFromDate" alt="imgFromDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"  />
						</div>
					</td>
					<td class="rightAligned" style="padding: 0 10px 0 30px;">To</td>
					<td>
						<div id="toDateDiv" class="required" style="float: left; border: 1px solid gray; width: 150px; height: 20px;">
							<input id="txtToDate" name="txtToDate" readonly="readonly" type="text" class="required"  maxlength="10" style="border: none; float: left; width: 125px; height: 13px; margin: 0px;" value="" tabindex="102"/>
							<img id="imgToDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"  />
						</div>
					</td>
				</tr>
			</table>
			<table style="height: 30px;">
				<tr>
					<td class="rightAligned" style="padding-right: 8px;">Branch</td>
					<td style="padding-top: 0px;">
						<div style="height: 20px;">
							<div id="branchDiv" style="border: 1px solid gray; width: 90px; height: 20px; margin:0 5px 0 0;">
								<input id="txtBranchCd" name="txtBranchCd" type="text" maxlength="2" class="upper" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="" tabindex="103" lastValidValue="">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchCdLOV" name="searchBranchCdLOV" alt="Go" style="float: right;"/>
							</div>
							
						</div>						
					</td>	
					<td>
						<input id="txtBranchName" type="text" readonly="readonly" style="width: 255px;">
					</td>
				</tr>
			</table>
		</div>
		
		<div class="sectionDiv" style="width: 160px; height: 120px; margin: 0 0 10px 210px; padding: 15px;">
			<table>
				<tr>
					<td>
						<input id="detailRB" name="reportRG" type="radio" value="D" checked="checked" style="float: left; margin-right: 10px;"><label for="detailRB" style="margin: 2px 5px 8px 0;">Detail</label>
					</td>
				</tr>
				<tr>
					<td>
						<input id="summaryRB" name="reportRG" type="radio" value="S" style="float: left; margin-right: 10px;"><label for="summaryRB" style="margin: 2px 5px 4px 0;">Summary</label>
					</td>
				</tr>
				<tr>
					<td>
						<div style="margin: 20px 0 40px 0;">
							<input id="chkTranClass" type="checkbox" checked="checked" value="1" style="margin-right: 7px; float: left;">
							<label for="chkTranClass">Include DCB</label>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<div>
							<input id="chkPerBranch" type="checkbox" checked="checked" value="1" style="margin-right: 7px; float: left;">
							<label for="chkPerBranch">Acctg Entry per Branch</label>
						</div>
					</td>
				</tr>
			</table>
		</div>
		
		<div id="printDialogFormDiv" class="sectionDiv" style="width: 310px; height: 120px; margin-left: 10px; padding: 15px 22px 15px 8px;" align="center">
			<table style="float: left; padding: 7px 0 0 15px;">
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
						<input value="PDF" title="PDF" type="radio" id="pdfRB" name="fileRG" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled"><label for="pdfRB" style="margin: 2px 0 4px 0">PDF</label>
						<input value="EXCEL" title="Excel" type="radio" id="excelRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="excelRB" style="margin: 2px 0 4px 0">Excel</label>
						<input value="CSV" title="CSV" type="radio" id="csvRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="csvRB" style="margin: 2px 0 4px 0">CSV</label>
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
						<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma" maxlength="3">
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
		
		<div class="buttonsDiv" >
			<input id="btnPrint" type="button" class="button" value="Print" style="width: 80px; ">
		</div>
		
	</div>
</div>



<script type="text/javascript">
try{
	setModuleId("GIACS117");
	setDocumentTitle("Cash Receipt Register");
	initializeAll();
	$("txtBranchName").value = "ALL BRANCHES";
	$("chkTranClass").value = 1;
	
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
			$("pdfRB").disabled = true;
			$("excelRB").disabled = true;
			$("csvRB").disabled = true;
		} else {
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
			if(dest == "file"){
				$("pdfRB").disabled = false;
				$("excelRB").disabled = false;
				$("csvRB").disabled = false;
			}else{
				$("pdfRB").disabled = true;
				$("excelRB").disabled = true;
				$("csvRB").disabled = true;
			}		
		}
	}
	
	function showBranchLOV(isIconClicked){
		var searchString = isIconClicked ? "%" : ($F("txtBranchCd").trim() == "" ? "%" : $F("txtBranchCd"));	
		
		LOV.show({
			controller: 'AccountingLOVController',
			urlParameters: {
				action:		"getGIACS117BranchLOV",
				branchCd:	$F("txtBranchCd"),
				searchString: searchString
			},
			title: "List of Branches",
			width: 405,
			height: 386,
			draggable: true,
			filterText: escapeHTML2(searchString),
			autoSelectOneRecord: true,
			columnModel: [
				{
					id: "branchCd",
					title: "Branch Code",
					width: "80px"
				},
				{
					id: "branchName",
					title: "Branch Name",
					width: "308px"
				}
			],
			onSelect: function(row){
				if(row != undefined){
					$("txtBranchCd").value = row.branchCd;
					$("txtBranchName").value = row.branchName;
					$("txtBranchCd").setAttribute("lastValidValue", row.branchCd);
				}
			},
			onCancel: function(){
				$("txtBranchCd").focus();
				$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchCd");
			} 
		});
	}
	
	function validateBranchCd(){
		try{
			new Ajax.Request(contextPath+"/GIACCashReceiptsReportController",{
				method: "POST",
				parameters: {
					action: 	"validateGiacs117BranchCd",
					branchCd: 	$F("txtBranchCd"),
					moduleId:	"GIACS117"
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if (response.responseText != ""){
							$("txtBranchName").value = unescapeHTML2(response.responseText);
						}else {
							showMessageBox("Invalid value for BRANCH_CD", "E");
							$("txtBranchCd").value = "";
							$("txtBranchName").value = "ALL BRANCHES";
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("validateBranchCd", e);
		}
	}
	
	function printReport(){
		try{
			var reportId = "";
			var reportTitle = "";
			var postTranToggle = "";
			var tranClass = "";
			var perBranch = "";
			
			if($("detailRB").checked){
				reportId = "GIACR117";
				reportTitle = "Cash Receipt Register";
			}else if($("summaryRB").checked){
				reportId = "GIACR117B";
				reportTitle = "Cash Receipt (Summary)";
			}
			
			if ($F("chkPostDate") == 2){
				postTranToggle = "P";
			}
			
			if($F("chkTranDate") == 1){
				postTranToggle = "T";
			}
			
			if($F("chkTranClass") == 1){
				tranClass = "Y";
			}else{
				tranClass = "N";
			}
			
			if($F("chkPerBranch") == 1){
				perBranch = "Y";
			}else{
				perBranch = "N";
			}
			
			var content = contextPath+"/CashReceiptsReportPrintController?action=printReport&reportId="+reportId
						  +"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate")+"&postTranToggle="+postTranToggle+"&perBranch="
						  +perBranch+"&tranClass="+tranClass+"&branchCd="+$F("txtBranchCd")+"&noOfCopies="+$F("txtNoOfCopies")
						  +"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination");
			
			if($F("selDestination") == "screen"){
				showPdfReport(content, reportTitle);
			} else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					method: "POST",
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing complete.", "I");
						}
					}
				});
			}else if("file" == $F("selDestination")){
				var fileType = "PDF";
				if($("pdfRB").checked){
					fileType = "PDF";
				}else if ($("excelRB").checked){
					fileType = "XLS";
				}else if ($("csvRB").checked){
					fileType = "CSV";
				}	
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
								/*var message = $("fileUtil").copyFileToLocal(response.responseText);
								if(message != "SUCCESS"){
									showMessageBox(message, imgMessage.ERROR);
								}*/
// 								copyFileToLocal(response);
								if($("geniisysAppletUtil") == null || $("geniisysAppletUtil").copyFileToLocal == undefined){
									showMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", imgMessage.ERROR);
								} else {
									var message = "";
									if ($("csvRB").checked){
										message = $("geniisysAppletUtil").copyFileToLocal(response.responseText, "csv");
										deleteCSVFileFromServer(response.responseText);
									}else{
										message = $("geniisysAppletUtil").copyFileToLocal(response.responseText, "reports");
									}
									if(message.include("SUCCESS")){
										showMessageBox("Report file generated to " + message.substring(9), "I");	
									} else {
										showMessageBox(message, "E");
									}
								}
							}
							
						}
					});
			} else if("local" == $F("selDestination")){
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "LOCAL"},
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							printToLocalPrinter(response.responseText);
						}
					}
				});
			}	
		}catch(e){
			showErrorMessage("printReport", e);
		}
	}
	
	toggleRequiredFields("screen");
	
	$("imgSpinUp").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if (no < 100){
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
		if($F("txtNoOfCopies") != ""){
			if(isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0 || $F("txtNoOfCopies") > 100){
				showWaitingMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", function(){
					$("txtNoOfCopies").value = "1";
				});			
			}
		}
	});
	
	$("chkPostDate").observe("click", function(){
		if ($("chkPostDate").checked){
			$("chkPostDate").value = 2;
			$("chkTranDate").value = 0;
			$("chkTranDate").checked = false;
		}else{
			$("chkPostDate").value = 0;
			$("chkTranDate").value = 1;
			$("chkTranDate").checked = true;
		}
	});
	
	$("chkTranDate").observe("click", function(){
		if($("chkTranDate").checked){
			$("chkTranDate").value = 1;
			$("chkPostDate").value = 0;
			$("chkPostDate").checked = false;
		}else{
			$("chkTranDate").value = 0;
			$("chkPostDate").value = 2;
			$("chkPostDate").checked = true;
		}
	});
	
	$("chkTranClass").observe("click", function(){
		if($("chkTranClass").checked){
			$("chkTranClass").value = 1;
		}else{
			$("chkTranClass").value = 2;
		}
		
		if($F("chkPostDate") == 2){
			$("chkTranDate").value = 0;
		}else{
			$("chkTranDate").value = 1;
		}
	});
	
	$("chkPerBranch").observe("click", function(){
		if($("chkPerBranch").checked){
			$("chkPerBranch").value = 1;
		}else{
			$("chkPerBranch").value = 2;			
		}
	});
	
	$("txtFromDate").observe("blur", function(){
		if ($F("txtFromDate") != "" && $F("txtToDate") == ""){
			$("txtToDate").value = dateFormat(Date.parse($F("txtFromDate")).moveToLastDayOfMonth(), 'mm-dd-yyyy');
		}
	});
	
	$("txtToDate").observe("blur", function(){
		if ($F("txtFromDate") != "" && $F("txtToDate") == ""){
			$("txtToDate").value = dateFormat(Date.parse($F("txtFromDate")).moveToLastDayOfMonth(), 'mm-dd-yyyy');
		}
	});
	
	
	$("imgFromDate").observe("click", function(){
		scwNextAction = function(){
							checkInputDates("txtFromDate", "txtFromDate", "txtToDate");
						}.runsAfterSCW(this, null);
						
		scwShow($("txtFromDate"),this, null);
	});
	
	$("imgToDate").observe("click", function(){
		scwNextAction = function(){
							checkInputDates("txtToDate", "txtFromDate", "txtToDate");
						}.runsAfterSCW(this, null);
						
		scwShow($("txtToDate"),this, null);
	});
	
	$("txtBranchCd").observe("keyup", function(){
		$("txtBranchCd").value = $("txtBranchCd").value.toUpperCase();
	});
	
	$("txtBranchCd").observe("change", function(){
		if ($F("txtBranchCd") != ""){
			showBranchLOV(false);
		}else{
			$("txtBranchName").value = "ALL BRANCHES";
		}
	});
	
	$("searchBranchCdLOV").observe("click", function(){
		showBranchLOV(true);
	});
	
	$("btnPrint").observe("click", function(){
		/*if($F("txtFromDate") == "" && $F("txtToDate") == ""){
			showMessageBox("Please enter From Date and To Date.", "E");
		}else if($F("txtFromDate") == "" && $F("txtToDate") != ""){
			showMessageBox("Please enter From Date.", "E");
		}else if($F("txtFromDate") != "" && $F("txtToDate") == ""){
			showMessageBox("Please enter To Date.", "E");
		}else if(compareDatesIgnoreTime(Date.parse($("txtFromDate").value),Date.parse($("txtToDate").value)) == -1){
			showMessageBox("From Date should be earlier than To Date.", "E");
		}else if($F("selDestination") == "printer" && ($("selPrinter").value == "" || $("txtNoOfCopies").value == "")){
			showMessageBox("Printer Name and No. of Copies are required.", "I");
		}else if($F("selDestination") == "printer" && (isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0)){
			showMessageBox("Invalid number of copies.", "I");
		}else{
			printReport();
		}*/
		if (checkAllRequiredFieldsInDiv('fieldDiv') && checkAllRequiredFieldsInDiv('printDialogFormDiv')){
			printReport();
		}
	});
	
	$("cashReceiptRegisterExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});
	
	$("txtFromDate").focus();
}catch(e){
	showErrorMessage("Page Error:", e);
}	
</script>
