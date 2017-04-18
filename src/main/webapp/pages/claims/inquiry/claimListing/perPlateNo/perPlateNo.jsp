<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="mainNavPerPlateNo">
 	<!-- 
 	removed by robert 10.02.2013 2 exit buttons
 	<div id="perPlateNoSubMenu">
	 	<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnPerPlateNoExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div> -->
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Claim Listing per Plate No</label>
	   	</div>
	</div>		
	<div class="sectionDiv" style="padding: 0 0 10px 0;">
		<div style="float: left;">
			<table style="margin: 10px 10px 5px 59px;">
				<tr>
					<td class="rightAligned">Plate No</td>
					<td class="leftAligned">
						<span class="lovSpan required" style="width: 400px; margin-right: 30px;">
							<input type="text" id="txtPlateNo" ignoreDelKey="true" style="width: 370px; float: left; border: none; height: 14px; margin: 0;" class="required" tabindex="101"/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchPlateNo" alt="Go" style="float: right;" tabindex="102"/>
						</span>
					</td>
				</tr>
			</table>
			<div style="float: left; margin-left: 115px; margin-bottom: 10px;">
				<fieldset style="width: 385px;">
					<legend>Search By</legend>
					<table>
						<tr>
							<td class="rightAligned">
								<input type="radio" name="searchBy" id="rdoClaimFileDate" style="float: left; margin: 3px 2px 3px 70px;" tabindex="103" />
								<label for="rdoClaimFileDate" style="float: left; height: 20px; padding-top: 3px;" title="Claim File Date">Claim File Date</label>
							</td>
							<td class="rightAligned">
								<input type="radio" name="searchBy" id="rdoLossDate" style="float: left; margin: 3px 2px 3px 50px;" tabindex="104" />
								<label for="rdoLossDate" style="float: left; height: 20px; padding-top: 3px;" title="Loss Date">Loss Date</label>
							</td>
						</tr>
					</table>
				</fieldset>
			</div>
		</div>
		<div class="sectionDiv" style="float: right; width: 255px; margin: 12px 60px 0 0;">
			<table style="margin: 8px;">	
				<tr>
					<td class="rightAligned"><input type="radio" name="byDate" id="rdoAsOf" title="As of" style="float: left;" tabindex="105"/><label for="rdoAsOf" title="As of" style="float: left; height: 20px; padding-top: 3px;">As of</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv" id="divAsOf">
							<input type="text" removeStyle="true" id="txtAsOf" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="106"/>
							<img id="imgAsOf" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" tabindex="107"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned"><input type="radio" name="byDate" id="rdoFrom" title="From" style="float: left;" tabindex="108"/><label for="rdoFrom" style="float: left; height: 20px; padding-top: 3px;">From</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv" id="divFrom">
							<input type="text" removeStyle="true" id="txtFrom" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="109"/>
							<img id="imgFrom" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" tabindex="110"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">To</td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv" id="divTo">
							<input type="text" removeStyle="true" id="txtTo" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="111"/>
							<img id="imgTo" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex="112"/>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div class="sectionDiv" style="margin-bottom: 50px;">
		<div style="padding: 10px 0 0 10px;">
			<div id="perPlateNoTable" style="height: 300px; margin-left: auto;"></div>
		</div>
		<div style="margin: 5px; float: left; margin-left: 20px;">
			<table>
				<tr>
					<td>
						<input type="button" id="btnRecoveryDetails" class="disabledButton" value="Recovery Details" tabindex="201" />
					</td>
					<td>
						<input type="button" id="btnVehicleInformation" class="disabledButton" value="Vehicle Information" tabindex="202" />
					</td>
				</tr>		
			</table>	
		</div>
		<div style="margin: 5px; float: right; margin-right: 20px;">
			<table>
				<tr>
					<td class="rightAligned">Totals</td>
					<td class=""><input type="text" id="txtTotLossReserve" style="width: 120px; text-align: right;" readonly="readonly" tabindex="203"/></td>
					<td class=""><input type="text" id="txtTotExpenseReserve" style="width: 120px; text-align: right;" readonly="readonly" tabindex="204"/></td>
					<td class=""><input type="text" id="txtTotLossesPaid" style="width: 120px; text-align: right;" readonly="readonly" tabindex="205"/></td>
					<td class=""><input type="text" id="txtTotExpensesPaid" style="width: 120px; text-align: right;" readonly="readonly" tabindex="206"/></td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv" style="margin: 10px; float: left; width: 97.5%;">
			<table style="margin: 5px; float: left;">
				<tr>
					<td class="rightAligned">Assured</td>
					<td class="leftAligned" colspan="4">
						<input type="text" id="txtAssured" style="width: 99%" readonly="readonly" tabindex="301" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Policy Number</td>
					<td class="leftAligned"><input type="text" id="txtPolicyNo" style="width: 370px;" readonly="readonly" tabindex="302"/></td>
					<td width="50px"></td>
					<td class="rightAligned">Loss Date</td>
					<td class="leftAligned"><input type="text" id="txtLossDate" style="width: 230px;" readonly="readonly" tabindex="304"/></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 110px;">Claim Number</td>
					<td class="leftAligned"><input type="text" id="txtClaimNo" style="width: 370px;" readonly="readonly" tabindex="303"/></td>
					<td></td>
					<td class="rightAligned">File Date</td>
					<td class="leftAligned"><input type="text" id="txtFileDate" style="width: 230px;" readonly="readonly" tabindex="305"/></td>
				</tr>			
			</table>
		</div>
		<div style="float: left; width: 100%; margin-bottom: 10px;" align="center">
			<input type="button" class="disabledButton" id="btnPrintReport" value="Print Report" tabindex="401"/>
		</div>
		<div>
			<input type="hidden" class="recoverySw" id="recoverySw"/>
		</div>
	</div>
</div>

<script type="text/javascript">
	try{
		onLOV = false;
		setModuleId("GICLS268");
		setDocumentTitle("Claim Listing Per Plate No.");
		
		function initGICLS268(){
			onLOV = false;
			$("txtPlateNo").focus();
			$("rdoAsOf").checked = true;
			$("txtAsOf").value = getCurrentDate();
			$("rdoClaimFileDate").checked = true;
			disableFromToFields();
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			setPrintButtons(false);
			objVehicleInfo = new Object();
			objRecovery = new Object();
		}
		
		function setPrintButtons(x){
			if(x){
				enableButton("btnPrintReport");
				enableToolbarButton("btnToolbarPrint");
			} else {
				disableButton("btnPrintReport");
				disableToolbarButton("btnToolbarPrint");
				
			}
		}
		
		function disableFromToFields() {
			$("txtAsOf").disabled = false;
			$("imgAsOf").disabled = false;
			$("txtFrom").disabled = true;
			$("txtTo").disabled = true;
			$("imgFrom").disabled = true;
			$("imgTo").disabled = true;
			$("txtFrom").value = "";
			$("txtTo").value = "";
			$("rdoAsOf").checked = true;
			$("txtAsOf").value = getCurrentDate();
			disableDate("imgFrom");
			disableDate("imgTo");
			enableDate("imgAsOf");
			$("txtFrom").setStyle({backgroundColor: '#F0F0F0'});
			$("divFrom").setStyle({backgroundColor: '#F0F0F0'});
			$("txtTo").setStyle({backgroundColor: '#F0F0F0'});
			$("divTo").setStyle({backgroundColor: '#F0F0F0'});
			$("txtAsOf").setStyle({backgroundColor: 'white'});
			$("divAsOf").setStyle({backgroundColor: 'white'});
		}
		
		function disableAsOfFields() {
			$("txtFrom").disabled = false;
			$("imgFrom").disabled = false;
			$("imgTo").disabled = false;
			$("txtTo").disabled = false;
			$("txtAsOf").disabled = true;
			$("imgAsOf").disabled = true;
			$("txtAsOf").value = "";
			$("rdoFrom").checked = true;
			disableDate("imgAsOf");
			enableDate("imgFrom");
			enableDate("imgTo");
			$("txtFrom").setStyle({backgroundColor: '#FFFACD'});
			$("divFrom").setStyle({backgroundColor: '#FFFACD'});
			$("txtTo").setStyle({backgroundColor: '#FFFACD'});
			$("divTo").setStyle({backgroundColor: '#FFFACD'});
			$("txtAsOf").setStyle({backgroundColor: '#F0F0F0'});
			$("divAsOf").setStyle({backgroundColor: '#F0F0F0'});
		}
		
		function disableFields() {
			$("rdoAsOf").disable();
			$("txtAsOf").disable();
			$("rdoFrom").disable();
			$("txtFrom").disable();
			$("txtTo").disable();
			$("imgAsOf").disabled = true;
			$("imgFrom").disabled = true;
			$("imgTo").disabled = true;
			disableSearch("imgSearchPlateNo");
			disableDate("imgAsOf");
			disableDate("imgFrom");
			disableDate("imgTo");
			$("txtPlateNo").readOnly = true;
			$("txtFrom").setStyle({backgroundColor: '#F0F0F0'});
			$("divFrom").setStyle({backgroundColor: '#F0F0F0'});
			$("txtTo").setStyle({backgroundColor: '#F0F0F0'});
			$("divTo").setStyle({backgroundColor: '#F0F0F0'});
			$("txtAsOf").setStyle({backgroundColor: '#F0F0F0'});
			$("divAsOf").setStyle({backgroundColor: '#F0F0F0'});
			disableToolbarButton("btnToolbarExecuteQuery");
		}
		
		observeBackSpaceOnDate("txtAsOf");
		observeBackSpaceOnDate("txtFrom");
		observeBackSpaceOnDate("txtTo");
		
		function validateRequiredDates(){
			if($("rdoFrom").checked){
				if($("txtFrom").value == ""){
					customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "txtFrom");
					return false;	
				}
				else if($("txtTo").value == ""){
					customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "txtTo");
					return false;
				}
			}
			return true;
		}
		
		function getParams() {
			var params = "";
			if(!$("rdoClaimFileDate").checked && !$("rdoLossDate").checked)
				$("rdoClaimFileDate").checked = true;
			
			if($("rdoClaimFileDate").checked)
				params = "&searchByOpt=fileDate";
			else
				params = "&searchByOpt=lossDate";
			params = params + "&dateAsOf=" + $("txtAsOf").value + "&dateFrom=" + $("txtFrom").value + "&dateTo=" + $("txtTo").value;
			return params;
		}
		
		$("txtAsOf").observe("focus", function(){
			if ($("imgAsOf").disabled == true) return;
			var asOfDate = $F("txtAsOf") != "" ? new Date($F("txtAsOf").replace(/-/g,"/")) :"";
			var sysdate = new Date();
			if (asOfDate > sysdate && asOfDate != ""){
				customShowMessageBox("Date should not be greater than the current date.", "I", "txtAsOf");
				$("txtAsOf").clear();
				return false;
			}
		});
		
	 	$("txtFrom").observe("focus", function(){
			if ($("imgFrom").disabled == true) return;
			var fromDate = $F("txtFrom") != "" ? new Date($F("txtFrom").replace(/-/g,"/")) :"";
			var sysdate = new Date();
			var toDate = $F("txtTo") != "" ? new Date($F("txtTo").replace(/-/g,"/")) :"";
			if (fromDate > sysdate && fromDate != ""){
				customShowMessageBox("Date should not be greater than the current date.", "I", "txtFrom");
				$("txtFrom").clear();
				$("txtTo").clear();
				return false;
			}
			if (toDate < fromDate && toDate != ""){
				customShowMessageBox("From Date should not be later than To Date.", "I", "txtTo");
				$("txtFrom").clear();
				$("txtTo").clear();
				return false;
			}
		});
	 	
	 	$("txtTo").observe("focus", function(){
			if ($("imgTo").disabled == true) return;
			var toDate = $F("txtTo") != "" ? new Date($F("txtTo").replace(/-/g,"/")) :"";
			var fromDate = $F("txtFrom") != "" ? new Date($F("txtFrom").replace(/-/g,"/")) :"";
			var sysdate = new Date();
			if (toDate > sysdate && toDate != ""){
				customShowMessageBox("Date should not be greater than the current date.", "I", "txtTo");
				$("txtTo").clear();
				return false;
			}
			if (toDate < fromDate && toDate != ""){
				customShowMessageBox("TO Date should not be less than the FROM date.", "I", "txtTo");
				$("txtTo").clear();
				return false;
			}
			if(fromDate=="" && toDate!=""){
				customShowMessageBox("Please enter FROM date first.", "I", "txtTo");
				$("txtTo").clear();
				$("txtFrom").clear();
				return false;
			}
		});
	 	
	 	function changeSearchByOpt(){
	 		if($("txtPlateNo").readOnly){
				tbgClaimsPerPlateNo.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerPlateNo&refresh=1&plateNo="+$("txtPlateNo").value + getParams();
				tbgClaimsPerPlateNo._refreshList();
	 		}	
	 		//added codes below by robert 10.02.2013
	 		if (tbgClaimsPerPlateNo.geniisysRows.length == 0){
				setPrintButtons(false);
			} else{
				setPrintButtons(true);
			}
		}
	 	
	 	function resetForm(){
			$("txtPlateNo").clear();
			$("txtPlateNo").enable();
			$("txtPlateNo").removeAttribute("readonly");
			enableSearch("imgSearchPlateNo");
			$("rdoAsOf").enable();
			$("rdoClaimFileDate").checked = false;
			$("rdoLossDate").checked = false;
			$("rdoFrom").disabled = false;
			setDetails(null);
			tbgClaimsPerPlateNo.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerPlateNo&refresh=1";
			tbgClaimsPerPlateNo._refreshList();
			initGICLS268();
		}
	 	
	 	function showGICLS268PlateNoLOV(){
	 		onLOV = true;
			LOV.show({ 
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getPlateNoGICLS268LOV",
					page : 1,
					searchString : $("txtPlateNo").value
				},
				title : "List of Plate No",
				width : 370,
				height : 386,
				columnModel : [ {
					id : "plateNo",
					title : "Plate No",
					width : 357,
				}],
				draggable : true,
				autoSelectOneRecord: true,
				filterText:  $("txtPlateNo").value,
				onSelect : function(row) {			
						$("txtPlateNo").value = unescapeHTML2(row.plateNo);
						onLOV = false;
						enableToolbarButton("btnToolbarEnterQuery");
						enableToolbarButton("btnToolbarExecuteQuery");
				},
				onCancel : function () {
					onLOV = false;
					$("txtPlateNo").focus();
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtPlateNo");
					onLOV = false;
				}
			});
		}
	 	
	 	function executeQuery(){
	 		tbgClaimsPerPlateNo.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerPlateNo&refresh=1&plateNo="+ $("txtPlateNo").value + getParams();
			tbgClaimsPerPlateNo._refreshList();
			if (tbgClaimsPerPlateNo.geniisysRows.length == 0){
				customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtPlateNo");
				setPrintButtons(false);
			} else{
				$("recoverySw").value = "N";
				for(var i = 0 ; i < tbgClaimsPerPlateNo.geniisysRows.length; i++){
					if(tbgClaimsPerPlateNo.geniisysRows[i].recoverySw == "Y"){
						$("recoverySw").value = "Y";
					}
				}
				setPrintButtons(true);
			}
			disableFields();
	 	}
	 	
	 	function showRecoveryDetails() {
			try {
			overlayRecoveryDetails = 
				Overlay.show(contextPath+"/GICLClaimListingInquiryController", {
					urlContent: true,
					urlParameters: {action : "showRecoveryDetails",																
									ajax : "1",
									claimId : objRecovery.claimId
					},			
				    title: "Recovery Details",
				    height: 500,
				    width: 820,
				    draggable: true
				});
			} catch (e) {
				showErrorMessage("overlay error: " , e);
			}
		}
	 	
	 	function showVehicleInfo() {
			try {
			overlayVehicleInfo = 
				Overlay.show(contextPath+"/GICLMotorCarDtlController", {
					urlContent: true,
					urlParameters: {action : "showVehicleInfo",																
									ajax : "1",
									claimId : objVehicleInfo.claimId,
									vehicleType : objVehicleInfo.vehicleType,
									sublineCd : objVehicleInfo.sublineCd,
									owner : $("txtAssured").value,
									vehicleType : objVehicleInfo.vehicleType
					},				
				    title: "Vehicle Information",
				    height: 305,
				    width: 797,
				    draggable: true
				});
			} catch (e) {
				showErrorMessage("overlay error: " , e);
			}
		}
	 	
	 	$("rdoClaimFileDate").observe("click", changeSearchByOpt);
		$("rdoLossDate").observe("click", changeSearchByOpt);
		$("btnRecoveryDetails").observe("click", showRecoveryDetails);
		$("btnVehicleInformation").observe("click", showVehicleInfo);
		$("btnToolbarEnterQuery").observe("click", resetForm);
		$("rdoAsOf").observe("click", disableFromToFields);
		$("rdoFrom").observe("click", disableAsOfFields);
		
		$("btnToolbarExecuteQuery").observe("click", function(){
			if(validateRequiredDates())
				executeQuery();
		});
		
		$("btnPrintReport").observe("click", function(){
			showGenericPrintDialog("Print Claim Listing per Plate No", checkReport, loadPrintGiclr268, true);
			$("csvOptionDiv").show(); // added by carlo de guzman 3.31.2016 SR5406
		});
		
		$("btnToolbarPrint").observe("click", function(){
			showGenericPrintDialog("Print Claim Listing per Plate No", checkReport, loadPrintGiclr268, true);
			$("csvOptionDiv").show(); // added by carlo de guzman 3.31.2016 SR5406
		});
		
		var reports = [];
		function checkReport(){
			if(!($("clmListingPerPlateNo").checked) && !($("rcvryListingPerPlateNo").checked)){
				showMessageBox("Please select the type of report you want to print.", "I");
				return false;
			}
			var reportId = [];
			if($("clmListingPerPlateNo").checked){
				reportId.push({reportId : "GICLR268"});
			}
			if($("rcvryListingPerPlateNo").checked){
				reportId.push({reportId : "GICLR268A"});
			} 
			for(var i=0; i < reportId.length; i++){
				doPrint(reportId[i].reportId);	
			}
			if ("screen" == $F("selDestination")) {
				showMultiPdfReport(reports);
				reports = [];
			}
		}
		
		function doPrint(reportId){
			try {
				var content;
				var searchBy;
				if($("rdoClaimFileDate").checked){
					searchBy = "claimFileDate";
				}else{
					searchBy = "lossDate";
				}
				content = contextPath+"/PrintClaimListingInquiryController?action=printReport&reportId="+reportId+"&printerName="+$F("selPrinter")					
						+"&plateNo="+$F("txtPlateNo")+"&searchBy="+searchBy+"&fromDate="+$F("txtFrom")+"&toDate="+$F("txtTo")+"&asOfDate="+$F("txtAsOf");
				if($F("selDestination") == "screen"){
					var reportTitle = "";
					if(reportId == "GICLR268")
						reportTitle = "Claim Listing per Plate No.";
					else
						reportTitle = "Recovery Listing per Plate No.";
					reports.push({reportUrl : content, reportTitle : reportTitle});			
				}else if($F("selDestination") == "printer"){
					new Ajax.Request(content, {
						method: "GET",
						parameters : {noOfCopies : $F("txtNoOfCopies"),
								 	 printerName : $F("selPrinter")
								 	 },
						evalScripts: true,
						asynchronous: true,
						onComplete: function(response){
							if (checkErrorOnResponse(response)){
							
							}
						}
					});
				}else if($F("selDestination") == "file"){
				    var fileType = "PDF"; // added by carlo de guzman 3.31.2016 SR 5406
					
					if($("rdoPdf").checked) 
						fileType = "PDF";
					else if ($("rdoCsv").checked)
						fileType = "CSV";  // end
					new Ajax.Request(content, {
						parameters : {destination : "file",
								    //fileType : $("rdoPdf").checked ? "PDF" : "XLS"}, removed by carlo de guzman 3.31.2016 SR 5406
							          fileType : fileType},
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								if (fileType == "CSV"){  // added by carlo de guzman 3.31.2016 SR 5406
									copyFileToLocal(response, "csv");
									deleteCSVFileFromServer(response.responseText);
									} else  // end
								copyFileToLocal(response);
							}
						}
					});
				}else if("local" == $F("selDestination")){
					new Ajax.Request(content, {
						method: "POST",
						parameters : {destination : "local"},
						evalScripts: true,
						asynchronous: true,
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
			} catch (e) {
				showErrorMessage("printReport", e);
			}
		}
		
		function loadPrintGiclr268(){
			try{ 
				var content = "<table border='0' style='margin: auto; margin-top: 10px; margin-bottom: 10px;'><tr><td><input type='checkbox' id='clmListingPerPlateNo' name='clmListingPerPlateNo' style='float: left; margin-bottom: 5px;'><label style='margin-top: 2px; margin-right: 20px;' for='clmListingPerPlateNo'>Claim Listing Per Plate No.</label></td></tr>"+
							  "<tr><td><input type='checkbox' id='rcvryListingPerPlateNo' name='rcvryListingPerPlateNo' style='float: left; padding-bottom: 3px;'><label for='rcvryListingPerPlateNo'>Recovery Listing Per Plate No.</label></td></tr>"; 
				$("printDialogFormDiv2").update(content); 
				$("printDialogFormDiv2").show();
				$("printDialogMainDiv").up("div",1).style.height = "235px";
				$($("printDialogMainDiv").up("div",1).id).up("div",0).style.height = "267px";
				
				if($("recoverySw").value == "Y"){
					$("rcvryListingPerPlateNo").checked = true;
				}else{
					$("rcvryListingPerPlateNo").disabled = true;
				}
				$("clmListingPerPlateNo").checked = true;
				
				$("selPrinter").removeClassName("required");
				$("txtNoOfCopies").removeClassName("required");
				$("selDestination").observe("change", function(){
					if($F("selDestination") != "printer"){
						$("selPrinter").removeClassName("required");
						$("txtNoOfCopies").removeClassName("required");
					}else{
						$("selPrinter").addClassName("required");
						$("txtNoOfCopies").addClassName("required");
					}
				});
			}catch(e){
				showErrorMessage("loadPrintGiclr268", e);	
			}
		}
		
		$("txtAsOf").observe("blur", function(){
			if($("txtAsOf").value == "")
				$("txtAsOf").value = getCurrentDate();
		});
		
		$("txtPlateNo").observe('keypress', function(event){
			disableToolbarButton("btnToolbarExecuteQuery");
		    if(event.keyCode == Event.KEY_RETURN) {
		    	if(onLOV || $("txtPlateNo").readOnly)
		    		return;
		    	showGICLS268PlateNoLOV();
		    }
		});
		
		$("imgSearchPlateNo").observe("click", function(){
			if(onLOV || $("txtPlateNo").readOnly)
	    		return;
	    	showGICLS268PlateNoLOV();
		});
		
		$("imgAsOf").observe("click", function() {
			if ($("imgAsOf").disabled == true)
				return;
			scwShow($('txtAsOf'), this, null);
		});
		
		$("imgFrom").observe("click", function() {
			if ($("imgFrom").disabled == true)
				return;
			scwShow($('txtFrom'), this, null);
		});
		
		$("imgTo").observe("click", function() {
			if ($("imgTo").disabled == true)
				return;
			scwShow($('txtTo'), this, null);
		});
	 	
		function setDetails(rec) {
	 		if(rec != null){
	 			objVehicleInfo.claimId = rec.claimId;
	 			objVehicleInfo.vehicleType = rec.vehicleType;
	 			objVehicleInfo.sublineCd = rec.sublineCd;
	 			enableButton("btnVehicleInformation");
				
				if(rec.recoveryDetCount > 0){
					objRecovery.claimId = rec.claimId;
					enableButton("btnRecoveryDetails");
				} else {
					disableButton("btnRecoveryDetails");
				}
	 			
	 			$("txtAssured").value = unescapeHTML2(rec.assuredName);
	 			$("txtClaimNo").value = rec.claimNo;
	 			$("txtPolicyNo").value = rec.policyNo;
	 			$("txtLossDate").value = dateFormat(rec.lossDate, "mm-dd-yyyy");
	 			$("txtFileDate").value = dateFormat(rec.clmFileDate, "mm-dd-yyyy");
	 		} else {
				disableButton("btnVehicleInformation");
				disableButton("btnRecoveryDetails");
	 			$("txtAssured").clear();
	 			$("txtClaimNo").clear();
	 			$("txtPolicyNo").clear();
	 			$("txtLossDate").clear();
	 			$("txtFileDate").clear();
	 		}
	 	}
	
		var jsonClmListPerPlateNo = JSON.parse('${jsonClmListPerPlateNo}');		
		perPlateNoTableModel = {
				options: {
					toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
					},
					width: '900px',
					pager: {
					},  
					onCellFocus : function(element, value, x, y, id) {
						setDetails(tbgClaimsPerPlateNo.geniisysRows[y]);					
						tbgClaimsPerPlateNo.keys.removeFocus(tbgClaimsPerPlateNo.keys._nCurrentFocus, true);
						tbgClaimsPerPlateNo.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id){
						setDetails(null);
						tbgClaimsPerPlateNo.keys.removeFocus(tbgClaimsPerPlateNo.keys._nCurrentFocus, true);
						tbgClaimsPerPlateNo.keys.releaseKeys();
					}
				},									
				columnModel: [
					{
					    id: 'recordStatus',
					    title: '',
					    width: '0',
					    visible: false
					},
					{
						id: 'divCtrId',
						width: '0',
						visible: false 
					},				
					{
						id : 'adverseParty',
						title : 'A',
						altTitle : 'Adverse Party',
						width : '25px',
						editable : false,
						defaultValue : false,
						otherValue : false,
						filterOption : true,
						filterOptionType : 'checkbox',
						editor : new MyTableGrid.CellCheckbox({
							getValueOf : function(value) {
								if (value) {
									return "Y";
								} else {
									return "N";
								}
							}
						})
					},
					{
						id : 'thirdParty',
						title : 'T',
						altTitle : 'Third Party',
						width : '25px',
						editable : false,
						defaultValue : false,
						otherValue : false,
						filterOption : true,
						filterOptionType : 'checkbox',
						editor : new MyTableGrid.CellCheckbox({
							getValueOf : function(value) {
								if (value) {
									return "Y";
								} else {
									return "N";
								}
							}
						})
					},
					{
						id : 'recoverySw',
						title : 'R',
						altTitle : 'With Recovery',
						width : '25px',
						filterOption : true,
						filterOptionType : 'checkbox',
						editor : new MyTableGrid.CellCheckbox({
							getValueOf : function(value) {
								if (value) {
									return "Y";
								} else {
									return "N";
								}
							}
						})
					},				
					{
						id : "itemNo",
						title : "Item No.",
						width : 100,
						filterOption : true,
						filterOptionType: 'integerNoNegative'
					},
					{
						id : "itemTitle",
						title : "Item Title",
						width : 261,
						filterOption : true,
						renderer : function(val) {
							return escapeHTML2(val);
						}
					},
					{
						id : "lossReserve",
						title : "Loss Reserve",
						width : 110,
						filterOption : true,
						align : 'right',
						titleAlign: 'right',
						geniisysClass : 'money',
						filterOptionType : 'number'
					},
					{
						id : "expenseReserve",
						title : "Expense Reserve",
						width : 110,
						filterOption : true,
						align : 'right',
						titleAlign: 'right',
						geniisysClass : 'money',
						filterOptionType : 'number'
					},
					{
						id : "lossesPaid",
						title : "Losses Paid",
						width : 110,
						filterOption : true,
						align : 'right',
						titleAlign: 'right',
						geniisysClass : 'money',
						filterOptionType : 'number'
					},
					{
						id : "expensesPaid",
						title : "Expenses Paid",
						width : 110,
						filterOption : true,
						align : 'right',
						titleAlign: 'right',
						geniisysClass : 'money',
						filterOptionType : 'number'
					} 
					
				],
				rows: jsonClmListPerPlateNo.rows
			};
		
		tbgClaimsPerPlateNo = new MyTableGrid(perPlateNoTableModel);
		tbgClaimsPerPlateNo.pager = jsonClmListPerPlateNo;
		tbgClaimsPerPlateNo.render('perPlateNoTable');
		tbgClaimsPerPlateNo.afterRender = function(){
			setDetails(null);
			if(tbgClaimsPerPlateNo.geniisysRows.length > 0){
				var rec = tbgClaimsPerPlateNo.geniisysRows[0];
				$("txtTotLossReserve").value = formatCurrency(rec.totLossReserve);
				$("txtTotExpenseReserve").value = formatCurrency(rec.totExpenseReserve);
				$("txtTotLossesPaid").value = formatCurrency(rec.totLossesPaid);
				$("txtTotExpensesPaid").value = formatCurrency(rec.totExpensesPaid);
			} else {
				$("txtTotLossReserve").clear();
				$("txtTotExpenseReserve").clear();
				$("txtTotLossesPaid").clear();
				$("txtTotExpensesPaid").clear();
			}
		};

		/* 
		removed by robert 10.02.2013 2 exit buttons
		$("btnPerPlateNoExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
		}); */
		
		$("btnToolbarExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
		});
		
		initializeAll();
		initGICLS268();
	} catch(e){
		showErrorMessage("Error : ", e);
	}
</script>