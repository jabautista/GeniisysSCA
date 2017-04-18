<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="paidPoliciesWFacultativeMainDiv" style="float: left;">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Paid Policies w/ Facultative</label>
			<span class="refreshers" style="margin-top: 0;">
		 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div id="paidPoliciesWFacultativeDiv" class="sectionDiv" style="height: 440px;">
		<div class="sectionDiv" style="margin: 30px 0px 0px 173px; height: 350px; width: 575px;">
			<div class="sectionDiv" style="margin: 2px 0px 0px 2px; height: 45px; width: 569px;">
				<div style="margin: 15px 0px 0px 150px; float: left;">
					<input type="checkbox" id="chkPostingDate" checked="checked" style="float: left;" tabindex="29901"/>
					<label for="chkPostingDate" tabindex="29902">Posting Date</label>
					<input type="checkbox" id="chkTranDate" style="margin-left: 80px; float: left;" tabindex="29903"/>
					<label for="chkTranDate" tabindex="29904">Transaction Date</label>
				</div>
			</div>
			<div id="checkBoxDiv" class="sectionDiv" style="margin: 2px 0px 0px 2px; height: 45px; width: 569px;"> <!-- Added by Jerome Bautista 10.16.2015 SR 3892 -->
				<table align="center" style="height: 20px; margin-top: 10px;">
				<tr>
					<td> 
						<div>
							<input id="chkExcludeOpenTransactions" type="checkbox" value="" style="float: left;" tabindex="29905"/>
							<label style="margin-left: 7px;" for="chkExcludeOpenTransactions" >Exclude Open Transactions</label>
						</div>
					</td>
				</tr>
			</table>
			</div>
			<div class="sectionDiv" id="paramsDiv" style="margin: 2px 0px 0px 2px; height: 105px; width: 569px;">
				<table align="center" style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">From</td>
						<td colspan="2">
							<div id="fromDateDiv" class="required" style="float: left; border: solid 1px gray; width: 150px; height: 20px; margin-left: 5px; margin-top: 2px;">
								<input type="text" id="txtFromDate" class="required" style="float: left; margin-top: 0px; margin-right: 3px; height: 14px; width: 122px; border: none;" name="txtFromDate" readonly="readonly" tabindex="29906"/> <!-- tabindex value Modified by Jerome Bautista 10.16.2015 SR 3892 -->
								<img id="imgFromDate" alt="imgFromDate" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" tabindex="29907"/> <!-- tabindex value Modified by Jerome Bautista 10.16.2015 SR 3892 -->
							</div>
							<label style="margin: 6px 0px 0px 41px; ">To</label>
							<div id="toDateDiv" class="required" style="float: left; border: solid 1px gray; width: 150px; height: 20px; margin-left: 5px; margin-top: 2px;">
								<input type="text" id="txtToDate" class="required" style="float: left; margin-top: 0px; margin-right: 3px; height: 14px; width: 122px; border: none;" name="txtToDate" readonly="readonly" tabindex="29908"/> <!-- tabindex value Modified by Jerome Bautista 10.16.2015 SR 3892 -->
								<img id="imgToDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" tabindex="29909"/> <!-- tabindex value Modified by Jerome Bautista 10.16.2015 SR 3892 -->
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Branch</td>
						<td>
							<div id="branchCdDiv" style="float: left; width: 70px; height: 19px; margin-left: 5px; border: 1px solid gray;">
								<input id="txtBranchCd" title="Branch Code" type="text" class="upper" maxlength="2" style="float: left; height: 13px; width: 45px; margin: 0px; border: none;" tabindex="29910" lastValidValue=""> <!-- tabindex value Modified by Jerome Bautista 10.16.2015 SR 3892 -->
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgBranchCdLOV" name="imgBranchCdLOV" alt="Go" style="float: right;" tabindex="29911"/> <!-- tabindex value Modified by Jerome Bautista 10.16.2015 SR 3892 -->
							</div>
						</td>
						<td>
							<input type="text" id="txtBranchName" style="width: 280px; margin-top: 3x;" readonly="readonly" tabindex="29912"/> <!-- tabindex value Modified by Jerome Bautista 10.16.2015 SR 3892 -->
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Line</td>
						<td>
							<div id="lineCdDiv" style="float: left; width: 70px; height: 19px; margin-left: 5px; border: 1px solid gray;">
								<input id="txtLineCd" title="Line Code" type="text" class="upper" maxlength="2" style="float: left; height: 13px; width: 45px; margin: 0px; border: none;" tabindex="29913" lastValidValue=""> <!-- tabindex value Modified by Jerome Bautista 10.16.2015 SR 3892 -->
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgLineCdLOV" name="imgLineCdLOV" alt="Go" style="float: right;" tabindex="29914"/> <!-- tabindex value Modified by Jerome Bautista 10.16.2015 SR 3892 -->
							</div>
						</td>
						<td>
							<input type="text" id="txtLineName" style="width: 280px; margin-top: 3x;" readonly="readonly" tabindex="29915"/> <!-- tabindex value Modified by Jerome Bautista 10.16.2015 SR 3892 -->
						</td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" style="width: 190px; height: 136px; margin: 2px 0px 0px 2px;">
				<label style="margin-top: 20px; margin-left: 10px;">Branch of Policy:</label>
				<div style="margin-top: 15px; margin-left: 35px; float: left; width: 100%;">
					<input type="radio" id="rdoCreditingBranch" name="branch" checked="checked" style="float: left;"/>
					<label for="rdoCreditingBranch" style="margin-top: 3px;">Crediting Branch</label>
				</div>
				<div style="margin-top: 15px; margin-left: 35px; float: left; width: 100%;">
					<input type="radio" id="rdoIssuingSource" name="branch" style="float: left;"/>
					<label for="rdoIssuingSource" style="margin-top: 3px;">Issuing Source</label>
				</div>
			</div>
			<div class="sectionDiv" style="width: 375px; height: 136px; margin: 2px 0px 0px 2px;">
				<div id="printDiv" style="margin-top: 5px; margin-left: 65px; border: none; height: 130px; width: 300px; float: left;">
					<table style="margin-top: 10px;">
						<tr>
							<td class="rightAligned">Destination</td>
							<td class="leftAligned">
								<select id="selDestination" style="width: 200px;" tabindex="305">
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
								<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="fileType" tabindex="306" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled"><label for="rdoPdf" style="margin: 2px 0 4px 0">PDF</label>
								<input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="fileType" tabindex="307" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoExcel" style="margin: 2px 0 4px 0">Excel</label>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Printer</td>
							<td class="leftAligned">
								<select id="selPrinter" style="width: 200px;" class="required" tabindex="308">
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
								<input type="text" id="txtNoOfCopies" class="required integerNoNegativeUnformattedNoComma" maxlength="3" style="float: left; text-align: right; width: 175px;" tabindex="309" lastValidValue="">
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
			</div>
			<div id="buttonsDiv" style="margin: 13px 0px 0px 220px; float: left;">
				<input type="button" class="button" id="btnPrint" value="Print" style="width: 120px;"/>
			</div>
		</div>
	</div>
</div>
<script type="text/JavaScript">
try{
	setModuleId("GIACS299");
	setDocumentTitle("Paid Policies w/ Facultative");
	$("txtFromDate").focus();
	makeInputFieldUpperCase();
	initializeAll();
	
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
	
	$("txtNoOfCopies").observe("focus", function(){
		$("txtNoOfCopies").writeAttribute("lastValidValue", $F("txtNoOfCopies"));
	});
	
	$("txtNoOfCopies").observe("change", function(){
		if($F("txtNoOfCopies").trim() != "" && (parseInt($F("txtNoOfCopies")) <= 0 || parseInt($F("txtNoOfCopies")) > 100)){
			showWaitingMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", function(){
				$("txtNoOfCopies").value = $("txtNoOfCopies").readAttribute("lastValidValue");
			});			
		}
	});
	
	toggleRequiredFields("screen");
	
	$("imgFromDate").observe("click", function(){
		scwShow($("txtFromDate"),this, null);
	});
	
	$("imgToDate").observe("click", function(){
		scwShow($("txtToDate"),this, null);
	});
	
	$("txtFromDate").observe("focus", function(){
		var from = Date.parse($F("txtFromDate"));
		var to = Date.parse($F("txtToDate"));
		
		if(!$F("txtToDate") == "" && !$F("txtFromDate") == ""){
			if(to < from){
				customShowMessageBox("From Date should not be later than To Date.", "I", "txtFromDate");
				$("txtFromDate").clear();
			}
		}
	});
	
	$("txtToDate").observe("focus", function(){
		var from = Date.parse($F("txtFromDate"));
		var to = Date.parse($F("txtToDate"));
		
		if(!$F("txtFromDate") == "" && !$F("txtToDate") == ""){
			if(to < from){
				customShowMessageBox("From Date should not be later than To Date.", "I", "txtToDate");
				$("txtToDate").clear();
			}	
		}
	});
	
	function showBranchLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGIACS299BranchLOV",
							moduleId : "GIACS299",
							filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : ""),
							page : 1},
			title: "List of Branches",
			width: 400,
			height: 386,
			columnModel : [ {
								id: "issCd",
								title: "Branch Code",
								width : '90px'
							}, {
								id : "issName",
								title : "Branch Name",
								width : '295px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							} ],
				autoSelectOneRecord: true,
				filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : ""),
				onSelect: function(row) {
					$("txtBranchCd").value = row.issCd;
					$("txtBranchName").value = unescapeHTML2(row.issName);
					$("txtBranchCd").setAttribute("lastValidValue", row.issCd);
				},
				onCancel: function (){
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("imgBranchCdLOV").observe("click", showBranchLOV);
	$("txtBranchCd").observe("change", function() {
		if($F("txtBranchCd").trim() == "") {
			$("txtBranchCd").value = "";
			$("txtBranchCd").setAttribute("lastValidValue", "");
			$("txtBranchName").value = "ALL BRANCHES";
		} else {
			if($F("txtBranchCd").trim() != "" && $F("txtBranchCd") != $("txtBranchCd").readAttribute("lastValidValue")) {
				showBranchLOV();
			}
		}
	});
	
	function showLineLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGIACS299LineLOV",
							moduleId : "GIACS299",
							filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
							page : 1},
			title: "List of Lines",
			width: 400,
			height: 386,
			columnModel : [ {
								id: "lineCd",
								title: "Line Code",
								width : '90px'
							}, {
								id : "lineName",
								title : "Line Name",
								width : '295px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							} ],
				autoSelectOneRecord: true,
				filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
				onSelect: function(row) {
					$("txtLineCd").value = row.lineCd;
					$("txtLineName").value = unescapeHTML2(row.lineName);
					$("txtLineCd").setAttribute("lastValidValue", row.lineCd);
				},
				onCancel: function (){
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("imgLineCdLOV").observe("click", showLineLOV);
	$("txtLineCd").observe("change", function() {
		if($F("txtLineCd").trim() == "") {
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").value = "ALL LINES";
		} else {
			if($F("txtLineCd").trim() != "" && $F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue")) {
				showLineLOV();
			}
		}
	});
	
	function checkDate(){
		if($F("txtFromDate") == "" && $F("txtToDate") == ""){
			customShowMessageBox("Please enter From Date and To Date.", "I", "txtFromDate");
			return false;
		}
		if($F("txtFromDate") == "" && $F("txtToDate") != ""){
			customShowMessageBox("Please enter From Date.", "I", "txtFromDate");
			return false;
		}
		if($F("txtFromDate") != "" && $F("txtToDate") == ""){
			customShowMessageBox("Please enter To Date.", "I", "txtToDate");
			return false;
		}
		printReport();
	}
	
	function printReport(){
		try {
			var content = contextPath + "/ReinsuranceReportController?action=printReport&reportId=GIACR299" + getParams();
			if("screen" == $F("selDestination")){
				showPdfReport(content, "PAID POLICIES W/ FACULTATIVE");
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {noOfCopies : $F("txtNoOfCopies"),
								  printerName : $F("selPrinter")
								 },
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Processing, please wait..."),				
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							
						}
					}
				});
			}else if("file" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "file",
								  fileType : $("rdoPdf").checked ? "PDF" : "XLS"},
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							copyFileToLocal(response);
						}
					}
				});
			}else if("local" == $F("selDestination")){
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
			showErrorMessage("GIACR299 printReport", e);
		}
	}
	
	function getParams(){
		var params = "";
		params = params + "&branchCd=" + $F("txtBranchCd") + "&lineCd=" + $F("txtLineCd") + "&fromDate=" + $F("txtFromDate") + "&toDate=" + $F("txtToDate")
				 		+ "&cutOffParam=" + ($("chkPostingDate").checked ? "1" : "2") + "&bop=" + ($("rdoCreditingBranch").checked ? "1" : "2") 
				 		+ "&tranFlag=" + ($("chkExcludeOpenTransactions").checked ? "O" : "D"); //Added by Jerome Bautista 10.16.2015 SR 3892
		return params;
	}
	
	$("chkPostingDate").observe("click", function(){
		if($("chkPostingDate").checked){
			if($("chkTranDate").checked){
				$("chkTranDate").checked = false;
			}
		}else{
			$("chkTranDate").checked = true;
		}
	});
	
	$("chkTranDate").observe("click", function(){
		if($("chkTranDate").checked){
			if($("chkPostingDate").checked){
				$("chkPostingDate").checked = false;
			}
		}else{
			$("chkPostingDate").checked = true;
		}
	});
	
	$("btnPrint").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("paidPoliciesWFacultativeMainDiv")){
			printReport();
		}
	});
	
	$("acExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	});	
	
	$("txtBranchName").value = "ALL BRANCHES";
	$("txtLineName").value = "ALL LINES";
	observeReloadForm("reloadForm", showGIACS299);
}catch(e){
	showErrorMessage("paidPoliciesWFacultative", e);
}
</script>