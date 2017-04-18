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
   			<label>Commissions Paid Register</label>
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
						<td class="rightAligned">From</td>
						<td class="leftAligned">
							<div style="float:left; width:165px;" class="withIconDiv required">
								<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon required" readonly="readonly" style="width: 140px;" tabindex="101"/>
								<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" tabindex="102"/>
							</div>
						</td>
						<td class="rightAligned" style="width:40px;">To</td>
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
							<span class="lovSpan" style="width: 76px; margin: 3px 2px 0 0;">
								<input type="text" id="txtBranchCd" name="txtBranchCd" lastValidValue="" style="width: 50px; float: left; border: none; height: 12px;" class="upper" maxlength="2" tabindex="105"/>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osBranchCd" name="osBranchCd" alt="Go" style="float: right;" tabindex="106"/>
							</span>
							<input type="text" id="txtBranchName" name="txtBranchName" value="ALL BRANCHES" style="width: 323px; float: left; height: 14px; margin-left: 5px; margin-top: 3px;" class="upper" readonly="readonly" tabindex="107"/>							
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Intermediary Type</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan" style="width: 76px; margin: 3px 2px 0 0;">
								<input type="text" id="txtIntmType" name="txtIntmType" lastValidValue="" style="width: 50px; float: left; border: none; height: 12px;" class="upper" maxlength="30" tabindex="109"/>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osIntmType" name="osIntmType" alt="Go" style="float: right;" tabindex="110"/>
							</span>
							<input type="text" id="txtIntmDesc" name="txtIntmDesc" value="ALL INTERMEDIARY TYPES" style="width: 323px; float: left; height: 14px; margin-left: 5px; margin-top: 3px;" class="upper" readonly="" tabindex="111"/>
						</td>
					</tr>			
				</table>
			</div> <!-- end: searchParamsDiv -->
			
			<div id="radioParamsDiv2" name="radioParamsDiv2" class="sectionDiv" style="width:38%; height:150px; margin: 0 0 10px 10px;" >
				<table border="0" style="margin:10px 0 20px 35px;">
					<tr style="height:30px;">
						<td>
							<input type="radio" name="reportTag" id="rdoPerPolicy" style="float: left; margin: 3px 2px 3px 2px;" tabindex="301" />
							<label for="rdoPerPolicy" style="float: left; padding-top: 3px;" title="Per Policy">&nbsp;Per Policy</label>
						</td>
					</tr>
					<tr style="height:30px;">
						<td>
							<input type="radio" name="reportTag" id="rdoPerLine" style="float: left; margin: 3px 2px 3px 2px;" tabindex="302" />
							<label for="rdoPerLine" style="float: left; padding-top: 3px;" title="Per Line">&nbsp;Per Line</label>
						</td>
					</tr>
					<tr style="height:30px;">
						<td>
							<input type="radio" name="reportTag" id="rdoSummary" style="float: left; margin: 3px 2px 3px 2px;" tabindex="303" />
							<label for="rdoSummary" style="float: left; padding-top: 3px;" title="Summary">&nbsp;Summary</label>
						</td>
					</tr>
					<tr style="height:30px;">
						<td>
							<input type="checkbox" name="chkConsAllBranches" id="chkConsAllBranches" style="float: left; margin: 3px 2px 3px 2px;" tabindex="304" />
							<label for="chkConsAllBranches" style="float: left; padding-top: 3px;" title="Consolidate All Branches">&nbsp;Consolidate All Branches</label>
						</td>
					</tr>
				</table>
			</div> <!-- end: radioParamsDiv2 -->
				
			<div id="printDiv" class="sectionDiv" style="width:375px; height:150px; margin-left: 2px;">
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
								<!-- <input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="fileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoExcel" style="margin: 2px 0 4px 0">Excel</label> Deo [02.15.2017]: comment out (SR-5933)-->
								<input value="CSV" title="CSV" type="radio" id="rdoCSV" name="fileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoCSV" style="margin: 2px 0 4px 0">CSV</label> <!-- Deo [02.15.2017]: SR-5933 -->
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

	setModuleId("GIACS413");
	setDocumentTitle("Commissions Paid Register");
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
			//$("rdoExcel").disable(); //Deo [02.15.2017]: comment out (SR-5933)
			$("rdoCSV").disable(); //Deo [02.15.2017]: SR-5933
		} else {
			if(dest == "file"){
				$("rdoPdf").enable();
				//$("rdoExcel").enable(); //Deo [02.15.2017]: comment out (SR-5933)
				$("rdoCSV").enable(); //Deo [02.15.2017]: SR-5933
			} else {
				$("rdoPdf").disable();
				//$("rdoExcel").disable(); //Deo [02.15.2017]: comment out (SR-5933)
				$("rdoCSV").disable(); //Deo [02.15.2017]: SR-5933
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
		$("rdoPerLine").checked = true;
	}
	
	function getGiacs118BranchCdLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGIACS118BranchLOV",
							moduleId :  "GIACS413",
							filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : ""),
							page : 1},
			title: "Valid Values for Branch Name",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "branchCd",
								title: "Branch Code",
								width: '100px',
								filterOption: true
							},
							{
								id : "branchName",
								title: "Branch Name",
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
					$("txtBranchName").value = unescapeHTML2(row.branchName);
					$("txtBranchCd").setAttribute("lastValidValue", row.branchCd);								
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
	
	function getIntmTypeLOV(){		
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGIACS413IntmTypeLOV",
							moduleId :  "GIACS413",
							filterText : ($("txtIntmType").readAttribute("lastValidValue").trim() != $F("txtIntmType").trim() ? $F("txtIntmType").trim() : "%"),
							page : 1},
			title: "Valid Values For Intermediary Types",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "intmType",
								title : "Type Code",
								width : '120px',
							}, {
								id : "intmDesc",
								title : "Intm Type",
								width : '345px'
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtIntmType").readAttribute("lastValidValue").trim() != $F("txtIntmType").trim() ? $F("txtIntmType").trim() : "%"),
				onSelect: function(row) {
					$("txtIntmType").value = row.intmType;
					$("txtIntmDesc").value = unescapeHTML2(row.intmDesc);
					$("txtIntmType").setAttribute("lastValidValue", row.intmType);								
				},
				onCancel: function (){
					$("txtIntmType").value = $("txtIntmType").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtIntmType").value = $("txtIntmType").readAttribute("lastValidValue");
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
		function callThisAfterPrint(){
			showMessageBox("Printing complete.", "I");	
		}
		
		try {
			if(checkAllRequiredFieldsInDiv("printDiv")){
				var fileType = "";
				var paramTranPost = ""; //P_TRAN_POST
				
				if($("rdoPdf").disabled == false && $("rdoCSV"/*"rdoExcel"*/).disabled == false){ //Deo [02.15.2017]: replace excel with csv (SR-5933)
					fileType = $("rdoPdf").checked ? "PDF" : "CSV" /*"XLS"*/;	//Deo [02.15.2017]: replace excel with csv (SR-5933)
				}
				
				if($("chkPostingDate").checked){
					paramTranPost = "2";
				} else if($("chkTransactionDate").checked){
					paramTranPost = "1";					
				}
				
				var content = contextPath+"/GeneralDisbursementPrintController?action=printGIACS413Reports"
							+ "&noOfCopies=" + $F("txtNoOfCopies")
							+ "&printerName=" + $F("selPrinter")
							+ "&destination=" + $F("selDestination")
							+ "&reportId=" + reportId
							+ "&reportTitle=" + reportTitle
							+ "&fileType=" + fileType
							+ "&moduleId=" + "GIACS413"
							
							+ "&paramTranPost=" + paramTranPost
							+ "&fromDate=" + $F("txtFromDate")  //p_from_dt
							+ "&toDate=" + $F("txtToDate")		//p_to_dt
							+ "&branchCd=" + $F("txtBranchCd")
							+ "&intmType=" + ($F("txtIntmDesc") == "ALL INTERMEDIARY TYPES" ? "" : $F("txtIntmType"));

				var thisFunc = $F("selDestination") == "printer" ? callThisAfterPrint : null;
				printGenericReport(content, reportTitle, thisFunc, fileType == "CSV" ? "Y" : "");  //Deo [02.15.2017]: added csv condition (SR-5933)
			}
		} catch(e){
			showErrorMessage("printReport", e);
		}
	}
	
	observeReloadForm("reloadForm", showGiacs413);
	
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
	
	$("txtFromDate").observe("change", observeFromDateOnChange);
	function observeFromDateOnChange(){
		/*if($F("txtFromDate") != "" && $F("txtToDate") == ""){
			var today = Date.parse($F("txtFromDate"), 'mm-dd-yyyy');//**
			var lastDayOfMonth = new Date(today.getFullYear(), today.getMonth()+1, 0);
			$("txtToDate").value = dateFormat(lastDayOfMonth, 'mm-dd-yyyy');
		} else*/ if($F("txtFromDate") != "" && $F("txtToDate") != ""){
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
	
	/*$("txtToDate").observe("blur", function(){
		if($F("txtFromDate") != "" && $F("txtToDate") == ""){
			var today = Date.parse($F("txtFromDate"), 'mm-dd-yyyy');
			var lastDayOfMonth = new Date(today.getFullYear(), today.getMonth()+1, 0);
			$("txtToDate").value = dateFormat(lastDayOfMonth, 'mm-dd-yyyy');
		}
	});*/
	
	$("osBranchCd").observe("click", getGiacs118BranchCdLOV);
	$("txtBranchCd").observe("change", function(){
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
	
	$("osIntmType").observe("click", getIntmTypeLOV);
	$("txtIntmType").observe("change", function(){
		if($F("txtIntmType").trim() == "") {
			$("txtIntmType").value = "";
			$("txtIntmType").setAttribute("lastValidValue", "");
			$("txtIntmDesc").value = "ALL INTERMEDIARY TYPES";
		} else {
			if($F("txtIntmType").trim() != "" && $F("txtIntmType") != $("txtIntmType").readAttribute("lastValidValue")) {
				getIntmTypeLOV();
			}
		}
	});	
	
	$("chkConsAllBranches").observe("click", function(){
		if($("chkConsAllBranches").checked){
			$("txtBranchCd").value = "";
			$("txtBranchName").value = "ALL BRANCHES";
			disableSearch("osBranchCd"); //added by steven 11.21.2014
			$("txtBranchCd").readOnly = true; //added by steven 11.21.2014
			$("txtBranchCd").setAttribute("lastValidValue", "");	
		} else {
			enableSearch("osBranchCd"); //added by steven 11.21.2014
			$("txtBranchCd").readOnly = false; //added by steven 11.21.2014
		}
	});
	
	$("txtNoOfCopies").observe("change", function(){
		if($F("txtNoOfCopies").trim() != "" && (isNaN($F("txtNoOfCopies")) || parseInt($F("txtNoOfCopies")) <= 0 || parseInt($F("txtNoOfCopies")) > 100)){
			showWaitingMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", function(){
				$("txtNoOfCopies").value = "";
			});			
		}
	});
	
	$("btnPrint").observe("click", function(){
		var proceedToPrint = true;
		
		if(checkAllRequiredFieldsInDiv("printDiv") && checkAllRequiredFieldsInDiv("searchParamsDiv")){
			var elemDateFr = Date.parse($F("txtFromDate"), "mm-dd-yyyy");
			var elemDateTo = Date.parse($F("txtToDate"), "mm-dd-yyyy");
			
			var output = compareDatesIgnoreTime(elemDateFr, elemDateTo);
			if(output < 0){
				proceedToPrint = false;
				customShowMessageBox("From Date should be earlier than To Date.", "I", "txtFromDate");
			}
			
			if(proceedToPrint){
				if($("chkConsAllBranches").checked){
					if($("rdoPerLine").checked){
						validateReportId("GIACR413C","Commissions Paid Register (Consolidated - Detail)");
					} else if($("rdoSummary").checked){
						validateReportId("GIACR413D","Commissions Paid Register (Consolidated - Detail)");
					} else if($("rdoPerPolicy").checked){
						validateReportId("GIACR413E","Commissions Paid Register Per Branch (Detail)");
					} 
				} else {
					if($("rdoPerLine").checked){
						validateReportId("GIACR413A","Commissions Paid Register Per Branch (Detail)");
					} else if($("rdoSummary").checked){
						validateReportId("GIACR413B","Commissions Paid Register Per Branch (Summary)");
					} else if($("rdoPerPolicy").checked){
						validateReportId("GIACR413F","Commissions Paid Register Per Branch (Detail)");
					} 
				}
				
			}
		}
		
		/*var elemDateFr = Date.parse($F("txtFromDate"), "mm-dd-yyyy");
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
				customShowMessageBox("From Date should be earlier than To Date.", "I", "txtFromDate");
			}
		}
		
		if(proceedToPrint){
			if($("chkConsAllBranches").checked){
				if($("rdoPerLine").checked){
					validateReportId("GIACR413C","Commissions Paid Register (Consolidated - Detail)");
				} else if($("rdoSummary").checked){
					validateReportId("GIACR413D","Commissions Paid Register (Consolidated - Detail)");
				} else if($("rdoPerPolicy").checked){
					validateReportId("GIACR413E","Commissions Paid Register Per Branch (Detail)");
				} 
			} else {
				if($("rdoPerLine").checked){
					validateReportId("GIACR413A","Commissions Paid Register Per Branch (Detail)");
				} else if($("rdoSummary").checked){
					validateReportId("GIACR413B","Commissions Paid Register Per Branch (Summary)");
				} else if($("rdoPerPolicy").checked){
					validateReportId("GIACR413F","Commissions Paid Register Per Branch (Detail)");
				} 
			}
			
		}	*/	
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