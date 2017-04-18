<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="bookedUnbookedCollectionMainDiv" name="bookedUnbookedCollectionMainDiv">
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
			<label>Collections for Booked/Unbooked Policies</label>
		</div>
	</div>
	<div class="sectionDiv" id="bookedUnbookedCollectionsReportBody" >
		<div class="sectionDiv" id="bookedUnbookedCollectionsReport" style="width: 70%; margin: 40px 138px 40px 138px;">
			<div class="sectionDiv" id="bookedUnbookedCollectionsReportInnerDiv" style="width: 97%; margin: 8px 8px 2px 8px;">
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
							<input type="text" id="branchName" name="branchName" style="width: 324px; float: left; height: 15px; text-align: left;" value="ALL BRANCHES" readonly="readonly"/>								
						</td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="rdoDiv" style="width: 24%; height:130px; margin: 0 0 8px 8px;">
				<table align = "center" style="padding: 10px;">
					<tr>
						<td>
							<input type="radio" checked="" name="bookedPolicies" id="bookedPolicies" title="Booked Policies" style="float: left;"/>
							<label for="bookedPolicies" style="float: left; height: 20px; padding-top: 3px;">Booked Policies</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="radio" name="unbookedPolicies" id="unbookedPolicies" title="Unbooked Policies" style="float: left;"/>
							<label for="unbookedPolicies" style="float: left; height: 20px; padding-top: 3px;">Unbooked Policies</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="radio" name="allPolicies" id="allPolicies" title="All Policies" style="float: left;"/>
							<label for="allPolicies" style="float: left; height: 20px; padding-top: 3px;">All Policies</label>
						</td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="rdoDiv" style="width: 20%; height:130px; margin: 0 0 8px 4px;">
				<table align = "center" style="padding: 10px;">
					<tr>
						<td>
							<input type="radio" checked="" name="detailed" id="detailed" title="Detailed" style="float: left;"/>
							<label for="detailed" style="float: left; height: 20px; padding-top: 3px;">Detailed</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="radio" name="summary" id="summary" title="Summary" style="float: left;"/>
							<label for="summary" style="float: left; height: 20px; padding-top: 3px;">Summary</label>
						</td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="printDiv" style="width: 51%; height:130px; margin: 0 8px 6px 4px;">
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
									<td style="width:30px;">&nbsp;</td>
									<!-- modified by gab 06.29.2016 SR 22493 -->
									<!-- <td><input type="radio" id="rdoExcel" name="rdoFileType" value="XLS" title="Excel" disabled="disabled" /></td>
									<td><label for="rdoExcel"> Excel</label></td> -->
									<td><input type="radio" id="rdoCSV" name="rdoFileType" value="CSV" title="CSV" disabled="disabled" tabindex="303" /></td>
									<td><label for="rdoCSV"> CSV</label></td>
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
							<input type="text" id="txtNoOfCopies" style="margin-left:5px;float:left; text-align:right; width:136px;" class="integerNoNegativeUnformattedNoComma">
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
	
	setModuleId("GIACS200");
	setDocumentTitle("Collections for Booked/Unbooked Policies");
	initializeAll();
	checkUserAccess();
	setDefaultParams();
	togglePrintFields("screen");
	var reportParam = "GIACR200A";
	var tranPost = "1";
	var paramOption = "1";
	
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
			if ($("detailed").checked){
				reportParam = "GIACR200A";
			} else {
				reportParam = "GIACR200B";
			}
			
			if ($("bookedPolicies").checked){
				paramOption = "1";	
			} else if ($("unbookedPolicies").checked) {
				paramOption = "2";
			} else {
				paramOption = "3";
			}
			//added by gab 06.17.2016 SR 22493
			if("file" == $F("selDestination")){
				if ($(rdoCSV).checked && $("detailed").checked){
					reportParam = "GIACR200A_CSV";
				}else if ($(rdoCSV).checked && $("summary").checked){
					reportParam = "GIACR200B_CSV";
				}
			}
			
			var content = contextPath + "/BookedUnbookedCollectionsPrintController?action=printReport"
            + "&reportId=" + reportParam
            + "&paramOption=" + paramOption
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
							
						}
					}
				});
			} else if("file" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "file",
								//edited by gab 06.17.2016 SR 22493
								//fileType : $("rdoPdf").checked ? "PDF" : "XLS"},
								  fileType : $("rdoPdf").checked ? "PDF" : "CSV2"},
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							//edited by gab 06.17.2016 SR 22493
							//copyFileToLocal(response);
							if (fileType = "CSV2"){
								copyFileToLocal(response, "csv");
								deleteCSVFileFromServer(response.responseText);
							}else{ 
								copyFileToLocal(response);
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
		+ "&toDate=" + $("txtToDate").value
		+ "&tranPost=" + tranPost;
		
		return params;
	}
	
	$("bookedPolicies").observe("click", function(){
		$("unbookedPolicies").checked = false;
		$("allPolicies").checked = false;
	});
	
	$("unbookedPolicies").observe("click", function(){
		$("bookedPolicies").checked = false;
		$("allPolicies").checked = false;
	});
	
	$("allPolicies").observe("click", function(){
		$("bookedPolicies").checked = false;
		$("unbookedPolicies").checked = false;
	});
	
	$("detailed").observe("click", function(){
		$("summary").checked = false;
	});
	
	$("summary").observe("click", function(){
		$("detailed").checked = false;
	});
	
	$("chkPostingDate").observe("click", function(){
		$("chkTranDate").checked = false;
		tranPost = "2";
		whenCheckBoxChangePT("P");
	});
	
	$("chkTranDate").observe("click", function(){
		$("chkPostingDate").checked = false;
		tranPost = "1";
		whenCheckBoxChangePT("T");
	});
	
	function whenCheckBoxChangePT(option){
		if ($("chkPostingDate").checked || $("chkTranDate").checked){
			null;
		} else {
			if (option == "P") {
				$("chkTranDate").checked = true;
				tranPost = "1";
			} else {
				$("chkPostingDate").checked = true;
				tranPost = "2";
			}
		}
	}
	
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
	
	$("branchCd").setAttribute("lastValidValue", "");
	$("searchBranchCd").observe("click", showGIACS200BranchLOV);
	$("branchCd").observe("change", function() {		
		if($F("branchCd").trim() == "") {
			$("branchCd").value = "";
			$("branchCd").setAttribute("lastValidValue", "");
			$("branchName").value = "";
		} else {
			if($F("branchCd").trim() != "" && $F("branchCd") != $("branchCd").readAttribute("lastValidValue")) {
				showGIACS200BranchLOV();
			}
		}
	});
	$("branchCd").observe("keyup", function(){
		$("branchCd").value = $F("branchCd").toUpperCase();
	});
	
	function showGIACS200BranchLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGeneralBranchLOV",
							moduleId :  "GIACS200",
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
	
	/* $("searchBranchCd").observe("click", function(){
		fetchBranchLOV();
	});
	
	function fetchBranchLOV(){
		LOV.show({
			controller: 'AccountingLOVController',
			urlParameters: {
				action:		"fetchSimpleBranchLOV",
				moduleId:   "GIACS200"  
			},
			title: "Valid Values for Branches",
			width: 405,
			height: 386,
			draggable: true,
			columnModel: [
				{
					id: "branchCd",
					title: "Branch Code",
					width: "100px"
				},
				{
					id: "branchName",
					title: "Branch Name",
					width: "310px"
				}
			],
			onSelect: function(row){
				if(row != undefined){
					$("branchCd").value = row.branchCd;
					$("branchName").value = row.branchName;
				}
			}
		});
	} */
	
	function setDefaultParams(){
		$("chkPostingDate").checked = false;
		$("chkTranDate").checked = true;
	}
	
	
	function checkUserAccess(){
		try{
			new Ajax.Request(contextPath+"/GIACAccTransController?action=checkUserAccess2", {
				method: "POST",
				parameters: {
					moduleName: "GIACS200"
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
	
	//modified by gab 06.29.2016 SR 22493
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
			$("rdoCSV").disable();
		} else {
			if(destination == "file"){
				$("rdoPdf").enable();
				//$("rdoExcel").enable();
				$("rdoCSV").enable();
			} else {
				$("rdoPdf").disable();
				//$("rdoExcel").disable();
				$("rdoCSV").disable();
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

</script>


