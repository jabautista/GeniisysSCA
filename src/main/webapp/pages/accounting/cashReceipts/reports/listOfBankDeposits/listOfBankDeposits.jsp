<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="listOfDepositsDiv">
	<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label>List of Deposits</label>
		<span class="refreshers" style="margin-top: 0;">
 			<label id="btnReloadForm" name="gro" style="margin-left: 5px;">Reload Form</label>
		</span>
	</div>
</div>
	<div class="sectionDiv">
		<div style="margin: 30px auto; width: 630px; border: 1px solid #E0E0E0; padding: 3px;">
			<div style="border: 1px solid #E0E0E0; padding: 15px 0;">
				<table align="center">
					<tr>
						<td><label for="chkPostingDate" style="margin-left: 40px;">Posting Date</label></td>
						<td><input type="checkbox" id="chkPostingDate" style="margin-left: 40px; margin-right: 40px;" tabindex="101"/></td>
						<td><label for="chkTranDate">Transaction Date</label></td>
						<td><input type="checkbox" id="chkTranDate" style="margin-left: 40px; margin-right: 40px;" tabindex="102"/></td>
					</tr>
				</table>
			</div>
			<div style="border: 1px solid #E0E0E0; margin-top: 2px; padding: 15px 0;">
				<table align="center">
					<tr>
						<td><label for="txtFromDate" style="float: right;">From</label></td>
						<td style="padding-left: 5px;">
							<div style="float: left; width: 140px; height: 20px; margin: 0;" class="withIconDiv required">
								<input type="text" id="txtFromDate" class="withIcon required" readonly="readonly" style="width: 116px;" tabindex="201"/>
								<img id="imgFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="" style="margin : 1px 1px 0 0; cursor: pointer"/>
							</div>
						</td>
						<td><label for="txtToDate" style="float: right; margin-left: 10px;">To</label></td>
						<td style="padding-left: 5px; width: 100px;">
							<div style="float: left; width: 140px; height: 20px; margin: 0;" class="withIconDiv required">
								<input type="text" id="txtToDate" class="withIcon required" readonly="readonly" style="width: 116px;" tabindex="202"/>
								<img id="imgToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="" style="margin : 1px 1px 0 0; cursor: pointer"/>
							</div>
						</td>
					</tr>
					<tr>
						<td><label for="txtBranchCd" style="float: right;">Branch</label></td>
						<td style="padding-left: 5px;" colspan="3">
							<span class="lovSpan" style="width: 70px; margin-bottom: 0;">
								<input type="text" id="txtBranchCd" style="width: 45px; float: left;" class="withIcon allCaps"  maxlength="2" tabindex="204" lastValidValue=""/>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgBranchCd" alt="Go" style="float: right;" />
							</span>
							<input type="text" id="txtBranchName" readonly="readonly" style="margin: 0; height: 14px; width: 297px; margin-left: 2px;" tabindex="205"/>
						</td>
					</tr>
					<tr>
						<td><label for="txtBankAcctCd" style="float: right;">Bank Account</label></td>
						<td style="padding-left: 5px;" colspan="3">
							<span class="lovSpan" style="width: 70px; margin-bottom: 0;">
								<input type="text" id="txtBankAcctCd" style="width: 45px; float: left;" class="withIcon integerNoNegative"  maxlength="3"  tabindex="206"/>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgBankAcctCd" alt="Go" style="float: right;" />
							</span>
							<input type="text" id="txtBankAcct" readonly="readonly" style="margin: 0; height: 14px; width: 297px; margin-left: 2px;" tabindex="207"/>
						</td>
					</tr>
				</table>
			</div>
			<div style="width: 100%; margin-top: 2px;">
				<div style="border: 1px solid #E0E0E0; width: 150px; height: 130px; float: left;">
					<table align="center" style="height: 55%; margin-top: 25px;">
						<tr>
							<td width="20px;">
								<input type="radio" id="rdoByBranch" name="opt1" tabindex="301" />
							</td>
							<td><label for="rdoByBranch">by Branch</label></td>
						</tr>
						<tr>
							<td>
								<input type="radio" id="rdoByBankAcct" name="opt1" tabindex="302" />
							</td>
							<td><label for="rdoByBankAcct">by Bank Account</label></td>
						</tr>
					</table>
				</div>
				<div style="border: 1px solid #E0E0E0; width: 150px; height: 130px; float: left; margin: 0 2px;">
					<table align="center" style="height: 55%; margin-top: 25px;">
						<tr>
							<td width="20px;">
								<input type="radio" id="rdoLayout1" name="opt2" tabindex="303"/>
							</td>
							<td><label for="rdoLayout1">Layout 1</label></td>
						</tr>
						<tr>
							<td>
								<input type="radio" id="rdoLayout2" name="opt2" tabindex="304"/>
							</td>
							<td><label for="rdoLayout2">Layout 2</label></td>
						</tr>
					</table>
				</div>
				<div id="printDiv" style="border: 1px solid #E0E0E0; height: 130px; width: 320px; float: left;">
					<table align="center" style="margin-top: 10px;">
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
								<input value="CSV" title="CSV" type="radio" id="rdoCSV" name="fileType" tabindex="307" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoCSV" style="margin: 2px 0 4px 0">CSV</label> <!-- edited by MarkS 7.7.2016 SR-5533 -->
								<!-- <input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="fileType" tabindex="307" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoExcel" style="margin: 2px 0 4px 0">Excel</label> -->
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
								<input type="text" id="txtNoOfCopies" tabindex="309" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma">
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
			<div>
				<input type="button" class="button" value="Print" tabindex="401" id="btnPrint" style="width: 120px; margin: 10px auto;"/>
			</div>
		</div>
	</div>
</div>
<script>
	try {
		
		
		var onLOV = false;
		var checkBankAcctCd = "";
		var checkBranchCd = "";
		
		function initGIACS281(){
			setModuleId("GIACS281");
			setDocumentTitle("List of Bank Deposits");
			$("chkTranDate").checked = true;
			$("txtBankAcct").value = "ALL BANK ACCOUNTS";
			$("txtBranchName").value = "ALL BRANCHES";
			$("rdoByBranch").checked = true;
			$("rdoLayout1").checked = true;
		}
		
		function resetForm() {
			onLOV = false;
			
			$("chkTranDate").checked = true;
			$("chkPostingDate").checked = false;
			$("txtFromDate").clear();
			$("txtToDate").clear();
			$("txtBankAcctCd").clear();
			$("txtBankAcct").value = "ALL BANK ACCOUNTS";
			$("txtBranchCd").clear();
			$("txtBranchName").value = "ALL BRANCHES";
			$("selDestination").selectedIndex = 0;
			toggleRequiredFields("screen");
			checkBankAcctCd = "";
			checkBranchCd = "";
			$("rdoByBranch").checked = true;
			$("rdoLayout1").checked = true;
		}
		
		$("btnReloadForm").observe("click", resetForm);
		//$("btnReloadForm").observe("click", showGIACS281);
		
		function getGIACS281BankAcctLOV() {
			if(onLOV) return;
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS281BankAcctLOV",
					searchString : checkBankAcctCd == "" ? $("txtBankAcctCd").value : "",
					page : 1
				},
				title : "Bank Accounts",
				width : 459,
				height : 386,
				columnModel : [ 
					{
						id : "bankAcctCd",
						title : "Bank Cd",
						width : '90px',
					},
					{
						id : "bankSname",
						title : "Bank Sname",
						width : '90px',
						renderer: function(value) {
							return unescapeHTML2(value);
						}
					},
					{
						id : "bankAcct",
						title : "Bank Account",
						width : '200px',
						renderer: function(value) {
							return unescapeHTML2(value);
						}
					},
					{
						id : "branchCd",
						title : "Branch",
						width : '60px'
					},
				],
				draggable : true,
				autoSelectOneRecord: true,
				filterText:  checkBankAcctCd == "" ? $("txtBankAcctCd").value : "",
				onSelect : function(row) {
					onLOV = false;
					$("txtBankAcctCd").value = row.bankAcctCd;
					$("txtBankAcct").value = row.bankAcct;
					checkBankAcctCd = row.bankAcctCd;
				},
				onCancel : function () {
					onLOV = false;
					$("txtBankAcctCd").value = checkBankAcctCd;
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBankAcctCd");
					onLOV = false;
					$("txtBankAcctCd").value = checkBankAcctCd;
				}
			});
		}
		
		$("imgBankAcctCd").observe("click", getGIACS281BankAcctLOV);
		
		function getGIACS281BranchLOV() {
			if(onLOV) return;
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS281BranchLOV",
					searchString : checkBranchCd != $F("txtBranchCd") ? $("txtBranchCd").value : "",
					moduleId: 'GIACS281',
					page : 1
				},
				title : "Valid Values for Branches",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "branchCd",
					title : "Branch Code",
					width : '120px',
				}, {
					id : "branchName",
					title : "Branch Name",
					width : '345px',
					renderer: function(value) {
						return unescapeHTML2(value);
					}
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText:  checkBranchCd == "" ? $("txtBranchCd").value : "",
				onSelect : function(row) {
					onLOV = false;
					$("txtBranchCd").value = row.branchCd;
					$("txtBranchName").value = row.branchName;
					$("txtBankAcctCd").focus();
					checkBranchCd = row.branchCd;
				},
				onCancel : function () {
					onLOV = false;
					$("txtBranchCd").value = checkBranchCd;
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchCd");
					onLOV = false;
					$("txtBranchCd").value = checkBranchCd;
				}
			});
		}
		
		$("imgBranchCd").observe("click", getGIACS281BranchLOV);
		
		$("txtBankAcctCd").observe("change", function(){
			if(this.value.trim() == ""){
				this.clear();
				checkBankAcctCd = "";
				$("txtBankAcct").value = "ALL BANK ACCOUNTS";
			} else {
				getGIACS281BankAcctLOV();	
			}
		});
		
		$("txtBranchCd").observe("change", function(){
			if(this.value.trim() == ""){
				this.clear();
				checkBranchCd = "";
				$("txtBranchName").value = "ALL BRANCHES";
			} else {
				getGIACS281BranchLOV();	
			}
		});

		$("chkTranDate").observe("click", function(){
			if(this.checked)
				$("chkPostingDate").checked = false;
			else
				$("chkPostingDate").checked = true;
		});
		
		$("chkPostingDate").observe("click", function(){
			if(this.checked)
				$("chkTranDate").checked = false;
			else
				$("chkTranDate").checked = true;
		});
		
		$("imgFromDate").observe("click", function(){
			scwShow($("txtFromDate"), this, null);
		});
		
		$("imgToDate").observe("click", function(){
			scwShow($("txtToDate"), this, null);
		});
		
		$("txtFromDate").observe("focus", function(){
			if ($("imgFromDate").disabled == true) return;
			
			var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) :"";
			var sysdate = new Date();
			var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
			
			if (fromDate > sysdate && fromDate != ""){
				customShowMessageBox("Date should not be greater than the current date.", "I", "txtFromDate");
				$("txtFromDate").clear();
				return false;
			}
			
			if (toDate < fromDate && toDate != ""){
				customShowMessageBox("From Date should be earlier than To Date.", "I", "txtFromDate");
				$("txtFromDate").clear();
				return false;
			}
		});
	 	
	 	$("txtToDate").observe("focus", function(){
			if ($("imgToDate").disabled == true) return;
			
			var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
			var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) :"";
			var sysdate = new Date();
			
			if (toDate > sysdate && toDate != ""){
				customShowMessageBox("Date should not be greater than the current date.", "I", "txtToDate");
				$("txtToDate").clear();
				return false;
			}
			
			if (toDate < fromDate && toDate != ""){
				customShowMessageBox("From Date should be earlier than To Date.", "I", "txtToDate");
				$("txtToDate").clear();
				return false;
			}
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
					$("rdoCSV").disable();				
			} else {
				if(dest == "file"){
					$("rdoPdf").enable();
					$("rdoCSV").enable();
				} else {
					$("rdoPdf").disable();
					$("rdoCSV").disable();
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
		
		toggleRequiredFields("screen");
		
		$("txtBankAcct").observe("focus", function(){
			if($("txtBankAcctCd").value != ""){
				var response = validateField("/GIACCashReceiptsReportController", "validateGIACS281BankAcctCd");
				if(response == "ERROR") {
					$("txtBankAcctCd").clear();
					getGIACS281BankAcctLOV();
				} else {
					$("txtBankAcct").value = unescapeHTML2(response);
				}
			}
		});
		
		$("txtBranchCd").observe("focus", function(){
			if($("txtBankAcctCd").value != ""){
				var response = validateField("/GIACCashReceiptsReportController", "validateGIACS281BankAcctCd");
				if(response == "ERROR") {
					$("txtBankAcctCd").clear();
					getGIACS281BankAcctLOV();
				} else {
					$("txtBankAcct").value = unescapeHTML2(response);
				}
			}
		});
		
		$("txtBranchName").observe("focus", function(){
			if($("txtBranchCd").value != ""){
				var response = validateField("/GIACBranchController","validateGIACBranchCd");
				if(response == "ERROR") {
					//customShowMessageBox("Invalid Branch Code", "E", "txtBranchCd");
					$("txtBranchCd").clear();
					getGIACS281BranchLOV();
				} else {
					$("txtBranchName").value = unescapeHTML2(response);
				}
			}
		});
		
		$("txtBankAcctCd").observe("focus", function(){
			if($("txtBranchCd").value != ""){
				var response = validateField("/GIACBranchController","validateGIACBranchCd");
				if(response == "ERROR") {
					//customShowMessageBox("Invalid Branch Code", "E", "txtBranchCd");
					$("txtBranchCd").clear();
					getGIACS281BranchLOV();
				} else {
					$("txtBranchName").value = unescapeHTML2(response);
				}
			}
		});
		
		function validateField(controller, action) {
			var ajaxResponse = "";
			var bankAcctCd = $("txtBankAcctCd").value;
			var branchCd = $("txtBranchCd").value;
			
			new Ajax.Request(contextPath + controller,{
				method: "POST",
				parameters: {
						     action : action,
						     bankAcctCd : bankAcctCd,
						     branchCd : branchCd,
						     moduleId : "GIACS281"
				},
				asynchronous: false,
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						ajaxResponse = trim(response.responseText);
					}
				}
			});
			
			return ajaxResponse;
		}
		
		function getParams(){
			var dateOpt = $("chkTranDate").checked ? "T" : "P";
			var params = "&bankAcctCd=" + $("txtBankAcctCd").value
						+ "&branchCd=" + $("txtBranchCd").value
						+ "&tranPost=" + dateOpt
						+ "&fromDate=" + $("txtFromDate").value
						+ "&toDate=" + $("txtToDate").value;
			return params;
		}
		
		function printReport(){
			try {
				var repId = "";
				
				if($("rdoByBranch").checked) {
// 					edited by MarkS SR5533 7.12.2016
					if($("rdoLayout1").checked){
						if("file" == $F("selDestination")){
							if($("rdoPdf").checked){
								repId = "GIACR281";
							}	
							else {
								repId = "GIACR281_CSV";
							}
					    } else {
					    	repId = "GIACR281";
					    }
					} else{
						if("file" == $F("selDestination")){
							if($("rdoPdf").checked){
								repId = "GIACR281A";
							}	
							else {
								repId = "GIACR281A_CSV";
							}
					    } else {
					    	repId = "GIACR281A";
					    }
					}
				} else {
					if($("rdoLayout1").checked){
						if("file" == $F("selDestination")){
							if($("rdoPdf").checked){
								repId = "GIACR282";
							}	
							else {
								repId = "GIACR282_CSV";
							}
					    } else {
					    	repId = "GIACR282";
					    }
					} else{
						if("file" == $F("selDestination")){
							if($("rdoPdf").checked){
								repId = "GIACR282A";
							}	
							else {
								repId = "GIACR282A_CSV";
							}
					    } else {
					    	repId = "GIACR282A";
					    }
					}
				}
				 
				var content = contextPath + "/CashReceiptsReportPrintController?action=printReport"
						                  + "&reportId=" + repId
						                  + getParams()
						                  + "&noOfCopies=" + $F("txtNoOfCopies")
						                  + "&printerName=" + $F("selPrinter")
						                  + "&destination=" + $F("selDestination");
			
				if("screen" == $F("selDestination")){
					showPdfReport(content, "");
				}else if($F("selDestination") == "printer"){
					new Ajax.Request(content, {
						parameters : {noOfCopies : $F("txtNoOfCopies")},
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
									  fileType : $("rdoPdf").checked ? "PDF" : "CSV2"},
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response){
							hideNotice();
							//edited by MarkS 8.17.16 SR5535 for filepath of the csv
							if (checkErrorOnResponse(response)){
								if($("rdoPdf").checked){
									copyFileToLocal(response, "reports");
								} else{
									copyFileToLocal(response, "csv");	
								}
								
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
				showErrorMessage("printReport", e);
			}
		}
		
		$("btnPrint").observe("click", function(){
			if($("txtFromDate").value == "")
				customShowMessageBox("Required fields must be entered.", "I", "txtFromDate");
			else if ($("txtToDate").value == "")
				customShowMessageBox("Required fields must be entered.", "I", "txtToDate");
			else {
				
				if($("txtBankAcctCd").value != ""){
					var response = validateField("/GIACCashReceiptsReportController", "validateGIACS281BankAcctCd");
					if(response == "ERROR") {
						customShowMessageBox("Invalid Line Code", "E", "txtBankAcctCd");
						$("txtBankAcctCd").clear();
						return;
					} else {
						$("txtBankAcct").value = unescapeHTML2(response);
					}
				}
			
			
				if($("txtBranchCd").value != ""){
					var response = validateField("/GIACBranchController", "validateGIACBranchCd");
					if(response == "ERROR") {
						customShowMessageBox("Invalid Branch Code", "E", "txtBranchCd");
						$("txtBranchCd").clear();
						return;
					} else {
						$("txtBranchName").value = unescapeHTML2(response);
					}
				}
				
				var dest = $F("selDestination");
				
				if(dest == "printer"){
					if(checkAllRequiredFieldsInDiv("printDiv")){
						printReport();
					}
				}else{
					printReport();
				}	
			}
				
		});
		
		initGIACS281();
		initializeAll(); 
	} catch (e) {
		showErrorMessage("Direct Premium Collections", e);
	}
</script>