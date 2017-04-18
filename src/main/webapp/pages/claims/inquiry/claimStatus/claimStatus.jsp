<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="mainNav" name="mainNav" claimsBasicMenu = "Y">
	<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
		<ul>
			<span id="clMenus" name="clMenus" style="display: block;">
				<li><a id="clmExit">Exit</a></li>
			</span>	
		</ul>
	</div>
</div>
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label>Claim Status</label> 
	</div>
</div>
<div id="claimStatusMainDiv" name="claimStatusMainDiv">	
	<div class="sectionDiv">
		<div style="width: 524px; float: left; margin: 10px 0 10px 10px;">
			<fieldset style="height: 50px; padding: 15px 10px 0 40px;">
				<legend>Search By:</legend>
				<table border="0" cellpadding="0" cellspacing="0">
	<!-- 				<tr>
						<td colspan="2"><label>Search By:</label></td>
					</tr> -->
					<tr>
						<td><input type="radio" id="rdoLossDate" name="rdoSearchBy" value= "lossDate" checked="checked"/></td>
						<td><label for="rdoLossDate" style="margin-right: 25px;">Loss Date</label></td>
						<td><input type="radio" id="rdoFileDate" name="rdoSearchBy" value= "fileDate"/></td>
						<td><label for="rdoFileDate" style="margin-right: 25px;">File Date</label></td>
						<td><input type="radio" id="rdoCloseDate" name="rdoSearchBy" value= "closeDate"/></td>
						<td><label for="rdoCloseDate" style="margin-right: 25px;">Close Date</label></td>
						<td><input type="radio" id="rdoSystemEntryDate" name="rdoSearchBy" value= "entryDate"/></td>
						<td><label for="rdoSystemEntryDate" style="margin-right: 25px;">System Entry Date</label></td>
					</tr>
				</table>
			</fieldset>
		</div>
		<div style="width: 200px; float: left;">
			<div class="sectionDiv" style="float: left; width: 364px; margin: 15px 10px 10px 10px;">
				<table style="margin: 2px 20px;">
					<tr>
						<td><input type="radio" id="rdoAsOfDate" name="rdoSearchByDate" value= "" checked="checked"/></td>
						<td><label for="rdoAsOfDate">As of</label></td>
						<td colspan="3">
							<div class="withIconDiv" style="width: 260px;margin-left: 3px;">
								<input type="text" id="txtAsOfDate" name="txtAsOfDate" value= "" style="width: 235px;" class="withIcon" readOnly="readonly"/>
								<img id="hrefAsOfDate" name="hrefAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As Of Date" onClick="scwShow($('txtAsOfDate'),this, null);" />
							</div>
						</td>
					</tr>
					<tr>
						<td><input type="radio" id="rdoFromToDate" name="rdoSearchByDate" value= ""/></td>
						<td><label for="rdoFromToDate">From</label></td>
						<td>
							<div style="float: left; margin-left: 3px; width: 105px;" class="withIconDiv">
						    	<input style="width: 80px;" class="withIcon" id="txtFromDate" name="txtFromDate" type="text" readOnly="readonly"/>
						    	<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" onClick="scwShow($('txtFromDate'),this, null);" />
						    </div>
						</td>
						<td style="width: 32px;"><label for="rdoFromToDate" style="width: 20px;text-align: right;margin-left: 10px;">To</label></td>
						<td>
							<div style="float: left; margin-left: 3px; width: 105px;" class="withIconDiv">
						    	<input style="width: 80px;" class="withIcon" id="txtToDate" name="txtToDate" type="text" readOnly="readonly"/>
						    	<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" onClick="scwShow($('txtToDate'),this, null);"/>
						    </div>
						</td>
					</tr>
				</table>	
			</div>
		</div>	
	</div> 
	<div class="sectionDiv" style="margin-bottom: 50px;">
		<div id="claimStatusTableDiv" style="margin: 10px 0 0 10px;width: 700px;float:left; padding-bottom: 25px;">
			<div id="claimStatusTable" style="height: 300px"></div>			
		</div>
		<div style="width: 118px; height: 210px; margin: 25px 0 0 82px; padding-top: 5px; float:left;" class="sectionDiv">
			<label style="margin-left: 35px; margin-bottom:10px; font-weight: bold;">Status</label>
			<div class="sectionDiv" style="margin: 5px; margin-top: 0; width: 105px;">
				<table align="center" style="width: 90px;" border="0" cellpadding="0" cellspacing="0">
					<tr style="height: 30px;">
						<td style="width: 5px;"><input type="radio" id="rdoOpen" name="rdoClaimStatus" value= "N"/></td>
						<td><label for="rdoOpen">Open</label></td>
					</tr>
					<tr style="height: 30px;">
						<td><input type="radio" id="rdoClosed" name="rdoClaimStatus" value= "C"/></td>
						<td><label for="rdoClosed">Closed</label></td>
					</tr>
					<tr style="height: 30px;">
						<td><input type="radio" id="rdoDenied" name="rdoClaimStatus" value= "D"/></td>
						<td><label for="rdoDenied">Denied</label></td>
					</tr>
					<tr style="height: 30px;">
						<td><input type="radio" id="rdoWithdrawn" name="rdoClaimStatus" value= "W"/></td>
						<td><label for="rdoWithdrawn">Withdrawn</label></td>
					</tr>
					<tr style="height: 30px;">
						<td><input type="radio" id="rdoCancelled" name="rdoClaimStatus" value= "X"/></td>
						<td><label for="rdoCancelled">Cancelled</label></td>
					</tr>
					<tr style="height: 30px;">
						<td><input type="radio" id="rdoAll" name="rdoClaimStatus" value= "" checked="checked"/></td>
						<td><label for="rdoAll">All</label></td>
					</tr>
				</table>
			</div>
		</div>
		<div class="sectionDiv" style="float:left; width: 97.5%; margin: 10px 10px 2px 10px;">
			<table align="center" style="margin: 10px;">
				<tr>
					<td align="right" style="width:162px;">Close Date</td>
					<td><input type="text" id="txtCloseDate" name="txtCloseDate" value= "" style="width: 250px;text-align: left;" readonly="readonly"/></td>
					<td align="right" style="width:120px;">System Entry Date</td>
					<td><input type="text" id="txtSystemEntryDate" name="txtSystemEntryDate" value= "" style="width: 250px;text-align: left;" readonly="readonly"/></td>
				</tr>
				<tr>
					<td align="right">Loss Date</td>
					<td><input type="text" id="txtLossDate" name="txtLossDate" value= "" style="width: 250px;text-align: left;" readonly="readonly"/></td>
					<td align="right">Processor</td>
					<td><input type="text" id="txtProcessor" name="txtProcessor" value= "" style="width: 250px;" readonly="readonly"/></td>
				</tr>
				<tr>
					<td align="right">File Date</td>
					<td><input type="text" id="txtFileDate" name="txtFileDate" value= "" style="width: 250px;text-align: left;" readonly="readonly"/></td>
				</tr>
				<tr>
					<td align="right">Remarks</td>
					<td colspan="3">
						<div style="float: left; width: 650px;" class="withIconDiv">
							<textarea onKeyDown="limitText(this,500);" onKeyUp="limitText(this,500);" id="txtRemarks" name="txtRemarks" style="width: 600px;resize:none;" class="withIcon" readonly="readonly"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editTxtRemarks" />
						</div>	
					</td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv" style="margin: 0 10px 0 10px; width: 97.5%;">
			<div style="margin: 10px;">
				<table align="center">
					<tr>
						<td align="right">Loss Reserve</td>
						<td><input type="text" id="txtLossReserve" name="txtLossReserve" value= "" style="width: 250px;text-align: right;" readonly="readonly"/></td>
						<td align="right" style="width:130px;">Losses Paid</td>
						<td><input type="text" id="txtLossesPaid" name="txtLossesPaid" value= "" style="width: 250px;text-align: right;" readonly="readonly"/></td>
					</tr>
					<tr>
						<td align="right" style="width:110px;">Expense Reserve</td>
						<td><input type="text" id="txtExpenseReserve" name="txtExpenseReserve" value= "" style="width: 250px;text-align: right;" readonly="readonly"/></td>
						<td align="right">Expense Paid</td>
						<td><input type="text" id="txtExpensePaid" name="txtExpensePaid" value= "" style="width: 250px;text-align: right;" readonly="readonly"/></td>
					</tr>
				</table>
			</div>
			<div align="center">
				<input type="button" class="button" id="btnPrintReport" name="btnPrintReport" value= "Print Report" style="margin: 10px 0 10px 0;"/>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	setModuleId("GICLS252");
	setDocumentTitle("Claim Status");
	enableFromToDate(false);
	initializeAll();
	initializeAccordion();
	initializeAllMoneyFields();
	var objGICLS252 = [];
	
	var jsonClmStatus = JSON.parse('${jsonClmStatus}');	
	
	claimStatusTableModel = {
			url : contextPath+"/GICLClaimStatusController?action=showMenuClaimStatus&refresh=1",
			options: {
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
				},
				width: '770px',
				height: '300px',
				onCellFocus : function(element, value, x, y, id) {
					setDetailsForm(tbgClaimStatus.geniisysRows[y]);					
					tbgClaimStatus.keys.removeFocus(tbgClaimStatus.keys._nCurrentFocus, true);
					tbgClaimStatus.keys.releaseKeys();
				},
				prePager: function(){
					setDetailsForm(null);
					tbgClaimStatus.keys.removeFocus(tbgClaimStatus.keys._nCurrentFocus, true);
					tbgClaimStatus.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id){					
					setDetailsForm(null);
					tbgClaimStatus.keys.removeFocus(tbgClaimStatus.keys._nCurrentFocus, true);
					tbgClaimStatus.keys.releaseKeys();
				},
				onSort : function(){
					setDetailsForm(null);
					tbgClaimStatus.keys.removeFocus(tbgClaimStatus.keys._nCurrentFocus, true);
					tbgClaimStatus.keys.releaseKeys();		
				},
				afterRender : function (){
					setDetailsForm(null);
					tbgClaimStatus.keys.removeFocus(tbgClaimStatus.keys._nCurrentFocus, true);
					tbgClaimStatus.keys.releaseKeys();
				},
				onRefresh : function(){
					setDetailsForm(null);
					tbgClaimStatus.keys.removeFocus(tbgClaimStatus.keys._nCurrentFocus, true);
					tbgClaimStatus.keys.releaseKeys();		
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
					id : "claimId",
					title: "Claim Number",
					width: '150px',
					align : "left",
					titleAlign : "left"
				},				
				{
					id : "policyNo",
					title: "Policy Number",
					width: '200px',
					align : "left",
					titleAlign : "left"
				},
				{
					id : "assuredName",
					title: "Assured Name",
					width: '200px',
					align : "left",
					titleAlign : "left",
					filterOption : true
				},				
				{
					id : "claimStatus",
					title: "Claim Status",
					width: '185px',
					align : "left",
					titleAlign : "left",
					filterOption : true
				},				
				{
					id : "lineCd",
					title: "Line Cd.",
					width : "0px",
					filterOption : true,
					visible : false
				},				
				{
					id : "sublineCd",
					title: "Subline Cd.",
					width : "0px",
					filterOption : true,
					visible : false
				},				
				{
					id : "issueYy",
					title: "Issue Year",
					width : "0px",
					filterOption : true,
					filterOptionType : 'number',
					visible : false
				},				
				{
					id : "polSeqNo",
					title: "Policy Sequence No.",
					width : "0px",
					filterOption : true,
					filterOptionType : 'number',
					visible : false
				},				
				{
					id : "renewNo",
					title: "Renew No.",
					width : "0px",
					filterOption : true,
					filterOptionType : 'number',
					visible : false
				},				
				{
					id : "clmYy",
					title: "Claim Year",
					width : "0px",
					filterOption : true,
					filterOptionType : 'number',
					visible : false
				},				
				{
					id : "clmSeqNo",
					title: "Claim Sequence No.",
					width : "0px",
					filterOption : true,
					filterOptionType : 'number',
					visible : false
				},				
				{
					id : "issCd",
					title: "Issue Cd.",
					width : "0px",
					filterOption : true,
					visible : false
				}
			],
			rows: jsonClmStatus.rows
		};
	
	tbgClaimStatus = new MyTableGrid(claimStatusTableModel);
	tbgClaimStatus.pager = jsonClmStatus;
	tbgClaimStatus.render('claimStatusTable');
	
	function setDetailsForm(rec){
		try{
			$("txtCloseDate").value = rec == null ? "" : rec.closeDate == null ? "" : rec.closeDate;
			$("txtSystemEntryDate").value = rec == null ? "" : rec.entryDate == null ? "" : rec.entryDate;
			$("txtLossDate").value = rec == null ? "" : rec.dspLossDate == null ? "" : rec.dspLossDate;
			$("txtProcessor").value = rec == null ? "" : unescapeHTML2(rec.inHouAdj);
			$("txtFileDate").value = rec == null ? "" : rec.clmFileDate == null ? "" : rec.clmFileDate;
			$("txtRemarks").value = rec == null ? "" : unescapeHTML2(rec.remarks);
			$("txtLossReserve").value = rec == null ? "" : formatCurrency(rec.lossResAmt);
			$("txtLossesPaid").value = rec == null ? "" : formatCurrency(rec.lossPdAmt);
			$("txtExpenseReserve").value = rec == null ? "" : formatCurrency(rec.expResAmt);
			$("txtExpensePaid").value = rec == null ? "" : formatCurrency(rec.expPdAmt);
		} catch(e){
			showErrorMessage("setDetailsForm", e);
		}
	}
	
	//Exit Module
 	$("clmExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});
	
	/*$("btnToolbarExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});*/
	
	//Remarks editor
	$("editTxtRemarks").observe("click", function () {
		showOverlayEditor("txtRemarks", 2000, "true");
	});
		
	//Enable/Disable FromToDate
	function enableFromToDate(enable){
		if (nvl(enable,false) == true){
			//enable
			$("txtAsOfDate").value 		= "";
			$("txtAsOfDate").disabled 	= true;
			disableDate("hrefAsOfDate");
			$("txtFromDate").disabled 	= false;
			$("txtToDate").disabled 	= false;
			enableDate("hrefFromDate");
			enableDate("hrefToDate");
		}else{	
			//disable
			$("txtAsOfDate").value 		= getCurrentDate();
			$("txtAsOfDate").disabled 	= false;
			enableDate("hrefAsOfDate");
			$("txtFromDate").value 		= "";
			$("txtToDate").value 		= "";
			$("txtFromDate").disabled 	= true;
			$("txtToDate").disabled 	= true;
			disableDate("hrefFromDate");
			disableDate("hrefToDate");
		}
	}
	
	//As Of Radio Button Event
	$("rdoAsOfDate").observe("click", function(a){
		enableFromToDate(false);
		getClmStatusParams();
	});
	
	//From Radio Button Event
	$("rdoFromToDate").observe("click", function(a){
		enableFromToDate(true);
		tbgClaimStatus.url = contextPath+"/GICLClaimStatusController?action=showMenuClaimStatus&refresh=1&clmStatusType=&dateBy=&dateAsOf=&dateFrom=&dateTo=";
		tbgClaimStatus._refreshList();
	});
	
	//Populate TbgClaimStatus
	function refreshTbgClaimStatus(status,dateBy,dateAsOf,dateTo){
		tbgClaimStatus.url = contextPath+"/GICLClaimStatusController?action=showMenuClaimStatus&refresh=1&clmStatusType="+status + "&dateBy="+dateBy+"&dateAsOf="+dateAsOf+"&dateFrom="+dateFrom+"&dateTo="+dateTo;
		tbgClaimStatus._refreshList();
	}
	
	//get Params
	function getClmStatusParams(){
		//get Date
		$$("input[name='rdoSearchBy']").each(function(btn){
			if (btn.checked){
				dateBy = $F(btn);
				dateAsOf = $F("txtAsOfDate");
				dateFrom = $F("txtFromDate");
				dateTo = $F("txtToDate");
				objGICLS252.dateBy = dateBy;
				objGICLS252.dateAsOf = dateAsOf;
				objGICLS252.dateFrom = dateFrom;
				objGICLS252.dateTo = dateTo;
			}			
		});
		//get Status
		$$("input[name='rdoClaimStatus']").each(function(btn){
			if (btn.checked){
				status = $F(btn);
				objGICLS252.status = status;
			}			
		});
		
		refreshTbgClaimStatus(status,dateBy,dateAsOf,dateTo);
	}
	
	//Search By Radio Event
 	$$("input[name='rdoSearchBy']").each(function(btn){
		btn.observe("click",function(){
			try{
				getClmStatusParams();	
			}catch(e){
				showErrorMessage("rdoSearchBy", e);
			}						
		});	
	});
	
 	//Status Radio Event
	$$("input[name='rdoClaimStatus']").each(function(btn){
		btn.observe("click",function(){
			try{
				getClmStatusParams();	
			}catch(e){
				showErrorMessage("rdoClaimStatus", e);
			}
		});	
	});
 	
	observeBackSpaceOnDate("txtAsOfDate");
	observeBackSpaceOnDate("txtFromDate");
	observeBackSpaceOnDate("txtToDate");
 	
 	//Validate As Of Date
	$("txtAsOfDate").observe("focus", function(){
		if ($F("txtAsOfDate") > getCurrentDate()){
			showMessageBox("Date should not be greater than the current date.", imgMessage.INFO);
			$("txtAsOfDate").value = getCurrentDate();
		}
		getClmStatusParams();
	});
	
	//Validate From Date
	$("txtFromDate").observe("focus", function(){
		if($F("txtToDate") != ""){
			if ($F("txtFromDate") > $F("txtToDate")){
				showMessageBox("FROM Date should not be greater than TO Date.", imgMessage.INFO);
				$("txtFromDate").clear();
				return;
			} 
		}
		if ($F("txtFromDate") > getCurrentDate()){//Kenneth L. 04.21.2014 removed =
			showMessageBox("Date should not be greater than the current date.", imgMessage.INFO);
			$("txtFromDate").clear();
			return;
		}
		if (($F("txtToDate") != "") && ($F("txtFromDate") != "")){
			getClmStatusParams();
		}		
	});
	
	//Validate To Date
	$("txtToDate").observe("focus", function(){
		if($F("txtFromDate") != ""){
			if ($F("txtToDate") < $F("txtFromDate") && $F("txtToDate") != ""){//Kenneth L. 04.21.2014 removed =
				showMessageBox("TO Date should not be less than FROM date.", imgMessage.INFO);
				$("txtToDate").clear();
				return;
			}
		}
		if ($F("txtToDate") > getCurrentDate()){
			showMessageBox("Date should not be greater than the current date.", imgMessage.INFO);
			$("txtToDate").clear();
			return;
		}
		if (($F("txtToDate") != "") && ($F("txtFromDate") != "")){
			getClmStatusParams();
		}	
	});

	// Print
	$("btnPrintReport").observe("click", function(){
		showGenericPrintDialog("Print Claim Listing per Status", checkReport, onLoadPrintGicls252, true);
	});
	
	var reports = [];
	function checkReport(){
		try{
			var reportId = [];
			
			reportId.push("GICLR252");
			
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
	
	objGICLS252.status = "";
	objGICLS252.dateTo = "";
	objGICLS252.dateFrom = "";
	objGICLS252.dateAsOf = getCurrentDate();
	objGICLS252.dateBy = "lossDate";
	
	function printReport(reportId){
		try{
			if($("rdoAsOfDate").checked == true){ // added by kenneth L. 04.11.2014
				objGICLS252.dateFrom = "";
		        objGICLS252.dateTo = "";
			}else{
				objGICLS252.dateAsOf = "";
			}
			
			var content = contextPath + "/PrintClaimListingInquiryController?action=printReport"
            + "&reportId=" + reportId
            + "&moduleId=GICLS252"
            + "&dateBy=" + objGICLS252.dateBy
            + "&dateAsOf=" + objGICLS252.dateAsOf
            + "&dateFrom=" + objGICLS252.dateFrom
            + "&dateTo=" + objGICLS252.dateTo
            + "&status=" + objGICLS252.status;

			reptTitle = "Claim Listing per Status";
			
			if("screen" == $F("selDestination")){
				reports.push({reportUrl : content, reportTitle : reptTitle});
			}else if($F("selDestination") == "printer"){
// 				new Ajax.Request(content, {
// 					parameters : {noOfCopies : $F("txtNoOfCopies")},
// 					onCreate: showNotice("Processing, please wait..."),				
// 					onComplete: function(response){
// 						hideNotice();
// 						if (checkErrorOnResponse(response)){
							
// 						}
// 					}
// 				}); Gzelle 06.05.2013
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
	
	function onLoadPrintGicls252(){
		$("printDialogMainDiv").up("div",1).style.height = "200px";
		$($("printDialogMainDiv").up("div",1).id).up("div",0).style.height = "232px";
	}
	
	/*$("btnToolbarPrint").observe("click", function(){
		showGenericPrintDialog("Print Claim Listing per Status", function(){
			showMessageBox("The report you are trying to generate is not yet available.", "I");
		});
	});*/
	
	getClmStatusParams(); //Gzelle 06.05.2013 - causes TYPE ERROR:this.keys is undefined on page load
	
</script>
