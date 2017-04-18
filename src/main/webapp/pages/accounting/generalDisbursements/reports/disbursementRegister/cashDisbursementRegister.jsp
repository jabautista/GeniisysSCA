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
   			<label>Cash Disbursement Register</label>
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
				<table border="0" align="center" style="margin:20px 0 0 0; width:100%;">
					<tr>
						<td style="width:33%;">
							<input type="radio" name="radioDates" id="rdoDVDate" style="float:left; margin: 3px 2px 3px 100px;" tabindex="201" />
							<label for="rdoDVDate" style="float: left; height: 20px; padding-top: 3px;" title="DV Date">&nbsp;DV Date</label>
						</td>
						<td style="width:33%">
							<input type="radio" name="radioDates" id="rdoCheckDate" style="float: left; margin: 3px 2px 3px 40px;" tabindex="202" />
							<label for="rdoCheckDate" style="float: left; height: 20px; padding-top: 3px;" title="Check Date">&nbsp;Check Date</label>
						</td>
						<td style="width:33%">
							<input type="radio" name="radioDates" id="rdoCheckPrintDate" style="float: left; margin: 3px 2px 3px 0;" tabindex="203" />
							<label for="rdoCheckPrintDate" style="float: left; height: 20px; padding-top: 3px;" title="Check Print Date">&nbsp;Check Print Date</label>
						</td>
					</tr>
				</table>
				<table border="0" align="center" style="margin:10px 0 20px 0; width:530px;">
					<tr>
						<td class="rightAligned">From</td>
						<td class="leftAligned">
							<div style="float:left; width:165px;" class="withIconDiv required">
								<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon required" readonly="readonly" style="width: 140px;" tabindex="101"/>
								<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" tabindex="102"/>
							</div>
						</td>
						<td class="rightAligned" style="width:45px;">To</td>
						<td class="leftAligned">
							<div style="float:left; width:165px;" class="withIconDiv required">
								<input type="text" id="txtToDate" name="txtToDate" class="withIcon required" readonly="readonly" style="width: 140px;" tabindex="103"/>
								<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex="104"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Branch</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan" style="width: 76px; margin-top: 5px;">
								<input type="text" id="txtBranchCd" name="txtBranchCd" lastValidValue="" maxlength="2" style="width: 50px; float: left; border: none; height: 14px; margin: 0;" class="upper" tabindex="105"/>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osBranchCd" name="osBranchCd" alt="Go" style="float: right;" tabindex="106"/>
							</span>
							<input type="text" id="txtBranchName" name="txtBranchName" value="ALL BRANCHES" style="width: 340px; float: left; margin: 5px;  height: 14px;" class="upper" tabindex="107"/>							
						</td>
					</tr>						
				</table>
			</div> <!-- end: searchParamsDiv -->
			
			<div id="radioParamsDiv2" name="radioParamsDiv2" class="sectionDiv" style="width:40%; height:150px; margin: 0 0 10px 10px;" >
				<table align="center" style="margin:10px 0 20px 5px;">
					<tr>
						<td>
							<input type="radio" name="reportTag" id="rdoDetailed" style="float: left; margin: 3px 2px 3px 20px;" tabindex="301" />
							<label for="rdoDetailed" style="float: left; padding-top: 3px;" title="Detailed">&nbsp;Detailed</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="radio" name="reportTagDetailOpt" id="rdoDvNo" style="float: left; margin-left:40px;" tabindex="302" />
							<label for="rdoDvNo" style="float: left; padding-top: 3px;" title="DV No.">&nbsp;DV No.</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="radio" name="reportTagDetailOpt" id="rdoCheckNo" style="float: left; margin-left: 40px;" tabindex="303" />
							<label for="rdoCheckNo" style="float: left; padding-top: 3px;" title="Check No.">&nbsp;Check No.</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="radio" name="reportTag" id="rdoSummary" style="float: left; margin: 3px 2px 3px 20px;" tabindex="304" />
							<label for="rdoSummary" style="float: left; padding-top: 3px;" title="Summary">&nbsp;Summary</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="chkAcctgEntryPerBranch" id="chkAcctgEntryPerBranch" style="float: left; margin: 3px 2px 3px 20px;" tabindex="305" />
							<label for="chkAcctgEntryPerBranch" style="float: left; padding-top: 3px;" title="Accounting Entry Per Branch">&nbsp;Accounting Entry Per Branch</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="radio" name="reportTag" id="rdoPurchase" style="float: left; margin: 3px 2px 3px 20px;" tabindex="306" />
							<label for="rdoPurchase" style="float: left; padding-top: 3px;" title="Purchase Register">&nbsp;Purchase Register</label>
						</td>
					</tr>
				</table>
			</div> <!-- end: radioParamsDiv2 -->
				
			<div id="printDiv"class="sectionDiv" style="width:362px; height:150px; margin-left: 2px;">
				<div style="float:left; margin-left:20px;" id="printDialogFormDiv">
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
			
			<div id="printBtnDiv" name="printButtonDiv" class="buttonsDiv" style="margin: 5px 0 10px 0;">
				<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width:90px;" />
			</div>
		</div> <!-- end: paramsDiv -->
	</div> <!-- end: moduleDiv -->

</div>

<script>

	setModuleId("GIACS118");
	setDocumentTitle("Cash Disbursement Register");
	initializeAll();
	makeInputFieldUpperCase();
	toggleRequiredFields("screen");
	initializeDefaultValues();
	observeChangeTagOnDate("hrefFromDate", "txtFromDate", observeFromDateOnChange);
	observeChangeTagOnDate("hrefToDate", "txtToDate", observeToDateOnChange);
	
	var isChecked = false;
	
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
			$("csvRB").disable(); 
		} else {
			if(dest == "file"){
				$("rdoPdf").enable();
				$("rdoExcel").enable();
				$("csvRB").enable();
			} else {
				$("rdoPdf").disable();
				$("rdoExcel").disable();
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
		$("rdoDVDate").checked = true;
		$("rdoDetailed").checked = true;
		$("rdoDvNo").checked = true;
		$("chkAcctgEntryPerBranch").checked = true;
	}
	
	function getGiacs118BranchCdLOV(fieldName, fieldValue){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGIACS118BranchLOV",
							filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : "%"),
							moduleId: "GIACS118",
							page : 1},
			title : "Valid Values for Branch Name",
			width: 405,
			height: 386,
			columnModel : [ {
								id : "branchCd",
								title : "Branch Code",
								width : '120px',
							}, {
								id : "branchName",
								title : "Branch Name",
								width : '270px'
							} ],
			autoSelectOneRecord: true,
			filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : "%"),
			onSelect: function(row) {
				$("txtBranchCd").value = row.branchCd;
				$("txtBranchCd").setAttribute("lastValidValue", row.branchCd);
				$("txtBranchName").value = unescapeHTML2(row.branchName);
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
		function displayAfterPrint(){
			showMessageBox("Printing complete.", "I");
		}
		
		try {
			if(checkAllRequiredFieldsInDiv("printDiv")){
				var fileType = "";
				var postTranToggle = ""; //v_post_tran_toggle
				var dvCheckToggle = "";  //v_dv_check_toggle
				var branchChk = "";
				var withCsv = null;
				if($("rdoPdf").disabled == false && $("rdoExcel").disabled == false){
					if($("rdoPdf").checked){
						fileType = "PDF";
					}else if ($("rdoExcel").checked){
						fileType = "XLS";
					}else if ($("csvRB").checked){
						withCsv = 'Y';
						fileType = "CSV";
					}
				}
				
				if($("chkPostingDate").checked){
					postTranToggle = "P";
				} else {
					postTranToggle = "T";	
					/* if($("rdoDVDate").checked){
						dvCheckToggle = "D";
					} else {
						dvCheckToggle = $("rdoCheckDate").checked == true ? "C" : "P";
					} */
				}
				if($("rdoDVDate").checked){
					dvCheckToggle = "D";
				} else {
					dvCheckToggle = $("rdoCheckDate").checked == true ? "C" : "P";
				}
				
				if($("rdoDetailed").checked && $("chkAcctgEntryPerBranch").checked){
					branchChk = "Y";
				} else if($("rdoDetailed").checked){
					branchChk = "N";	
				} else if($("rdoSummary").checked && $("chkAcctgEntryPerBranch").checked){
					branchChk = "Y";
				} else if($("rdoSummary").checked){
					branchChk = "N";
				} else if($("rdoPurchase").checked){
					branchChk = "";
				}
				
				var content = contextPath+"/GeneralDisbursementPrintController?action=printGiacs118Reports"
							+ "&noOfCopies=" + $F("txtNoOfCopies")
							+ "&printerName=" + $F("selPrinter")
							+ "&destination=" + $F("selDestination")
							+ "&reportId=" + reportId
							+ "&reportTitle=" + reportTitle
							+ "&fileType=" + fileType
							+ "&moduleId=" + "GIACS118"
							
							+ "&fromDate=" + $F("txtFromDate")
							+ "&toDate=" + $F("txtToDate")
							+ "&branchCd=" + $F("txtBranchCd")
							+ "&dvCheck=" + ($("rdoDvNo").checked ? "V" : "CH")
							+ "&branchChk=" + branchChk
							+ "&postTranToggle=" + postTranToggle
							+ "&dvCheckToggle=" + dvCheckToggle;

				var thisFunc = $F("selDestination") == "printer" ? displayAfterPrint : null;
				printGenericReport(content, reportTitle, thisFunc, withCsv); 
			}
		} catch(e){
			showErrorMessage("printReport", e);
		}
	}
	
	observeReloadForm("reloadForm", showGiacs118);
	
	$("chkPostingDate").observe("click", function(){
		$("chkTransactionDate").checked = ($("chkPostingDate").checked == true) ? false : true;
		$("rdoDVDate").disabled 		= ($("chkPostingDate").checked == true) ? true : false;
		$("rdoCheckDate").disabled 		= ($("chkPostingDate").checked == true) ? true : false;
		$("rdoCheckPrintDate").disabled = ($("chkPostingDate").checked == true) ? true : false;		
	});
	
	$("chkTransactionDate").observe("click", function(){
		$("chkPostingDate").checked 	= ($("chkTransactionDate").checked == true) ? false : true;
		$("rdoDVDate").disabled 		= ($("chkTransactionDate").checked == true) ? false : true;
		$("rdoCheckDate").disabled 		= ($("chkTransactionDate").checked == true) ? false : true;
		$("rdoCheckPrintDate").disabled = ($("chkTransactionDate").checked == true) ? false : true;		
	});

	$("hrefFromDate").observe("click", function(){
		scwShow($('txtFromDate'),this, null);
	});
	
	$("hrefToDate").observe("click", function(){
		scwShow($('txtToDate'),this, null);
	});
	$("txtFromDate").observe("change", observeFromDateOnChange);
	function observeFromDateOnChange(){
		if($F("txtFromDate") != "" && $F("txtToDate") == ""){
			var today = Date.parse($F("txtFromDate"), 'mm-dd-yyyy');//**
			var lastDayOfMonth = new Date(today.getFullYear(), today.getMonth()+1, 0);
			$("txtToDate").value = dateFormat(lastDayOfMonth, 'mm-dd-yyyy');
		} else if($F("txtFromDate") != "" && $F("txtToDate") != ""){
			checkFromToDates("txtFromDate");
		}
	}
	$("txtToDate").observe("blur", function(){
		if($F("txtFromDate") != "" && $F("txtToDate") == ""){
			if(!isChecked){
				var today = Date.parse($F("txtFromDate"), 'mm-dd-yyyy');
				var lastDayOfMonth = new Date(today.getFullYear(), today.getMonth()+1, 0);
				$("txtToDate").value = dateFormat(lastDayOfMonth, 'mm-dd-yyyy');
			} else {
				$("txtToDate").value = "";
				isChecked = false;
			}
		} else {
			observeToDateOnChange();
		}
	});
	function observeToDateOnChange(){
		if($F("txtFromDate") != "" && $F("txtToDate") != ""){
			checkFromToDates("txtToDate");
		}
	}
	
	function checkFromToDates(fieldId){
		var elemDateFr = Date.parse($F("txtFromDate"), "mm-dd-yyyy");
		var elemDateTo = Date.parse($F("txtToDate"), "mm-dd-yyyy");
		var output = compareDatesIgnoreTime(elemDateFr, elemDateTo);
		if(output < 0){
			isChecked = true;
			$(fieldId).value = "";
			customShowMessageBox("From Date should not be later than To Date.", "I", fieldId);						
		}
	}
	
	$("osBranchCd").observe("click", getGiacs118BranchCdLOV);	
	$("txtBranchCd").observe("change", function() {		
		if($F("txtBranchCd").trim() == "") {
			$("txtBranchCd").value = "";
			$("txtBranchCd").setAttribute("lastValidValue", "");
			$("txtBranchName").value = "ALL BRANCHES";
		} else {
			if($F("txtBranchCd").trim() != "" && $F("txtBranchCd") != $("txtBranchCd").readAttribute("lastValidValue")) {
				getGiacs118BranchCdLOV();
			}
		}
	});
	$("txtBranchCd").observe("keyup", function(event){
		$("txtBranchName").value = $F("txtBranchName").toUpperCase();
	});
	
	$("rdoDetailed").observe("click", function(){
		$("rdoDvNo").disabled = false;
		$("rdoCheckNo").disabled = false;
		$("rdoSummary").disabled = false;
		$("chkAcctgEntryPerBranch").disabled = false;
		$("rdoPurchase").disabled = false;
	});
	
	$("rdoSummary").observe("click", function(){
		$("rdoDvNo").disabled = true;
		$("rdoCheckNo").disabled = true;
		$("chkAcctgEntryPerBranch").disabled = false;
	});
	
	$("rdoPurchase").observe("click", function(){
		$("rdoDvNo").disabled = true;
		$("rdoCheckNo").disabled = true;
		$("chkAcctgEntryPerBranch").disabled = true;
	});
	
	$("btnPrint").observe("click", function(){
		var proceedToPrint = true;
		var elemDateFr = Date.parse($F("txtFromDate"), "mm-dd-yyyy");
		var elemDateTo = Date.parse($F("txtToDate"), "mm-dd-yyyy");
		
		if(checkAllRequiredFieldsInDiv("searchParamsDiv")){
			var output = compareDatesIgnoreTime(elemDateFr, elemDateTo);
			if(output < 0){
				proceedToPrint = false;
				customShowMessageBox("From Date should be earlier than To Date.", "I", "txtFromDate");
			}
			
			if(proceedToPrint){
				if($("rdoDetailed").checked){
					validateReportId("GIACR118","Cash Disbursement Register");
				} else if($("rdoPurchase").checked){
					validateReportId("GIACR118C","Purchase Register");
				} else {
					validateReportId("GIACR118B","Cash Disbursement (Summary)");
				}
			}
		}
	});
	
	$("txtNoOfCopies").observe("change", function(){
		if(isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0 || $F("txtNoOfCopies") > 100){
			showWaitingMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", function(){
				$("txtNoOfCopies").value = "1";
			});			
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