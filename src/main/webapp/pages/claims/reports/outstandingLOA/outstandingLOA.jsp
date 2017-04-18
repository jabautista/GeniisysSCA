<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="outstandingLOAMainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothMenu1" name="smoothMenu1" class="ddsmoothmenu">
			<ul> 
				<li><a id="outstandingLOAExit">Exit</a></li>
			</ul>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Outstanding LOA</label>
		</div>
	</div>
	<div id="outstandingLOASectionDiv" class="sectionDiv" style="width: 920px; height: 460px;">
		<div class="sectionDiv" style="width: 617px; height:360px; margin: 40px 20px 20px 150px;">
			<div id="fieldDiv" class="sectionDiv" style="width: 575px; height: 100px; margin: 10px 10px 0px 10px; padding: 10px 10px 25px 10px;"/>
				<table align="left" style="padding-left: 27px;">	
					<tr>
						<td class="rightAligned"><input type="radio" name="byDate" id="rdoFromDate" title="From" style="float: left; margin-right: 10px;"/><label for="rdoFromDate" tabindex="101" style="float: left; height: 20px; padding-top: 3px; padding-right: 10px;">From</label></td>
						<td>
							<div style="float: left; width: 165px;" class="withIconDiv">
								<input type="text" id="txtFromDate" name="start date." class="withIcon date" readonly="readonly" style="width: 140px;" tabindex="102"/>
								<img id="imgFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" class="hover" onClick="scwShow($('txtFromDate'),this, null);" tabindex="103"/>
							</div>
						</td> 
						<td class="rightAligned" style="padding-left: 80px; padding-right: 10px;">To</td>
						<td>
							<div style="float: left; width: 165px;" class="withIconDiv">
								<input type="text" id="txtToDate" name="an ending date." class="withIcon date" readonly="readonly" style="width: 140px;" tabindex="104"/>
								<img id="imgToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" class="hover" onClick="scwShow($('txtToDate'),this, null);" tabindex="105"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned"><input type="radio" name="byDate" id="rdoAsOfDate" title="As of" style="float: left; margin-right: 10px;"/><label for="rdoAsOfDate" tabindex="106" title="As of" style="float: left; height: 20px; padding-top: 3px; padding-right: 10px;">As of</label></td>
						<td>
							<div style="float: left; width: 165px;" class="withIconDiv">
								<input type="text" id="txtAsOfDate" name="an as of date." class="withIcon" readonly="readonly" style="width: 140px;" tabindex="107"/>
								<img id="imgAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" class="hover" onClick="scwShow($('txtAsOfDate'),this, null);" tabindex="108"/>
							</div>
						</td>
					</tr>
				</table>
				<table align="left" style="padding-left: 40px;">	
					<tr>
						<td class="rightAligned" style="padding-right: 10px;">Subline</td>
						<td class="leftAligned" colspan="4">
							<span class="lovSpan" style="width: 85px; margin-right: 4px;">
								<input type="text" id="txtSublineCd" name="Subline" maxlength="7" style="width: 60px; float: left; border: none; height: 14px; margin: 0;" class="" tabindex="109"/>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchSublineCd" name="imgSearchSubline" alt="Go" style="float: right;" tabindex="110"/>
							</span>
<!-- 							<span class="lovSpan" style="width: 340px; margin-right: 30px;"> -->
								<input type="text" id="txtSublineName" name="Subline" maxlength="30" readonly="readonly" style="width: 314px; float: left; height: 14px;" class="" tabindex="111"/>  
<%-- 								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchSublineName" name="imgSearchSubline" alt="Go" style="float: right;" tabindex="112"/> --%>
<!-- 							</span> -->
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="padding-right: 10px;">Branch</td>
						<td class="leftAligned" colspan="4">
							<span class="lovSpan" style="width: 85px; margin-right: 4px;">
								<input type="text" id="txtBranchCd" name="Branch" maxlength="2" style="width: 60px; float: left; border: none; height: 14px; margin: 0;" class="" tabindex="112"/>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBranchCd" name="imgSearchBranch" alt="Go" style="float: right;" tabindex="113"/>
							</span>
<!-- 							<span class="lovSpan" style="width: 340px; margin-right: 30px;"> -->
								<input type="text" id="txtBranchName" name="Branch" maxlength="20" readonly="readonly" style="width: 314px; float: left; height: 14px;" class="" tabindex="114"/>  
<%-- 								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBranchName" name="imgSearchBranch" alt="Go" style="float: right;" tabindex="116"/> --%>
<!-- 							</span> -->
						</td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" style="width: 35%; height: 110px; margin: 2px 2px 10px 10px; padding: 8px 0 22px 0;">				
				<div>
					<table style="padding-left: 20px; padding-top: 10px;">
						<tr>	
							<td style="padding-left: 30px; padding-bottom: 13px;">
								<input type="radio" id="rdoLossDate" name="rdo" checked="checked" value="LS"/>
							</td>
							<td>
								<label for="rdoLossDate" tabindex="201">Loss Date</label>
							</td>
						</tr>
						<tr>
							<td style="padding-left: 30px; padding-bottom: 13px;">
								<input type="radio" id="rdoClaimFileDate" name="rdo" value="CF"/>
							</td>
							<td>
								<label for="rdoClaimFileDate" tabindex="202">Claim File Date</label>
							</td>
						</tr>
						<tr>
							<td style="padding-left: 30px; padding-bottom: 13px;">
								<input type="radio" id="rdoLOADate" name="rdo" value="LO"/>
							</td>
							<td>
								<label for="rdoLOADate" tabindex="203">LOA Date</label>
							</td>
						</tr>						
					</table>
				</div>
			</div>
			
			<div id="printDialogFormDiv" class="sectionDiv" style="width: 55.8%; height: 110px; margin: 2px 0 0 1px; padding: 15px 22px 15px 8px;" align="center">
				<table style="float: left; padding: 1px 0px 0px 15px;">
					<tr>
						<td class="rightAligned">Destination</td>
						<td class="leftAligned">
							<select id="selDestination" style="width: 200px;" tabindex="301">
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
							<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="rdoFileType" style="margin: 2px 5px 4px 40px; float: left;" checked="checked" disabled="disabled" tabindex="302"><label for="pdfRB" style="margin: 2px 0 4px 0">PDF</label>
							<input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="rdoFileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="303"><label for="excelRB" style="margin: 2px 0 4px 0">Excel</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Printer</td>
						<td class="leftAligned">
							<select id="printerName" style="width: 200px;" tabindex="304">
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
							<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="integerNoNegativeUnformattedNoComma" tabindex="305"/>
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
			
			<div id="buttonsDiv" class="buttonsDiv" align="center">
				<input id="btnPrint" type="button" class="button" value="Print" style="width: 100px;" tabindex="401"/>
			</div>
		</div>	
	</div>
</div>

<script type="text/javascript">
	setModuleId("GICLS219");
	setDocumentTitle("Outstanding LOA");
	
	function initializaOutstandingLOA() {
		$("txtSublineName").value = "ALL SUBLINES";
		$("txtBranchName").value = "ALL BRANCHES";
		$("rdoFromDate").checked = true;		
		toggleCalendar(true);	
		togglePrintFields("screen");
		observeBackSpaceOnDate("txtFromDate");
		observeBackSpaceOnDate("txtToDate");
		observeBackSpaceOnDate("txtAsOfDate");	
	}	
	
	function showSublineLOV(text) {
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getOutstLOASublineLOV",
				  branchCd : $("txtBranchCd").value,
					search : $(text).value == "ALL SUBLINES" ? $(text).value = "" : $(text).value 
				},
				title : "Valid Values for Subline",
				width : 370,
				height : 390,
				autoSelectOneRecord : true,
				filterText : $(text).value,
				columnModel : [ 
				    {
						id : "sublineCd",
						title : "Subline Code",
						width : '100px'
					}, 
					{
						id : "sublineName",
						title : "Subline Name",
						width : '250px'
					}
				],
				draggable : true,
				onSelect : function(row) {
					$("txtSublineCd").value = row.sublineCd;
					$("txtSublineName").value = row.sublineName;
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		} catch (e) {
			showErrorMessage("Subline LOV", e);
		}
	}
	
	function showBranchLOV(text) {
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getOutstLOABranchLOV",
					search : $(text).value == "ALL BRANCHES" ? $(text).value = "" : $(text).value
				},
				width : 370,
				height : 390,
				autoSelectOneRecord : true,
				filterText : $(text).value,
				columnModel : [ 
				    {
						id : "issCd",
						title : "Branch Code",
						width : '100px'
					}, 
					{
						id : "issName",
						title : "Branch Name",
						width : '250px'
					}
				],
				draggable : true,
				onSelect : function(row) {
					$("txtBranchCd").value = row.issCd;
					$("txtBranchName").value = row.issName;
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		} catch (e) {
			showErrorMessage("Branch LOV", e);
		}
	}
	
	function checkAllDates() {
		check = true;
		if ($("rdoFromDate").checked == true) {
			$$("input[type='text'].date").each(function(m) {
				if (m.value == "") {
					check = false;
					customShowMessageBox("Please specify " + m.name, "I", m.id);
					return false;
				}
			});
		}else if ($("rdoAsOfDate").checked == true) {
			if ($("txtAsOfDate").value == "") {
				check = false;
				customShowMessageBox("Please specify an As of date.", "I", "txtAsOfDate");
				return false;
			}
		}
		return check;
	}
	
	function validateDates(field) {
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g, "/")) : "";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g, "/")) : "";
		var asOfDate = $F("txtAsOfDate") != "" ? new Date($F("txtAsOfDate").replace(/-/g, "/")) : "";
		var sysdate = new Date();
		
		if ($("rdoFromDate").checked == true) {
			if (fromDate > sysdate && fromDate != "") {
				customShowMessageBox("Date should not be greater than the current date.", "I", "txtFromDate");
				$(field).clear();
				return false;
			}

			if (toDate > sysdate && toDate != "") {
				customShowMessageBox("Date should not be greater than the current date.", "I", "txtToDate");
				$(field).clear();
				return false;
			}
			
			if (fromDate > toDate && toDate != "") {
				if (field == "txtFromDate") {
					customShowMessageBox("From Date should not be later than To Date.", "I", "txtFromDate");
				} else {
					customShowMessageBox("From Date should not be later than To Date.", "I", "txtToDate");
				}
				$(field).clear();
				return false;
			}
		}else if ($("rdoAsOfDate").checked == true) {
			if (asOfDate > sysdate && asOfDate != "") {
				customShowMessageBox("Date should not be greater than the current date.", "I", "txtAsOfDate");
				$(field).clear();
				return false;				
			}
		}
		
	}
	
	function toggleCalendar(enable){
		if (nvl(enable,false) == true){
			//enable asof calendar
			$("txtAsOfDate").value 		= "";
			$("txtAsOfDate").disabled 	= true;
			$("txtFromDate").disabled 	= false;
			$("txtToDate").disabled 	= false;
			disableDate("imgAsOfDate");
			enableDate("imgFromDate");
			enableDate("imgToDate");
		}else{	
			//disable asof calendar
			$("txtAsOfDate").value 		= getCurrentDate();
			$("txtFromDate").value 		= "";
			$("txtToDate").value 		= "";
			$("txtAsOfDate").disabled 	= false;
			$("txtFromDate").disabled 	= true;
			$("txtToDate").disabled 	= true;
			enableDate("imgAsOfDate");
			disableDate("imgFromDate");
			disableDate("imgToDate");
		}
	}
	
	function getChoiceDate() {
		var choice = "";
		$$("input[name='rdo']").each(function(rdo) {
				if (rdo.checked){
					choice = $F(rdo);
				}	
		});
		return choice;
	}
	
	function printOutstandingLOAReport(){
		try {
			var content = contextPath + "/PrintOutstandingLOAController?action=printReport"
							+"&reportId="+ "GICLR219"
							+"&fromDate="+ $("txtFromDate").value
							+"&toDate="+ $("txtToDate").value
							+"&asOfDate="+ $("txtAsOfDate").value
							+"&branchCd="+ $("txtBranchCd").value
							+"&sublineCd="+ $("txtSublineCd").value
							+"&choiceDate="+ getChoiceDate();
		
			if("screen" == $F("selDestination")){
				showPdfReport(content, "Outstanding LOA");
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {noOfCopies : $F("txtNoOfCopies"),
						  	      printerName : $F("printerName")},
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
							copyFileToLocal(response, "reports");
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

	function checkLov(action, cd, desc, func, label) {
		if ($(cd).value == "") {
			$(desc).value = label;
		} else {
			var output = validateTextFieldLOV("/ClaimsLOVController?action=" + action + "&search=" + $(cd).value + "&branchCd=" + $("txtBranchCd").value, $(cd).value, "Searching, please wait...");
			if (output == 2) {
				func();
			} else if (output == 0) {
				$(cd).clear();
				$(desc).value = label;
				
				if ($(cd).value == label) {
					$("txtSublineCd").clear();
				}else if ($(cd).value == label) {
					$("txtBranchCd").clear();
				}
				
				customShowMessageBox($(cd).getAttribute("name") + " does not exist.", "I", cd);
			} else {
				func();
			}
		}
	}
	
	function defaultValues(check, field, label) {
		if ($(check).value == "") {
			$(field).value = label;
		}
		if ($(field).value == label) {
			$(check).clear();
		}
	}
	
	function togglePrintFields(dest) {
		if (dest == "printer") {
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
			$("rdoExcel").disable();
		} else {
			if (dest == "file") {
				$("rdoPdf").enable();
				$("rdoExcel").enable();
			} else {
				$("rdoPdf").disable();
				$("rdoExcel").disable();
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
	
	$("txtFromDate").observe("focus", function() {
		if ($("imgFromDate").disabled == true) return;
		validateDates("txtFromDate");
	});
	
	$("txtToDate").observe("focus", function() {
		if ($("imgToDate").disabled == true) return;
		validateDates("txtToDate");
	});
	
	$("txtAsOfDate").observe("focus", function() {
		if ($("imgAsOfDate").disabled == true) return;
		validateDates("txtAsOfDate");
	});
	
	$("rdoFromDate").observe("click", function() {
		toggleCalendar(true);
	});
	
	$("rdoAsOfDate").observe("click", function() {
		toggleCalendar(false);
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
		togglePrintFields(dest);
	});	
	
	$("btnPrint").observe("click", function() {
		var dest = $F("selDestination");
		if(dest == "printer"){
			if(checkAllRequiredFieldsInDiv("printDialogFormDiv")){
				if (checkAllDates()) {
					printOutstandingLOAReport();
				}
			}
		}else{
			if (checkAllDates()) {
				printOutstandingLOAReport();
			}
		}
	});

	$$("input[name='Subline']").each(function(search) {
		search.observe("change", function() {
			if (search.id == "txtSublineCd") {
				checkLov("getOutstLOASublineLOV", "txtSublineCd", "txtSublineName", function() {
					showSublineLOV("txtSublineCd");
				}, "ALL SUBLINES");
			}
		});
	});

	$$("input[name='Branch']").each(function(search) {
		search.observe("change", function() {
			if (search.id == "txtBranchCd") {
				checkLov("getOutstLOABranchLOV", "txtBranchCd", "txtBranchName", function() {
					showBranchLOV("txtBranchCd");
				}, "ALL BRANCHES");
			}
		});
	});
	
	$$("img[name='imgSearchSubline']").each(function(search) {
		search.observe("click", function() {
			if (search.id == "imgSearchSublineCd") {
				showSublineLOV($("txtSublineCd"));
				defaultValues("txtSublineCd", "txtSublineName", "ALL SUBLINES");
			}
		});
	});
	
	$$("img[name='imgSearchBranch']").each(function(search) {
		search.observe("click", function() {
			if (search.id == "imgSearchBranchCd") {
				showBranchLOV($("txtBranchCd"));
				defaultValues("txtBranchCd", "txtBranchName", "ALL BRANCHES");
			}
		});
	});

	$("outstandingLOAExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});
	
	initializaOutstandingLOA();
</script>