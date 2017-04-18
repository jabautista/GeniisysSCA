<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="smsReportPrintingMainDiv" name="smsReportPrintingMainDiv" style="height: 800px; margin-bottom: 40px;">
	<div id="smsReportPrintingMainMenu" name="smsReportPrintingMainMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="exit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>SMS Report Printing</label>
	   		<span class="refreshers" style="margin-top: 0;">
	 			<label id="reloadForm" name="reloadForm" style="margin-left: 5px;">Reload Form</label>
			</span>
	   	</div>
	</div>
	<div id="sectionDivTop" class="sectionDiv">
		<fieldset style="width: 30%; height: 200px; float:left; margin-left: 115px; margin-top:15px;">
			<legend><b>Message Received</b></legend>
			<div align="center">
				<table style="margin: 10px 10px 10px 10px">
					<tr>
						<td class="rightAligned">Globe</td>
						<td class="leftAligned"><input class="rightAligned" type="text" id="txtRecGlobe" name="txtRecGlobe" style="width:85px;" value="" readonly="readonly"></td>
					</tr>
					<tr>
						<td class="rightAligned">Smart</td>
						<td class="leftAligned"><input class="rightAligned" type="text" id="txtRecSmart" name="txtRecSmart" style="width:85px;" value="" readonly="readonly"></td>
					</tr>
					<tr>
						<td class="rightAligned">Sun</td>
						<td class="leftAligned"><input class="rightAligned" type="text" id="txtRecSun" name="txtRecSun" style="width:85px;" value="" readonly="readonly"></td>
					</tr>
					<tr>
						<td class="rightAligned">Total Received</td>
						<td class="leftAligned"><input class="rightAligned" type="text" id="txtRecTotal" name="txtRecTotal" style="width:85px;" value="" readonly="readonly"></td>
					</tr>
				</table>
			</div>
		</fieldset>
		<fieldset style="width: 40%; height: 200px; float:right; margin-right: 115px; margin-top:15px;">
			<legend><b>Message Sent</b></legend>
			<div align="center">
				<table style="margin: 10px 10px 10px 10px">
					<tr>
						<td class="rightAligned">Globe</td>
						<td class="leftAligned"><input class="rightAligned" type="text" id="txtSentGlobe" name="txtRecGlobe" style="width:85px;" value="" readonly="readonly"></td>
					</tr>
					<tr>
						<td class="rightAligned">Smart</td>
						<td class="leftAligned"><input class="rightAligned" type="text" id="txtSentSmart" name="txtRecSmart" style="width:85px;" value="" readonly="readonly"></td>
					</tr>
					<tr>
						<td class="rightAligned">Sun</td>
						<td class="leftAligned"><input class="rightAligned" type="text" id="txtSentSun" name="txtSentSun" style="width:85px;" value="" readonly="readonly"></td>
					</tr>
					<tr>
						<td class="rightAligned">Total Sent</td>
						<td class="leftAligned"><input class="rightAligned" type="text" id="txtSentTotal" name="txtRecTotal" style="width:85px;" value="" readonly="readonly"></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td class="rightAligned">User</td>
						<td class="leftAligned">
							<span class="lovSpan" style="width: 92px; height: 21px; margin: 2px 2px 0 0; float: left;">
								<input type="text" id="txtUserId" name="txtUserId" style="width: 67px; float: left; border: none; height: 13px;" class="disableDelKey allCaps" maxlength="8" tabindex="107" />
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchUser" name="searchUser" alt="Go" style="float: right;">
							</span> 
							<span class="lovSpan" style="border: none; width: 130px; height: 21px; margin: 0 2px 0 2px; float: left;">
								<input type="text" id="txtUserName" name="txtUserName" style="width: 130px; float: left; height: 15px;" class="disableDelKey allCaps" lastValidValue="ALL USER" readonly="readonly" />
							</span>
						</td>
					</tr>
				</table>
			</div>
		</fieldset>
		<fieldset style="width: 674px; height: 130px; float:left; margin-left: 115px; margin-top:10px;">
			<legend><b>Date Parameter</b></legend>
			<div align="center" id="dateParamDiv">
				<table style="margin: 10px 10px 10px 10px">
					<tr>
						<td class="rightAligned">
							<input type="radio" name="rdoDate" id="rdoByPeriod" title="By Period" value="P" style="float: left; margin-bottom: 2px;"/>
						</td>
						<td class="leftAligned" style="width: 60px;">
							<label for="rdoByPeriod" style="float: left;">By Period</label>
						</td>
					</tr>
					<tr>
						<td>
						</td>
						<td class="rightAligned">From</td>
						<td>
							<div id="fromDateDiv" style="float: left; border: 1px solid gray; width: 145px; height: 20px;">
								<input id="txtFromDate" name="From Date." readonly="readonly" type="text" class="date" maxlength="10" style="border: none; float: left; width: 120px; height: 13px; margin: 0px;" value="" tabindex="101"/>
								<img id="imgFromDate" alt="imgFromDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtFromDate'),this, null);" />
							</div>
						</td> 
						<td align="center" style="width: 30px;">To</td>
						<td>
							<div id="toDateDiv" style="float: left; border: 1px solid gray; width: 145px; height: 20px;">
								<input id="txtToDate" name="To Date." readonly="readonly" type="text" class="date" maxlength="10" style="border: none; float: left; width: 120px; height: 13px; margin: 0px;" value="" tabindex="102"/>
								<img id="imgToDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtToDate'),this, null);" />
							</div>
						</td>
					</tr>
					<tr><td style="height:10px;">&nbsp;</td></tr>
					<tr>
						<td class="rightAligned">
							<input type="radio" checked="checked" name="rdoDate" id="rdoAsOf" title="By Period" value="2" style="float: left; margin-bottom: 2px;"/>
						</td>
						<td class="leftAligned">
							<label for="rdoAsOf" style="float: left;">As Of</label>
						</td>
						<td>
							<div id="fromDateDiv" style="float: left; border: 1px solid gray; width: 145px; height: 20px;">
								<input id="txtAsOfDate" name="From Date." readonly="readonly" type="text" class="date" maxlength="10" style="border: none; float: left; width: 120px; height: 13px; margin: 0px;" value="" tabindex="101"/>
								<img id="imgAsOfDate" alt="imgAsOfDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtAsOfDate'),this, null);" />
							</div>
						</td> 
					</tr>
				</table>
			</div>
		</fieldset>
		<fieldset style="width: 674px; height: 180px; float:left; margin-left: 115px; margin-top:10px; margin-bottom: 15px;">
			<legend><b>Reports</b></legend>
			<div align="center">
					<table id="printDialogMainTab" name="printDialogMainTab" align="center" style="padding: 5px;">
						<tr>
							<td>
							</td>
							<td class="leftAligned">
								<input type="checkbox" id="chkMessRecList" name="chkMessRecList">
							</td>
							<td class="leftAligned">
								<label for="chkMessRecList">Messages Received Listing</label>
							</td>
						</tr>
						<tr><td></td></tr>
						<tr>
							<td>
							</td>
							<td class="leftAligned">
								<input type="checkbox" id="chkMessSentList" name="chkMessSentList">
							</td>
							<td class="leftAligned">
								<label for="chkMessSentList">Messages Sent Listing</label>
							</td>
						</tr>
						<tr><td></td></tr>
						<tr>
							<td style="text-align:right; width: 80px;">Destination</td>
							<td style="width: 150px;" colspan="2">
								<select id="selDestination" style="margin-left:5px; width:200px;" tabindex="301" >
									<option value="screen">Screen</option>
									<option value="printer">Printer</option>
									<option value="file">File</option>
									<option value="local">Local Printer</option>
								</select>
							</td>
						</tr>
						<tr id="trRdoFileType">
							<td style="width: 80px;">&nbsp;</td>
							<td style="width: 150px;" colspan="2">
								<table border="0">
									<tr>
										<td><input type="radio" style="margin-left:0px;" id="rdoPdf" name="rdoFileType" value="PDF" title="PDF" checked="checked" disabled="disabled" style="margin-left:10px;" tabindex="302"/></td>
										<td><label for="rdoPdf"> PDF</label></td>
										<td style="width:20px;">&nbsp;</td>
										<td><input type="radio" id="rdoExcel" name="rdoFileType" value="XLS" title="Excel" disabled="disabled" tabindex="303" /></td>
										<td><label for="rdoExcel"> Excel</label></td>
									</tr>									
								</table>
							</td>
						</tr>
						<tr>
							<td style="text-align:right; width: 80px;">Printer Name</td>
							<td style="width: 123px" colspan="2">
								<select id="printerName" style="margin-left:5px; width:200px;" tabindex="304">
									<option></option>
										<c:forEach var="p" items="${printers}">
											<option value="${p.name}">${p.name}</option>
										</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<td style="text-align:right; width: 80px;">No. of Copies</td>
							<td style="width: 150px;" colspan="2">
								<input type="text" id="txtNoOfCopies" maxlength="3" style="margin-left:5px;float:left; text-align:right; width:177px;" class="integerNoNegativeUnformattedNoComma" tabindex="305">
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
		</fieldset>
		<div align="center" style="margin-bottom: 30px;">
			<input id="btnRefresh" type="button" class="button" value="Refresh" style="width: 120px;"/>
			<input id="btnPrint" type="button" class="button" value="Print" style="width: 120px;"/>
		</div>
	</div>
</div>
<script type="text/javascript">
	initializeAll();
	initializeAccordion();
	toggleCalendar(false);
	$("txtUserName").value = "ALL USER";
	togglePrintFields($("selDestination").value);
	disableButton("btnPrint");
	reportId = [];
	populateFields();
	setModuleId("GISMS012");
	setDocumentTitle("SMS Report Printing");
	
	function showSmsReportPrinting(){
		new Ajax.Request(contextPath + "/GISMSmsReportController", {
			method : "POST",
			parameters : {
							action 	: "showSmsReportPrinting"
						 },
	        onCreate   : showNotice("Loading SMS Reporting Printing, please wait..."),
	        onComplete : function(response){
	        	hideNotice();
	        	try {
					if(checkErrorOnResponse(response)){
						$("dynamicDiv").update(response.responseText);
					}
				} catch (e) {
					showErrorMessage("showSmsReportPrinting - onComplete : ", e);
				}
	        }
		});
	}
	
	$("exit").observe("click", function(){
		document.stopObserving("keyup");
		goToModule("/GIISUserController?action=goToSMS", "SMS Main", null);
	});
	
	$("reloadForm").observe("click", function(){
		showSmsReportPrinting();
	});
	
	$("btnRefresh").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("dateParamDiv")){
			document.stopObserving("keyup");
			populateFields();
		}
	});
	
	$("searchUser").observe("click", function(){
		showUserLOV($("txtUserId").value);
	});
	
	function populateFields(){
		new Ajax.Request(contextPath+"/GISMSmsReportController", {
			method: "GET",
			parameters: {
				action: "populateSmsReportPrint",
				fromDate:	$F("txtFromDate"),
				toDate:		$F("txtToDate"),
				asOfDate:	$F("txtAsOfDate"),
				user: 		$F("txtUserId"),
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					$("txtRecGlobe").value 	= obj.recGlobe;
					$("txtRecSmart").value 	= obj.recSmart;
					$("txtRecSun").value 	= obj.recSun;
					$("txtSentGlobe").value = obj.sentGlobe;
					$("txtSentSmart").value = obj.sentSmart;
					$("txtSentSun").value 	= obj.sentSun;
					$("txtRecTotal").value 	= obj.recTotal;
					$("txtSentTotal").value = obj.sentTotal;
				}
			}
		});
	}
	
	function showUserLOV(user){
		try{
			LOV.show({
				controller : "SmsLOVController",
				urlParameters : {
					action   : "getGISMS012UserListLOV",
					user : user,
					page : 1
				},
				title: "User",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'user',
						title: 'User ID',
						width : '100px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'userName',
						title: 'User Name',
					    width: '335px',
					    align: 'left'
					}
				],
				filterText: nvl(user, "%"), 
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtUserId").value = unescapeHTML2(row.user);
						$("txtUserName").value = unescapeHTML2(row.userName);
						$("txtUserId").setAttribute("lastValidValue", unescapeHTML2(row.user));
						$("txtUserName").setAttribute("lastValidValue", unescapeHTML2(row.userName));
						populateFields();
					}
				},
				onCancel: function(){
					$("txtUserId").focus();
					$("txtUserId").value = $("txtUserId").getAttribute("lastValidValue");
					$("txtUserName").value = $("txtUserName").getAttribute("lastValidValue");
					populateFields();
		  		},
		  		onUndefinedRow: function(){
		  			customShowMessageBox("No record selected.", imgMessage.INFO, "txtUserId");
					$("txtUserId").value = $("txtUserId").getAttribute("lastValidValue");
					$("txtUserName").value = $("txtUserName").getAttribute("lastValidValue");
					populateFields();
		  		}
			});
		}catch(e){
			showErrorMessage("showUserLOV",e);
		}
	}
	
	function toggleCalendar(enable){
		if (nvl(enable,false) == true){
			$("txtAsOfDate").value 		= "";
			//$("txtFromDate").value 		= getCurrentDate();
			//$("txtToDate").value 		= getCurrentDate();
			$("txtAsOfDate").disabled 	= true;
			$("txtFromDate").disabled 	= false;
			$("txtToDate").disabled 	= false;
			disableDate("imgAsOfDate");
			enableDate("imgFromDate");
			enableDate("imgToDate");
			$("txtFromDate").addClassName("required");
			$("txtToDate").addClassName("required");
		}else{	
			$("txtAsOfDate").value 		= getCurrentDate();
			$("txtFromDate").value 		= "";
			$("txtToDate").value 		= "";
			$("txtAsOfDate").disabled 	= false;
			$("txtFromDate").disabled 	= true;
			$("txtToDate").disabled 	= true;
			enableDate("imgAsOfDate");
			disableDate("imgFromDate");
			disableDate("imgToDate");
			$("txtFromDate").removeClassName("required");
			$("txtToDate").removeClassName("required");
		}
	}
	
	$("rdoByPeriod").observe("click", function() {
		toggleCalendar(true);
	});
	$("rdoAsOf").observe("click", function() {
		toggleCalendar(false);
	});
	
	function validateFromAndToDate(field) {
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g, "/")) : "";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g, "/")) : "";
		
		if (fromDate > toDate && toDate != "") {
			if (field == "txtFromDate") {
				customShowMessageBox("From date should not be later than To date.", "I", "txtFromDate");
			} else {
				customShowMessageBox("From date should not be later than To date.", "I", "txtToDate");
			}
			$(field).clear();
			return false;
		}
	}
	
	$("txtToDate").observe("focus", function() {
		validateFromAndToDate("txtToDate");
	});
	
	$("txtFromDate").observe("focus", function() {
		validateFromAndToDate("txtFromDate");
	});
	
	$("txtUserId").observe("change", function() {
		if($("txtUserId").value ==""){
			$("txtUserName").value = "ALL USER";
			$("txtUserId").setAttribute("lastValidValue", "");
			$("txtUserName").setAttribute("lastValidValue", unescapeHTML2("ALL USER"));
		} else {
			validateUser();
		}
		fireEvent($("btnRefresh"), "click");
	});
	
	function validateUser(){
		new Ajax.Request(contextPath+"/GISMSmsReportController", {
			method: "GET",
			parameters: {
				action: "validateGisms012User",
				user: $F("txtUserId")
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(nvl(obj.user, "") == "NO DATA"){
						showUserLOV($("txtUserId").value);						
						/* showWaitingMessageBox("User does not exist!", "I", function(){
							$("txtUserId").focus();
							$("txtUserId").value = "";
							$("txtUserName").value = "ALL USER"; 
						}); */
					}else if (nvl(obj.user, "") == "MANY"){
						showUserLOV($("txtUserId").value);
					}
					else{
						$("txtUserId").value = obj.user;
						$("txtUserName").value = obj.userName;
						$("txtUserId").setAttribute("lastValidValue", unescapeHTML2(obj.user));
						$("txtUserName").setAttribute("lastValidValue", unescapeHTML2(obj.userName));
					}
				}
			}
		});
	}
	
	function togglePrintFields(destination) {
		if ($("selDestination").value == "printer") {
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
			if ($("selDestination").value == "file") {
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
	
	$("selDestination").observe("change",function(){
		togglePrintFields($("selDestination").value);
	});
	$("imgSpinUp").observe("click", function() {
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if(no < 100){
			$("txtNoOfCopies").value = no + 1;
		}
	});

	$("imgSpinDown").observe("click", function() {
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if (no > 1) {
			$("txtNoOfCopies").value = no - 1;
		}
	});
	
	$("imgSpinUp").observe("mouseover", function() {
		$("imgSpinUp").src = contextPath + "/images/misc/spinupfocus.gif";
	});

	$("imgSpinDown").observe("mouseover", function() {
		$("imgSpinDown").src = contextPath + "/images/misc/spindownfocus.gif";
	});

	$("imgSpinUp").observe("mouseout", function() {
		$("imgSpinUp").src = contextPath + "/images/misc/spinup.gif";
	});

	$("imgSpinDown").observe("mouseout", function() {
		$("imgSpinDown").src = contextPath + "/images/misc/spindown.gif";
	});
	
	$("txtNoOfCopies").observe("change", function() {
		if ($("txtNoOfCopies").value <= 0 || $("txtNoOfCopies").value > 100){
			showWaitingMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", function(){
				$("txtNoOfCopies").focus();
				$("txtNoOfCopies").value = 1;
			});
		}
	});
	
	$("chkMessRecList").observe("click",function(){
		if($("chkMessRecList").checked == true){
			enableButton("btnPrint");
		} else if ($("chkMessRecList").checked == false && $("chkMessSentList").checked == true){
			enableButton("btnPrint");
		} else {
			disableButton("btnPrint");
		}
	});
	
	$("chkMessSentList").observe("click",function(){
		if($("chkMessSentList").checked == true){
			enableButton("btnPrint");
		} else if ($("chkMessSentList").checked == false && $("chkMessRecList").checked == true){
			enableButton("btnPrint");
		} else {
			disableButton("btnPrint");
		}
	});
	
	function getParams(report){
		var params = "";
		params = "&reportId="+ report+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate")+"&asOfDate="+$F("txtAsOfDate")+"&user="+$F("txtUserId");
		return params;
	}
	
	function validatePrint(){
		if ("printer" == $F("selDestination")) {
			if($F("printerName") == ""){
				showWaitingMessageBox("Required fields must be entered.", "I", function(){
					$("printerName").focus();
				});
				return false;
			}
			if($("txtNoOfCopies").value > 100 || $("txtNoOfCopies").value < 1){
				showWaitingMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", function(){
					$("txtNoOfCopies").focus();
				});
				return false;
			}
		}
	}
	
	function checkPrint(){
		if($("chkMessRecList").checked == true){
			validatePrint();
			printReport("GISMR012A", "Messages Received");
		}
		if($("chkMessSentList").checked == true){
			validatePrint();
			printReport("GISMR012B", "Messages Sent");
		}
		if ("screen" == $F("selDestination")) {
			showMultiPdfReport(reports);
			reports = [];
		}
	}
	
	$("btnPrint").observe("click",function(){
		if(checkAllRequiredFieldsInDiv("dateParamDiv")){
			checkPrint();
		}
	});
	
	function printReport(rep, repTitle) {
		try {
			var content = contextPath + "/GISMPrintReportController?action=printReport" + getParams(rep);
			if ("screen" == $F("selDestination")) {
				reports.push({reportUrl : content, reportTitle : repTitle});	
			} else if ($F("selDestination") == "printer") {
				new Ajax.Request(content, {
					parameters : {
						noOfCopies : $F("txtNoOfCopies"),
						printerName : $F("printerName")
					},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							showMessageBox("Printing complete.", imgMessage.SUCCESS);
						}
					}
				});
			} else if ("file" == $F("selDestination")) {
				new Ajax.Request(content, {
					parameters : {
						destination : "file",
						fileType : $("rdoPdf").checked ? "PDF" : "XLS"
					},
					onCreate : showNotice("Generating report, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							copyFileToLocal(response);
						}
					}
				});
			} else if ("local" == $F("selDestination")) {
				new Ajax.Request(content, {
					parameters : {
						destination : "local"
					},
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							var message = printToLocalPrinter(response.responseText);
							if (message != "SUCCESS") {
								showMessageBox(message, imgMessage.ERROR);
							} else {
								showMessageBox("Printing complete.", imgMessage.SUCCESS);
							}
						}
					}
				});
			}
		} catch (e) {
			showErrorMessage("printReport", e);
		}
	}
	
	
</script>