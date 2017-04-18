<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
    
<div id="listOfBndersMainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothMenu1" name="smoothMenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="listOfBindersExit">Exit</a></li>
			</ul>
		</div>
	</div>

	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>List of Binders Attached to Redistributed Records</label>
		</div>
	</div>
	
	<div id="listOfBindersDiv" class="sectionDiv" style="width: 920px; height: 500px">
		<div class="sectionDiv" style="width: 560px; height: 410px; margin: 40px 20px 20px 175px;">
			<div id="chkboxDiv" class="sectionDiv" style="width: 540px; height: 50px; margin: 8px 10px 0 10px;">
				<input id="chkIssueDate" type="checkbox" checked="checked" value="I" style="margin: 15px 0 0 100px; float: left;">
				<label for="chkIssueDate" style="margin: 15px 100px 0 15px;">Issue Date</label>
				<input id="chkEffDate" type="checkbox" value="E" style="margin: 15px 0 0 80px; float: left;">
				<label for="chkEffDate" style="margin: 15px 0 0 15px;">Effectivity Date</label>
			</div>
						
			<div id="inputDiv" class="sectionDiv" style="width: 540px; height: 150px; margin: 2px 10px 0 10px;">
				<table style="margin: 18px 0px 0 25px;">
					<tr>
						<td class="rightAligned" style="margin-right: 10px;">
							<input id="asOfRB" name="dateRG" type="radio" value="A" style="float: left; margin-right: 7px;">
							<label for="asOfRB" style="float: left; padding-top: 2px; margin-right: 5px;">As Of</label>
						</td>
						<td>
							<div id="asOfDiv" style="float: left; width: 160px;" class="withIconDiv">
								<input type="text" id="txtAsOfDate" name="txtAsOfDate" value="${asOfDate}" class="withIcon" readonly="readonly" style="width: 135px;"/>
								<img id="imgAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date" onClick="scwShow($('txtAsOfDate'),this, null);" />
							</div>
						</td>						
					</tr>
					 <tr>
						<td class="rightAligned">
							<input id="fromRB" name="dateRG" type="radio" value="F" style="float: left; margin-right: 7px;" checked="checked">
							<label for="fromRB" style="float: left; padding-top: 2px; margin-right: 5px;">From</label>
						</td>
						<td>
							<div id="fromDiv" style="float: left; width: 160px;" class="withIconDiv">
								<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon" readonly="readonly" style="width: 135px;"/>
								<img id="imgFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"  />
							</div>
						</td>						
						<td class="rightAligned" width="95px">To</td>
						<td>
							<div id="toDiv" style="float: left; width: 160px;" class="withIconDiv">
								<input type="text" id="txtToDate" name="txtToDate" class="withIcon" readonly="readonly" style="width: 135px;"/>
								<img id="imgToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"  />
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="padding-right: 8px;">Branch</td>
						<td colspan="5">							
							<span class="lovSpan" style="width:67px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input type="text" id="txtBranchCd" name="txtBranchCd" maxlength="2" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchCdLOV" name="searchBranchCdLOV" alt="Go" style="float: right;"/>
							</span>
							<input id="txtBranchName" type="text" readonly="readonly" style="width: 350px;" >
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="padding-right: 8px;">Line</td>
						<td colspan="5">							
							<span class="lovSpan" style="width:67px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input type="text" id="txtLineCd" name="txtLineCd" maxlength="2" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCdLOV" name="searchLineCdLOV" alt="Go" style="float: right;"/>
							</span>
							<input id="txtLineName" type="text" readonly="readonly" style="width: 350px;">
						</td>
					</tr>  
				</table>
			</div>
			
			<div id="printDialogFormDiv" class="sectionDiv" style="width: 540px; height: 120px; margin: 2px 0 5px 10px; padding: 10px 0 10px 0;" align="center">
				<table style="float: left; padding: 7px 0 0 1px; width: 310px; margin-left: 90px;">
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
				<input id="btnExtract" type="button" class="button" value="Extract" style="width: 80px; ">
				<input id="btnPrint" type="button" class="button" value="Print" style="width: 80px; " >
			</div>
		</div>
	</div>
	
</div> 

<script type="text/javascript">
try{
	setModuleId("GIACS274");
	setDocumentTitle("List of Binders Attached to Redistributed Records");
	initializeAll();
	
	disableDate("imgAsOfDate");
	
	var prevExtJSON = JSON.parse('${prevExtJSON}'.replace(/\\/g, '\\\\'));	
	var asOfDate = prevExtJSON.asOfDate == null? null : dateFormat(prevExtJSON.asOfDate, 'mm-dd-yyyy');
	var fromDate = prevExtJSON.fromDate == null? null : dateFormat(prevExtJSON.fromDate, 'mm-dd-yyyy');
	var toDate = prevExtJSON.toDate == null? null : dateFormat(prevExtJSON.toDate, 'mm-dd-yyyy');
	var lineCd = prevExtJSON.paramLineCd == null ? "" : unescapeHTML2(prevExtJSON.paramLineCd);
	var branchCd = prevExtJSON.paramIssCd == null ? "" : unescapeHTML2(prevExtJSON.paramIssCd);
	
	var dateTag = prevExtJSON.dateTag == null ? "I" : prevExtJSON.dateTag;
	
	$("txtLineCd").value = prevExtJSON.paramLineCd == null ? "" : unescapeHTML2(prevExtJSON.paramLineCd);
	$("txtLineCd").setAttribute("lastValidValue", $F("txtLineCd"));
	$("txtBranchCd").value = prevExtJSON.paramIssCd == null ? "" : unescapeHTML2(prevExtJSON.paramIssCd);
	$("txtBranchCd").setAttribute("lastValidValue", $F("txtBranchCd"));
	$("txtLineName").value = prevExtJSON.lineName == null ? "ALL LINES" : prevExtJSON.lineName;
	$("txtBranchName").value = prevExtJSON.issName == null ? "ALL BRANCHES" : prevExtJSON.issName;
	
	$("txtFromDate").value = fromDate;
	$("txtToDate").value = toDate;
	$("txtAsOfDate").value = asOfDate;
	$("txtFromDate").addClassName("required");
	$("txtToDate").addClassName("required");
	$("fromDiv").addClassName("required");
	$("toDiv").addClassName("required");
	
	if (prevExtJSON.dateTag == "I"){
		$("chkIssueDate").checked = true;
		$("chkEffDate").checked = false;
	}else if(prevExtJSON.dateTag == "E"){
		$("chkEffDate").checked = true;
		$("chkIssueDate").checked = false;
	}
	
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
		var searchString = isIconClicked ? '%' : ($F("txtBranchCd").trim() == "" ? '%' : $F("txtBranchCd"));
		
		try{
			LOV.show({
				controller: 'AccountingLOVController',
				urlParameters: {
					action:		'getGIACS274BranchLOV',
					searchString: searchString
				},
				title: 'List of Branches',
				width:	405,
				height: 386,
				draggable: true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				columnModel: [
					{
						id: 'branchCd',
						title: 'Branch Cd',
						width: '80px'
					},
					{
						id: 'branchName',
						title: 'Branch Name',
						width: '308px'
					}
				],
				onSelect: function(row){
					if (row != undefined){
						$("txtBranchCd").setAttribute("lastValidValue", row.branchCd);
						$("txtBranchCd").value = row.branchCd;
						$("txtBranchName").value = row.branchName;
					}
				},
				onUndefinedRow : function(){
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchCd");
				},
				onCancel: function(){
					$("txtBranchCd").focus();
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
				}
			});
		}catch(e){
			showErrorMessage("showBranchLOV", e);
		}
	}
	
	function validateBranchCd(){
		try{
			new Ajax.Request(contextPath+"/GIACReinsuranceReportsController", {
				parameters:{
					action:		"validateGIACS274BranchCd",
					branchCd:		$F("txtBranchCd")
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if (response.responseText == ""){
						$("txtBranchName").value = "ALL BRANCHES";
						clearFocusElementOnError($("txtBranchCd"), "Invalid value for BRANCH_CD");
					}else{
						$("txtBranchName").value = unescapeHTML2(response.responseText);
					}
				}
			});
		}catch(e){
			showErrorMessage("validateBranchCd", e);
		}
	}
	
	function showLineLOV(isIconClicked){
		var searchString = isIconClicked ? '%' : ($F("txtLineCd").trim() == "" ? '%' : $F("txtLineCd"));
		
		try{
			LOV.show({
				controller: 'AccountingLOVController',
				urlParameters: {
					action:		'getGiisLineLOV',
					searchString: searchString
				},
				title: 'List of Lines',
				width:	405,
				height: 386,
				draggable: true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				columnModel: [
					{
						id: 'lineCd',
						title: 'Line Cd',
						width: '80px'
					},
					{
						id: 'lineName',
						title: 'Line Name',
						width: '308px'
					}
				],
				onSelect: function(row){
					if (row != undefined){
						$("txtLineCd").setAttribute("lastValidValue", row.lineCd);
						$("txtLineCd").value = row.lineCd;
						$("txtLineName").value = row.lineName;
					}
				},
				onUndefinedRow : function(){
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
				},
				onCancel: function(){
					$("txtLineCd").focus();
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				}
			});			
		}catch(e){
			showErrorMessage("showLineLOV", e);
		}
	}
	
	function validateLineCd(){
		try{
			new Ajax.Request(contextPath+"/GIACReinsuranceReportsController", {
				parameters:{
					action:		"validateGIACS274LineCd",
					lineCd:		$F("txtLineCd")
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if (response.responseText == "ERROR"){
							$("txtLineName").value = "ALL LINES";
							clearFocusElementOnError($("txtLineCd"), "Invalid value for LINE_CD");
						}else{
							$("txtLineName").value = unescapeHTML2(response.responseText);
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("validateLineCd", e);
		}
	}
	
	function extractRecords(){
		try{
			var dateParam = null;
			
			if ($("asOfRB").checked){
				dateParam = "A";
			}else if ($("fromRB").checked){
				dateParam = "F";
			}
			
			new Ajax.Request(contextPath+"/GIACReinsuranceReportsController",{
				parameters: {
					action:		'extractGiacs274',
					fromDate:	$F("txtFromDate"),
					toDate:		$F("txtToDate"),
					asOfDate:	$F("txtAsOfDate"),
					dateParam:	dateParam,
					issueDate:	$F("chkIssueDate"),
					effDate:	$F("chkEffDate"),
					lineCd:		$F("txtLineCd"),
					issCd:		$F("txtBranchCd")
				},
				evalScript: true,
				asynchronous: true,
				onCreate: showNotice("Extracting records, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						var json = JSON.parse(response.responseText);
						
						if(json.msg == "SUCCESS"){
							var noOfRec = json.recExtracted > 0 ? json.recExtracted : "No";
							showMessageBox("Extraction finished. " + noOfRec + " records extracted.", "I");
							
							if (json.recExtracted > 0){
								if (dateParam == "A"){
									fromDate = null;
									toDate = null;
									asOfDate = $F("txtAsOfDate");	
								}else if(dateParam == "F"){
									fromDate = $F("txtFromDate");
									toDate = $F("txtToDate");
									asOfDate = null;	
								}
								lineCd = $F("txtLineCd");
								branchCd = $F("txtBranchCd");
								prevExtJSON.dateTag = dateTag;
							}else{
								fromDate = null;
								toDate = null;
								asOfDate = null;	
							}
						}						
					}
				}
			});
		}catch(e){
			showErrorMessage("extractRecords", e);
		}		
	}
	
	function printReport(){
		try{
			var reportTitle = "List of Binders Attached to Redistributed Records";
			var content = contextPath+"/ReinsuranceReportController?action=printReport&reportId=GIACR274"
						  +"&issCd="+$F("txtBranchCd")+"&lineCd="+$F("txtLineCd")+"&noOfCopies="+$F("txtNoOfCopies")
						  +"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination");
			
			if($F("selDestination") == "screen"){
				showPdfReport(content, reportTitle);
			} else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					method: "POST",
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Processing, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing Completed.", "I");
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
	
	$("chkIssueDate").observe("click", function(){
		if($("chkIssueDate").checked){
			$("chkIssueDate").value = "I";
			$("chkEffDate").checked = false;
			dateTag = "I";
		}else{
			$("chkIssueDate").value = null;
			$("chkEffDate").checked = true;
			dateTag = "E";
		}
	});
	
	$("chkEffDate").observe("click", function(){
		if($("chkEffDate").checked){
			$("chkEffDate").value = "E";
			$("chkIssueDate").checked = false;
			dateTag = "E";
		}else{
			$("chkEffDate").value = null;
			$("chkIssueDate").checked = true;
			dateTag = "I";
		}
	});
	
	$$("input[name='dateRG']").each(function(rb){
		rb.observe("click", function(){
			if (rb.value == "F"){
				enableDate("imgToDate");
				enableDate("imgFromDate");
				disableDate("imgAsOfDate");
				$("txtFromDate").value = fromDate;
				$("txtToDate").value = toDate;
				$("txtAsOfDate").clear();
				$("txtFromDate").addClassName("required");
				$("txtToDate").addClassName("required");
				$("txtAsOfDate").removeClassName("required");
				$("fromDiv").addClassName("required");
				$("toDiv").addClassName("required");
				$("asOfDiv").removeClassName("required");
			}else{
				enableDate("imgAsOfDate");
				disableDate("imgFromDate");
				disableDate("imgToDate");
				$("txtAsOfDate").value = asOfDate;
				$("txtFromDate").clear();
				$("txtToDate").clear();
				$("txtFromDate").removeClassName("required");
				$("txtToDate").removeClassName("required");
				$("txtAsOfDate").addClassName("required");
				$("fromDiv").removeClassName("required");
				$("toDiv").removeClassName("required");
				$("asOfDiv").addClassName("required");
			}
		});
	});
	
	$("txtToDate").observe("blur", function(){
		if($F("txtFromDate") != "" && $F("txtToDate") == ""){
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
		if($F("txtBranchCd") != ""){
			showBranchLOV(false); //validateBranchCd();
		}else{
			$("txtBranchCd").setAttribute("lastValidValue", "");
			$("txtBranchName").value = "ALL BRANCHES";
		}
	});	
	
	$("searchBranchCdLOV").observe("click", function(){
		showBranchLOV(true);
	});
	
	
	$("txtLineCd").observe("keyup", function(){
		$("txtLineCd").value = $("txtLineCd").value.toUpperCase();
	});
	
	$("txtLineCd").observe("change", function(){
		if($F("txtLineCd") != ""){
			showLineLOV(false); //validateLineCd();
		}else{
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").value = "ALL LINES";
		}
	});
	
	$("searchLineCdLOV").observe("click", function(){
		showLineLOV(true);
	});
	
	$("btnExtract").observe("click", function(){
		if (checkAllRequiredFieldsInDiv("inputDiv")){
			var changed = false;
			
			if ($("fromRB").checked){				
				if (fromDate != $F("txtFromDate")) changed = true;
				if (toDate != $F("txtToDate")) changed = true;
				if (dateTag != prevExtJSON.dateTag) changed = true;
				if (unescapeHTML2(lineCd) != $F("txtLineCd")) changed = true;
				if (unescapeHTML2(branchCd) != $F("txtBranchCd")) changed = true;
				
				/*if((fromDate != null && toDate != null) && compareDatesIgnoreTime(Date.parse(fromDate), Date.parse($F("txtFromDate"))) == 0){
					if(compareDatesIgnoreTime(Date.parse(toDate), Date.parse($F("txtToDate"))) == 0){
						if ($F("chkIssueDate") == prevExtJSON.dateTag || $F("chkEffDate") == prevExtJSON.dateTag){
							showConfirmBox("Confirmation", "Data has been extracted within this specified period. Do you wish to continue extraction?",
											"Yes", "No",
											function(){
												extractRecords();
											},
											null);
						}
					}else{
						extractRecords();
					}
				}else{
					extractRecords();
				}	*/
				
				$("txtAsOfDate").clear();
				
			}else if($("asOfRB").checked){
				if (asOfDate != $F("txtAsOfDate")) changed = true;
				if (dateTag != prevExtJSON.dateTag) changed = true;
				if (unescapeHTML2(lineCd) != $F("txtLineCd")) changed = true;
				if (unescapeHTML2(branchCd) != $F("txtBranchCd")) changed = true;
				
				/*if(asOfDate != null && compareDatesIgnoreTime(Date.parse(asOfDate), Date.parse($F("txtAsOfDate"))) == 0){
					if ($F("chkIssueDate") == prevExtJSON.dateTag || $F("chkEffDate") == prevExtJSON.dateTag){
						showConfirmBox("Confirmation", "Data has been extracted within this specified parameter/s. Do you wish to continue extraction?",
										"Yes", "No",
										function(){
											extractRecords();
										},
										null);
					}
					
				}else{			
					extractRecords();
				}*/
			}
			
			if (changed){
				extractRecords();
			}else{
				showConfirmBox("Confirmation", "Data has been extracted within this specified parameter/s. Do you wish to continue extraction?",
						"Yes", "No",
						function(){
							extractRecords();
						},
						null);
			}
		}
	});
	
	$("btnPrint").observe("click", function(){
		/*
		if($F("selDestination") == "printer" && ($("selPrinter").value == "" || $("txtNoOfCopies").value == "")){
			showMessageBox("Printer Name and No. of Copies are required.", "I");
		}else if($F("selDestination") == "printer" && (isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0)){
			showMessageBox("Invalid number of copies.", "I");
		}else{
			printReport();
		}*/
				
		if (checkAllRequiredFieldsInDiv("inputDiv") && checkAllRequiredFieldsInDiv("printDialogFormDiv")){
			var changed = false;
			
			if (asOfDate == null && fromDate == null && toDate == null){
				showMessageBox("Please extract data first.", "I");
				return;	
			}
			
			if ($("asOfRB").checked){
				/*if((asOfDate != null && compareDatesIgnoreTime(Date.parse(asOfDate), Date.parse($F("txtAsOfDate"))) != 0)
						|| asOfDate == null && ( dateTag != prevExtJSON.dateTag) 
						|| unescapeHTML2(lineCd) != $F("txtLineCd") || unescapeHTML2(branchCd) != $F("txtBranchCd")){
					/*showMessageBox("You have not yet extracted records with the same date yet.", "I");
					return false;* /
					showConfirmBox("Confirmation", "The specified parameter/s has not been extracted. Do you want to extract the data using the specified parameter/s?",
							"Yes", "No",
							function(){
								extractRecords();
							},
							null);
				}else{
					printReport();
				}*/
				if (asOfDate != $F("txtAsOfDate")) changed = true;
				if (dateTag != prevExtJSON.dateTag) changed = true;
				if (unescapeHTML2(lineCd) != $F("txtLineCd")) changed = true;
				if (unescapeHTML2(branchCd) != $F("txtBranchCd")) changed = true;
			}else if($("fromRB").checked){
				/*if((fromDate != null && compareDatesIgnoreTime(Date.parse(fromDate), Date.parse($F("txtFromDate"))) != 0) ||
						(toDate != null && compareDatesIgnoreTime(Date.parse(toDate), Date.parse($F("txtToDate"))) != 0) ||
						(fromDate == null || toDate == null) && ( dateTag != prevExtJSON.dateTag) 
						|| unescapeHTML2(lineCd) != $F("txtLineCd") || unescapeHTML2(branchCd) != $F("txtBranchCd")){
					/*showMessageBox("You have not yet extracted records with the same date yet.", "I");
					return false;* /
					showConfirmBox("Confirmation", "The specified period has not been extracted. Do you want to extract the data using the specified period?",
							"Yes", "No",
							function(){
								extractRecords();
							},
							null);
				}else {
					printReport();
				}*/
				if (fromDate != $F("txtFromDate")) changed = true;
				if (toDate != $F("txtToDate")) changed = true;
				if (dateTag != prevExtJSON.dateTag) changed = true;
				if (unescapeHTML2(lineCd) != $F("txtLineCd")) changed = true;
				if (unescapeHTML2(branchCd) != $F("txtBranchCd")) changed = true;
			}
			
			//printReport();
			if (changed){
				showConfirmBox("Confirmation", "The specified parameter/s has not been extracted. Do you want to extract the data using the specified parameter/s?",
						"Yes", "No",
						function(){
							extractRecords();
						},
						null);
			}else{
				printReport();
			}
		}
	});
	
	$("listOfBindersExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});
	

	if ($F("txtAsOfDate") != "") {
		$("asOfRB").checked = true;
		fireEvent($("asOfRB"), "click");
	}else{
		$("fromRB").checked = true;
		fireEvent($("fromRB"), "click");		
	} 
	
}catch(e){
	showErrorMessage("Page Error", e);
}
</script>