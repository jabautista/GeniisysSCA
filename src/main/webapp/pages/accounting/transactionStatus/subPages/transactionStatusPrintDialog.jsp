<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="tranStatMainDiv" style="width: 99.5%; margin-top: 10px; float: left;" align="center">
	<div class="sectionDiv" style="float: left;" id="tranStatFormDiv">
		<table id="tranStatMainTab" name="tranStatMainTab" align="center" style="margin: 10px;">
			<tr>
				<td class="rightAligned">From</td>
				<td class="leftAligned">
					<div style="float: left; width: 100px;" class="withIconDiv">
						<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon required" readonly="readonly" style="width: 76px;" tabindex="101"/>
						<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" tabindex="102"/>
					</div>				
				</td>
				<td class="rightAligned" style="width: 16px;">To</td>
				<td class="leftAligned">
					<div style="float: left; width: 100px;" class="withIconDiv">
						<input type="text" id="txtToDate" name="txtToDate" class="withIcon required" readonly="readonly" style="width: 76px;" tabindex="103"/>
						<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex="104"/>
					</div>	
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Branch</td>
				<td class="leftAligned" colspan="3">
					<span class="lovSpan" style="width: 226px;">
						
						<input type="text" id="txtBranchPrint" name="txtBranchPrint" style="width: 201px; float: left; border: none; height: 14px; margin: 0;" class="" tabindex="105"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBranch" name="imgSearchBranch" alt="Go" style="float: right;" tabindex="106"/>
					</span>				
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Tran Class</td>
				<td class="leftAligned" colspan="3">
					<span class="lovSpan" style="width: 226px;">
						
						<input type="text" id="txtTranClass" name="txtTranClass" style="width: 201px; float: left; border: none; height: 14px; margin: 0;" class="" tabindex="107"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchTranClass" name="imgSearchTranClass" alt="Go" style="float: right;" tabindex="108"/>
					</span>	
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Status</td>
				<td class="leftAligned" colspan="3">
					<span class="lovSpan" style="width: 226px;">
						
						<input type="text" id="txtStatus" name="txtStatus" style="width: 201px; float: left; border: none; height: 14px; margin: 0;" class="" tabindex="109"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchStatus" name="imgSearchStatus" alt="Go" style="float: right;" tabindex="110"/>
					</span>	
				</td>
			</tr>
		</table>
	</div>
</div>
<div id="printDialogMainDiv" style="width: 99.5%; padding-top: 5px; float: left;" align="center">
	<div class="sectionDiv" style="float: left;" id="printDialogFormDiv">
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
			<c:if test="${showFileOption eq 'true'}">
				<tr>
					<td></td>
					<td>
						<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="fileType" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled"><label for="rdoPdf" style="margin: 2px 0 4px 0">PDF</label>
						<input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="fileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoExcel" style="margin: 2px 0 4px 0">Excel</label>
					</td>
				</tr>
			</c:if>				
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
	<!-- do not delete this printDialogFormDiv2 --><div class="sectionDiv" style="float: left; display: none;" id="printDialogFormDiv2"></div>
	<div id="buttonsDiv" style="float: left; width: 100%; margin-top: 10px; margin-bottom: 5px;">
		<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width: 80px;">
		<input type="button" class="button" id="btnPrintCancel" name="btnPrintCancel" value="Cancel">		
		
		<input type="hidden" id="hidStatusCd" name="hidStatusCd"/>
		<input type="hidden" id="hidTranClassCd" name="hidTranClassCd"/>
		<input type="hidden" id="hidBranchPrintCd" name="hidBranchPrintCd"/>
	</div>	
</div>
<script type="text/javascript">
	initializeAll();
	$("txtTranClass").stopObserving("keyup");
	$("txtBranchPrint").stopObserving("keyup");
	$("txtStatus").stopObserving("keyup");
	
	initTranStatPrintDialog();
	objTransactionStatus = new Object();
	
	function validateParamsOnPrint() {
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) :"";
		
		if ($("txtStatus").value == "") {
			$("txtStatus").value = "ALL";
			$("hidStatusCd").value = "ALL";
		}
		
		if ($("txtToDate").value == "" && $("txtFromDate").value == "") {
			customShowMessageBox("Specify dates for processing.", imgMessage.INFO, "txtFromDate");
			return false;
		}else if ($("txtFromDate").value == "") {
			customShowMessageBox("Specify FROM date for processing.", imgMessage.INFO, "txtFromDate");
			return false;
		}else if ($("txtToDate").value == "") {
			customShowMessageBox("Specify TO date for processing.", imgMessage.INFO, "txtToDate");
			return false;
		}
		
		if ($("txtToDate").value != "" && $("txtFromDate").value != "") {
			if (toDate >= fromDate) {	//Added = by kenneth L. 05.09.2014
				return true;
			}else {
				customShowMessageBox("Invalid dates, specify valid dates.", imgMessage.INFO, "txtFromDate");
				return false;
			}
		}
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
	
	$("btnPrintCancel").observe("click", function(){
		overlayTranStatPrintDialog.close();
	});
	
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
	
	//calendar icon fromdate
	$("hrefFromDate").observe("click", function() {
		if ($("hrefFromDate").disabled == true) return;
		scwShow($('txtFromDate'),this, null);
	});
	
	//calendar icon todate
	$("hrefToDate").observe("click", function() {
		if($("hrefToDate").disabled == true) return;
		scwShow($('txtToDate'),this, null);
	});
	
	//branch field 
	$("txtBranchPrint").observe("change", function (){	
		$("hidBranchPrintCd").value = "ALL";
		if(!$F("txtBranchPrint").empty()) {			
			showPrintDialogBranchLOV($F("txtBranchPrint"));
		}else{
			$("hidBranchPrintCd").value = "ALL";
			$("txtBranchPrint").value = "ALL - ALL BRANCHES";
		}
	});

	//status field
	$("txtStatus").observe("change", function(){
		/* if(!$F("txtStatus").empty()) {
			showPrintDialogStatusLOV();
		} */
		$("hidStatusCd").value = "";
		if(!$F("txtStatus").empty()) {			
			showPrintDialogStatusLOV($F("txtStatus"));
		}else{
			$("hidStatusCd").value = "";
		}
	});
	
	//tran class field
	$("txtTranClass").observe("change", function() {	
		$("hidTranClassCd").value = "";
		if(!$F("txtTranClass").empty()) {			
			showPrintDialogTranClassLOV($F("txtTranClass"));
		}else{
			$("hidTranClassCd").value = "";
		}
// 		if(!$F("txtTranClass").empty()){
// 			showPrintDialogTranClassLOV($F("txtTranClass"));
// 		}		
	});

	$("txtTranClass").observe("keyup", function(e) {
		if(e.keyCode == 46 || e.keyCode == 8) {
			if($F("txtTranClass").empty()){
				$("hidTranClassCd").value = "";
			}
		}
	});

	$("txtStatus").observe("keyup", function(e) {
		if(e.keyCode == 46 || e.keyCode == 8) {
			if($F("txtStatus").empty()){
				$("hidStatusCd").value = "";
			}
		}
	});

	$("txtBranchPrint").observe("keyup", function(e) {
		if(e.keyCode == 46 || e.keyCode == 8) {
			if($F("txtBranchPrint").empty()){
				$("hidBranchPrintCd").value = "";
			}
		}
	});
	
	//branch lov
	$("imgSearchBranch").observe("click", function(){
		showPrintDialogBranchLOV("%"); 
	});
	
	//status lov
	$("imgSearchStatus").observe("click", function(){
		showPrintDialogStatusLOV("%"); 
	});
	
	//tran class lov
	$("imgSearchTranClass").observe("click", function() {
		showPrintDialogTranClassLOV("%");
	});	
	
	//print button dialog
	$("btnPrint").observe("click", function(){
		if (validateParamsOnPrint()) {
			var dest = $F("selDestination");
			if(dest == "printer"){
				if(checkAllRequiredFieldsInDiv("printDialogFormDiv")){
					overlayTranStatPrintDialog.onPrint();
				}
			}else{
				overlayTranStatPrintDialog.onPrint();
			}	
		}

	});
	
	//print dialog settings default
	function initTranStatPrintDialog() {
		/* if (acctgTranStat.tranClass != null) {
			//showPrintDialogTranClassLOV(acctgTranStat.tranClass);		
		} */

		$("txtBranchPrint").value = "ALL - ALL BRANCHES";
		$("hidBranchPrintCd").value = "ALL";
		$("hidTranClassCd").value = acctgTranStat.tranClass;
		$("txtTranClass").value = acctgTranStat.tranClass + " - " + acctgTranStat.tranClassDesc;
		$("txtStatus").value = acctgTranStat.tranFlag.toUpperCase();
		$("hidStatusCd").value = acctgTranStat.rvLowValue;
		observeBackSpaceOnDate("txtFromDate");
		observeBackSpaceOnDate("txtToDate");
		
		toggleRequiredFields("screen");
		overlayTranStatPrintDialog.onLoad != null ? overlayTranStatPrintDialog.onLoad() :null;	
	}
	
	//branch LOV
	function showPrintDialogBranchLOV(param){ 
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action : "getPrintDialogBranchLOV",
				moduleId: "GIACS231",
				branch: (($F("hidBranchPrintCd") == "ALL" && $F("txtBranchPrint") == "ALL - ALL BRANCHES") ? "%" : param),
				fundCd: $F("hidFundCd"),
				//findText: ($F("hidBranchPrintCd") == "" && $F("txtBranchPrint") != ""? $F("txtBranchPrint") : "%"), removed by gzelle
				page : 1
			},
			title : "List of Branches",
			width : 400,
			height : 400,
			hideColumnChildTitle: true,
			columnModel : [ 
 				{
					id : "branchCd",
					title: "Branch Code",
					sortable: true,
					width: '120px'
				},
				{
					id : "branchName",
					title: "Branch Name",
					sortable: true,
					width: '260px'
				}
			],
			draggable : true,
			autoSelectOneRecord: true,
			//filterText: ($F("hidTranClassCd") == "" && $F("txtTranClass") != ""? $F("txtTranClass") : "%"), replaced by Gzelle
			filterText: ($F("hidBranchPrintCd") == "" && $F("txtBranchPrint") != ""? $F("txtBranchPrint") : "%"),
			onSelect : function(row) {
				$("hidBranchPrintCd").value = row.branchCd;
				$("txtBranchPrint").value = row.branchCd + " - " + row.branchName;
			}
		});	
	}
	
	//tran class LOV
	function showPrintDialogTranClassLOV(tranClass){		
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action : "getPrintDialogTranClassLOV",
				tranClass : ($F("hidTranClassCd") != null && $F("hidTranClassCd") != "" ? "" : tranClass),
				//findText: ($F("hidTranClassCd") == "" && $F("txtTranClass") != ""? $F("txtTranClass") : "%"), removed by gzelle 
				page : 1
			},
			title : "List of Tran Class",
			width : 400,
			height : 400,
			hideColumnChildTitle: true,
			columnModel : [ 
 				{
					id : "rvLowValue rvMeaning",
					title: "Tran Class",
					sortable: true,
					width: '380px',
					children: [ 
						{
							id : "rvLowValue",
							width: 120,
							editable : false,
							filterOption: true
						},
						{
							id : "rvMeaning",
							width: 260,
							editable : false,
							filterOption: true
						}
 					          ]
				}
			],
			draggable : true,
			autoSelectOneRecord: true,
			filterText: ($F("hidTranClassCd") == "" && $F("txtTranClass") != ""? $F("txtTranClass") : "%"),
			onSelect : function(row) {
				$("hidTranClassCd").value = row.rvLowValue;
				$("txtTranClass").value = row.rvLowValue + " - " + row.rvMeaning;
			}
		});	
	}
	
	//status LOV
	function showPrintDialogStatusLOV(status){		
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action : "getPrintDialogStatusLOV",
				status : ($F("hidStatusCd") != null && $F("hidStatusCd") != "" ? "" : status),
				//findText: ($F("hidStatusCd") == "" && $F("txtStatus") != ""? $F("txtStatus") : "%"), removed by gzelle
				page : 1
			},
			title : "List of Transaction Status",
			width : 370,
			height : 280,
			columnModel : [ 
				{
					id : "rvLowValue",
					width: 110,
					visible: true
				},
 				{
					id : "rvMeaning",
					title: "Transaction Status",
					sortable: true,
					width: '240px'
				}
			],
			draggable : true,
			autoSelectOneRecord: true,
			filterText: ($F("hidStatusCd") != null && $F("hidStatusCd") != "" ? "%" : $F("txtStatus")),
			onSelect : function(row) {
				$("txtStatus").value = row.rvMeaning;
				$("hidStatusCd").value = row.rvLowValue;
			}
		});	
	}
	
	function printReport(){
		try {
			var content = contextPath + "/PrintGIACInquiryController?action=printReport"
							+"&reportId=GIACR211&tranClass="+$F("hidTranClassCd")
							+"&tranFlag="+($F("hidStatusCd") == "ALL" ? "" : $F("hidStatusCd"))
							+"&branchCd="+($F("hidBranchPrintCd") == "ALL" ? "" : $F("hidBranchPrintCd"))
							+"&fromDate="+$F("txtFromDate")
							+"&toDate="+$F("txtToDate");
			
			if($F("selDestination") == "screen"){
				showPdfReport(content, "Transaction Status");
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {noOfCopies : $F("txtNoOfCopies"),
						  	      printerName : $F("selPrinter")},
					evalScripts: true,
					asynchronous: true,					
					onCreate: showNotice("Processing, please wait..."),	
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							
						}
					}
				});
			}else if( $F("selDestination") == "file"){
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
			}else if($F("selDestination") == "local"){
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
	
	/* $("txtBranchPrint").observe("change", function() {
		if ($F("txtBranchPrint") == "" || $F("txtBranchPrint") == null) {
			$("txtBranchPrint").value = "ALL - ALL BRANCHES";
			$("hidBranchPrintCd").value = "ALL";
		}
	}); */
	
// 	$("txtStatus").observe("change", function() {
// 		if ($("txtStatus").value == "") {
// 			$("txtStatus").value = "ALL";
// 			$("hidStatusCd").value = "ALL";
// 		}
// 	});
	
	
	objTransactionStatus.printReport = printReport;
	
</script>