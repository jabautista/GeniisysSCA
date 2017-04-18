<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>


<div id="collectionAnalysisMainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothMenu1" name="smoothMenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="collectionAnalysisExit">Exit</a></li>
			</ul>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Collection Analysis</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	
	<div class="sectionDiv" style="width: 920px; height: 450px;">
		<div class="sectionDiv" style="width: 600px; height: 370px; margin: 40px 20px 20px 150px;">
			<div id="fieldsDiv" class="sectionDiv" style="width: 570px; height: 140px; margin: 10px 10px 0 13px;">
				<table style="margin: 20px 10px 0 103px;">
					<tr>
						<td>
							<label style="float: left; padding-top: 2px; margin-right: 7px;">From</label>
							<div id="fromDiv" class="required" style="width: 140px; height: 20px; border: solid gray 1px; float: left;">
								<input id="txtFromDate" name="txtFromDate" readonly="readonly" type="text" value="${dateFrom}" class="leftAligned required" maxlength="10" style="border: none; float: left; width: 115px; height: 13px; margin: 0px;" value=""/>
								<img id="imgFromDate" alt="imgFromDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" />							
							</div>
						</td>
						<td>
							<label style="float: left; padding-top: 2px; margin-right: 5px; padding-left: 77px;">To</label>
							<div id="toDiv" class="required" style="width: 140px; height: 20px; border: solid gray 1px; float: left;">
								<input id="txtToDate" name="txtToDate" readonly="readonly" type="text" value="${dateTo}" class="leftAligned required" maxlength="10" style="border: none; float: left; width: 115px; height: 13px; margin: 0px;" value=""/>
								<img id="imgToDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"/>							
							</div>
						</td>
					</tr>
				</table>
				<table style="margin: 0 10px 0 30px;">
					<tr>
						<td>
							<input id="branchRB" name="repTypeRG" type="radio" value="BRANCH" checked="checked" style="float: left; margin-right: 7px;">
							<label for="branchRB" style="float: left; margin-right: 5px;">Branch</label>					
						</td>
						<td>							
							<div id="branchCdDiv" style="width: 90px; height: 20px; border: solid gray 1px; float: left;">
								<input id="txtBranchCd" name="txtBranchCd" type="text" maxlength="2" style="border: none; float: left; width: 65px; height: 13px; margin: 0px;" value="${branchCd}" ignoreDelKey="1"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchCdLOV" name="searchBranchCdLOV" alt="Go" style="float: right;"/>							
							</div>
						</td>
						<td>
							<input id="txtBranchName" type="text" readonly="readonly" style="width: 280px;" value="${branchName }">
						</td>
					</tr>
					<tr>
						<td>
							<input id="intmRB" name="repTypeRG" type="radio" value="INTM" style="float: left; margin-right: 7px;">
							<label for="intmRB" style="float: left; margin-right: 5px;">Intermediary</label>						
						</td>
						<td>
							<div id="intmNoDiv" style="width: 90px; height: 20px; border: solid gray 1px; float: left;"">
								<input id="txtIntmNo" name="txtIntmNo" type="text" class="rightAligned integerUnformattedNoComma" maxlength="12" style="border: none; float: left; width: 65px; height: 13px; margin: 0px;" value="${intmNo }" readonly="readonly" ignoreDelKey="1"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmNoLOV" name="searchIntmNoLOV" alt="Go" style="float: right;"/>							
							</div>
						</td>
						<td>
							<input id="txtIntmName" type="text" readonly="readonly" style="width: 280px;" value="${intmName }">
						</td>
					</tr>
				</table>
			</div>
			
			<div id="dateTagDiv" class="sectionDiv" style="width: 220px; height: 160px; margin: 2px 0  0 13px;">
				<table>
					<tr>
						<td style="padding: 35px 0 10px 0;">
							<input id="orRB" name="dateTagRG" type="radio" checked="checked" value="OR" style="float: left; margin: 1px 7px 0 50px;">
							<label for="orRB" style="margin: 0 4px 2px 2px; ">OR Date</label>
						</td>
					</tr>
					<tr>
						<td style="padding-bottom: 10px;">
							<input id="dcbRB" name="dateTagRG" type="radio" value="DCB" style="float: left; margin: 1px 7px 0 50px;">
							<label for="dcbRB" style="margin: 0 4px 2px 2px; ">DCB Date</label>
						</td>
					</tr>
					<tr>
						<td style="padding-bottom: 5px;">
							<input id="postingRB" name="dateTagRG" type="radio" value="POSTING" style="float: left; margin: 1px 7px 0 50px;">
							<label for="postingRB" style="margin: 0 4px 2px 2px; ">Posting Date</label>
						</td>
					</tr>
				</table>
			</div>
			
			<div id="printDialogFormDiv" class="sectionDiv" style="width: 300px; height: 140px; margin: 2px 0 0 1px; padding: 10px 27px 10px 20px;" align="center">
				<table style="float: left; padding: 7px 0 0 1px; width: 310px;">
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
							<input value="EXCEL" title="Excel" type="radio" id="excelRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="110"><label for="excelRB" style="margin: 2px 0 4px 0">Excel</label>
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
							<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma" tabindex="112">
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
				<input id="btnExtract" type="button" class="button" value="Extract" style="width: 90px;" tabindex="113">
				<input id="btnPrint" type="button" class="button" value="Print" style="width: 90px;" tabindex="114">
			</div>
			
		</div>
	</div>
	
</div>

<script type="text/javascript">
try{
	setModuleId("GIACS078");
	setDocumentTitle("Collection Analysis");
	initializeAll();
	
	$("txtFromDate").focus();
	
	$("txtBranchName").value = '${branchName}' != "" ? unescapeHTML2('${branchName}') : "ALL BRANCHES";
	disableSearch("searchIntmNoLOV");
	
	var extracted = "N";
	var repType = $("branchRB").checked ? "BRANCH" : "INTM";
	var dateTag = "OR";
	var prevExtFromDate = '${dateFrom}' != "" ? '${dateFrom}' : null;
	var prevExtToDate = '${dateTo}' != "" ? '${dateTo}' : null;
	var prevExtBranchCd = '${branchCd}' != "" ? unescapeHTML2('${branchCd}') : "";
	var prevExtIntmNo = '${intmNo}' != "" ? '${intmNo}' : "";
	
		
	observeReloadForm("reloadForm", showCollectionAnalysisPage);
	
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
			}else{
				$("pdfRB").disabled = true;
				$("excelRB").disabled = true;
			}		
		}
	}
	
	function showBranchLOV(isIconClicked){
		var searchString = isIconClicked ? "%" : escapeHTML2($F("txtBranchCd").trim());
		
		LOV.show({
			controller:	'AccountingLOVController',
			urlParameters:{
				action:			"getGIACS078BranchLOV",
				moduleId:		"GIACS078",
				searchString:	searchString
			},
			title: "List of Branches",
			width: 405,
			height: 386,
			draggable: true,
			filterText: searchString,
			autoSelectOneRecord: true,
			columnModel: [
				{
					id: 'branchCd',
					title: 'Branch Code',
					width: '90px'
				}, 
				{
					id: 'branchName',
					title: 'Branch Name',
					width: '300px'
				}
			],
			onSelect: function(row){
				if (row != undefined){
					$("txtBranchCd").value = unescapeHTML2(row.branchCd);
					$("txtBranchCd").setAttribute("lastValidValue", $F("txtBranchCd"));
					$("txtBranchName").value = unescapeHTML2(row.branchName);
				}
			},
			onCancel: function(){
				$("txtBranchCd").value =  $("txtBranchCd").readAttribute("lastValidValue");
			},
			onUndefinedRow: function(){
				$("txtBranchCd").value =  $("txtBranchCd").readAttribute("lastValidValue");
				showWaitingMessageBox("No record selected.", imgMessage.INFO, function(){
					$("txtBranchCd").focus();
				});
			}
		});	
	}
	
	function validateBranchCd(){
		try{
			new Ajax.Request(contextPath+"/GIACCashReceiptsReportController",{
				parameters: {
					action:		"validateGiacs078BranchCd",
					branchCd:	$F("txtBranchCd"),
					moduleId:	"GIACS078"
				},
				asynchronous: true,
				evalScripts: true,
				onCreate:	showNotice("Searching Branch, please wait.."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						if (response.responseText != ""){
							$("txtBranchName").value = unescapeHTML2(response.responseText);
						}else{
							//clearFocusElementOnError("txtBranchCd", "Invalid value for BRANCH_CD");
							$("txtBranchName").value = "ALL BRANCHES";
							showBranchLOV();
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("validateBranchCd", e);
		}
	}
	
	function showIntmLOV(isIconClicked){
		var searchString = isIconClicked ? "%" : escapeHTML2($F("txtIntmNo").trim());
		
		LOV.show({
			controller: 'AccountingLOVController',
			urlParameters: {
				action: 		"getGIACS078IntmLOV",
				searchString:	searchString
			},
			title: "List of Intermediaries",
			width: 460,
			height: 386,
			draggable: true,
			filterText: searchString,
			autoSelectOneRecord: true,
			columnModel: [
				{
					id: 'intmNo',
					title: 'Intm No',
					width: '80px',
					titleAlign: 'right',
					align: 'right'
				},
				{
					id: 'intmName',
					title: 'Intm Name',
					width: '360px'
				}
			],
			onSelect: function(row){
				if (row != undefined){
					$("txtIntmNo").value = row.intmNo;
					$("txtIntmNo").setAttribute("lastValidValue", row.intmNo);
					$("txtIntmName").value = unescapeHTML2(row.intmName);
				}
			},
			onCancel: function(){
				$("txtIntmNo").clear();
				$("txtIntmNo").value =  $("txtIntmNo").readAttribute("lastValidValue");
			},
			onUndefinedRow: function(){
				$("txtIntmNo").clear();
				$("txtIntmNo").value =  $("txtIntmNo").readAttribute("lastValidValue");
				showWaitingMessageBox("No record selected.", imgMessage.INFO, function(){
					$("txtIntmNo").focus();
				});
			}
		});
	}
	
	function validateIntmNo(){
		try{
			new Ajax.Request(contextPath+"/GIACCashReceiptsReportController",{
				method: "POST",
				parameters: {
					action:		"validateIntmNo",
					intmNo:		$F("txtIntmNo")
				},
				asynchronous: false,
				evalScripts: true,
				onCreate:	showNotice("Searching Intermediary, please wait.."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						var json = JSON.parse(response.responseText);
						
						if (json.intmName != undefined){
							$("txtIntmName").value = unescapeHTML2(json.intmName);
						}else{
							//clearFocusElementOnError("txtIntmNo", "Invalid value for INTM_NO");
							$("txtIntmName").value = "ALL INTERMEDIARY";
							showIntmLOV();
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("validateIntmNo", e);
		}
	}
	
	function extractRecords(){
		try{			
			new Ajax.Request(contextPath+"/GIACCashReceiptsReportController",{
				parameters: {
					action:		"extractGiacs078Records",
					fromDate:	$F("txtFromDate"),
					toDate:		$F("txtToDate"),
					branchCd:	$F("txtBranchCd"),
					intmNo:		$F("txtIntmNo"),
					dateTag:	dateTag
				},
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Extracting records, please wait.."),
				onComplete: function(response){
					hideNotice("");
					
					if(checkErrorOnResponse(response)){
						var msg = response.responseText == "0" ? "No" : response.responseText;
						if (response.responseText != "0"){
							extracted = "Y";
							prevExtFromDate = $F("txtFromDate");
							prevExtToDate = $F("txtToDate");
							prevExtBranchCd = $F("txtBranchCd");
							prevExtIntmNo = $F("txtIntmNo");
							
							//showMessageBox("Extraction finished. " + response.responseText + " records extracted.", "I");
						} /*else {
							showMessageBox("No records extracted", "I");
						}*/	//shan 10.07.2013
						
						showWaitingMessageBox("Extraction finished. " + msg + " records extracted.", "I", function(){
							/*if (mode == "PRINT"){
								printReport();
							}*/
						});
					}
				}
			});
		}catch(e){
			showMessageBox("extractRecords", e);
		}
	}
	
	
	function printReport(){
		try{
			var content = contextPath+"/CashReceiptsReportPrintController?action=printReport&moduleId=GIACS078&reportId=GIACR078"
					      +"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate")+"&branchCd="+$F("txtBranchCd")+"&intmNo="+$F("txtIntmNo")
					      +"&dateTag="+dateTag+"&repType="+repType+"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")
					      +"&destination="+$F("selDestination");
			
			if($F("selDestination") == "screen"){
				showPdfReport(content, "Collection Analysis");
			} else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					method: "POST",
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing complete.", "S");
						}
					}
				});
			}else if("file" == $F("selDestination")){
					new Ajax.Request(content, {
						method: "POST",
						parameters : {destination : "FILE",
									  fileType    : $("pdfRB").checked ? "PDF" : "XLS"},
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
								copyFileToLocal(response);
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
	
	$("txtFromDate").observe("blur", function(){
		if ($F("txtFromDate") != "" && $F("txtToDate") == ""){
			$("txtToDate").value = dateFormat(Date.parse($F("txtFromDate")).moveToLastDayOfMonth(), 'mm-dd-yyyy');
		}/*else{
			checkInputDates(this.id, this.id, "txtToDate");
		}*/
	});
	
	$("txtToDate").observe("blur", function(){
		if ($F("txtFromDate") != "" && $F("txtToDate") == ""){
			$("txtToDate").value = dateFormat(Date.parse($F("txtFromDate")).moveToLastDayOfMonth(), 'mm-dd-yyyy');
		}/*else{
			checkInputDates(this.id, "txtFromDate", this.id);
		}*/
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
	
	$$("input[name='repTypeRG']").each(function(rb){
		rb.observe("click", function(){
			repType = rb.value;
			
			if (rb.value == "BRANCH"){
				enableSearch("searchBranchCdLOV");
				$("txtBranchName").value = "ALL BRANCHES";
				$("txtBranchCd").value = "";
				$("txtBranchCd").readOnly = false;
				disableSearch("searchIntmNoLOV");
				$("txtIntmNo").readOnly = true;
				$("txtIntmNo").value = "";
				$("txtIntmName").value = "";
				$("txtBranchCd").focus();
			}else if (rb.value == "INTM"){
				enableSearch("searchIntmNoLOV");
				$("txtIntmName").value = "ALL INTERMEDIARIES";
				$("txtIntmNo").value = "";
				$("txtIntmNo").readOnly = false;
				disableSearch("searchBranchCdLOV");
				$("txtBranchCd").readOnly = true;
				$("txtBranchCd").value = "";
				$("txtBranchName").value = "";
				$("txtIntmNo").focus();
			}
		});
	});
	

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
			this.setAttribute("lastValidValue", "");
			$("txtBranchName").value = "ALL BRANCHES";
		}
	});
	
	$("searchIntmNoLOV").observe("click", function(){
		showIntmLOV(true);
	});
	
	$("txtIntmNo").observe("change", function(){
		if($F("txtIntmNo") != ""){
			showIntmLOV(false); //validateIntmNo();
		}else{
			this.setAttribute("lastValidValue", "");
			$("txtIntmName").value = "ALL INTERMEDIARIES";
		}
	});
	
	$$("input[name='dateTagRG']").each(function(rb){
		rb.observe("click", function(){
			dateTag = rb.value;
		});
	});
	
	$("btnExtract").observe("click", function(){
		/*if ($F("txtFromDate") == "" && $F("txtToDate") == ""){
			showMessageBox("Please enter From Date and To Date.", "E");
		}else if($F("txtFromDate") == ""){
			showMessageBox("Please enter From Date.", "E");
		}else if($F("txtToDate") == ""){
			showMessageBox("Please enter To Date.", "E");
		}else if (compareDatesIgnoreTime(Date.parse($("txtFromDate").value),Date.parse($("txtToDate").value)) == -1){
			showMessageBox("From Date should be earlier than To Date.", "E");
		}else{
			extractRecords();
		}*/
		
		if (checkAllRequiredFieldsInDiv('fieldsDiv')){
			var changed = false;
			if (prevExtFromDate != $F("txtFromDate")) changed = true;
			if (prevExtToDate != $F("txtToDate")) changed = true;
			if (prevExtBranchCd != $F("txtBranchCd")) changed = true;
			if (prevExtIntmNo != $F("txtIntmNo")) changed = true;
			
			if ( changed ){
				extractRecords();				
			}else{
				showConfirmBox("CONFIRMATION", "Data has been extracted within the specified parameter/s. Do you wish to continue extraction?", "Yes", "No",  
						function(){
							extractRecords();	
						}
		);
			}
		}
	});
	
	$("btnPrint").observe("click", function(){
		/*new Ajax.Request(contextPath+"/GIACCashReceiptsReportController",{
			parameters: {
				action:		"countGiacs078ExtractedRecords",
				fromDate:	$F("txtFromDate"),
				toDate:		$F("txtToDate"),
			},
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					if (response.responseText != "0"){
						extracted = "Y";
						
						/*if ($F("txtFromDate") == "" && $F("txtToDate") == ""){
							showMessageBox("Please enter From and To Date.", "E");
						}else if($F("txtFromDate") == ""){
							showMessageBox("Please enter From Date.", "E");
						}else if($F("txtToDate") == ""){
							showMessageBox("Please enter To Date.", "E");
						}else if (compareDatesIgnoreTime(Date.parse($("txtFromDate").value),Date.parse($("txtToDate").value)) == -1){
							showMessageBox("From Date should be earlier than To Date.", "E");
						}else if(!checkAllRequiredFieldsInDiv('printDialogFormDiv')){
							//showMessageBox("Printer Name and No. of Copies are required.", "I");
						}else if($F("selDestination") == "printer" && (isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0)){
							showMessageBox("Invalid number of copies.", "I");
						}else{
							printReport();
						}* /
						if(checkAllRequiredFieldsInDiv('fieldsDiv') && checkAllRequiredFieldsInDiv('printDialogFormDiv')){
							checkPrevExtParams("PRINT"); //printReport();
						 }
					}else{
						extracted = "N";
						showMessageBox("Please extract data first.", "I");
					}
					 
				}
			}
		});*/
		
		if(checkAllRequiredFieldsInDiv('fieldsDiv') && checkAllRequiredFieldsInDiv('printDialogFormDiv')){
			if (prevExtFromDate == null && prevExtToDate == null){
				showMessageBox("Please extract records first.", "I");
				return;
			}
			
			var changed = false;
			if (prevExtFromDate != $F("txtFromDate")) changed = true;
			if (prevExtToDate != $F("txtToDate")) changed = true;
			if (unescapeHTML2(prevExtBranchCd) != $F("txtBranchCd")) changed = true;
			if (prevExtIntmNo != $F("txtIntmNo")) changed = true;
			
			if (changed){
				showConfirmBox("CONFIRMATION", "The specified parameter/s has not been extracted. Do you want to extract the data using the specified parameter/s?", "Yes", "No",  
								function(){
									extractRecords();	
								}
				);
			}else{
				printReport();
			}
		 }
	});
	
	$("collectionAnalysisExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});
	
	if ($F("txtIntmNo") != ""){
		$("intmRB").checked = true;
		enableSearch("searchIntmNoLOV");
		disableSearch("searchBranchCdLOV");
		$("txtBranchCd").readOnly = true;
		$("txtBranchCd").value = "";
		$("txtBranchName").value = "";
		$("txtIntmNo").focus();
		$("txtIntmName").value = unescapeHTML2('${intmName}') != "" ? unescapeHTML2('${intmName}')  : "ALL INTERMEDIARIES";
	}
	
}catch(e){
	showErrorMessage("Page Error: ",e);
}
</script>