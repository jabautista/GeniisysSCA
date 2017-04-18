<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<jsp:include page="/pages/toolbar.jsp"></jsp:include>
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label>Recovery Status</label> 
	</div>
</div>
<div id="recoveryStatusMainDiv" name="recoveryStatusMainDiv">	
	<div class="sectionDiv">
		<div style="width: 520px; float: left; margin: 10px 0 10px 10px;">
			<fieldset style="height: 70px; padding: 30px 0 0 15px;">
				<legend>Status</legend>
				<table border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td><input type="radio" id="rdoAllRecoveries" name="rdoStatus" value= "A" checked="checked"/></td>
						<td><label for="rdoAllRecoveries" style="margin-right: 15px;">All Recoveries</label></td>
						<td><input type="radio" id="rdoInProgress" name="rdoStatus" value= "P"/></td>
						<td><label for="rdoInProgress" style="margin-right: 15px;">In Progress</label></td>
						<td><input type="radio" id="rdoClosed" name="rdoStatus" value= "CD"/></td>
						<td><label for="rdoClosed" style="margin-right: 15px;">Closed</label></td>
						<td><input type="radio" id="rdoCancelled" name="rdoStatus" value= "CC"/></td>
						<td><label for="rdoCancelled" style="margin-right: 15px;">Cancelled</label></td>
						<td><input type="radio" id="rdoWrittenOff" name="rdoStatus" value= "WO"/></td>
						<td><label for="rdoWrittenOff" style="margin-right: 15px;">Written Off</label></td>
					</tr>
				</table>
			</fieldset>
		</div>
		<div style="float: left; width: 377px; margin: 10px 0 10px 5px;">
			<fieldset style="height: 80px; padding: 10px 10px 10px 10px;">
				<legend>Search By</legend>
				<table border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td class="leftAligned" style="width: 125px;">
						<input style="float: left;" type="radio" id="rdoClaimFileDate" name="rdoSearchBy" value="claimFileDate" checked="checked">
						<label for="rdoClaimFileDate" style="float: left;">Claim File Date</label>
					</td>
					<td class="rightAligned">
						<input type="radio" id="rdoAsOf" name="rdoDateBtn" value="asOf" checked="checked">
					</td>
					<td class="leftAligned" style="width: 35px;"><label for="rdoAsOf">As of </label></td>
					<td class="rightAligned">
						<div style="float: left; margin-left: 3px; width: 150px;" class="withIconDiv">
					    	<input style="width: 125px;" class="withIcon" id="txtAsOfDate" name="txtAsOfDate" type="text" readOnly="readonly"/>
					    	<img id="hrefAsOfDate" name="hrefAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As Of Date" onClick="scwShow($('txtAsOfDate'),this, null);" />
					    </div>
					</td>
				</tr>
				<tr>
					<td class="leftAligned">
						<input style="float: left;" type="radio" id="rdoLossDate" name="rdoSearchBy" value="lossDate" >
						<label for="rdoLossDate" style="float: left;">Loss Date</label>
					</td>
					<td class="rightAligned">
						<input type="radio" id="rdoFrom" name="rdoDateBtn" value="fromTo">
					</td>
					<td class="leftAligned"><label for="rdoFrom">From </label></td>
					<td class="rightAligned">
						<div style="float: left; margin-left: 3px; width: 150px;" class="withIconDiv">
					    	<input style="width: 125px;" class="withIcon" id="txtFromDate" name="txtFromDate" type="text" readOnly="readonly"/>
					    	<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" onClick="scwShow($('txtFromDate'),this, null);" />
					    </div>
					</td>
				</tr>
				<tr>
					<td class="leftAligned">
					</td>
					<td class="rightAligned"></td>
					<td class="leftAligned" ><label>To </label></td>
					<td class="rightAligned">
						<div style="float: left; margin-left: 3px; width: 150px;" class="withIconDiv">
					    	<input style="width: 125px;" class="withIcon" id="txtToDate" name="txtToDate" type="text" readOnly="readonly"/>
					    	<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" onClick="scwShow($('txtToDate'),this, null);"/>
					    </div>
					</td>	
				</tr>
			</table>
			</fieldset>	
		</div>	
	</div> 
	<div class="sectionDiv" style="margin-bottom: 50px;">
		<div id="recoveryStatusTableDiv" style="margin: 10px 0 0 10px;width: 700px;float:left;">
			<div id="recoveryStatusTable" style="height: 331px"></div>			
		</div>

		<div class="sectionDiv" style="margin: 10px; float: left; width: 97.5%;">
			<table style="margin: 5px; float: left;">
				<tr>
					<td class="rightAligned" style="width: 60px;">Policy No</td>
					<td class="leftAligned"><input type="text" id="txtPolicyNo" style="width: 430px;" readonly="readonly" tabindex="303"/></td>
					<td class="rightAligned"style="width: 100px;">Loss Date</td>
					<td class="leftAligned"><input type="text" id="txtLossDate" style="width: 250px;" readonly="readonly" tabindex="304"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Assured</td>
					<td class="leftAligned"><input type="text" id="txtAssured" style="width: 430px;" readonly="readonly" tabindex="305"/></td>
					<td class="rightAligned">Claim File Date</td>
					<td class="leftAligned"><input type="text" id="txtClaimFileDate" style="width: 250px;" readonly="readonly" tabindex="306"/></td>
				</tr>
				<tr>
					<input type="hidden" id="txtSearchBy" name="txtSearchBy" value=""/>
					<input type="hidden" id="txtDateCondition" name="txtDateCondition" value=""/>	
					<input type="hidden" id="hidClaimId" name="hidClaimId" value=""/>
					<input type="hidden" id="hidRecoveryId" name="hidRecoveryId" value=""/>			
				</tr>		
			</table>
		</div>
		<div style="float: left; width: 100%; margin-bottom: 10px;" align="center">
			<input type="button" class="button" id="btnRecoveryDetails" value="Details" style="width: 150px;" tabindex="401"/>
			<input type="button" class="button" id="btnRecoveryHistory" value="Recovery History" style="width: 150px;" tabindex="401"/>
			<div>
				<input type="button" class="button" id="btnPrintReport" name="btnPrintReport" value= "Print Report" style="width: 125px; margin: 10px 0 10px 0;"/>
			</div>
		</div>
		
	</div>
</div>

<script type="text/javascript">
	setModuleId("GICLS269");
	setDocumentTitle("Recovery Status");
	enableFromToDate(false);
	initializeAll();
	initializeAccordion();
	initializeAllMoneyFields();
	var objGICLS269 = [];
	var executeQuery = false;
	objRecDetails = new Object();
	initalizeGICLS269();
	
		
	var jsonRecoveryStatus = JSON.parse('${jsonRecoveryStatus}');	
	recoveryStatusTableModel = {
			url : contextPath+"/GICLLossRecoveryStatusController?action=showLossRecoveryStatus&refresh=1",
			options: {
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter : function(){
						setDetailsForm(null);
						tbgRecoveryStatus.keys.removeFocus(tbgRecoveryStatus.keys._nCurrentFocus, true);
						tbgRecoveryStatus.keys.releaseKeys();
					}
				},
				width: '900px',
				pager: {
				},
				onCellFocus : function(element, value, x, y, id) {
					setDetailsForm(tbgRecoveryStatus.geniisysRows[y]);					
					tbgRecoveryStatus.keys.removeFocus(tbgRecoveryStatus.keys._nCurrentFocus, true);
					tbgRecoveryStatus.keys.releaseKeys();
				},
				prePager: function(){
					setDetailsForm(null);
					tbgRecoveryStatus.keys.removeFocus(tbgRecoveryStatus.keys._nCurrentFocus, true);
					tbgRecoveryStatus.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id){					
					setDetailsForm(null);
				},
				onSort : function(){
					setDetailsForm(null);
					tbgRecoveryStatus.keys.removeFocus(tbgRecoveryStatus.keys._nCurrentFocus, true);
					tbgRecoveryStatus.keys.releaseKeys();		
				},
				onRefresh : function(){
					setDetailsForm(null);
					tbgRecoveryStatus.keys.removeFocus(tbgRecoveryStatus.keys._nCurrentFocus, true);
					tbgRecoveryStatus.keys.releaseKeys();
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
					id: 'claimId',
					width: '0',
					visible: false 
				},
				{
					id: 'recoveryId',
					width: '0',
					visible: false 
				},
				{
					id : "recoveryNo",
					title: "Recovery Number",
					width: '200px',
					align : "left",
					titleAlign : "left",
					filterOption : true
				},				
				{
					id : "claimNo",
					title: "Claim Number",
					width: '210px',
					align : "left",
					titleAlign : "left",
					filterOption : true
				},
				{
					id : "lossCategory",
					title: "Loss Category",
					width: '250px',
					align : "left",
					titleAlign : "left",
					filterOption : true
				},				
				{
					id : "recoveryStatus",
					title: "Status",
					width: '190px',
					align : "left",
					titleAlign : "left",
					filterOption : true
				},
				{
					id : "lawyerCd",
					title: "",
					width: '0',
					visible: false
				},
				{ 
					id : "lawyer",
					title: "",
					width: '0px',
					width: '0',
					visible: false
				},	
				{
					id : "tpItemDesc",
					title: "",
					width: '0',
					visible: false
				},	
				{
					id : "recoverableAmt",
					title: "",
					width: '0',
					visible: false
				},	
				{
					id : "recoveredAmtR",
					title: "",
					width: '0',
					visible: false
				},	
				{
					id : "plateNo",
					title: "",
					width: '0',
					visible: false
				}
				
			],
			rows: jsonRecoveryStatus.rows
		};
	
	tbgRecoveryStatus = new MyTableGrid(recoveryStatusTableModel);
	tbgRecoveryStatus.pager = jsonRecoveryStatus;
	tbgRecoveryStatus.render('recoveryStatusTable');
	
	
	function setDetailsForm(rec){
		try{
			$("txtPolicyNo").value = rec == null ? "" : unescapeHTML2(rec.policyNo);
			$("txtAssured").value = rec == null ? "" : unescapeHTML2(rec.assuredName);
			$("txtLossDate").value = rec == null ? "" : rec.dspLossDate == null ? "" : dateFormat(rec.dspLossDate, 'mm-dd-yyyy');
			$("txtClaimFileDate").value = rec == null ? "" : rec.clmFileDate == null ? "" : dateFormat(rec.clmFileDate, 'mm-dd-yyyy');
			$("hidRecoveryId").value = rec == null ? "" : rec.recoveryId;
			$("hidClaimId").value = rec == null ? "" : rec.claimId;

			objRecDetails.lawyerCd = rec==null? "" : rec.lawyerCd;
			objRecDetails.lawyer = rec==null? "" : unescapeHTML2(rec.lawyer);
			objRecDetails.tpItemDesc = rec==null? "" : unescapeHTML2(rec.tpItemDesc);
			objRecDetails.recoverableAmt = rec==null? "" : rec.recoverableAmt;
			objRecDetails.recoveredAmtR = rec==null? "" : rec.recoveredAmtR;
			objRecDetails.plateNo = rec==null? "" : unescapeHTML2(rec.plateNo);
		} catch(e){
			showErrorMessage("setDetailsForm", e);
		}
	}
	
	//Exit Module
	$("btnToolbarExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});			
	
	//Enable/Disable FromToDate
	function enableFromToDate(enable){
		if (nvl(enable,false) == true){
			//enable
			$("txtAsOfDate").value 		= "";
			$("txtAsOfDate").disabled 	= true;
			$("txtFromDate").setStyle({backgroundColor: '#FFFACD'});
			$("txtToDate").setStyle({backgroundColor: '#FFFACD'});
			$("txtAsOfDate").setStyle({backgroundColor: '#F0F0F0'});
			disableDate("hrefAsOfDate");
			$("txtFromDate").disabled 	= false;
			$("txtToDate").disabled 	= false;
			enableDate("hrefFromDate");
			enableDate("hrefToDate");
		}else{	
			//disable
			$("txtAsOfDate").value 		= getCurrentDate();
			$("txtAsOfDate").disabled 	= false;
			$("txtAsOfDate").setStyle({backgroundColor: '#FFFACD'});
			enableDate("hrefAsOfDate");
			$("txtFromDate").value 		= "";
			$("txtToDate").value 		= "";
			$("txtFromDate").disabled 	= true;
			$("txtToDate").disabled 	= true;
			$("txtFromDate").setStyle({backgroundColor: '#F0F0F0'});
			$("txtToDate").setStyle({backgroundColor: '#F0F0F0'});
			disableDate("hrefFromDate");
			disableDate("hrefToDate");
		}
	}
	
	
	//As Of Radio Button Event
	$("rdoAsOf").observe("click", function(a){
		enableFromToDate(false);
	});
		
	//From Radio Button Event
	$("rdoFrom").observe("click", function(a){
		enableFromToDate(true);
	});
	
	//Search By Radio Event
 	$$("input[name='rdoSearchBy']").each(function(btn){
		btn.observe("click",function(){
			try{
				getStatusParams();	
			}catch(e){
				showErrorMessage("rdoSearchBy", e);
			}						
		});	
	});
	
	//Status Radio Event
	$$("input[name='rdoStatus']").each(function(btn){
		btn.observe("click",function(){
			try{
				getStatusParams();	
			}catch(e){
				showErrorMessage("rdoStatus", e);
			}
		});	
	});
 	
 	//Validate As Of Date
	$("txtAsOfDate").observe("focus", function(){
		if ($F("txtAsOfDate") > getCurrentDate()){
			showMessageBox("Date should not be greater than the current date.", imgMessage.INFO);
			$("txtAsOfDate").value = getCurrentDate();
		}
	});
	
	
	//Validate From Date
	$("txtFromDate").observe("focus", function(){
		if($F("txtFromDate") && $F("txtToDate") != ""){
			if ($F("txtFromDate") > $F("txtToDate")){
				showMessageBox("From Date should not be later than To Date.", imgMessage.INFO);
				$("txtFromDate").clear();
				return;
			} 
		}
		if ($F("txtFromDate") && $F("txtFromDate") > getCurrentDate()){
			showMessageBox("Date should not be greater than the current date.", imgMessage.INFO);
			$("txtFromDate").clear();
			return;
		}		
	});
	
	//Validate To Date
	$("txtToDate").observe("focus", function(){
		if($F("txtToDate") != "" && $F("txtFromDate") != ""){
			if ($F("txtToDate") < $F("txtFromDate")){
				showMessageBox("From Date should not be later than To Date.", imgMessage.INFO);
				$("txtToDate").clear();
				return;
			}
		}
		if ($F("txtToDate") != "" && $F("txtToDate") > getCurrentDate()){
			showMessageBox("Date should not be greater than the current date.", imgMessage.INFO);
			$("txtToDate").clear();
			return;
		}
	});
	
	//toolbar buttons
	$("btnToolbarEnterQuery").observe("click", resetHeaderForm);
	$("btnToolbarExecuteQuery").observe("click", function() {
		if($("txtAsOfDate").disabled){
			if ($("txtFromDate").value == "") {		
				showWaitingMessageBox("Required field must be entered", "I", function() {
					$("txtFromDate").focus(); 
				});	
				return;
			}else if ($("txtToDate").value == "") {
				showWaitingMessageBox("Required field must be entered", "I", function() {
					$("txtToDate").focus(); 
				});	
				return;
			}				
		}
		executeQuery=true;
		getStatusParams();
		disableToolbarButton("btnToolbarExecuteQuery");
		enableToolbarButton("btnToolbarEnterQuery");
		disableDateFields();
	});
	
	function resetHeaderForm(){
		try{		
			enableDateFields();
			getStatusParams();
			tbgRecoveryStatus.url = contextPath+"/GICLLossRecoveryStatusController?action=showLossRecoveryStatus&refresh=1";
			tbgRecoveryStatus._refreshList();
			executeQuery = false;
			disableToolbarButton("btnToolbarEnterQuery");
			enableToolbarButton("btnToolbarExecuteQuery");
		} catch(e){
			showErrorMessage("resetHeaderForm", e);
		}
	}
	
	//enable date fields
	function enableDateFields() {
		$("rdoAsOf").disabled 		= false;
		$("txtAsOfDate").disabled 	= false;	
		enableDate("hrefAsOfDate");
		$("txtAsOfDate").setStyle({backgroundColor: '#FFFACD'});
		$("rdoAsOf").checked = true;
		$("txtAsOfDate").value 		= getCurrentDate();
		$("rdoFrom").disabled 		= false;	
		$("txtFromDate").value 		= "";
		$("txtToDate").value 		= "";
		$("rdoAllRecoveries").checked = true;
		$("rdoClaimFileDate").checked = true;
	}
	
	//disable date fields
	function disableDateFields() {
		disableDate("hrefFromDate");
		disableDate("hrefToDate");
		disableDate("hrefAsOfDate");
		$("rdoAsOf").disabled 		= true;
		$("rdoFrom").disabled 		= true;
		$("txtAsOfDate").disabled 	= true;		
		$("txtFromDate").disabled 	= true;
		$("txtToDate").disabled 	= true;		
		$("txtAsOfDate").setStyle({backgroundColor: '#F0F0F0'});
		$("txtFromDate").setStyle({backgroundColor: '#F0F0F0'});
		$("txtToDate").setStyle({backgroundColor: '#F0F0F0'});
	}
	
	function getStatusParams(){
		//get Date By
		$$("input[name='rdoSearchBy']").each(function(btn){
			if (btn.checked){
				dateBy = $F(btn);
			}			
		});
		
		//get Status
		$$("input[name='rdoStatus']").each(function(btn){
			if (btn.checked){
				status = $F(btn);
				objGICLS269.status = status;				
			}			
		});
		
		dateAsOf = $F("txtAsOfDate");
		dateFrom = $F("txtFromDate");
		dateTo = $F("txtToDate");
		objGICLS269.dateBy = dateBy;
		objGICLS269.dateAsOf = dateAsOf;
		objGICLS269.dateFrom = dateFrom;
		objGICLS269.dateTo = dateTo;
		
		if(executeQuery){
			refreshTbgRecoveryStatus(status,dateAsOf,dateFrom,dateTo,dateBy);
		}		
	}
	
	//Populate TbgRecoveryStatus
	function refreshTbgRecoveryStatus(status,dateAsOf,dateFrom,dateTo,dateBy){
		tbgRecoveryStatus.url = contextPath+"/GICLLossRecoveryStatusController?action=showLossRecoveryStatus&refresh=1&recStatusType="+status + "&dateAsOf="+dateAsOf+"&dateFrom="+dateFrom+"&dateTo="+dateTo+"&dateBy="+dateBy;
		tbgRecoveryStatus._refreshList();
	}
	
	// Print
	$("btnPrintReport").observe("click", function(){
		showGenericPrintDialog("Print Loss Recovery Status", checkReport, onLoadPrintGicls269, true);
	});
	
	var reports = [];
	function checkReport(){
		try{
			var reportId = [];
			
			reportId.push("GICLR269");
			
			for(var i=0; i < reportId.length; i++){
				printReport(reportId[i]);	
			}
			
			if ("screen" == $F("selDestination")) {
				showMultiPdfReport(reports);
				reports = [];
			}
			
		} catch(e){
			showErrorMessage("printReport", e);
		}
	}
	
	function printReport(reportId){
		try{
			
			var content = contextPath + "/PrintClaimListingInquiryController?action=printReport"
            + "&reportId=" + reportId
            + "&moduleId=GICLS269"
            + "&dateBy=" + objGICLS269.dateBy
            + "&dateAsOf=" + objGICLS269.dateAsOf
            + "&dateFrom=" + objGICLS269.dateFrom
            + "&dateTo=" + objGICLS269.dateTo
            + "&status=" + objGICLS269.status;
			
			reptTitle = "Loss Recovery Status";
			
			if("screen" == $F("selDestination")){
				reports.push({reportUrl : content, reportTitle : reptTitle});
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					method: "GET",
					parameters : {noOfCopies : $F("txtNoOfCopies"),
							 	 printerName : $F("selPrinter")
							 	 },
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Printing report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
						
						}
					}
				});
			}else if("file" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "file",
						          fileType    : $("rdoPdf").checked ? "PDF" : "XLS"},
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
			
		} catch(e){
			showErrorMessage("printReport", e);
		}
	}
	
	function onLoadPrintGicls269(){
		$("printDialogMainDiv").up("div",1).style.height = "200px";
		$($("printDialogMainDiv").up("div",1).id).up("div",0).style.height = "232px";
	}
	
	function initalizeGICLS269(){
		hideToolbarButton("btnToolbarPrint");
		disableToolbarButton("btnToolbarEnterQuery");
	}
		
	$("btnRecoveryDetails").observe("click", showGICLS269RecoveryDetails);
	$("btnRecoveryHistory").observe("click", showGICLS269RecoveryHistory);
	
	getStatusParams();
</script>
