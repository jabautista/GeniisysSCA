<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="distRegisterPolicyPerPerilMainDiv" name="distRegisterPolicyPerPerilMainDiv">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
	   		<label>Distribution Register (Policy Per Peril)</label>
	   	</div>
	</div>
	<div class="sectionDiv" id="distRegisterPolicyPerPerilBody" >
		<div class="sectionDiv" id="distRegisterPolicyPerPeril" style="width: 70%; margin: 40px 138px 40px 138px;">
			<div class="sectionDiv" id="distRegisterPolicyPerPerilInnerDiv" style="width: 97%; margin: 8px 8px 2px 8px;">
				<table id="distRegisterParam" align="center" style="padding: 20px;">
					<tr>
						<td class="rightAligned" style="width: 80px;">From</td>
						<td>
							<div style="float: left; width: 160px;" class="withIconDiv required">
								<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon required" readonly="readonly" style="width: 135px;"/>
								<img id="imgFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"/>
							</div>
						</td>
						<td class="rightAligned" style="width: 68px;">To</td>
						<td>
							<div style="float: left; width: 160px;" class="withIconDiv required">
								<input type="text" id="txtToDate" name="txtToDate" class="withIcon required" readonly="readonly" style="width: 135px;"/>
								<img id="imgToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" id="branchOption" style="width: 80px;">Cred. Branch</td>
						<td colspan="3">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="allCaps"  type="text" id="txtBranchCd" name="txtBranchCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;" maxlength="2"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchCd" name="searchBranchCd" alt="Go" style="float: right;"/>
							</span>
							<input type="text" id="txtBranchName" name="txtBranchName" style="width: 324px; float: left; text-align: left;" value="ALL BRANCHES" readonly="readonly"/>								
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 80px;">Line</td>
						<td colspan="3">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="allCaps"  type="text" id="txtLineCd" name="txtLineCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;" maxlength="2"/>		
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" name="searchLineCd" alt="Go" style="float: right;"/>
							</span>
							<input type="text" id="txtLineName" name="txtLineName" style="width: 324px; float: left; text-align: left;" value="ALL LINES" readonly="readonly"/>								
						</td>
					</tr>
					<tr>
						<td class="rightAligned"></td>
						<td><input checked="checked" type="radio" name="rdoBranchOption" id="rdoCredBranch" title="Crediting Branch" style="float: left; margin-right: 7px;"/><label for="rdoCredBranch" style="float: left; height: 20px; padding-top: 3px;">Crediting Branch</label></td>
						<td colspan="2"><input type="radio" name="rdoBranchOption" id="rdoIssSource" title="Issuing Source" style="float: left; margin-right: 7px;"/><label for="rdoIssSource" style="float: left; height: 20px; padding-top: 3px;">Issuing Source</label></td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="distRegisterPolicyPerPerilInnerDiv" style="width: 97%; margin: 0px 8px 2px 8px;">
				<table align="center" style="padding: 0px;">
					<tr>
						<td style="padding-right: 10px; padding-left: 25px;">
							<input type="button" class="button" id="btnOption" name="btnOption" value="Per Transaction" style="width: 120px; margin-bottom: 10px; margin-top: 10px;">
						</td>
						<td class="rightAligned" style="padding-right: 5px;">Print Report</td>
						<td>
							<select style="width: 180px;" id="printOption" name="printOption" class="mandatoryEnchancement">
								<option></option>
							</select>	
						</td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="rdoPolicyDiv" style="width: 46%; height:130px; margin: 0 0 8px 8px;">
				<table align = "left" style="padding: 15px 0 0 30px;">
					<tr>
						<td>
							<input type="radio" checked="checked" id="rdoPerLineSubline" name="perOption" title="Per line subline" style="float: left; margin-right: 7px;"/>
							<label id="rdoPerLineSublineLabel" for="rdoPerLineSubline" style="float: left; height: 20px; padding-top: 3px;">Per line subline</label>
						</td>
					</tr>
					<tr height="40px">
						<td>
							<input type="radio" id="rdoPerLineSublinePeril" name="perOption" title="Per line subline peril" style="float: left; margin-right: 7px;"/>
							<label id="rdoPerLineSublinePerilLabel" for="rdoPerLineSublinePeril" style="float: left; height: 20px; padding-top: 3px;">Per line subline peril</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="radio" id="rdoPerPolicy" name="perOption" title="Per Policy" style="float: left; margin-right: 7px;"/>
							<label id="rdoPerPolicyLabel" for="rdoPerPolicy" style="float: left; height: 20px; padding-top: 3px;">Per policy</label>
						</td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="printDiv" style="width: 50%; height:130px; margin: 0 8px 6px 4px;">
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
			<div id="buttonsDiv" style="width: 100%; height: 50px; float: left;">
				<table align="center">
					<tbody>
						<tr>
							<td>
								<input id="btnInspection" class="button noChangeTagAttr" type="button" style="display: none; value="Select Inspection" name="btnInspection">
							</td>
							<td>
								<input id="btnExtract"  name="btnExtract" class="button" type="button" style="width: 100px;" value="Extract">
							</td>
							<td>
								<input id="btnPrint" name="btnPrint" class="button" type="button" style="width: 100px;" value="Print">
							</td>
							<td>
								<input id="btnCancel" name="btnCancel" class="button" type="button" style="width: 100px;" value="Cancel">
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	setModuleId("GIACS128");
	setDocumentTitle("Distribution Register (Policy Per Peril)");
	initializeAll();
	checkUserAccess();
	toggleRequiredFields("screen");
	var branchExist = true;
	var lineExist = true;
	var resetBranch = false;
	var resetLine = false;
	var perTransactionY = ["Distribution Register", "Treaty Distribution", "Policy Distribution", "Line per Peril Distribution", "Summarized"];
	var perTransactionN = ["All Policies", "Current Policies", "Negated Policies", "Previously Taken Policies"];
	var paramFromDate;
	var paramToDate;
	
	populateDropDownMenu("Y");
	
	$("btnPrint").observe("click", function(){
		if($F("txtFromDate") == "" || $F("txtToDate") == ""){
			showMessageBox("Required fields must be entered.", "I");
			return false;
		}
		
		if($F("selDestination") == "printer"){
			if($F("selPrinter") == ""){
				showMessageBox("Required fields must be entered.", "I");
				return false;
			}
			
			if(isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") == "" || ($F("txtNoOfCopies") < 1 || $F("txtNoOfCopies") > 100)){
				showMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I");
				$("txtNoOfCopies").value = "";
				return false;
			}
		}	
		
		try {
			var reportId = null;
			var reportTitle = null;
			var pToggle = null;
			var fileType = $("rdoPdf").checked ? "PDF" : "XLS";
			var chkIssueCode = $("rdoCredBranch").checked ? "C" : "I";
		
			if($("btnOption").value == "Per Transaction"){
				if($F("printOption") == "Distribution Register"){
					reportId = 'GIACR198';
					reportTitle = 'Distribution Register';
				} else if($F("printOption") == "Treaty Distribution"){
					reportId = 'GIACR218';
					reportTitle = 'Treaty Distribution Per Peril';
				} else if($F("printOption") == "Policy Distribution"){
					reportId = 'GIACR122';
					reportTitle = 'Distribution Register per Policy';
				} else if($F("printOption") == "Line per Peril Distribution"){
					reportId = 'GIACR123';
					reportTitle = 'Distribution Register per Peril';
				} else if($F("printOption") == "Summarized"){
					reportId = 'GIACR124';
					reportTitle = 'Distribution Register per Line';
				}
				
				if($("rdoPerLineSubline").checked){
					pToggle = 'A';
				} else if($("rdoPerLineSublinePeril").checked){
					pToggle = 'P';
				} else if($("rdoPerPolicy").checked){
					pToggle = 'E';
				}
			} else if($("btnOption").value == "Back"){
				if($F("printOption") == "All Policies" && $("rdoPerLineSubline").checked){
					reportId = 'GIACR246';
					reportTitle = 'Distribution Register of All Policies(Summary)';
				} else if($F("printOption") == "Current Policies" && $("rdoPerLineSubline").checked){
					reportId = 'GIACR247';
					reportTitle = 'Distribution Register of Current Policies(Summary)';
				} else if($F("printOption") == "Negated Policies" && $("rdoPerLineSubline").checked){
					reportId = 'GIACR248';
					reportTitle = 'Distribution Register of Negated Policies(Summary)';
				} else if($F("printOption") == "Previously Taken Policies" && $("rdoPerLineSubline").checked){
					reportId = 'GIACR249';
					reportTitle = 'DISTRIBUTION REGISTER OF PREVIOUSLY TAKEN UP POLICIES PER LINE SUBLINE';
				} else if($F("printOption") == "All Policies" && $("rdoPerLineSublinePeril").checked){
					reportId = 'GIACR242';
					reportTitle = 'Distribution Register of All Policies(Detailed)';
				} else if($F("printOption") == "Current Policies" && $("rdoPerLineSublinePeril").checked){
					reportId = 'GIACR243';
					reportTitle = 'Distribution Register of Current Policies(Detailed)';
				} else if($F("printOption") == "Negated Policies" && $("rdoPerLineSublinePeril").checked){
					reportId = 'GIACR244';
					reportTitle = 'Distribution Register of Negated Policies(Detailed)';
				} else if($F("printOption") == "Previously Taken Policies" && $("rdoPerLineSublinePeril").checked){
					reportId = 'GIACR245';
					reportTitle = 'Distribution Register of Previously Taken Policies(Detailed)';
				} else if($F("printOption") == "All Policies" && $("rdoPerPolicy").checked){
					reportId = 'GIACR260';
					reportTitle = 'DISTRIBUTION REGISTER OF ALL POLICIES';
				} else if($F("printOption") == "Current Policies" && $("rdoPerPolicy").checked){
					reportId = 'GIACR261';
					reportTitle = 'DISTRIBUTION REGISTER OF CURRENTLY TAKEN POLICIES (DETAILED)';
				} else if($F("printOption") == "Negated Policies" && $("rdoPerPolicy").checked){
					reportId = 'GIACR262';
					reportTitle = 'DISTRIBUTION REGISTER OF NEGATED POLICIES (DETAILED)';
				} else if($F("printOption") == "Previously Taken Policies" && $("rdoPerPolicy").checked){
					reportId = 'GIACR263';
					reportTitle = 'DISTRIBUTION REGISTER OF PREVIOUSLY TAKEN UP POLICIES';
				}
			}
			
			var content = contextPath+"/EndOfMonthPrintReportController?action=printReport"
						+"&noOfCopies=" + $F("txtNoOfCopies")
						+"&printerName=" + $F("selPrinter")
						+"&destination=" + $F("selDestination")
						+"&reportId=" + reportId
						+"&reportTitle=" + reportTitle
						+"&fromDate=" + $F("txtFromDate")	
						+"&toDate=" + $F("txtToDate")
						+"&fileType=" + fileType
						+"&chkIssueCode=" + chkIssueCode
						+"&moduleId=" + "GIACS128"
						+"&pToggle=" + pToggle
						+"&lineCd=" + $F("txtLineCd")
						+"&issCd=" + $F("txtBranchCd"); 
			printGenericReport(content, reportTitle);
		} catch (e) {
			showErrorMessage("printReport",e);
		}
	});
	
	$("btnExtract").observe("click", function(){
		checkDates();
		extractRecord();
	});
	
	function extractRecord(){
		try{
			new Ajax.Request(contextPath+"/GIACEndOfMonthReportsController",{
				method: "POST",
				parameters : {action : "giacs128ExtractRecord",
		        			  fromDate : $F("txtFromDate"),
        					  toDate : $F("txtToDate"),
        					  moduleId : "GIACS128",
       						  perBranch : $("rdoCredBranch").checked ? "C" : "I"},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Loading, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						paramFromDate = $F("txtFromDate");
						paramToDate = $F("txtToDate");
						showMessageBox("Extraction Complete. ", imgMessage.SUCCESS);
					}
				}
			});
		} catch (e) {
			showErrorMessage("Extraction Error..",e);
		}
	}
	
	function checkDates(){
		if(paramFromDate == $F("txtFromDate")){
			if(paramToDate == $F("txtToDate")){
				showConfirmBox("Extract", "You have already extracted values with these dates. Do you still want to re-extract?", "Ok", "Cancel", function() {
				   extractRecord();
				}, onCancel, null);
			}
		}
		
		if($F("txtFromDate") == "" || $F("txtToDate") == ""){
			showMessageBox("Required fields must be entered.", "I");
			return false;
		}
	}
	
	function onCancel(){
		return false;
	}
	
	$("btnOption").observe("click", function(){
		if($("btnOption").value == "Per Transaction"){
			$("btnOption").value = "Back";
			populateDropDownMenu("N");
		} else if($("btnOption").value == "Back"){
			$("btnOption").value = "Per Transaction";
			populateDropDownMenu("Y");
		}
	});
	
	function populateDropDownMenu(option){
		var select = document.getElementById("printOption");
		document.getElementById("printOption").options.length = 0;
		
		if(option == "Y"){
			for(var i = 0; i < perTransactionY.length; i++) {
			    var opt = perTransactionY[i];
			    var el = document.createElement("option");
			    el.textContent = opt;
			    el.value = opt;
			    select.appendChild(el);
			}
			document.getElementById('rdoPerLineSublineLabel').innerHTML = "All";
			document.getElementById('rdoPerLineSublinePerilLabel').innerHTML = "Policy";
			document.getElementById('rdoPerPolicyLabel').innerHTML = "Endorsement";
		} else if(option == "N"){
			for(var i = 0; i < perTransactionN.length; i++) {
			    var opt = perTransactionN[i];
			    var el = document.createElement("option");
			    el.textContent = opt;
			    el.value = opt;
			    select.appendChild(el);
			}
			document.getElementById('rdoPerLineSublineLabel').innerHTML = "Per line subline";
			document.getElementById('rdoPerLineSublinePerilLabel').innerHTML = "Per line subline peril";
			document.getElementById('rdoPerPolicyLabel').innerHTML = "Per policy";
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
				customShowMessageBox("From Date should not be later than To Date.","E","txtFromDate");
				this.clear();
			}
		}
	});
	
	$("txtToDate").observe("focus", function(){
		if ($("txtFromDate").value != ""&& this.value != "") {
			if (compareDatesIgnoreTime(Date.parse($F("txtFromDate")),Date.parse($("txtToDate").value)) == -1) {
				customShowMessageBox("From Date should not be later than To Date.","E","txtToDate");
				this.clear();
			}
		}
	});
	
	function checkUserAccess(){
		try{
			new Ajax.Request(contextPath+"/GIACAccTransController?action=checkUserAccess2", {
				method: "POST",
				parameters: {
					moduleName: "GIACS128"
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
		toggleRequiredFields(destination);
	});	
	
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
	
	$("btnCancel").observe("click", function(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	});
	
	function checkPrevExt(){
		new Ajax.Request(contextPath+"/GIACEndOfMonthReportsController?action=checkPrevExt",{
			parameters: {
				
			},
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				if (checkErrorOnResponse(response)){
					var res = JSON.parse(response.responseText);
					if(res.vFromDate != "" || res.vToDate != null){
						$("txtFromDate").value = res.vFromDate;
						$("txtToDate").value = res.vToDate;	
					}
				}
			}
		});
	}
	
	$$("input[name='rdoBranchOption']").each(function(radio){
		radio.observe("click", function(){
			if(this.id == "rdoCredBranch"){
				document.getElementById('branchOption').innerHTML = 'Cred. Branch';
			} else if (this.id == "rdoIssSource"){
				document.getElementById('branchOption').innerHTML = 'Iss. Source';
			}
		});
	});
	
	checkPrevExt();
	
	$("txtBranchCd").setAttribute("lastValidValue", "");
	$("txtBranchName").setAttribute("lastValidValue", "ALL BRANCHES");
	$("searchBranchCd").observe("click", showGiacs128BranchLov);
	$("txtBranchCd").observe("change", function() {		
		if($F("txtBranchCd").trim() == "") {
			$("txtBranchCd").value = "";
			$("txtBranchCd").setAttribute("lastValidValue", "");
			$("txtBranchName").value = "ALL BRANCHES";
			$("txtBranchName").setAttribute("lastValidValue", "ALL BRANCHES");
		} else {
			if($F("txtBranchCd").trim() != "" && $F("txtBranchCd") != $("txtBranchCd").readAttribute("lastValidValue")) {
				showGiacs128BranchLov();
			}
		}
	});
	$("txtBranchCd").observe("keyup", function(){
		$("txtBranchCd").value = $F("txtBranchCd").toUpperCase();
	});
	
	function showGiacs128BranchLov(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGiacs128BranchLov",
							filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : ""),
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
				filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : ""),
				onSelect: function(row) {
					$("txtBranchCd").value = row.branchCd;
					$("txtBranchName").value = row.branchName;
					$("txtBranchCd").setAttribute("lastValidValue", row.branchCd);
					$("txtBranchName").setAttribute("lastValidValue", row.branchName);	
				},
				onCancel: function (){
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
					$("txtBranchName").value = $("txtBranchName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
					$("txtBranchName").value = $("txtBranchName").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("txtLineCd").setAttribute("lastValidValue", "");
	$("txtLineName").setAttribute("lastValidValue", "ALL LINES");
	$("searchLineCd").observe("click", showGiacs128LineLov);
	$("txtLineCd").observe("change", function() {		
		if($F("txtLineCd").trim() == "") {
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").value = "ALL LINES";
			$("txtLineName").setAttribute("lastValidValue", "ALL LINES");
		} else {
			if($F("txtLineCd").trim() != "" && $F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue")) {
				showGiacs128LineLov();
			}
		}
	});
	$("txtLineCd").observe("keyup", function(){
		$("txtLineCd").value = $F("txtLineCd").toUpperCase();
	});
	
	function showGiacs128LineLov(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGiacs128LineLov",
							filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
							page : 1},
			title: "List of Lines",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "lineCd",
								title: "Line Code",
								width: '100px',
								filterOption: true
							},
							{
								id : "lineName",
								title: "Line Name",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
				onSelect: function(row) {
					$("txtLineCd").value = row.lineCd;
					$("txtLineName").value = row.lineName;
					$("txtLineCd").setAttribute("lastValidValue", row.lineCd);
					$("txtLineName").setAttribute("lastValidValue", row.lineName);
				},
				onCancel: function (){
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
					$("txtLineName").value = $("txtLineName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
					$("txtLineName").value = $("txtLineName").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
</script>