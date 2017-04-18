<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<div id="disbListMainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothMenu1" name="smoothMenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="disbListExit">Exit</a></li>
			</ul>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv" >
		<div id="innerDiv" name="innerDiv">
			<label>Disbursement List</label>
		</div>
	</div>
	
	<div id="disbListDiv" class="sectionDiv" style="width: 920px; height: 500px;">
		<div class="sectionDiv" style="width: 600px; height: 400px; margin: 40px 20px 20px 150px;">
			<div id="truncDateDiv" class="sectionDiv" style="width: 570px; height: 60px; margin: 10px 10px 0 13px;">
				<table style="margin: 20px 10px 0 103px;">
					<tr>
						<td>
							<input id="chkPosting" type="checkbox" value="P" style="float: left;">
							<label for="chkPosting" style="margin: 0 150px 0 7px;">Posting Date</label>
						</td>
						<td>
							<input id="chkTran" type="checkbox" value="T" checked="checked" style="float: left;">
							<label for="chkTran" style="margin-left: 7px;">Transaction Date</label>
						</td>
					</tr>
				</table>
			</div>
			
			<div id="fieldsDiv" class="sectionDiv" style="width: 570px; height: 130px; margin: 2px 0 0 13px;">
				<input id="hidFundCd" type="hidden" value="${fundCd}" />
				<table style="margin: 18px 10px 0 33px;">
					<tr>
						<td class="rightAligned">From</td>
						<td>
							<div style="float: left; width: 160px;" class="withIconDiv required">
								<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon required" readonly="readonly" style="width: 135px;"/>
								<img id="imgFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date" />
							</div>
						</td>
						<td class="rightAligned" width="68px" style="padding-left: 48px;">To</td>
						<td>
							<div style="float: left; width: 160px;" class="withIconDiv required">
								<input type="text" id="txtToDate" name="txtToDate" class="withIcon required" readonly="readonly" style="width: 135px;"/>
								<img id="imgToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"/>
							</div>
						</td>
					</tr>
						<td class="rightAligned">Branch</td>
						<td colspan="5">							
							<span class="lovSpan" style="width:87px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input type="text" id="txtBranchCd" name="txtBranchCd" maxlength="2" style="width: 56px; float: left; margin-right: 4px; border: none; height: 13px;"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchCdLOV" name="searchBranchCdLOV" alt="Go" style="float: right;"/>
							</span>
							<input id="txtBranchName" type="text" readonly="readonly" style="width: 350px;">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Request</td>
						<td colspan="5">							
							<span class="lovSpan" style="width:87px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input type="text" id="txtDocCd" name="txtDocCd" maxlength="5" style="width: 56px; float: left; margin-right: 4px; border: none; height: 13px;"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchDocCdLOV" name="searchDocCdLOV" alt="Go" style="float: right;"/>
							</span>
							<input id="txtDocName" type="text" readonly="readonly" style="width: 350px;">
						</td>
					</tr>
				</table>
			</div>
			
			<div id="printDialogFormDiv" class="sectionDiv" style="width: 570px; height: 120px; margin: 2px 0 0 13px; padding: 10px 0 10px 0;" align="center">
				<table style="float: left; padding: 7px 0 0 1px; width: 310px; margin-left: 110px;">
					<tr>
						<td class="rightAligned">Destination</td>
						<td class="leftAligned">
							<select id="selDestination" style="width: 200px;" tabindex="108">
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
							<input value="PDF" title="PDF" type="radio" id="pdfRB" name="fileRG" style="margin: 2px 5px 4px 40px; float: left;" checked="checked" disabled="disabled" tabindex="109"><label for="pdfRB" style="margin: 2px 0 4px 0">PDF</label>
							<!-- <input value="EXCEL" title="Excel" type="radio" id="excelRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="110"><label for="excelRB" style="margin: 2px 0 4px 0">Excel</label> Dren Niebres 05.04.2016 SR-5225-->
						    <input value="CSV2" title="CSV" type="radio" id="csvRB" name="fileRG" style="margin: 2px 5px 4px 40px; float: left;" disabled="disabled" tabindex="109"><label for="pdfRB" style="margin: 2px 0 4px 0">CSV</label> <!-- Dren Niebres 05.04.2016 SR-5225 -->
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Printer</td>
						<td class="leftAligned">
							<select id="selPrinter" style="width: 200px;" class="required" tabindex="111">
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
							<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma" maxlength="3" tabindex="112">
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
			
			<div id="buttonsDiv" class="buttonsDiv">
				<input id="btnPrint" type="button" class="button" value="Print" style="width: 80px;" tabindex="114">
			</div>
			
		</div>
		
	</div>	
	
</div>

<script type="text/javascript">
try{
	setModuleId("GIACS273");
	setDocumentTitle("Disbursement List");
	initializeAll();
	
	var truncDate = "T";
	
	$("txtBranchName").value = "ALL BRANCHES";
	$("txtDocName").value = "ALL PAYMENT REQUESTS";
	
	
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
			//$("excelRB").disabled = true; //Dren Niebres 05.04.2016 SR-5225
			$("csvlRB").disabled = true; //Dren Niebres 05.04.2016 SR-5225
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
				//$("excelRB").disabled = false; //Dren Niebres 05.04.2016 SR-5225
				$("csvRB").disabled = false; //Dren Niebres 05.04.2016 SR-5225
			}else{
				$("pdfRB").disabled = true;
				//$("excelRB").disabled = true; //Dren Niebres 05.04.2016 SR-5225
				$("csvRB").disabled = true; //Dren Niebres 05.04.2016 SR-5225
			}		
		}
	}
	
	function showBranchLOV(isIconClicked){
		var searchString = isIconClicked ? "%" : ($F("txtBranchCd").trim() == "" ? "%" : $F("txtBranchCd"));
		LOV.show({
			controller:		'AccountingLOVController',
			urlParameters:	{
				action:		'getGIACS273BranchLOV',
				fundCd:		$F("hidFundCd"),
				searchString : searchString,
				moduleId:	"GIACS273"
			},
			title:	'Branch Code',
			width:	405,
			height: 386,
			draggable: true,
			autoSelectOneRecord: true,
			filterText: escapeHTML2(searchString),
			columnModel:[
				{
					id: 'branchCd',
					title: 'Branch Code',
					width: '80px'
				},
				{
					id: 'branchName',
					title: 'Branch Name',
					width: '380px'
				}
			],
			onSelect: function(row){
				if(row != undefined){
					$('txtBranchCd').setAttribute("lastValidValue", row.branchCd);
					$("txtBranchCd").value = row.branchCd;
					$("txtBranchName").value = row.branchName;
				}
			},onCancel: function(){
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
			new Ajax.Request(contextPath+"/GIACGenearalDisbReportController",{
				parameters: {
					action:		'validateGIACS273BranchCd',
					branchCd:	$F("txtBranchCd"),
					fundCd:		$F("hidFundCd"),
					moduleId:	"GIACS273"
				},
				asynchronous: true,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if (response.responseText != ""){
							$("txtBranchName").value = unescapeHTML2(response.responseText);
						}else{
							clearFocusElementOnError("txtBranchCd", "Invalid value for BRANCH_CD");
							$("txtBranchName").value = "ALL BRANCHES";
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("validateBranchCd", e);
		}
	}
	
	function showDocumentLOV(isIconClicked){
		var searchString = isIconClicked ? "%" : ($F("txtDocCd").trim() == "" ? "%" : $F("txtDocCd"));
		
		LOV.show({
			controller:		'AccountingLOVController',
			urlParameters: {
				action:		'getGIACS273DocLOV',
				branchCd:	$F("txtBranchCd"),
				searchString : searchString,
			},
			title: 'Document Code',
			width: 405,
			height: 386,
			draggable: true,
			autoSelectOneRecord: true,
			filterText: escapeHTML2(searchString),
			columnModel: [
				{
					id: 'documentCd',
					title: 'Document Cd',
					width: '80px'
				},
				{
					id: 'documentName',
					title: 'Document Name',
					width: '380px'
				}
			],
			onSelect: function(row){
				if (row != undefined){
					$("txtDocCd").setAttribute("lastValidValue", row.documentCd);
					$("txtDocCd").value = row.documentCd;
					$("txtDocName").value = row.documentName;
				}
			},
			onCancel: function(){
				$("txtDocCd").focus();
				$("txtDocCd").value = $("txtDocCd").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				$("txtDocCd").value = $("txtDocCd").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtDocCd");
			} 
		});
	}
	
	function validateDocumentCd(){
		try{
			new Ajax.Request(contextPath+"/GIACGenearalDisbReportController",{
				parameters: {
					action:		'validateGIACS273DocCd',
					branchCd:	$F("txtBranchCd"),
					documentCd:	$F("txtDocCd")
				},
				asynchronous: true,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if (response.responseText != ""){
							$("txtDocName").value = unescapeHTML2(response.responseText);
						}else{
							clearFocusElementOnError("txtDocCd", "Invalid value for DOCUMENT_CD");
							$("txtDocName").value = "ALL PAYMENT REQUESTS";
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("validateDocumentCd", e);
		}
	}
	
	function printReport(){
		try{			
			var reportId; //Dren Niebres 05.04.2016 SR-5225 - Start

			if($F("selDestination") == "file") { 
				if ($("pdfRB").checked) 
					reportId = "GIACR273";
				else 
					reportId = "GIACR273_CSV";		
			} else {
				reportId = "GIACR273";
			}				
			
			var content = contextPath + "/GeneralDisbursementPrintController?action=printGIACR273&reportId="+reportId+"&branchCd="
						  +$F("txtBranchCd")+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate")+"&docCd="+$F("txtDocCd")
						  +"&truncDate="+truncDate+"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")
						  +"&destination="+$F("selDestination");
			
			if($F("selDestination") == "screen"){
				showPdfReport(content, "Disbursement List");
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
				
				if ($("pdfRB").checked)
					fileType = "PDF";
				else
					fileType = "CSV2";				
				
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
								if (fileType == "CSV2"){ 
									copyFileToLocal(response, "csv"); 
								} else 
									copyFileToLocal(response); //Dren Niebres 05.04.2016 SR-5225 - End				
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
	
	$("chkPosting").observe("click", function(){
		if ($("chkPosting").checked){
			truncDate = "P";
			$("chkTran").checked = false;
		}else{
			truncDate = "T";
			$("chkTran").checked = true;
		}
	});
	
	$("chkTran").observe("click", function(){
		if($("chkTran").checked){
			truncDate = "T";
			$("chkPosting").checked = false;
		}else{
			truncDate = "P";
			$("chkPosting").checked = true;
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
	
	$("txtFromDate").observe("blur", function(){
		if ($F("txtFromDate") != "" && $F("txtToDate") == ""){
			$("txtToDate").value = dateFormat(Date.parse($F("txtFromDate")).moveToLastDayOfMonth(), 'mm-dd-yyyy');
		}
	});
	
	/*$("txtToDate").observe("blur", function(){
		fireEvent($("txtFromDate"), "blur");
	});*/
	
	$("searchBranchCdLOV").observe("click", function(){
		showBranchLOV(true);
	});
	
	$("txtBranchCd").observe("keyup", function(){
		$("txtBranchCd").value = $("txtBranchCd").value.toUpperCase();
	});
	
	$("txtBranchCd").observe("change", function(){
		if($F("txtBranchCd") != ""){
			showBranchLOV(false); //validateBranchCd();
		}else{
			$("txtBranchCd").setAttribute("lastValidValue", "");
			$("txtBranchName").value = "ALL BRANCHES";
		}
	});
	
	$("searchDocCdLOV").observe("click", function(){
		showDocumentLOV(true);
	});
	
	$("txtDocCd").observe("keyup", function(){
		$("txtDocCd").value = $("txtDocCd").value.toUpperCase();
	});
	
	$("txtDocCd").observe("change", function(){
		if ($F("txtDocCd") != ""){
			showDocumentLOV(false);//validateDocumentCd();
		}else{
			$("txtDocCd").setAttribute("lastValidValue", "");
			$("txtDocName").value = "ALL PAYMENT REQUESTS";
		}
	});
	
	$("btnPrint").observe("click", function(){
		if($("chkPosting").checked == false && $("chkTran").checked == false){
			showMessageBox("Please choose if the report will be based on Posting date or Tran Date", "E");
		}/*else if($F("txtFromDate") == "" && $F("txtToDate") == ""){
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
		}*/else if (checkAllRequiredFieldsInDiv('fieldsDiv') && checkAllRequiredFieldsInDiv('printDialogFormDiv')){
			printReport();
		}
	});
	
	$("disbListExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});
	
}catch(e){
	showMessageBox("Page Error: ",e);
}
</script>
