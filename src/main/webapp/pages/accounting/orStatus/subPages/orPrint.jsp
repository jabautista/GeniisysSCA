<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="orPrintDialogMainDiv" style="width: 99.5%; padding-top: 5px; float: left;" align="center">
	<div class="sectionDiv" id="paramPrintDiv" style="float: left;">
		<table align="center" style="padding: 10px;">
			<tr>
				<td class="leftAligned">From</td>
				<td class="rightAligned">
					<!--Kenneth 01.14.2013  -->
					<div class="withIconDiv required" style="float: left; margin-left: 3px;  width: 100px;">
						<input id="txtFromDate" class="withIcon required" type="text" style="width: 76px;" name="txtFromDate" readOnly="readonly"/> 
						<img src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" id="hrefFromDate" alt="From Date"/>
					</div>
				</td>
				<td class="leftAligned">To</td>
				<td class="rightAligned">
					<!--Kenneth 01.14.2013  -->
					<div class="withIconDiv required" style="float: left; margin-left: 3px; width: 100px;">
						<input id="txtToDate" class="withIcon required" type="text" style="width: 76px;" name="txtToDate" readOnly="readonly"/> 
						<img src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" id="hrefToDate" alt="To Date"/>
					</div>
				</td>
			</tr>
			<tr>
				<td class="leftAligned">Branch</td>
				<td class="rightAligned" colspan="3">
					<span class="lovSpan" style="width: 226px; margin-left: 3px;">
						<input type="text" id="txtBranch" name="txtBranch" style="width: 201px; float: left; border: none; height: 14px; margin: 0;" value="ALL - ALL BRANCHES"/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBranchPrint" name="imgSearchBranchPrint" alt="Go" style="float: right;"/>
					</span>
				</td>
			</tr>
			<tr>
				<td class="leftAligned">Status</td>
				<td class="rightAligned" colspan="3">
					<span class="lovSpan" style="width: 226px; margin-left: 3px;">
						<input type="text" id="txtStatus" name="txtStatus" style="width: 201px; float: left; border: none; height: 14px; margin: 0;"/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchStatus" name="imgSearchBranch" alt="Go" style="float: right;"/>
					</span>
				</td>
			</tr>
			<tr>
				<td colspan="4">
					<table align="center">	
						<tr>
							<td><input type="radio" id="open" name="flag" checked="checked" value="O"/></td>
							<td>Open</td>
							<td><input type="radio" id="all" name="flag" value=""/></td>
							<td>All</td>
						</tr>
						<tr>
							<td><input type="radio" id="closed" name="flag" value="C"/></td>
							<td>Closed</td>
							<td><input type="radio" id="noOrDetails" name="flag" value="N"/></td>
							<td>No OR Details</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="float: left;" id="orPrintDialogFormDiv">
		<table id="orPrintDialogMainTab" name="orPrintDialogMainTab" align="center" style="padding: 10px;">
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
						<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;"/>
						<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;"/>
						<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;"/>
						<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;"/>
					</div>					
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="float: left; display: none;" id="orPrintDialogFormDiv2"></div>
	<div id="orPrintButtonsDiv" style="float: left; width: 100%; margin-top: 10px; margin-bottom: 5px;">
		<input type="button" class="button" id="btnOrPrint" name="btnOrPrint" value="Print" style="width: 80px;"/>
		<input type="button" class="button" id="btnOrPrintCancel" name="btnOrPrintCancel" value="Cancel"/>
	</div>
	<input type="hidden" id="hidBranch" name="hidBranch"/>
	<input type="hidden" id="hidFlag" name="hidFlag" value="O"/>
	<input type="hidden" id="hidPrintStatus" name="hidPrintStatus"/>
</div>
<script type="text/javascript">
	initializeAll();
	var repId = null;
	var repTitle = null;
	if ($F("hidStatusName") == ""){
		$("txtStatus").value = "ALL";
		$("hidPrintStatus").value = "";
	}else{
		$("txtStatus").value = $F("hidStatusName").toUpperCase();
		$("hidPrintStatus").value = $F("hidStatusName").toUpperCase().substring(0,1);
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
	
	function onPrintLoad(){
		if ($F("txtStatus") == "PRINTED"){
			$("open").disabled 			= false;
			$("closed").disabled 		= false;
			$("all").disabled 			= false;
			$("noOrDetails").disabled 	= false;
		}else if ($F("txtStatus") != "PRINTED"){
			$("open").disabled 			= true;
			$("closed").disabled 		= true;
			$("all").disabled 			= true;
			$("noOrDetails").disabled 	= true;
		}
	}
	
	function showStatusLOV(param){
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action : "getAllOrStatusLOV",
				//status : $F("txtStatus"), kenneth 01.14.2014
				status : ($F("hidPrintStatus") != null && $F("hidPrintStatus") != "" ? "" : param),
				page : 1
			},
			title : "List of OR Status",
			width : 370,
			height :400,
			hideColumnChildTitle: true,
			columnModel : [ 
				{
					id : "rvLowValue rvMeaning",
					title: "O.R. Status",
					sortable: true,
					width: '335px',
					children: [ 
						{
							id : "rvLowValue",
							width: 100,
							editable : false,
							filterOption: true
						},
						{
							id : "rvMeaning",
							width: 235,
							editable : false,
							filterOption: true
						}
						          ]
				}	
			],
			draggable : true,
			autoSelectOneRecord: true,
			//filterText: $F("txtStatus"), Kenneth 01.14.2014
			filterText: ($F("hidPrintStatus") != null && $F("hidPrintStatus") != "" ? "%" : $F("txtStatus")),
			onSelect : function(row) {
				if (row.rvLowValue == "ALL"){
					$("hidPrintStatus").value = "";
					$("txtStatus").value = "ALL";
				}else{
					$("txtStatus").value = row.rvMeaning;	
					$("hidPrintStatus").value = row.rvLowValue;
				}
				onPrintLoad();
			},
		   onCancel : function(){
			   	$("txtStatus").focus();
		   },
		   onUndefinedRow : function(){
			   	customShowMessageBox("No record selected.", imgMessage.INFO, "txtStatus");
		   }
		});	
	}
	
	function showAllBranchLOV(param){
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action : "getPrintDialogBranchLOV",
				moduleId: "GIACS235",
				//branch: $F("txtBranch"), Kenneth 01.14.2014
				branch: (($F("hidBranch") == "ALL" && $F("txtBranch") == "ALL - ALL BRANCHES") ? "%" : param),
				fundCd: $F("hidFundCd"),
				page : 1
			},
			title : "List of Branches",
			width : 370,
			height : 400,
			columnModel : [ 
 				{
					id : "branchCd",
					title: "Branch Code",
					sortable: true,
					width: '100px'
				},
				{
					id : "branchName",
					title: "Branch Name",
					sortable: true,
					width: '235px'
				}
			],
			draggable : true,
			autoSelectOneRecord: true,
			//filterText: $F("txtBranch"), Kenneth 01.14.2014
			filterText: ($F("hidBranch") == "" && $F("txtBranch") != ""? $F("txtBranch") : "%"),
			onSelect : function(row) {
				$("txtBranch").value = row.branchCd + " - " + row.branchName;
				$("hidBranch").value = row.branchCd;
			},
		 	onCancel : function(){
			   	$("txtBranch").focus();
		   	},
		   onUndefinedRow : function(){
			   	customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranch");
		   }
		});	
	}
	
	function printReport(){
		try {
			if($F("hidPrintStatus") == "P" && $F("hidFlag") == "N"){
				repId = "GIACR235A";
				repTitle = "Exception Report for Printer ORs";
			}else{
				repId = "GIACR235";
				repTitle = "Listing per OR Status";
			}
			if($F("txtStatus") == ""){
				$("hidPrintStatus").value = "";
			}
			if($F("txtBranch") == ""){
				$("hidBranch").value = "";
			}
			var content = contextPath + "/PrintGIACInquiryController?action=printReport"
							+"&reportId="+repId
							+"&orFlag="+$F("hidPrintStatus")
							+"&issCd="+$F("hidBranch")
							+"&fromDate="+$F("txtFromDate")
							+"&toDate="+$F("txtToDate")
							+"&tranFlag="+$F("hidFlag");
// 			if($F("txtFromDate") == ""){
// 				customShowMessageBox("Pls. enter FROM date.", imgMessage.INFO, "txtFromDate");
// 			}else if($F("txtToDate") == ""){
// 				customShowMessageBox("Pls. enter TOM date.", imgMessage.INFO, "txtToDate");	//Kenneth 01.14.2013
// 			}else 
			if(checkAllRequiredFieldsInDiv("paramPrintDiv")){
				if("screen" == $F("selDestination")){
					showPdfReport(content, repTitle);
				}else if($F("selDestination") == "printer"){
					new Ajax.Request(content, {
						method: "GET",
						parameters : {noOfCopies : $F("txtNoOfCopies"),
						 	 		 printerName : $F("selPrinter")},
						onCreate: showNotice("Processing, please wait..."),	
						asynchronous: true,
						evalScripts: true,
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								showMessageBox("Printing complete.", "S");	//Kenneth 01.14.2014
							}
						}
					});
				}else if($F("selDestination") == "file"){
					new Ajax.Request(content, {
						method: "POST",
						parameters : {destination : "file",
									  fileType : $("rdoPdf").checked ? "PDF" : "XLS"},
						onCreate: showNotice("Generating report, please wait..."),
						asynchronous: true,
						evalScripts: true,
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								copyFileToLocal(response);
							}
						}
					});
				}else if($F("selDestination") == "local"){
					new Ajax.Request(content, {
						method: "POST",
						parameters : {destination : "local"},
						asynchronous: true,
						evalScripts: true,
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
			}
		} catch (e){
			showErrorMessage("printReport", e);
		}
	}
	
	$$("input[name='flag']").each(function(btn) {
		btn.observe("click", function() {
			$("hidFlag").value = $F(btn);
		});
	});
	
 	$("hrefFromDate").observe("click", function() {
		scwShow($('txtFromDate'),this, null);
	});
	
 	$("hrefToDate").observe("click", function() {
		scwShow($('txtToDate'),this, null);
	});
	
 	$("btnOrPrintCancel").observe("click", function(){
		overlayOrPrint.close();
	});

	$("imgSpinUp").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if(no < 100){ //Kenneth 01.14.2014
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
	
	$("txtNoOfCopies").observe("change", function(){	//Kenneth 01.14.2014
		if($F("txtNoOfCopies").trim() != "" && (isNaN($F("txtNoOfCopies")) || parseInt($F("txtNoOfCopies")) <= 0 || parseInt($F("txtNoOfCopies")) > 100)){
			showWaitingMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", function(){
				$("txtNoOfCopies").value = "";
			});			
		}
	});
	
	$("selDestination").observe("change", function(){
		var dest = $F("selDestination");
		toggleRequiredFields(dest);
	});	
	
	$("btnOrPrint").observe("click", function(){
		var dest = $F("selDestination");
		if(dest == "printer"){
			if(checkAllRequiredFieldsInDiv("orPrintDialogFormDiv")){
				overlayOrPrint.onPrint();
			}
		}else{
			overlayOrPrint.onPrint();
		}	
	});
	function validateFromAndTo(field) {
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g, "/")) : "";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g, "/")) : "";
		var sysdate = new Date();

		if ((fromDate > toDate && toDate != "")) {
			customShowMessageBox("From date must not be later than to date.", "I", "txtToDate");
			$(field).clear();
			return false;
		}

	}
	$("txtFromDate").observe("focus", function() {
		if ($("hrefFromDate").disabled == true) return;
		validateFromAndTo("txtFromDate");
	});

	$("txtToDate").observe("focus", function() {
		if ($("hrefToDate").disabled == true) return;
		validateFromAndTo("txtToDate");
	});
	
	$("imgSearchBranchPrint").observe("click", function() {
		//showAllBranchLOV(); Kenneth 01.14.2014
		showAllBranchLOV("%");
	});
	
	$("imgSearchStatus").observe("click", function() {
		//showStatusLOV(); Kenneth 01.14.2014
		showStatusLOV("%");
		onPrintLoad();
	});
	
	$("txtBranch").observe("change", function() {
		//showAllBranchLOV(); Kenneth 01.14.2014
		$("hidBranch").value = "ALL";
		if(!$F("txtBranch").empty()) {			
			showAllBranchLOV($F("txtBranch"));
		}else{
			$("hidBranch").value = ""; //"ALL";
			$("txtBranch").value = "ALL - ALL BRANCHES";
		}
	});
	
	$("txtStatus").observe("change", function() {
		//showStatusLOV(); Kenneth 01.14.2014
		$("hidPrintStatus").value = "";
		if(!$F("txtStatus").empty()) {			
			showStatusLOV($F("txtStatus"));
		}else{
			$("hidPrintStatus").value = "";
		}
		onPrintLoad();
	});
	
	onPrintLoad();
	observeBackSpaceOnDate("txtToDate");
	observeBackSpaceOnDate("txtFromDate");
	toggleRequiredFields("screen");
	overlayOrPrint.onLoad != null ? overlayOrPrint.onLoad() :null;
	objPrintOr.printOr = printReport;
</script>