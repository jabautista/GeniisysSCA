<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<!-- 
removed by robert 10.02.2013 2 exit buttons
<div id="mainNavPerPolicy">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="clmPerPolExit">Exit</a></li>
			</ul>
		</div>
	</div>
</div> -->
<div id="clmListingPerPolicyMainDiv" name="clmListingPerPolicyMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Policy Information</label>
		</div>
	</div>	
	<div id="clmListingPerPolicyDiv" align="center" class="sectionDiv">
		<div style="margin: 5px; margin-left: 10px; width: 530px; float: left;">
			<table border="0" align="center">
				<tr>
					<td class="rightAligned" style="width: 75px;">Policy No.</td>
					<td class="rightAligned">
						<div id="lineCdDiv" style="width: 47px; float: left;" class="withIconDiv">
							<input type="text" id="txtNbtLineCd" name="txtNbtLineCd" value="" style="width: 22px;" class="withIcon allCaps" maxlength="2" tabindex="101">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtNbtLineCdIcon" name="txtNbtLineCdIcon" alt="Go" />
						</div>
						<div id="sublineCdDiv" style="width: 89px; float: left;" class="withIconDiv">
							<input type="text" id="txtNbtSublineCd" name="txtNbtSublineCd" value="" style="width: 64px;" class="withIcon allCaps" maxlength="7" tabindex="102">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtNbtSublineCdIcon" name="txtNbtSublineCdIcon" alt="Go" />
						</div>

						<div style="width: 47px; float: left;" class="withIconDiv">
							<input type="text" id="txtNbtPolIssCd" name="txtNbtPolIssCd" value="" style="width: 22px;" class="withIcon allCaps" maxlength="2" tabindex="103">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtNbtPolIssCdIcon" name="txtNbtPolIssCdIcon" alt="Go" />
						</div>
						<div style="width: 47px; float: left;" class="withIconDiv">
							<input type="text" id="txtNbtIssueYy" name="txtNbtIssueYy" value="" style="width: 22px;" class="withIcon integerNoNegativeUnformattedNoComma" maxlength="2" tabindex="104">
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtNbtIssueYyIcon" name="txtNbtIssueYyIcon" alt="Go" />
						</div>
						<input type="text" id="txtNbtPolSeqNo" name="txtNbtPolSeqNo" value="" style="width: 71px; float: left;" class="integerNoNegativeUnformattedNoComma" maxlength="7" tabindex="105">
						<input type="text" id="txtNbtRenewNo" name="txtNbtRenewNo" value="" style="width: 33px; float: left; margin-left: 4px;" class="integerNoNegativeUnformattedNoComma" maxlength="2" tabindex="106">
						<div class="withIconDiv" style="border: 0px; float: right;">
							<img style="margin-left: 3px; float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="nbtSearchPolicyIcon" name="nbtSearchPolicyIcon" alt="Go" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Assured</td>
					<td class="rightAligned">
						<input style="float: left; width: 370px;" type="text" id="txtNbtAssuredName" name="txtNbtAssuredName" readonly="readonly" tabindex="107">
					</td>
				</tr>
				<tr>
					<td></td>
					<td>
						<fieldset style="margin-left: 0; width: 361px;">
							<legend>Search by</legend>
							<table border="0" align="center">
								<tr>
									<td>
										<input style="float: left; margin: 4px 5px 0 0;" type="radio" id="rdoNbtDateType1" name="rdoNbtDateType" value="claimFileDate" checked="checked" tabindex="108">
									</td>
									<td>
										<label for="rdoNbtDateType1">Claim File Date</label>
									</td>
									<td>
										<input style="float: left; margin: 4px 5px 0 30px;" type="radio" id="rdoNbtDateType2" name="rdoNbtDateType" value="lossDate" tabindex="109">
									</td>
									<td><label for="rdoNbtDateType2">Loss Date</label></td>
								</tr>
							</table>
						</fieldset>
					</td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv" style="float: right; width: 255px; margin: 12px 60px 0 0;">
			<table border="0" align="center" style="margin: 8px;">
				<tr>
					<td class="rightAligned">
						<input type="radio" id="rdoDateBtn1" name="rdoDateBtn" value="asOf" checked="checked" tabindex="110">
					</td>
					<td class="rightAligned">
						<label for="rdoDateBtn1">As of </label>
					</td>
					<td class="rightAligned">
						<div id="divAsOfDate" style="padding: 1px 2px 0 0; float: left; margin-left: 3px; width: 165px;" class="withIconDiv">
							<input style="width: 105px;" class="withIcon" id="txtNbtAsOfDate" name="txtNbtAsOfDate" type="text" readOnly="readonly" tabindex="111"/>
							<img id="hrefNbtAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned"><input type="radio" id="rdoDateBtn2" name="rdoDateBtn" value="fromTo" tabindex="112"></td>
					<td class="rightAligned"><label for="rdoDateBtn2">From </label></td>
					<td class="rightAligned">
						<div id="divFromDate" style="padding: 1px 2px 0 0; float: left; margin-left: 3px; width: 165px;" class="withIconDiv">
							<input style="width: 105px;" class="withIcon" id="txtNbtFromDate" name="txtNbtFromDate" type="text" readOnly="readonly" tabindex="113" />
							<img id="hrefNbtFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned"></td>
					<td class="rightAligned"><label for="rdoDateBtn2" style="float: right;">To</label></td>
					<td class="rightAligned">
						<div id="divToDate" style="padding: 1px 2px 0 0; float: left; margin-left: 3px; width: 165px;" class="withIconDiv">
							<input style="width: 105px;" class="withIcon" id="txtNbtToDate" name="txtNbtToDate" type="text" readOnly="readonly" tabindex="114" />
							<img id="hrefNbtToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" />
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
	
	<div class="sectionDiv" style="margin-bottom: 50px;">
		<div id="clmListingPerPolicyDiv2" style="padding: 10px 0 0 5px; height: 503px; width: 911px;">
			<div id="clmPerPolicyDetailsGrid" style="height: 300px; margin-left: auto;"></div>
		</div>
	</div>
</div>
<script type="text/javascript">
	try {
		
		var onLOV = false;
		
		/* function getPolicyNo() {
			var policyNo = "&lineCd=" + $("txtNbtLineCd").value +
			               "&sublineCd=" + $("txtNbtSublineCd").value +
			               "&polIssCd=" + $("txtNbtPolIssCd").value +
			               "&issueYy=" +$("txtNbtIssueYy").value + 
			               "&polSeqNo=" + $("txtNbtPolSeqNo").value + 
			               "&renewNo=" + $("txtNbtRenewNo").value;
			return policyNo;
		} */
		initializeAll();
		
		var c0032Grid = JSON.parse('${perPolicyTG}'.replace(/\\/g, '\\\\'));
		
		if(c0032Grid.callFrom == 'GICLS010'){
			$('rdoNbtDateType1').disable();
			$('rdoNbtDateType2').disable();
			
			if(c0032Grid.total == 0){
				showWaitingMessageBox("You are not allowed to access this record.", "E", function(){
					objCLMGlobal.callingForm = "GICLS250"; 
					showClaimBasicInformation();
				});
			}
		}
		
		var c0032 = c0032Grid.rows || [];
		if (c0032.length == 1) {
			populateClmPerPolicy(c0032[0]);
		} else {
			populateClmPerPolicy(null);
		}
		
		function resetForm(){
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			$("rdoDateBtn1").enable();
			$("rdoDateBtn2").enable();
			$("txtNbtLineCd").clear();
            $("txtNbtSublineCd").clear();
            $("txtNbtPolIssCd").clear();
            $("txtNbtIssueYy").clear();
            $("txtNbtPolSeqNo").clear(); 
            $("txtNbtRenewNo").clear();
            $("txtNbtAssuredName").clear();
			$("txtNbtLineCd").focus();
			populateClmPerPolicy(null);
			$("txtTotLossResAmt").clear();
			$("txtTotExpResAmt").clear();
			$("txtTotLossPdAmt").clear();
			$("txtTotExpPdAmt").clear();
			disableSearchIcons(false);
			setFieldsToReadOnly(false);
			$("rdoNbtDateType1").click();
			$("rdoDateBtn1").click();
			objPolicy = new Object();
		}
		
		function getPolicyNo() {
			var policyNo = "&lineCd=" + $("txtNbtLineCd").value +
			               "&sublineCd=" + $("txtNbtSublineCd").value +
			               "&polIssCd=" + $("txtNbtPolIssCd").value +
			               "&issueYy=" +$("txtNbtIssueYy").value + 
			               "&polSeqNo=" + $("txtNbtPolSeqNo").value + 
			               "&renewNo=" + $("txtNbtRenewNo").value;
			return policyNo;
		}
		
		function executeQuery(){
			populateClmPerPolicy(objPolicy);
		}
		
		$("rdoNbtDateType1").observe("click", function(){
			if($("txtNbtLineCd").readOnly)
				populateClmPerPolicy(objPolicy);
		});
		
		$("rdoNbtDateType2").observe("click", function(){
			if($("txtNbtLineCd").readOnly)
				populateClmPerPolicy(objPolicy);
		});
		
		function resetFields() {
			enableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			$("txtNbtAssuredName").clear();
		}

		//Observe Enter Query BUTTON
		$("btnToolbarEnterQuery").observe("click", resetForm);
		
		//Observe Execute Query Button
		$("btnToolbarExecuteQuery").observe("click", function(){
			if($("rdoDateBtn2").checked == true){
				if($F("txtNbtFromDate") != "" && $F("txtNbtToDate") != ""){
					executeQuery();
				} else {
					customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "");
				}
			} else {
				executeQuery();
			}
		});
		
		/* 
		removed by robert 10.02.2013 2 exit buttons
		$("clmPerPolExit").observe("click", function(){
			delete objPolicy;
			if(c0032Grid.callFrom == 'GICLS010'){
				showClaimBasicInformation();
			} else
				goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
		}); */
		
		$("btnToolbarExit").observe("click", function(){
			delete objPolicy;
			if(c0032Grid.callFrom == 'GICLS010'){
				showClaimBasicInformation();
			} else
				goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
		});
		
		//Observe delete on DATE field
		/* observeBackSpaceOnDate("txtNbtAsOfDate");
		observeBackSpaceOnDate("txtNbtFromDate");
		observeBackSpaceOnDate("txtNbtToDate"); */

		//As of Date ICON CLICK event
		$("hrefNbtAsOfDate").observe("click", function() {
			if ($("hrefNbtAsOfDate").disabled == true)
				return;
			scwShow($('txtNbtAsOfDate'), this, null);
		});

		//As of Date validate event
		$("txtNbtAsOfDate").observe("focus", function() {
			if ($("hrefNbtAsOfDate").disabled == true)
				return;
			var asOfDate = $F("txtNbtAsOfDate") != "" ? new Date($F("txtNbtAsOfDate").replace(/-/g, "/")) : "";
			var sysdate = new Date();
			if (asOfDate > sysdate && asOfDate != "") {
				customShowMessageBox("Date should not be greater than the current date.", "I", "txtNbtAsOfDate");
				$("txtNbtAsOfDate").clear();
				return false;
			}
		});

		//From Date ICON CLICK event
		$("hrefNbtFromDate").observe("click", function() {
			if ($("hrefNbtFromDate").disabled == true)
				return;
			scwShow($('txtNbtFromDate'), this, null);
		});

		//From Date validate event
		$("txtNbtFromDate").observe("focus",function() {
			if ($("hrefNbtFromDate").disabled == true)
				return;
			var fromDate = $F("txtNbtFromDate") != "" ? new Date($F("txtNbtFromDate").replace(/-/g, "/")): "";
			var sysdate = new Date();
			if (fromDate > sysdate && fromDate != "") {
				customShowMessageBox("Date should not be greater than the current date.", "I", "txtNbtFromDate");
				$("txtNbtFromDate").clear();
				return false;
			}
		});

		//To Date ICON CLICK event
		$("hrefNbtToDate").observe("click", function() {
			if ($("hrefNbtToDate").disabled == true)
				return;
			scwShow($('txtNbtToDate'), this, null);
		});

		//To Date validate event
		$("txtNbtToDate").observe("focus",
		function() {
			if ($("hrefNbtToDate").disabled == true)
				return;
			var toDate = $F("txtNbtToDate") != "" ? new Date($F("txtNbtToDate").replace(/-/g, "/")) : "";
			var fromDate = $F("txtNbtFromDate") != "" ? new Date($F("txtNbtFromDate").replace(/-/g, "/")): "";
			var sysdate = new Date();
			if (toDate > sysdate && toDate != "") {
				customShowMessageBox("Date should not be greater than the current date.","I", "txtNbtToDate");
				$("txtNbtToDate").clear();
				return false;
			}
			if (toDate < fromDate && toDate != "") {
				customShowMessageBox("TO Date should not be less than the FROM date.","I", "txtNbtToDate");
				$("txtNbtToDate").clear();
				return false;
			}
		});

		//Search Policy ICON CLICK event
		$("nbtSearchPolicyIcon").observe("click",function() {
			if (checkRequiredFields() && $("txtNbtAssuredName").value == "")
				showClmPolicyNoLOV();
		});
		
		//Enable or Disable details in Date
		function enableFromToDate(enable) {
			if (nvl(enable, false) == true) {
				//enable
				$("txtNbtAsOfDate").value = "";
				$("txtNbtAsOfDate").disabled = true;
				$("hrefNbtAsOfDate").disabled = true;
				$("txtNbtFromDate").disabled = false;
				$("txtNbtToDate").disabled = false;
				$("hrefNbtFromDate").disabled = false;
				$("hrefNbtToDate").disabled = false;
				//added required styles in from-to date
				// pol cruz, 03-21-2013
				$("txtNbtFromDate").setStyle({backgroundColor : '#FFFACD'});
				$("divFromDate").setStyle({backgroundColor : '#FFFACD'});
				$("txtNbtToDate").setStyle({backgroundColor : '#FFFACD'});
				$("divToDate").setStyle({backgroundColor : '#FFFACD'});
				$("txtNbtAsOfDate").setStyle({backgroundColor : '#F0F0F0'});
				$("divAsOfDate").setStyle({backgroundColor : '#F0F0F0'});
				disableDate("hrefNbtAsOfDate");
				enableDate("hrefNbtFromDate");
				enableDate("hrefNbtToDate");
			} else {
				//disable
				$("txtNbtAsOfDate").value = getCurrentDate();
				$("txtNbtAsOfDate").disabled = false;
				$("hrefNbtAsOfDate").disabled = false;
				$("txtNbtFromDate").value = "";
				$("txtNbtToDate").value = "";
				$("txtNbtFromDate").disabled = true;
				$("txtNbtToDate").disabled = true;
				$("hrefNbtFromDate").disabled = true;
				$("hrefNbtToDate").disabled = true;
				//added required styles in from-to date
				// pol cruz, 03-21-2013
				$("txtNbtFromDate").setStyle({backgroundColor : '#F0F0F0'});
				$("divFromDate").setStyle({backgroundColor : '#F0F0F0'});
				$("txtNbtToDate").setStyle({backgroundColor : '#F0F0F0'});
				$("divToDate").setStyle({backgroundColor : '#F0F0F0'});
				$("txtNbtAsOfDate").setStyle({backgroundColor : 'white'});
				$("divAsOfDate").setStyle({backgroundColor : 'white'});
				enableDate("hrefNbtAsOfDate");
				disableDate("hrefNbtFromDate");
				disableDate("hrefNbtToDate");
			}
		}
		//Initialize GICL250
		function initGICL250() {
			onLOV = false;
			objPolicy = new Object();
			
			$("rdoNbtDateType1").checked = true;
			$("rdoDateBtn1").checked = true;
			$("lineCdDiv").setStyle({backgroundColor : '#FFFACD'});
			$("sublineCdDiv").setStyle({backgroundColor : '#FFFACD'});
			$("txtNbtLineCd").setStyle({backgroundColor : '#FFFACD'});
			$("txtNbtSublineCd").setStyle({backgroundColor : '#FFFACD'});
			$("txtNbtLineCd").focus();
			enableFromToDate(false);
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			disableToolbarButton("btnToolbarPrint");
		}
		
		function getParams(){
			var params =   "&lineCd=" +  $("txtNbtLineCd").value
						 + "&sublineCd=" + $("txtNbtSublineCd").value
						 + "&polIssCd=" + $("txtNbtPolIssCd").value
						 + "&issueYy=" + $("txtNbtIssueYy").value
						 + "&polSeqNo=" + $("txtNbtPolSeqNo").value
						 + "&renewNo=" + $("txtNbtRenewNo").value;
			
			if($("rdoNbtDateType1").checked)
				params += "&searchByOpt=fileDate";
			else
				params += "&searchByOpt=lossDate";
			
			params += "&dateAsOf=" + $("txtNbtAsOfDate").value + "&dateFrom=" + $("txtNbtFromDate").value + "&dateTo=" + $("txtNbtToDate").value;
			
			return params;
		} 
		var reports = [];
		function checkReport(){
			if(!$("chkClaimListing").checked && !$("chkRecoveryListing").checked){
				customShowMessageBox("Please choose which report you want to print.", imgMessage.ERROR, 'btnToolbarPrint');
				return false;
			}
			
			var reportId = [];
			
			if($("chkClaimListing").checked)
				reportId.push("GICLR250");
			if($("chkRecoveryListing").checked)
				reportId.push("GICLR250A");

			for(var i=0; i < reportId.length; i++){
				printReport(reportId[i]);	
			}
			
			if ("screen" == $F("selDestination")) {
				showMultiPdfReport(reports);
				reports = [];
			}
		}
		objCLM.checkReport = checkReport;
		
		function printReport(reportId){
			try {
				var content = contextPath + "/PrintClaimListingInquiryController?action=printReport"
						                  + "&reportId=" + reportId
						                  + "&moduleId=GICLS250"
						                  + getParams();
				
				if(reportId == "GICLR250")
					reptTitle = "Claim Listing per Policy";
				else
					reptTitle = "Recovery Listing per Policy";
				
				if("screen" == $F("selDestination")){
					reports.push({reportUrl : content, reportTitle : reptTitle});
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
									  fileType : $("rdoPdf").checked ? "PDF" : "XLS"},
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								copyFileToLocal(response);
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
		objCLM.printReport = printReport;
		
		function addCheckbox(){
			var htmlCode = "<table cellspacing='10px' style='margin: 10px;'><tr><td><input type='checkbox' id='chkClaimListing' checked='checked' /></td><td><label for='chkClaimListing'>Claim Listing Per Policy</label></td></tr><tr><td><input type='checkbox' checked='checked' id='chkRecoveryListing' /></td><td><label for='chkRecoveryListing'>Recovery Listing Per Policy</label></td></tr></table>"; 
			
			$("printDialogFormDiv2").update(htmlCode); 
			$("printDialogFormDiv2").show();
			$("printDialogMainDiv").up("div",1).style.height = "248px";
			$($("printDialogMainDiv").up("div",1).id).up("div",0).style.height = "280px";
			
			if(objCLM.giclClmReserveExist == 'N'){
				$("chkRecoveryListing").checked = false;
				$("chkRecoveryListing").disable();
			}
				
		}
		objCLM.addCheckbox = addCheckbox;
		
		$("btnToolbarPrint").observe("click", function(){
			showGenericPrintDialog("Print Claim Listing / Recovery Listing  per Policy", checkReport, addCheckbox, true);
		});

		//As Of Radio Button Event
		$("rdoDateBtn1").observe("click", function(a) {
			enableFromToDate(false);
		});

		//From Radio Button Event
		$("rdoDateBtn2").observe("click", function(a) {
			enableFromToDate(true);
		});

		//Line code/name LOV
		$("txtNbtLineCd").observe("keypress", function(event){
			if(!$("txtNbtLineCd").readOnly){
				checkWhenUserTypes(event);
			}
			if(event.keyCode == 13 && !$("txtNbtLineCd").readOnly) {
				this.disable();
				showClmLineCdLOV2("GICLS250");
			}
		});
		
		$("txtNbtLineCdIcon").observe("click", function() {
			showClmLineCdLOV2("GICLS250");
		});

		//Subline code/name LOV
		$("txtNbtSublineCd").observe("keypress", function(event){
			if(!$("txtNbtLineCd").readOnly){
				checkWhenUserTypes(event);
			} 
			if(event.keyCode == 13 && !$("txtNbtLineCd").readOnly) {
				if (trim($("txtNbtLineCd").value) == ""){
					customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtNbtLineCd");
					return false;
				}
				this.disable();
				showClmSublineCdLOV("GICLS250", $F("txtNbtLineCd"));
			}
		});
		
		$("txtNbtSublineCdIcon").observe("click", function() {
			if (trim($("txtNbtLineCd").value) == ""){
				customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtNbtLineCd");
				return false;
			}
			showClmSublineCdLOV("GICLS250", $F("txtNbtLineCd"));
		});

		//Issue code/name LOV
		$("txtNbtPolIssCdIcon").observe("click", function() {
			if(checkRequiredFields())
				showClmIssCdLOV2("GICLS250", $F("txtNbtLineCd"),$F("txtNbtSublineCd"));
		});
		
		$("txtNbtPolIssCd").observe("keypress", function(event){
			if(event.keyCode == 13 && !$("txtNbtLineCd").readOnly) {
				if(checkRequiredFields()){
					this.disable();
					showClmIssCdLOV2("GICLS250", $F("txtNbtLineCd"),$F("txtNbtSublineCd"));
				}
			}
			if(!$("txtNbtLineCd").readOnly){
				checkWhenUserTypes(event);
			}
		});

		//Issue year LOV
		$("txtNbtIssueYyIcon").observe("click", function() {
			if (checkRequiredFields())
				showClmIssueYyLOV("GICLS250", $F("txtNbtLineCd"), $F("txtNbtSublineCd"));
		});
		
		$("txtNbtIssueYy").observe("keypress", function(event){
			if(event.keyCode == 13 && !$("txtNbtLineCd").readOnly) {
				if(checkRequiredFields()){
					this.disable();
					showClmIssueYyLOV("GICLS250", $F("txtNbtLineCd"), $F("txtNbtSublineCd"));
				}
			}
			if(!$("txtNbtLineCd").readOnly){
				checkWhenUserTypes(event);
			}
		});
		
		$("txtNbtPolSeqNo").observe("keypress", function(event){
			if(!$("txtNbtLineCd").readOnly){
				checkWhenUserTypes(event);
			} 
			if(event.keyCode == 13){
				$("nbtSearchPolicyIcon").click();
			};
		});

		$("txtNbtRenewNo").observe("keypress", function(event){
			if(!$("txtNbtLineCd").readOnly){
				checkWhenUserTypes(event);
			}
			if(event.keyCode == 13){
				$("nbtSearchPolicyIcon").click();
			};
		});
		
		function checkWhenUserTypes(event){
			if(event.keyCode == 0 || event.keyCode == 8){
				$("txtNbtAssuredName").clear();
				enableToolbarButton('btnToolbarEnterQuery');
				disableToolbarButton("btnToolbarExecuteQuery");
			}
		}
		
		function checkRequiredFields() {
			if (trim($("txtNbtLineCd").value) == "") {
				$("txtNbtLineCd").clear();
				customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtNbtLineCd");
				return false;
			} else if(trim($("txtNbtSublineCd").value) == ""){
				$("txtNbtSublineCd").clear();
				customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtNbtSublineCd");
				return false;
			} else
				return true;
		}

		initGICL250();
		window.scrollTo(0, 0);
		setModuleId("GICLS250");
		setDocumentTitle("Claim Listing Per Policy");
		hideNotice("");
	} catch (e) {
		showErrorMessage("Claim Listing Per Policy page.", e);
	}
</script>