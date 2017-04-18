<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="polWithPremPaymentsDiv" name="polWithPremPaymentsDiv">
	<div id="toolbarDiv" name="toolbarDiv">
		<div class="toolButton">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/enterQuery.png) left center no-repeat;" id="btnToolbarEnterQuery">Enter Query</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/enterQueryDisabled.png) left center no-repeat;" id="btnToolbarEnterQueryDisabled">Enter Query</span>
		</div>
		<div class="toolButton">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/executeQuery.png) left center no-repeat;" id="btnToolbarExecuteQuery">Execute Query</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/executeQueryDisabled.png) left center no-repeat;" id="btnToolbarExecuteQueryDisabled">Execute Query</span>
		</div>
		<div class="toolButton" style="float: right;">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/exit.png) left center no-repeat;" id="btnToolbarExit">Exit</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/exitDisabled.png) left center no-repeat;" id="btnToolbarExitDisabled">Exit</span>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Premium Payment Warranty Tracking Screen</label>
		</div>
	</div>
	<div class="sectionDiv" align="center">
		<fieldset style="margin: 10px;">
			<div style="float:left;">
				<table cellpadding="0">
					<tr>
						<td>
							Search By:
						</td>
					</tr>
					<tr>
						<td class="rightAligned" width="140px" style="padding-top: 12px;">
							<input type="radio" name="searchBy" id="rdoIncDate" style="float: left; margin: 3px 2px 3px 30px;" tabindex="103" checked="checked" tabindex="101"/>
							<label for="rdoIncDate" style="float: left; height: 20px; padding-top: 3px;">Incept Date</label>
						</td>
						<td width="20px"></td>
						<td class="rightAligned" width="140px" style="padding-top: 12px;">
							<input type="radio" name="searchBy" id="rdoAcctEntDate" style="float: left; margin: 3px 2px 3px 30px;" tabindex="102"/>
							<label for="rdoAcctEntDate" style="float: left; height: 20px; padding-top: 3px;">Acct. Entry Date</label>
						</td>
						<td width="20px"></td>
						<td class="rightAligned" width="140px" style="padding-top: 12px;">
							<input type="radio" name="searchBy" id="rdoBookDate" style="float: left; margin: 3px 2px 3px 30px;" tabindex="103"/>
							<label for="rdoBookDate" style="float: left; height: 20px; padding-top: 3px;">Booking Date</label>
						</td>
					</tr>
				</table>
			</div>
			<div style="float:right;">
				<table cellspacing="0" align="center" style="float: right;">
					<tr>
						<td class="rightAligned"  style="padding-top: 4px;">
							<input type="radio" name="byDate" id="rdoAsOf" title="As of" style="float: left;" tabindex="104"/>
							<label for="rdoAsOf" title="As of" style="float: left; height: 20px; padding-top: 3px;">As of</label>
						</td>
						<td class="leftAligned">
							<div style="float: left; width: 145px;" class="withIconDiv">
								<input type="text" id="txtAsOfDate" name="txtAsOfDate" class="withIcon" readonly="readonly" style="width: 120px;"/>
								<img id="hrefAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" tabindex="105" onClick="scwShow($('txtAsOfDate'),this, null);"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">
							<input type="radio" name="byDate" id="rdoFrom" title="From" style="float: left;" tabindex="106"/>
							<label for="rdoFrom" style="float: left; height: 20px; padding-top: 3px;">From</label>
						</td>
						<td class="leftAligned">
							<div style="float: left; width: 145px;" class="withIconDiv">
								<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon" readonly="readonly" style="width: 120px;"/>
								<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" tabindex="107" onClick="scwShow($('txtFromDate'),this, null);"/>
							</div>
						</td>
						<td class="rightAligned">To</td>
						<td class="leftAligned">
							<div style="float: left; width: 145px;" class="withIconDiv">
								<input type="text" id="txtToDate" name="txtToDate" class="withIcon" readonly="readonly" style="width: 120px;"/>
								<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex="108" onClick="scwShow($('txtToDate'),this, null);"/>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</fieldset>
	</div>
	<div id="sectionDivBottom" class="sectionDiv" style="margin-bottom: 30px;">
		<div id="polWithPremPaymentsTable" style="padding: 10px 10px 10px 10px;">
			<div id="polWithPremPaymentsTableDiv" style="height: 340px;"></div>
		</div>
		<div class="sectionDiv" align="center" style="margin: 0px 10px 10px 10px; width: 97.5%; padding: 15px 0px 15px 0">
			<table cellpadding="0" cellspacing="0">
				<tr>
					<td class="rightAligned">Assured</td>
					<td class="leftAligned" colspan="5"><input type="text" id="txtAssured" style="width: 650px;" readonly="readonly" tabindex="201"/></td>
				<tr>
				<tr>
					<td class="rightAligned">Policy / Endt No</td>
					<td class="leftAligned" colspan="5"><input type="text" id="txtPolNo" style="width: 650px;" readonly="readonly" tabindex="202"/></td>
				<tr>
				<tr>
					<td class="rightAligned" width="100px">Incept Date</td>
					<td class="leftAligned"><input type="text" id="txtIncDate" style="width: 120px;" readonly="readonly" tabindex="203"/></td>
					<td class="rightAligned" width="132px">Acct. Entry Date</td>
					<td class="leftAligned"><input type="text" id="txtAcctEntDate" style="width: 120px;" readonly="readonly" tabindex="204"/></td>
					<td class="rightAligned" width="130px">Booking Date</td>
					<td class="leftAligned"><input type="text" id="txtBookDate" style="width: 120px;" readonly="readonly" tabindex="205"/></td>
				<tr>
			</table>
		</div>	
	</div>
</div>
<script type="text/javascript">
	initializeAll();
	initializeAccordion();
	setModuleId("GIPIS214");
	setDocumentTitle("Premium Payment Warranty Tracking Screen");
	var exec = false;
	
	onPageLoadSetting();
	
	function onPageLoadSetting(){
		$("rdoIncDate").focus();
		showTableGrid();
		$("rdoAsOf").disabled = false;
		$("txtAsOfDate").disabled = false;
		$("rdoFrom").disabled = false;
		enableDate("hrefAsOfDate");
		enableDate("hrefFromDate");
		enableDate("hrefToDate");
		toggleCalendar(false);
		$("rdoAsOf").checked = true;
		$("rdoIncDate").checked = true;
		exec = false;
		execAgain = true;
		enableToolbarButton("btnToolbarExecuteQuery");
	}
	
	
	$("btnToolbarExit").observe("click", function(){
		document.stopObserving("keyup");
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	function showTableGrid(){
		try {
			polWithPremPaymentsTable = {
				url : contextPath+ "/GIRIBinderController?action=showPolWithPremPayments",
				id: "polWithPremPayments",
				options : {
					height : '335px',
					hideColumnChildTitle : true,
					pager : {},
					onCellFocus : function(element, value, x, y, id) {
						setDetails(tbgPolWithPremPaymentsTable.geniisysRows[y]);
						tbgPolWithPremPaymentsTable.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id) {
						setDetails(null);
						tbgPolWithPremPaymentsTable.keys.releaseKeys();
					},
					onSort : function(){
						setDetails(null);
						tbgPolWithPremPaymentsTable.keys.releaseKeys();
					},
					afterRender : function() {
						setDetails(null);
						tbgPolWithPremPaymentsTable.keys.releaseKeys();
					}, 
					toolbar : {
						elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
						onFilter : function(){
							tbgPolWithPremPaymentsTable.keys.releaseKeys();
							setDetails(null);
						},
						onRefresh : function(){
							setDetails(null);
							tbgPolWithPremPaymentsTable.keys.releaseKeys();
						}
					}
				},
				columnModel : [ 
					{
					    id: 'recordStatus',
					    width: '0',
					    visible: false
					},
					{
						id: 'divCtrId',
						width: '0',
						visible: false 
					},
					{
						id : "binderLinecd binderYy bindrSeqNo",
						title : "Binder",
						align : "left",
						titleAlign: "left",
						width : '140px',
						children : [ {
							id : 'binderLinecd',
							title : 'Binder Line Cd',
							width : 60,
							filterOption : true,
							editable : false
						}, {
							id : 'binderYy',
							title : 'Binder YY',
							width : 40,
							filterOption : true,
							filterOptionType: 'integerNoNegative',
							editable : false
						}, {
							id : 'bindrSeqNo',
							title : 'Binder Seq No',
							width : 40,
							filterOption : true,
							filterOptionType: 'integerNoNegative',
							editable : false
						} ]
					},
					{
						id : "riName",
						title : "Reinsurer",
						align : "left",
						titleAlign: "left",
						width : '250px',
						filterOption : true
					},
					{
						id : "binderDate",
						title : "Binder Date",
						align : "left",
						titleAlign: "left",
						width : '130px',
						filterOption : true,
						filterOptionType: 'formattedDate',
						renderer : function(value) {
					    	return dateFormat(value, "mm-dd-yyyy"); 
					    }
					},
					{
						id : "premWarrDays",
						title : "PPW",
						align : "left",
						titleAlign: "left",
						width : '80px',
						filterOption : true,
						filterOptionType: 'integerNoNegative'
					},
					{
						id : "riTsiAmt",
						title : "TSI Share Amt.",
						align : "right",
						titleAlign: "right",
						width : '130px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},
					{
						id : "riPremAmt",
						title : "Prem. Share Amt.",
						align : "right",
						titleAlign: "right",
						width : '130px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					}
				],
				rows : []
			};
			tbgPolWithPremPaymentsTable = new MyTableGrid(polWithPremPaymentsTable);
			tbgPolWithPremPaymentsTable.render('polWithPremPaymentsTableDiv');
		} catch (e) {
			showErrorMessage("polWithPremPayments.jsp", e);
		}
	}
	
	function setDetails(row){
		try{
			$("txtAssured").value		= row == null ? "" : unescapeHTML2(row.assdName);
			$("txtPolNo").value 	 	= row == null ? "" : unescapeHTML2(row.polNo);
			$("txtIncDate").value 	 	= row == null ? "" : row.incDate==null? "" : dateFormat(row.incDate, "mm-dd-yyyy"); 
			$("txtAcctEntDate").value 	= row == null ? "" : row.acctEntDate==null? "" : dateFormat(row.acctEntDate, "mm-dd-yyyy"); 
			$("txtBookDate").value 	 	= row == null ? "" : row.bookDate; 
		}catch(e){	
			showErrorMessage("setDetails", e);
		}
	}
	
	function toggleCalendar(enable){
		if (nvl(enable,false) == true){
			$("txtAsOfDate").value 		= "";
			$("txtAsOfDate").disabled 	= true;
			$("txtFromDate").disabled 	= false;
			$("txtToDate").disabled 	= false;
			disableDate("hrefAsOfDate");
			enableDate("hrefFromDate");
			enableDate("hrefToDate");
		}else{	
			$("txtAsOfDate").value 		= getCurrentDate();
			$("txtFromDate").value 		= "";
			$("txtToDate").value 		= "";
			$("txtAsOfDate").disabled 	= false;
			$("txtFromDate").disabled 	= true;
			$("txtToDate").disabled 	= true;
			enableDate("hrefAsOfDate");
			disableDate("hrefFromDate");
			disableDate("hrefToDate");
		}
	}
	
	$("rdoFrom").observe("click", function() {
		toggleCalendar(true);
	});
	$("rdoAsOf").observe("click", function() {
		toggleCalendar(false);
	});
	
	//date field validations
	$("txtFromDate").observe("focus", function(){
		if ($("hrefFromDate").disabled == true) return;
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) : "";
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
		var sysdate = new Date();
		if (fromDate > sysdate && fromDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtFromDate");
			$("txtFromDate").clear();
			return false;
		}
		if (toDate < fromDate && toDate != ""){
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
	
	function getParams(){
		var params = "";
		var search = 1;
		if($("rdoIncDate").checked){
			search = 1;
		}else if($("rdoAcctEntDate").checked){
			search = 2;
		}else if($("rdoBookDate").checked){
			search = 3;
		}
		params = "&searchBy="+search+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate")+"&asOfDate="+$F("txtAsOfDate");
		return params;
	}
	
	function queryTable(){
		if(checkParams()){
			if (execAgain){
				tbgPolWithPremPaymentsTable.url = contextPath +"/GIRIBinderController?action=showPolWithPremPayments&refresh=1"+getParams();
				tbgPolWithPremPaymentsTable._refreshList();
				disableToolbarButton("btnToolbarExecuteQuery");
				$("rdoFrom").disabled = true;
				$("rdoAsOf").disabled = true;
				$("txtAsOfDate").disabled = true;
				$("txtFromDate").disabled = true;
				$("txtToDate").disabled = true;
				disableDate("hrefAsOfDate");
				disableDate("hrefFromDate");
				disableDate("hrefToDate");
				exec = true;
				execAgain = false;
			}
		}
	}
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		queryTable();
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		onPageLoadSetting();
	});
	
	function checkParams(){
		if($("rdoFrom").checked){
			if($F("txtFromDate") == ""){
				customShowMessageBox("Pls. enter FROM date.", imgMessage.INFO, "txtFromDate");
				return false;
			}
			if($F("txtToDate") == ""){
				customShowMessageBox("Pls. enter TO date.", imgMessage.INFO, "txtToDate");
				return false;	
			}
			return true;
		} else if ($("rdoAsOf").checked) {
			if($F("txtAsOfDate") == ""){
				customShowMessageBox("Pls. enter As Of date.", imgMessage.INFO, "txtAsOfDate");
				return false;	
			}
			return true;
		}
	}
	
	$("rdoIncDate").observe("click",function(){
		if(exec){
			execAgain=true;
			queryTable();
		}
	});
	$("rdoAcctEntDate").observe("click",function(){
		if(exec){
			execAgain=true;
			queryTable();
		}
	});
	$("rdoBookDate").observe("click",function(){
		if(exec){
			execAgain=true;
			queryTable();
		}
	});
	
</script>