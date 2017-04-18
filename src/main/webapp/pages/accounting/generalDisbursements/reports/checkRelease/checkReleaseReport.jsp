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
   			<label>Check Release Report</label>
	   	</div>
	</div>
	
	<div id="moduleDiv" name="moduleDiv" class="sectionDiv" >
		
		<div id="paramsDiv" name="paramsDiv" class="sectionDiv" style="width:70%; margin: 40px 120px 40px 130px;">
			
			<div id="searchParamsDiv" name="searchParamsDiv" class="sectionDiv" align="center" style="width:96.7%; margin:10px 10px 2px 10px;">
				<table border="0" align="center" style="margin:10px 0 10px 0; width:575px;">
					<tr id="trFromToDate">
						<td id="tdFromDateLbl" class="rightAligned" style="width:85px;">From</td>
						<td id="tdFromDate" class="leftAligned">
							<div id="fromDateDiv" style="float:left; width:165px;" class="withIconDiv required">
								<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon required" readonly="readonly" style="width: 140px;" tabindex="101"/>
								<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" tabindex="102"/>
							</div>
						</td>
						<td id="tdToDateLbl" class="rightAligned" style="width:63px;">To</td>
						<td id="tdToDate" class="leftAligned">
							<div id="toDateDiv" style="float:left; width:165px;" class="withIconDiv required" changetagAttr="true">
								<input type="text" id="txtToDate" name="txtToDate" class="withIcon required" readonly="readonly" style="width: 140px;" tabindex="103"/>
								<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex="104"/>
							</div>
						</td>
					</tr>
					<tr id="trCutOffDate">
						<td id="tdCutOffDateLbl" class="rightAligned" style="width:85px;">Cut Off Date</td>
						<td id="tdCutOffDate" class="leftAligned">
							<div id="cutOffDateDiv" style="float:left; width:165px;" class="withIconDiv required">
								<input type="text" id="txtCutOffDate" name="txtCutOffDate" class="withIcon required" readonly="readonly" style="width: 140px;" tabindex="101"/>
								<img id="hrefCutOffDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="CutOff Date" tabindex="102"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width:85px;">Branch</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan" style="width: 90px; margin-right: 2px;">
								<input type="text" id="txtBranchCd" name="txtBranchCd" style="width: 50px; float: left; border: none; height: 14px; margin: 0;" class="upper" tabindex="105" maxlength="2" />  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osBranchCd" name="osBranchCd" alt="Go" style="float: right;" tabindex="106" />
							</span>
							<input type="text" id="txtBranchName" name="txtBranchName" value="ALL BRANCHES" style="width:340px; float: left; height: 14px; margin: 0;" class="upper" tabindex="107" maxlength="50" readonly="readonly" />							
						</td>
					</tr>					
				</table>
			</div> <!-- end: searchParamsDiv -->
			
			<div id="radioParamsDiv2" name="radioParamsDiv2" class="sectionDiv" style="width:32.9%; height:150px; margin: 0 0 10px 10px;" >
				<table border="0" style="margin:40px 0 20px 25px;">
					<tr style="height:30px;">
						<td>
							<input type="radio" name="checkType" id="rdoReleasedChecks" style="float: left; margin: 3px 2px 3px 10px;" tabindex="301" />
							<label for="rdoReleasedChecks" style="float: left; padding-top: 3px;" title="Date">&nbsp;Released Checks</label>
						</td>
					</tr>
					<tr style="height:30px;">
						<td>
							<input type="radio" name="checkType" id="rdoUnreleasedChecks" style="float: left; margin: 3px 2px 3px 10px;" tabindex="302" />
							<label for="rdoUnreleasedChecks" style="float: left; padding-top: 3px;" title="Check No.">&nbsp;Unreleased Checks</label>
						</td>
					</tr>					
				</table>
			</div> <!-- end: radioParamsDiv2 -->
				
			<div id="printDiv" class="sectionDiv" style="width:408px; height:150px; margin-left: 2px;">
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
								<!-- <input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="fileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoExcel" style="margin: 2px 0 4px 0">Excel</label> Dren Niebres 05.03.2016 SR-5355-->
								<input value="CSV2" title="CSV" type="radio" id="rdoCsv" name="fileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoCsv" style="margin: 2px 0 4px 0">CSV</label> <!-- Dren Niebres 05.03.2016 SR-5355 -->
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
								<input type="text" id="txtNoOfCopies" maxlength="3" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma">
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
	var onLOV = false; // checks if an LOV overlay is displayed
	var onCalDisp = false;
	//var proceedToPrint = true;
	
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
			//$("rdoExcel").disable(); //Dren Niebres 05.03.2016 SR-5355			
			$("rdoCsv").disable(); //Dren Niebres 05.03.2016 SR-5355
		} else {
			if(dest == "file"){
				$("rdoPdf").enable();
				//$("rdoExcel").enable(); //Dren Niebres 05.03.2016 SR-5355			
				$("rdoCsv").enable(); //Dren Niebres 05.03.2016 SR-5355
			} else {
				$("rdoPdf").disable();
				//$("rdoExcel").disable(); //Dren Niebres 05.03.2016 SR-5355			
				$("rdoCsv").disable(); //Dren Niebres 05.03.2016 SR-5355
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
		$("rdoReleasedChecks").checked = true;
		$("trCutOffDate").hide();
		$("txtFromDate").focus();
		
		var today = new Date();
		var lastDayOfMonth = new Date(today.getFullYear(), today.getMonth(), 1);
		$("txtFromDate").value = dateFormat(lastDayOfMonth, 'mm-dd-yyyy');
		$("txtToDate").value = dateFormat(today, 'mm-dd-yyyy');
	//	$("txtCutOffDate").value = dateFormat(new Date(), 'mm-dd-yyyy');
	}
	
	function getGiacs184BranchCdLOV(fieldName, fieldValue, isIconClicked){
		if(onLOV) return;
		
		var searchString = isIconClicked ? "%" : (($F(fieldName).trim() == "" || $F(fieldName).trim() == "ALL BRANCHES") ? "%" : $F(fieldName));
		onLOV = true;
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action : "getGIACS184BranchLOV",
				searchString : searchString, //+"%", //(fieldValue.trim() == "" ? "%" : fieldValue+"%"),	// SR-2842 : shan 07.14.2015
				//filterText: ($F(fieldName).trim() == "" ? "%" : $F(fieldName)),
				moduleId: 'GIACS184',
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
				width : '345px'
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			filterText: escapeHTML2(searchString), //($F(fieldName).trim() == "" ? "%" : $F(fieldName)+"%"),
			onSelect : function(row) {
				onLOV = false;
				if(row != null || row != undefined){
					$("txtBranchCd").value = row.branchCd;
					$("txtBranchName").value = row.branchName;
				}
			},
			onCancel: function(){
				onLOV = false;
				if($F("txtBranchName") == "" && $F("txtBranchCd") == ""){
					$("txtBranchName").value = "ALL BRANCHES";
				}
				$(fieldName).focus();
				//customShowMessageBox("No record selected.", imgMessage.INFO, fieldName);				
			},
			onUndefinedRow : function(){
				onLOV = false;
				customShowMessageBox("No record selected.", imgMessage.INFO, fieldName);
			} 
		});
	}
	
	function validateBranchCd2(fieldName, fieldValue, isIconClicked){
		//var searchString = isIconClicked ? "%" : (($F(fieldName).trim() == "" || $F(fieldName).trim() == "ALL BRANCHES") ? "%" : $F(fieldName)+"%");
		
		var cond = validateTextFieldLOV("/AccountingLOVController?action=getGIACS184BranchLOV"
						//+ "&searchString=" + (fieldValue.trim() == "" ? "%" : fieldValue) //+"%"
						+ "&moduleId=GIACS184"
						+ "&filterText=" + (($F(fieldName).trim() == "" || $F(fieldName).trim() == "ALL BRANCHES") ? "%" : encodeURIComponent($F(fieldName)))
						, ($F(fieldName).trim() == "" ? "%" : $F(fieldName))
						, "");
		if (cond > 1) {
			getGiacs184BranchCdLOV(fieldName, fieldValue, isIconClicked);
		} else if(cond < 1) {
			fieldValue = "";
			getGiacs184BranchCdLOV(fieldName, fieldValue, isIconClicked);
		} else if(cond.total == 1 && !isIconClicked){
			getGiacs184BranchCdLOV(fieldName, fieldValue, isIconClicked);
		} else if(cond.total == 1 && isIconClicked){
			if(($F("txtBranchCd") != cond.branchCd && $F("txtBranchName") != cond.branchName) ||
					($F("txtBranchCd") == "" && $F("txtBranchName") == "ALL BRANCHES") ){
				getGiacs184BranchCdLOV(fieldName, fieldValue, isIconClicked);
			} else {
				$("txtBranchCd").value = cond.branchCd == null ? "" : cond.branchCd;
				$("txtBranchName").value = cond.branchName == null ? "ALL BRANCHES" : cond.branchName;
			}
		} else {
			getGiacs184BranchCdLOV(fieldName, fieldValue, isIconClicked);
		}
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
				var fileType = "";
				var reportId; //Dren Niebres 05.03.2016 SR-5355 - Start
				
				if($("rdoReleasedChecks").checked){
					if($F("selDestination") == "file") { 
						if ($("rdoPdf").checked) 
							reportId = "GIACR186";
						else 
							reportId = "GIACR186_CSV";		
					} else {
						reportId = "GIACR186";
					}									
				} else {
					if($F("selDestination") == "file") { 
						if ($("rdoPdf").checked) 
							reportId = "GIACR185";
						else 
							reportId = "GIACR185_CSV";		
					} else {
						reportId = "GIACR185";
					}						
				}
					
				if($("rdoPdf").disabled == false && $("rdoCsv").disabled == false){ 
					fileType = $("rdoPdf").checked ? "PDF" : "CSV2"; 
				}					
					
				var content = contextPath+"/GeneralDisbursementPrintController?action=printGIACS184Reports"
							+ "&noOfCopies=" + $F("txtNoOfCopies")
							+ "&printerName=" + $F("selPrinter")
							+ "&destination=" + $F("selDestination")
							+ "&reportId=" + reportId
							+ "&reportTitle=" + reportTitle
							+ "&fileType=" + fileType
							+ "&moduleId=" + "GIACS184"
							
							+ "&fromDate=" + $F("txtFromDate")
							+ "&toDate=" + $F("txtToDate")
							+ "&cutOffDate=" + $F("txtCutOffDate")
							+ "&asOfDate=" //+ dateFormat(new Date(), 'mm-dd-yyyy') //$F("txtCutOffDate")
							+ "&branchCd=" + $F("txtBranchCd")
							 
							// additional params for GIACR186
							+ "&paramNull=" + "0"
							+ "&paramCleared=" + "N";

				if (fileType == "CSV2"){
					printGenericReport(content, reportTitle, null,"csv");
				} else 
					printGenericReport(content, reportTitle); //Dren Niebres 05.03.2016 SR-5355 - End
			}
		} catch(e){
			showErrorMessage("printReport", e);
		}
	}
	
	function validateDates(fieldName){
		var elemDateFr = Date.parse($F("txtFromDate"), "mm-dd-yyyy");
		var elemDateTo = Date.parse($F("txtToDate"), "mm-dd-yyyy");
		
		if($F("txtToDate") != "" && $F("txtFromDate") != ""){
			var output = compareDatesIgnoreTime(elemDateFr, elemDateTo);
			if(output < 0){
				$(fieldName).value = "";
				customShowMessageBox("From Date should not be later than To Date.", "I", fieldName);
			}
		}
	}
	
	function validateDateFrom(){
		validateDates('txtFromDate');
	}
	function validateDateTo(){
		validateDates('txtToDate');
	}
	
	$("hrefFromDate").observe("click", function(){
		scwShow($('txtFromDate'),this, null);
	});
	
	$("hrefToDate").observe("click", function(){
		scwShow($('txtToDate'),this, null);
	});
	
	$("hrefCutOffDate").observe("click", function(){
		scwShow($('txtCutOffDate'),this, null);
	});
	
	$("osBranchCd").observe("click", function(){
		var fieldVal = $F("txtBranchCd");
		validateBranchCd2("txtBranchCd", fieldVal, true);
	});
	
	$("txtBranchCd").observe("change", function(){
		if($F("txtBranchCd") == "" && ($F("txtBranchName") == "" || $F("txtBranchName") == "ALL BRANCHES")){
			$("txtBranchName").value = "ALL BRANCHES";
			$("txtBranchCd").value = "";
		} else {
			var fieldVal = $F("txtBranchCd");
			validateBranchCd2("txtBranchCd", fieldVal, false);
		}
	});
	
	$("txtBranchCd").observe("keypress", function(event){
		if(event.keyCode == objKeyCode.ENTER) {
			var fieldVal = $F("txtBranchCd");
			validateBranchCd2("txtBranchCd", fieldVal, false);
		} else if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0) {
			$("txtBranchName").clear();
		}
	});
	
	$("txtBranchName").observe("change", function(){
		if($F("txtBranchCd") == "" && ($F("txtBranchName") == "ALL BRANCHES" || $F("txtBranchName") == "")){
			$("txtBranchName").value = "ALL BRANCHES";
			$("txtBranchCd").value = "";
		} else {
			var fieldVal = $F("txtBranchName") == "ALL BRANCHES" ? "" : $F("txtBranchName");
			validateBranchCd2("txtBranchName", fieldVal, false);
		}
	});
	
	$("txtBranchName").observe("keypress", function(event){
		if(event.keyCode == objKeyCode.ENTER) {
			var fieldVal = $F("txtBranchName") == "ALL BRANCHES" ? "" : $F("txtBranchName");
			validateBranchCd2("txtBranchName", fieldVal, false);
		} else if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0) {
			$("txtBranchCd").clear();
		}
	});
	
	$("rdoReleasedChecks").observe("click", function(){
		if($F("txtCutOffDate") != ""){
			$("rdoReleasedChecks").checked = true;
			$("rdoUnreleasedChecks").checked = false;
			//$("tdCutOffDate").down("div", 0).removeClassName("required");
			$("trCutOffDate").hide();
			$("trFromToDate").show();
		} else {
			$("rdoReleasedChecks").checked = false;
			$("rdoUnreleasedChecks").checked = true;
			customShowMessageBox("Please specify the period covered.", "I", "txtCutOffDate");
		}	
	});
	
	$("rdoUnreleasedChecks").observe("click", function(){
		if($F("txtFromDate") != "" && $F("txtToDate") != ""){
			$("rdoUnreleasedChecks").checked = true;
			$("rdoReleasedChecks").checked = false;
			$("trCutOffDate").show();
			$("trFromToDate").hide();
			$("txtCutOffDate").value = dateFormat(new Date(), 'mm-dd-yyyy');			
		} else {
			$("rdoUnreleasedChecks").checked = false;
			$("rdoReleasedChecks").checked = true;
			var field = $F("txtFromDate") != "" ? ($F("txtToDate") != "" ? "" : "txtToDate") : "txtFromDate";
			customShowMessageBox("Please specify the period covered.", "I", field);
		}
	});
	
	$("btnPrint").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("printDiv")){
			if($("rdoReleasedChecks").checked){
				if($F("txtFromDate") != "" && $F("txtToDate") != ""){
					validateReportId("GIACR186","Released Checks");	
				} else {
					showMessageBox(objCommonMessage.REQUIRED, "I");
				}
				
			} else if($("rdoUnreleasedChecks").checked){
				if($F("txtCutOffDate") != ""){
					validateReportId("GIACR185","Unreleased Checks");	
				} else {
					showMessageBox(objCommonMessage.REQUIRED, "I");
				}				
			}
		}		
	});
	
	setModuleId("GIACS184");
	setDocumentTitle("Check Release Report");
	initializeAll();
	makeInputFieldUpperCase();
	toggleRequiredFields("screen");
	initializeDefaultValues();
	observeChangeTagOnDate("hrefFromDate", "txtFromDate", validateDateFrom);
	observeChangeTagOnDate("hrefToDate", "txtToDate", validateDateTo);
	
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
	
	$("txtNoOfCopies").observe("change", function(){
		if( parseInt($F("txtNoOfCopies")) > 100 || parseInt(nvl($F("txtNoOfCopies"), "0")) == 0 ){
			customShowMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", "txtNoOfCopies");
			$("txtNoOfCopies").value = "";
		}
	});
	
</script>