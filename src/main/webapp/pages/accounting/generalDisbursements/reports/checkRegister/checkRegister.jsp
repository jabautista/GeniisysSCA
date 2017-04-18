<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>

<div id="checkRegisterMainDiv" name="checkRegisterMainDiv">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
   			<label>Check Register</label>
   			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	
	<div id="moduleDiv" name="moduleDiv" class="sectionDiv" >
		
		<div id="paramsDiv" name="paramsDiv" class="sectionDiv" style="width:70%; margin: 40px 120px 40px 130px;">
			<div id="chkDatesParamsDiv" name="chkDatesParamsDiv" class="sectionDiv" align="center" style="width:96.7%; height:50px; margin:10px 10px 2px 10px;">
				<table border="0" style="margin-top:15px; width:100%;">
					<tr>
						<td><input type="checkbox" id="chkPostingDate" name="chkPostingDate" style="margin-left:120px; float:left;"/>
							<label for="chkPostingDate" id="lblChkPostingDate" style="float:left;">&nbsp; Posting Date</label></td>
						<td><input type="checkbox" id="chkTransactionDate" name="chkTransactionDate" style="margin-left:0px; float:left;" />
							<label for="chkTransactionDate" id="lblChkTransactionDate" style="float:left;">&nbsp; Transaction Date</label></td>
					</tr>
				</table>
			</div>
			
			<div id="searchParamsDiv" name="searchParamsDiv" class="sectionDiv" align="center" style="width:96.7%; margin:0 10px 2px 10px;">
				<table border="0" align="center" style="margin:10px 0 20px 0; width:575px;">
					<tr>
						<td class="rightAligned"></td>
						<td class="leftAligned" colspan="3">
							<input id="cbParticulars" type="checkbox" style="margin-right:5px; float:left;">
							<label id="lblParticulars" style="float:left;" for="cbParticulars" title="Particulars">Particulars</label>
						</td>
					</tr>	
					<tr>
						<td class="rightAligned">From</td>
						<td class="leftAligned">
							<div style="float:left; width:165px;" class="withIconDiv">
								<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="101"/>
								<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" tabindex="102"/>
							</div>
						</td>
						<td class="rightAligned" style="width:40px;">To</td>
						<td class="leftAligned">
							<div style="float:left; width:164px;" class="withIconDiv">
								<input type="text" id="txtToDate" name="txtToDate" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="103"/>
								<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex="104"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Branch</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan" style="width: 76px; margin-right: 2px;">
								<input type="text" id="txtBranchCd" name="txtBranchCd" lastValidValue="" style="width: 50px; float: left; border: none; height: 14px; margin: 0;" class="upper" tabindex="105" maxlength="2"/>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osBranchCd" name="osBranchCd" alt="Go" style="float: right;" tabindex="106"/>
							</span>
							<input type="text" id="txtBranchName" name="txtBranchName" value="ALL BRANCHES" style="width: 340px; float: left; height: 14px; margin: 0;" class="upper" maxlength="50" readonly="readonly" tabindex="107"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Bank Account</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan" style="width: 76px; margin-right: 2px;">
								<input type="text" id="txtBankAcctCd" name="txtBankAcctCd" lastValidValue="" style="width: 50px; float: left; border: none; height: 14px; margin: 0;" class="upper" maxlength="3" tabindex="109"/>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osBankAcctCd" name="osBankAcctCd" alt="Go" style="float: right;" tabindex="110"/>
							</span>
							<input type="text" id="txtBankAcctName" name="txtBankAcctName" value="ALL BANK ACCOUNTS" style="width: 340px; float: left; height: 14px; margin: 0;" class="upper" maxlength="10" readonly="readonly" tabindex="111"/>
							<input type="hidden" id="hidBankAcctNo" name="hidBankAcctNo" />
							<input type="hidden" id="hidBranchBank" name="hidBranchBank" />
							<input type="hidden" id="hidBranchCd" name="hidBranchCd" />
						</td>
					</tr>	
				</table>
			</div> <!-- end: searchParamsDiv -->
			
			<div id="radioParamsDiv2" name="radioParamsDiv2" class="sectionDiv" style="width:33%; height:150px; margin: 0 0 10px 10px;" >
				<table border="0" style="margin:10px 0 20px 25px;">
					<tr height="30px">
						<td style="text-align:left;">Sort by:</td>
					</tr>
					<tr>
						<td>
							<input type="radio" name="sortBy" id="rdoCheckDate" style="float: left; margin: 3px 2px 3px 30px;" tabindex="301" />
							<label for="rdoCheckDate" style="float: left; padding-top: 3px;" title="Date">&nbsp;Date</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="radio" name="sortBy" id="rdoCheckNo" style="float: left; margin: 3px 2px 3px 30px;" tabindex="302" />
							<label for="rdoCheckNo" style="float: left; padding-top: 3px;" title="Check No.">&nbsp;Check No.</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="radio" name="sortBy" id="rdoRefNo" style="float: left; margin: 3px 2px 3px 30px;" tabindex="303" />
							<label for="rdoRefNo" style="float: left; padding-top: 3px;" title="Ref No.">&nbsp;Ref No.</label>
						</td>
					</tr>
				</table>
			</div> <!-- end: radioParamsDiv2 -->
				
			<div id="printDiv" class="sectionDiv" style="width:407px; height:150px; margin-left: 2px;">
				<div style="float:left; margin-left:20px; margin-top:10px;" id="printDialogFormDiv">
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
								<!-- removed print to excel option by robert SR 5197 02.02.16 
								<input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="fileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoExcel" style="margin: 2px 0 4px 0">Excel</label> -->
								<input value="CSV" title="CSV" type="radio" id="csvRB" name="fileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="csvRB" style="margin: 2px 0 4px 0">CSV</label>
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
								<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" maxlength="3" class="required integerNoNegativeUnformattedNoComma">
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
			
			<div id="printBtnDiv" name="printButtonDiv" class="buttonsDiv" style="margin: 5px 0 15px 0;">
				<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width:90px;" />
			</div>
		</div> <!-- end: paramsDiv -->
	</div> <!-- end: moduleDiv -->

</div>

<script>

	setModuleId("GIACS135");
	setDocumentTitle("Check Register");
	initializeAll();
	makeInputFieldUpperCase();
	toggleRequiredFields("screen");
	initializeDefaultValues();
	
	var onLOV = false; // checks if an LOV overlay is displayed
	
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
			//$("rdoExcel").disable(); removed print to excel option by robert SR 5197 02.02.16 
			$("csvRB").disable(); 
		} else {
			if(dest == "file"){
				$("rdoPdf").enable();
				//$("rdoExcel").enable(); removed print to excel option by robert SR 5197 02.02.16 
				$("csvRB").enable(); 
			} else {
				$("rdoPdf").disable();
				//$("rdoExcel").disable(); removed print to excel option by robert SR 5197 02.02.16 
				$("csvRB").disable(); 
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
		$("chkTransactionDate").click();
		$("rdoCheckDate").checked = true;
		$("hrefFromDate").focus();
	}
	
	function getGiacs118BranchCdLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action : "getGIACS135BranchLOV",
				moduleId : "GIACS135",
				filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : "")
			},
			title: "Valid Values for Branch Name",
			width: 405,
			height: 386,
			columnModel:[
			             	{	id : "branchCd",
								title: "Branch Code",
								width: '80px'
							},
							{	id : "branchName",
								title: "Branch Name",
								width: '308px'
							}
						],
			draggable: true,
			filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : "%"),
			autoSelectOneRecord: true,
			onSelect : function(row){
				if(row != undefined) {
					$("txtBranchCd").value = row.branchCd;
					$("txtBranchName").value = unescapeHTML2(row.branchName);
					$("txtBranchCd").setAttribute("lastValidValue", row.branchCd);
				}
			},
	  		onCancel: function(){
	  			$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
	  		},
	  		onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});		
	}
	
	function getBankAcctNoLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action : "getGIACS135BankAcctNoLOV",
				moduleId : "GIACS135",
				filterText : ($("txtBankAcctCd").readAttribute("lastValidValue").trim() != $F("txtBankAcctCd").trim() ? $F("txtBankAcctCd").trim() : "%")
			},
			title: "Bank Accounts",
			width: 500,
			height: 386,
			columnModel : [ {
								id : "bankCd",
								title : "Code",
								width : '50px',
							}, {
								id : "bankName",
								title : "Name",
								width : '90px'
							}, {
								id : "bankAcctNo",
								title : "Bank Account Number",
								width : '150px'
							}, {
								id : "branchBank",
								title : "Branch Bank",
								width : '80px'
							}, {
								id : "branchCd",
								title : "Branch Code",
								width : '80px'
							} 
			],
			draggable: true,
			filterText : ($("txtBankAcctCd").readAttribute("lastValidValue").trim() != $F("txtBankAcctCd").trim() ? $F("txtBankAcctCd").trim() : "%"),
			autoSelectOneRecord: true,
			onSelect : function(row){
				if(row != undefined) {
					$("txtBankAcctCd").value = row.bankCd;
					$("txtBankAcctName").value = unescapeHTML2(row.bankName);
					$("txtBankAcctCd").setAttribute("lastValidValue", row.bankCd);
					$("hidBankAcctNo").value = row.bankAcctNo;
					$("hidBranchBank").value = row.branchBank;
					$("hidBranchCd").value = row.branchCd;
				}
			},
	  		onCancel: function(){
	  			$("txtBankAcctCd").value = $("txtBankAcctCd").readAttribute("lastValidValue");
	  		},
	  		onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtBankAcctCd").value = $("txtBankAcctCd").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});
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
							showMessageBox("No existing records found in GIIS_REPORTS.", "E");
						}
					}
				}
			});
		} catch(e){
			showErrorMessage("validateReportId",e);
		}
	}
	
	function printReport(reportId, reportTitle){
		try {
			if(checkAllRequiredFieldsInDiv("printDiv")){
				var fileType = null;
				var withCsv = null;
				var postTranToggle = ""; //v_post_tran_toggle
				var withParticulars = $("cbParticulars").checked ? "I" : "E";
				
				if($("rdoPdf").disabled == false /*&& $("rdoExcel").disabled == false --removed print to excel option by robert SR 5197 02.02.16 */){
					if($("rdoPdf").checked){
						fileType = "PDF";
					//}else if ($("rdoExcel").checked){ removed print to excel option by robert SR 5197 02.02.16 
					//	fileType = "XLS";
					}else if ($("csvRB").checked){
						fileType = "CSV";
						withCsv = "Y";
					}
				}
				
				if($("chkPostingDate").checked){
					postTranToggle = "P";
				} else if($("chkTransactionDate").checked){
					postTranToggle = "T";					
				}
				var orderBy = ($("rdoCheckDate").checked ? "CHECK_DATE, CHECK_NO" : ($("rdoCheckNo").checked ? "CHECK_NO, CHECK_DATE" : "DV_NO, CHECK_DATE")); //changed by steven 11.19.2014 from REF_NO to DV_NO
				var content = contextPath+"/GeneralDisbursementPrintController?action=printGIACR135"
							+ "&noOfCopies=" + $F("txtNoOfCopies")
							+ "&printerName=" + $F("selPrinter")
							+ "&destination=" + $F("selDestination")
							+ "&reportId=" + reportId
							+ "&reportTitle=" + reportTitle
							+ "&fileType=" + fileType
							+ "&moduleId=" + "GIACS135"	
							+ "&postTranToggle=" + postTranToggle
							+ "&beginDate=" + $F("txtFromDate")
							+ "&endDate=" + $F("txtToDate")
							+ "&branchCd=" + $F("txtBranchCd")
							+ "&bankCd=" + ($F("txtBankAcctName") == "ALL BANK ACCOUNTS" ? "" : $F("txtBankAcctCd"))
							+ "&bankAcctNo=" + ($F("txtBankAcctName") == "ALL BANK ACCOUNTS" ? "" : $F("hidBankAcctNo"))
							+ "&orderBy=" + encodeURIComponent(orderBy)
							+ "&ieParticulars=" + withParticulars;  // value is either E or I
							
							
				//added by MarkS 5/17/2016 SR-5197 copied codes from disbursementList.jsp as there was changes to basecontroller and CsvUtil
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
					
					if ($("rdoPdf").checked)
						fileType = "PDF";
					else
						fileType = "CSV";				
					
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
									if (fileType == "CSV"){ 
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
				//END SR-5197
				//printGenericReport(content, reportTitle,null,withCsv);  
			}
		} catch(e){
			showErrorMessage("printReport", e);
		}
	}
	observeReloadForm("reloadForm", showGiacs135);
	
	$("chkPostingDate").observe("click", function(){
		$("chkTransactionDate").checked = ($("chkPostingDate").checked == true) ? false : true;		
	});
	
	$("chkTransactionDate").observe("click", function(){
		$("chkPostingDate").checked 	= ($("chkTransactionDate").checked == true) ? false : true;
	});

	$("hrefFromDate").observe("click", function(){
		scwShow($('txtFromDate'),this, null);
	});
	
	$("hrefToDate").observe("click", function(){
		scwShow($('txtToDate'),this, null);
	});
	
	function validateDates(fieldName){
		var elemDateFr = Date.parse($F("txtFromDate"), "mm-dd-yyyy");
		var elemDateTo = Date.parse($F("txtToDate"), "mm-dd-yyyy");
		
		if(fieldName == "txtToDate" && $F("txtToDate") == "" && $F("txtFromDate") != ""){
				var today = Date.parse($F("txtFromDate"), 'mm-dd-yyyy');//**
				var lastDayOfMonth = new Date(today.getFullYear(), today.getMonth()+1, 0);
				$("txtToDate").value = dateFormat(lastDayOfMonth, 'mm-dd-yyyy');
		}
		
		if($F("txtToDate") != "" && $F("txtFromDate") != ""){
			var output = compareDatesIgnoreTime(elemDateFr, elemDateTo);
			if(output < 0){
				proceedToPrint = false;
				customShowMessageBox("From Date should not be later than To Date.", "I", fieldName);
				$(fieldName).value = "";
			}
		}
	}
	
	$("txtFromDate").observe("blur", function(){
		validateDates("txtFromDate");
	});
	
	$("txtToDate").observe("blur", function(){
		validateDates("txtToDate");
	});
	
	$("osBranchCd").observe("click", getGiacs118BranchCdLOV);
	
	$("txtBranchCd").observe("change", function(){
		if($F("txtBranchCd").trim() == ""){
			$("txtBranchName").value = "ALL BRANCHES";
			$("txtBranchCd").value = "";
			$("txtBranchCd").setAttribute("lastValidValue", "");
		} else {
			if($F("txtBranchCd").trim() != "" && $F("txtBranchCd") != $("txtBranchCd").readAttribute("lastValidValue")) {
				getGiacs118BranchCdLOV();
			}
		}
	});
	
	$("osBankAcctCd").observe("click", getBankAcctNoLOV);
	
	$("txtBankAcctCd").observe("change", function(){
		if($F("txtBankAcctCd").trim() == ""){
			$("txtBankAcctName").value = "ALL BANK ACCOUNTS";
			$("txtBankAcctCd").value = "";
			$("txtBankAcctCd").setAttribute("lastValidValue", "");
			$("hidBankAcctNo").value = "";
			$("hidBranchBank").value = "";
			$("hidBranchCd").value = "";
		} else {
			if($F("txtBankAcctCd").trim() != "" && $F("txtBankAcctCd") != $("txtBranchCd").readAttribute("lastValidValue")) {
				getBankAcctNoLOV();
			}
		}
	});
	
	$("btnPrint").observe("click", function(){
		var proceedToPrint = true;
		var elemDateFr = Date.parse($F("txtFromDate"), "mm-dd-yyyy");
		var elemDateTo = Date.parse($F("txtToDate"), "mm-dd-yyyy");
		
		if($F("txtFromDate") == "" && $F("txtToDate") == ""){
			proceedToPrint = false;
			customShowMessageBox("Please enter From Date and To Date.", "I", "txtFromDate");
		} 
		if($F("txtFromDate") == ""){
			proceedToPrint = false;
			customShowMessageBox("Please enter From Date.", "I", "txtFromDate");
		}
		if($F("txtToDate") == ""){
			proceedToPrint = false;
			customShowMessageBox("Please enter To Date.", "I", "txtToDate");
		}
		
		if($F("txtFromDate") != "" && $F("txtToDate") != ""){
			var output = compareDatesIgnoreTime(elemDateFr, elemDateTo);
			if(output < 0){
				proceedToPrint = false;
				customShowMessageBox("From Date should not be later than To Date.", "I", "txtFromDate");
			}
		}
		
		if(proceedToPrint){
			validateReportId("GIACR135","Check Register");
		}		
	});
	
	$("txtNoOfCopies").observe("change", function(){
		if( parseInt($F("txtNoOfCopies")) > 100 || parseInt(nvl($F("txtNoOfCopies"), "0")) == 0 ){
			customShowMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", "txtNoOfCopies");
			$("txtNoOfCopies").value = "1";
		}
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
	
</script>