<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="gicls273MainDiv" name="gicls273MainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Ex-Gratia Claims Inquiry</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div class="sectionDiv">
		<div style="width: 280px; float: left; margin: 10px 0 10px 10px;">
			<fieldset style="height: 45px; padding: 10px 10px 0 15px;">
				<legend>Search By:</legend>
				<table border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td><input type="radio" id="rdoClmFileDate" name="rdoSearchBy" value= "1"/></td>
						<td><label for="rdoClmFileDate" style="margin-right: 25px; margin-left: 3px;">Claim File Date</label></td>
						<td><input type="radio" id="rdoLossDate" name="rdoSearchBy" value= "2" checked="checked"/></td>
						<td><label for="rdoLossDate" style="margin-right: 25px; margin-left: 3px;">Loss Date</label></td>
					</tr>
				</table>
			</fieldset>
		</div>
		<div style="width: 605px; float: left;">
			<div class="sectionDiv" style="float: left; width: 605px; height: 50px; margin: 15px 10px 10px 10px;">
				<table style="padding: 10px 20px;">
					<tr>
						<td><input type="radio" id="rdoAsOfDate" name="rdoSearchByDate" value= "" checked="checked" style="margin: 0px 0px 0px 0px;"/></td>
						<td><label for="rdoAsOfDate" style="width: 30px;">As of</label></td>
						<td>
							<div id="asOfDiv" class="withIconDiv" style="width: 125px;margin-left: 3px;">
								<input type="text" id="txtAsOfDate" name="txtAsOfDate" value= "" style="width: 100px;" class="withIcon" readOnly="readonly"/>
								<img id="hrefAsOfDate" name="hrefAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As Of Date" onClick="scwShow($('txtAsOfDate'),this, null);" />
							</div>
						</td>

						<td style="padding-left: 40px;"><input type="radio" id="rdoFromToDate" name="rdoSearchByDate" value= "" style="margin: 0px 0px 0px 0px;"/></td>
						<td><label for="rdoFromToDate">From</label></td>
						<td>
							<div id="fromDiv" style="float: left; width: 125px;" class="withIconDiv">
						    	<input style="width: 100px;" class="withIcon" id="txtFromDate" name="txtFromDate" type="text" readOnly="readonly"/>
						    	<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" onClick="scwShow($('txtFromDate'),this, null);" />
						    </div>
						</td>
						<td><label for="rdoFromToDate" style="text-align: right;">To</label></td>
						<td>
							<div id="toDiv" style="float: left; width: 125px;" class="withIconDiv">
						    	<input style="width: 100px;" class="withIcon" id="txtToDate" name="txtToDate" type="text" readOnly="readonly"/>
						    	<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" onClick="scwShow($('txtToDate'),this, null);"/>
						    </div>
						</td>
					</tr>
				</table>	
			</div>
		</div>	
	</div> 
	<div class="sectionDiv" style="margin-bottom: 50px;">
		<div id="exGratiaDiv" style="padding-top: 10px; height: 350px;">
			<div id="exGratiaTable" style="height: 350px; width: 700px; margin-left: 10px;"></div>
		</div>
		<div id="exGratiaSubDiv" style="margin-top: 10px; height: 30px;">
			<table style="margin-left: 80px;">
				<tr>
					<td>
						<input type="button" class="button" id="btnPaymentDtls" name="btnPaymentDtls" value= "Payment Details" style="width: 145px"/>
					</td>
					<td align="right" style="padding-left: 80px;">Totals</td>
					<td style="padding-right: 0px;">
						<input type="text" id="txtLossReserve" name="txtLossReserve" value= "" style="width: 130px; text-align: right;" readonly="readonly"/>
					</td>
					<td style="padding-right: 0px;">
						<input type="text" id="txtExpenseReserve" name="txtExpenseReserve" value= "" style="width: 135px; text-align: right;" readonly="readonly"/>
					</td>
					<td style="padding-right: 0px;">
						<input type="text" id="txtLossesPaid" name="txtLossesPaid" value= "" style="width: 130px; text-align: right;" readonly="readonly"/>
					</td>
					<td>
						<input type="text" id="txtExpensePaid" name="txtExpensePaid" value= "" style="width: 123px;text-align: right;" readonly="readonly"/>
					</td>
				</tr>
			</table>
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
			</table>
		</div>
	</div>
</div>

<script type="text/javascript">
	setModuleId("GICLS273");
	setDocumentTitle("Ex-Gratia Claims Inquiry");
	enableFromToDate(false);
	initializeAll();
	initializeAccordion();
	initializeAllMoneyFields();
	var executeQuery = false;
	
	objGICLS273 = {};
	var objCurrExGratia = null;
	objGICLS273.exGratiaList = JSON.parse('${jsonExGratiaList}');
	objGICLS273.exitPage = null;
	objGICLS273.claimId = null;
	
	var exGratiaTable = {
			url : contextPath + "/GICLClaimsController?action=showGICLS273&refresh=1",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrExGratia = tbgExGratia.geniisysRows[y];
					objGICLS273.claimId = tbgExGratia.geniisysRows[y].claimId;
					setFieldValues(objCurrExGratia);
					tbgExGratia.keys.removeFocus(tbgExGratia.keys._nCurrentFocus, true);
					tbgExGratia.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgExGratia.keys.removeFocus(tbgExGratia.keys._nCurrentFocus, true);
					tbgExGratia.keys.releaseKeys();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgExGratia.keys.removeFocus(tbgExGratia.keys._nCurrentFocus, true);
						tbgExGratia.keys.releaseKeys();
					}
				},
				onSort: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgExGratia.keys.removeFocus(tbgExGratia.keys._nCurrentFocus, true);
					tbgExGratia.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgExGratia.keys.removeFocus(tbgExGratia.keys._nCurrentFocus, true);
					tbgExGratia.keys.releaseKeys();
				},				
				afterRender : function() {
					setFieldValues(null);
					tbgExGratia.keys.removeFocus(tbgExGratia.keys._nCurrentFocus, true);
					tbgExGratia.keys.releaseKeys();
					populateTotals(tbgExGratia.geniisysRows);
				}, 
				prePager: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgExGratia.keys.removeFocus(tbgExGratia.keys._nCurrentFocus, true);
					tbgExGratia.keys.releaseKeys();
				}
			},
			columnModel : [
				{ 								// this column will only use for deletion
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},	
				{
					id : "claimNo",
					title : "Claim Number",
					filterOption : false,
					width : '160px'
				},
				{
					id : 'clmStatDesc',
					title : 'Claim Status',
					filterOption : true,
					width : '150px'				
				},			
				{
					id : 'lossResAmt',
					title : 'Loss Reserve',
					filterOption : true,
					align : 'right',
					titleAlign : 'right',
					width : '140px',
					filterOptionType: 'number',
					geniisysClass: 'money'				
				},	
				{
					id : 'expResAmt',
					title : 'Expense Reserve',
					filterOption : true,
					align : 'right',
					titleAlign : 'right',
					width : '140px',
					filterOptionType: 'number',
					geniisysClass: 'money'				
				},	
				{
					id : 'lossPdAmt',
					title : 'Losses Paid',
					filterOption : true,
					align : 'right',
					titleAlign : 'right',
					width : '140px',
					filterOptionType: 'number',
					geniisysClass: 'money'				
				},	
				{
					id : 'expPdAmt',
					title : 'Expense Paid',
					filterOption : true,
					align : 'right',
					titleAlign : 'right',
					width : '140px',
					filterOptionType: 'number',
					geniisysClass: 'money'				
				},	
				{
					id : 'lineCd',
					title : 'Line Code',
					width : '0',
					filterOption : true,
					visible: false
				},
				{
					id : 'sublineCd',
					title : 'Subine Code',
					width : '0',
					filterOption : true,
					visible: false
				},
				{
					id : 'issCd',
					title : 'Issue Code',
					width : '0',
					filterOption : true,
					visible: false
				},
				{
					id : 'clmYy',
					title : 'Claim Year',
					width : '0',
					filterOption : true,
					filterOptionType: 'integerNoNegative',
					visible: false				
				},
				{
					id : 'clmSeqNo',
					title : 'Claim Seq No',
					width : '0',
					filterOption : true,
					filterOptionType: 'integerNoNegative',
					visible: false				
				}
			],
			rows : objGICLS273.exGratiaList.rows
		};

		tbgExGratia = new MyTableGrid(exGratiaTable);
		tbgExGratia.pager = objGICLS273.exGratiaList;
		tbgExGratia.render("exGratiaTable");
	
	function setFieldValues(rec){
		try{
			$("txtPolicyNo").value 		 = rec == null ? "" : unescapeHTML2(rec.policyNo);
			$("txtAssured").value 		 = rec == null ? "" : unescapeHTML2(rec.assdName);
			$("txtLossDate").value 		 = rec == null ? "" : rec.lossDate;
			$("txtClaimFileDate").value  = rec == null ? "" : rec.clmFileDate;
			rec == null ? disableButton("btnPaymentDtls") : enableButton("btnPaymentDtls");
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function populateTotals(obj){
		if (obj.length > 0){
			$("txtLossReserve").value 		= formatCurrency(obj[0].totLossRes);
			$("txtExpenseReserve").value 	= formatCurrency(obj[0].totExpRes);
			$("txtLossesPaid").value 		= formatCurrency(obj[0].totLossPd);
			$("txtExpensePaid").value 		= formatCurrency(obj[0].totExpPd);
		}else {
			$("txtLossReserve").clear();
			$("txtExpenseReserve").clear();
			$("txtLossesPaid").clear();
			$("txtExpensePaid").clear();
		}
	}
		
	function enableFromToDate(enable){
		if (nvl(enable,false) == true){
			//enable
			$("txtAsOfDate").value 		= "";
			$("txtAsOfDate").disabled 	= true;
			$("txtFromDate").disabled 	= false;
			$("txtToDate").disabled 	= false;
			disableDate("hrefAsOfDate");
			enableDate("hrefFromDate");
			enableDate("hrefToDate");
			$("fromDiv").setStyle({backgroundColor: '#FFFACD'});
			$("toDiv").setStyle({backgroundColor: '#FFFACD'});
			$("txtFromDate").setStyle({backgroundColor: '#FFFACD'});
			$("txtToDate").setStyle({backgroundColor: '#FFFACD'});
			$("txtAsOfDate").setStyle({backgroundColor: '#F0F0F0'});
			$("asOfDiv").setStyle({backgroundColor: '#F0F0F0'});
		}else{	
			//disable
			$("txtAsOfDate").value 		= getCurrentDate();
			$("txtAsOfDate").disabled 	= false;
			$("txtFromDate").value 		= "";
			$("txtToDate").value 		= "";
			$("txtFromDate").disabled 	= true;
			$("txtToDate").disabled 	= true;
			enableDate("hrefAsOfDate");
			disableDate("hrefFromDate");
			disableDate("hrefToDate");
			$("asOfDiv").setStyle({backgroundColor: '#FFFACD'});
			$("txtAsOfDate").setStyle({backgroundColor: '#FFFACD'});
			$("txtFromDate").setStyle({backgroundColor: '#F0F0F0'});
			$("txtToDate").setStyle({backgroundColor: '#F0F0F0'});
			$("fromDiv").setStyle({backgroundColor: '#F0F0F0'});
			$("toDiv").setStyle({backgroundColor: '#F0F0F0'});
		}
	}
	
	function refreshTbgExGratia(searchBy,dateAsOf,dateFrom,dateTo){
		tbgExGratia.url = contextPath+"/GICLClaimsController?action=showGICLS273&refresh=1&searchBy="+searchBy+"&asOfDate="+dateAsOf+"&fromDate="+dateFrom+"&toDate="+dateTo;
		tbgExGratia._refreshList();
		if (tbgExGratia.geniisysRows.length == 0){
			customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtAsOfDate");
			return false;
		}
		executeQuery = true;
		disableToolbarButton("btnToolbarExecuteQuery");
		enableToolbarButton("btnToolbarEnterQuery");
		enableToolbarButton("btnToolbarPrint");
		disableDateFields();
	}
	
	function getExGratiaParams(){
		$$("input[name='rdoSearchBy']").each(function(btn){
			if (btn.checked){
				searchBy = $F(btn);
				dateAsOf = $F("txtAsOfDate");
				dateFrom = $F("txtFromDate");
				dateTo = $F("txtToDate");
			}			
		});
		refreshTbgExGratia(searchBy,dateAsOf,dateFrom,dateTo);
	}
	
	function resetHeaderForm(){
		try{
			enableDateFields();
			tbgExGratia.url = contextPath+"/GICLClaimsController?action=showGICLS273&refresh=1";
			tbgExGratia._refreshList();
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarPrint");
			enableToolbarButton("btnToolbarExecuteQuery");
			executeQuery = false;
		} catch(e){
			showErrorMessage("resetHeaderForm", e);
		}
	}
	
	function enableDateFields() {
		$("rdoAsOfDate").disabled 		= false;
		$("txtAsOfDate").disabled 		= false;	
		$("rdoAsOfDate").checked 		= true;
		$("txtAsOfDate").value 			= getCurrentDate();
		$("rdoFromToDate").disabled 	= false;	
		$("txtFromDate").value 			= "";
		$("txtToDate").value 			= "";
		$("rdoClmFileDate").checked 	= true;
		enableDate("hrefAsOfDate");
		$("txtAsOfDate").setStyle({backgroundColor: '#FFFACD'});
	}
	
	function disableDateFields() {
		$("rdoAsOfDate").disabled 	= true;
		$("rdoFromToDate").disabled	= true;
		$("txtAsOfDate").disabled 	= true;		
		$("txtFromDate").disabled 	= true;
		$("txtToDate").disabled 	= true;		
		disableDate("hrefFromDate");
		disableDate("hrefToDate");
		disableDate("hrefAsOfDate");
		$("asOfDiv").setStyle({backgroundColor: '#F0F0F0'});
		$("fromDiv").setStyle({backgroundColor: '#F0F0F0'});
		$("toDiv").setStyle({backgroundColor: '#F0F0F0'});
		$("txtAsOfDate").setStyle({backgroundColor: '#F0F0F0'});
		$("txtFromDate").setStyle({backgroundColor: '#F0F0F0'});
		$("txtToDate").setStyle({backgroundColor: '#F0F0F0'});
	}
	
	$("rdoAsOfDate").observe("click", function(a){
		enableFromToDate(false);
	});
	
	$("rdoFromToDate").observe("click", function(a){
		enableFromToDate(true);
	});
	
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
		getExGratiaParams();
	});
	
 	$$("input[name='rdoSearchBy']").each(function(btn){
		btn.observe("click",function(){
			try{
				if (executeQuery) {
					getExGratiaParams();
				}
			}catch(e){
				showErrorMessage("rdoSearchBy", e);
			}						
		});	
	});

	$("txtAsOfDate").observe("focus", function(){
		if ($("hrefAsOfDate").disabled == true) return;
		var asOfDate = $F("txtAsOfDate") != "" ? new Date($F("txtAsOfDate").replace(/-/g,"/")) :"";
		var sysdate = new Date();
		if (asOfDate > sysdate && asOfDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtAsOfDate");
			$("txtAsOfDate").clear();
			return false;
		}
	});
	
	$("txtFromDate").observe("focus", function(){
		if ($("hrefFromDate").disabled == true) return;
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) : "";
		var sysdate = new Date();
		if (fromDate > sysdate && fromDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtFromDate");
			$("txtFromDate").clear();
			return false;
		}
		if (fromDate > toDate && toDate != ""){
			customShowMessageBox("From Date should not be later than To Date.", "I", "txtFromDate");
			$("txtFromDate").clear();
			return false;
		}
	});
	
	$("txtToDate").observe("focus", function(){
		if ($("hrefToDate").disabled == true) return;
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) :"";
		var sysdate = new Date();
		if (toDate > sysdate && toDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtToDate");
			$("txtToDate").clear();
			return false;
		}
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("From Date should not be later than To Date.", "I", "txtToDate");
			$("txtToDate").clear();
			return false;
		}
	});
	
	$("btnToolbarExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});
	
	observeReloadForm("reloadForm", showGICLS273); 	
	observeBackSpaceOnDate("txtAsOfDate");
	observeBackSpaceOnDate("txtFromDate");
	observeBackSpaceOnDate("txtToDate");
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarPrint");
	
	$("btnPaymentDtls").observe("click", function() {
		try {
			$$("input[name='rdoSearchBy']").each(function(btn){
				if (btn.checked){
					searchBy = $F(btn);
					dateAsOf = $F("txtAsOfDate");
					dateFrom = $F("txtFromDate");
					dateTo = $F("txtToDate");
				}			
			});
			overlayPaymentDetails = Overlay.show(contextPath+ "/GICLClaimsController", {
				urlContent : true,
				urlParameters : {
					action : "showGICLS273PaymentDetails",
					searchBy : searchBy,
					asOfDate : dateAsOf,
					fromDate : dateFrom,
					toDate : dateTo,
					claimId : objGICLS273.claimId
				},	
				title : "Payment Details",
				height: 420,
				width: 820,
				draggable : true
			});
		} catch (e) {
			showErrorMessage("overlay error: ", e);
		}
	});

	var reports = [];
	function checkReport(){
		try{
			//jmm SR-5629
			var fileType = $("rdoPdf").checked ? "PDF" : "CSV2" ;
			
			var reportId = [];
			if($("rdoPdf").checked){
				reportId.push("GICLR273");
			}else if($("rdoCsv").checked && "file" == $F("selDestination")){
				reportId.push("GICLR273_CSV");//jmm SR-5629
			}else{
				reportId.push("GICLR273");
			}
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
			$$("input[name='rdoSearchBy']").each(function(btn){
				if (btn.checked){
					searchBy = $F(btn);
					dateAsOf = $F("txtAsOfDate");
					dateFrom = $F("txtFromDate");
					dateTo = $F("txtToDate");
				}			
			});
			
			var content = contextPath + "/PrintClaimListingInquiryController?action=printReport"
            + "&reportId=" + reportId
            + "&moduleId=GICLS273"
            + "&searchBy=" + searchBy
            + "&dateAsOf=" + dateAsOf
            + "&dateFrom=" + dateFrom
            + "&dateTo=" + dateTo;

			reptTitle = "Ex-Gratia Claims";
			
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
						          fileType    : $("rdoPdf").checked ? "PDF" : "CSV2"},
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							if (fileType = "CSV2"){ //jmm SR-5629
								copyFileToLocal(response, "csv");
								deleteCSVFileFromServer(response.responseText);
							} else {
								copyFileToLocal(response);
							}
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
	
	$("btnToolbarPrint").observe("click", function(){
		showGenericPrintDialog("Print Ex-Gratia Claims", checkReport, "" ,true);
		$("csvOptionDiv").show();
	});
</script>
