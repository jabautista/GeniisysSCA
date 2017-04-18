<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div id="batchCheckingExtractMainDiv" name="batchCheckingExtractMainDiv">
  	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="batchCheckingExit">Exit</a></li>
			</ul>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
   			<label>Batch Checking</label>
   			<span class="refreshers" style="margin-top: 0;">
   				<label id="reloadForm" name="reloadForm">Reload Form</label>
   			</span>
	   	</div>
	</div>
	
	<div id="batchCheckingSectionDiv" class="sectionDiv" style="height: 565px; margin-bottom: 40px;">
		<div id="batchCheckingExtractHeaderDiv" style="margin-top: 10px; margin-left: 15px; margin-bottom: 10px; height: 85px;">
			<div id="batchTypeDiv" style="width: 130px; float: left;">
				<fieldset>
					<legend>Batch Type</legend>
					<table>
						<tr>
							<td class="rightAligned">
								<input type="radio" name="batchType" id="rdoProduction" value="B" style="float: left; margin: 3px 2px 3px 15px;" tabindex="99" checked="checked"/>
								<label for="rdoProduction" style="float: left; height: 20px; padding-top: 3px;" title="Production">Production</label>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">
								<input type="radio" name="batchType" id="rdoClaims" value="C" style="float: left; margin: 3px 2px 3px 15px;" tabindex="100"/>
								<label for="rdoClaims" style="float: left; height: 20px; padding-top: 3px;" title="Claims">Claims</label>
							</td>
						</tr>
					</table>
				</fieldset>
			</div>  
			<div id="batchCheckingExtractUsing" style="width: 175px; float: left;">
				<fieldset>
					<legend>Extract Using</legend>
					<table>
						<tr>
							<td class="rightAligned">
								<input type="radio" name="extractUsing" id="rdoPostingDate" value="P" style="float: left; margin: 3px 2px 3px 15px;" tabindex="101"/>
								<label for="rdoPostingDate" style="float: left; height: 20px; padding-top: 3px;" title="Posting Date">Posting Date</label>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">
								<input type="radio" name="extractUsing" id="rdoTransactionDate" value="T" style="float: left; margin: 3px 2px 3px 15px;" tabindex="102"/>
								<label for="rdoTransactionDate" style="float: left; height: 20px; padding-top: 3px;" title="Transaction Date">Transaction Date</label>
							</td>
						</tr>
					</table>
				</fieldset>
			</div>
			<div style="float: left; margin-top: 15px; margin-left: 10px; padding-top: 10px;">
				<table>
					<tr>
						<td class="rightAligned" width="30px;">From</td>
						<td class="leftAligned">
							<div style="float: left; width: 135px;" class="withIconDiv required" id="fromDiv">
								<input type="text" id="txtFromDate" name="From date." removeStyle="true" class="withIcon required date" readonly="readonly" style="width: 110px;" tabindex="103" prevFromDate=""/>
								<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" tabindex="104"/>
							</div>
						</td>
						<td class="rightAligned" style="width: 10px;">To</td>
						<td class="leftAligned">
							<div style="float: left; width: 135px;" class="withIconDiv required" id="toDiv">
								<input type="text" id="txtToDate" name="To date." removeStyle="true" class="withIcon required date" readonly="readonly" style="width: 110px;" tabindex="105" prevToDate=""/>
								<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex="106"/>
							</div>
						</td>
						<td style="padding-left: 15px;"><input type="button" class="button" id="btnExtract" name="btnExtract" value="Extract" style="width: 100px;" tabindex="201"/></td>
						<td><input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width: 100px;" tabindex="202"/></td>
					</tr>
				</table>
			</div>
		</div>
				<div id="tabComponentsDiv2" class="tabComponents1" style="align:center;width:100%">
			<ul>
				<li name="prodGroup" class="tab1 selectedTab1" style="width:20%"><a id="grossTab">Gross Premiums</a></li>
				<li name="prodGroup" class="tab1" style="width:22%"><a id="faculTab">Premiums Ceded To Facul</a></li>
				<li name="prodGroup" class="tab1" style="width:22%"><a id="treatyTab">Premiums Ceded To Treaty</a></li>
				<li name="prodGroup" class="tab1" style="width:20%"><a id="netTab">Net Premiums</a></li>
				<li name="claimGroup" class="tab1" style="width:20%; display: none;"><a id="outTab">Outstanding Losses</a></li>
				<li name="claimGroup" class="tab1" style="width:20%; display: none;"><a id="lossTab">Losses Paid</a></li>
			</ul>			
		</div>
		<div class="tabBorderBottom1"></div>
		<div id="tabPageContents" name="tabPageContents" style="width: 100%; float: left;">	
			<div id="tabGrossContents" name="tabGrossContents" style="width: 100%; float: left;">
				<div id="tableDiv" style="margin-top: 15px; margin-bottom:10px; height: 325px;"></div>
				<table style="margin-bottom: 10px;">
					<tr align="center">
						<td id="tdTotal" class="rightAligned" style="width:450px;">Total</td>
						<td class="leftAligned">
							<input type="hidden" id="txtTotalGross" name="txtTotalGross" class="text rightAligned" readonly="readonly" style="width: 163px;"/>
							<input type="text" id="txtTotalPrem" name="txtTotalPrem" class="text rightAligned" readonly="readonly" style="width: 134px;"/>
							<input type="text" id="txtTotalBal" name="txtTotalBal" class="text rightAligned" style="width: 134px;" readonly="readonly" />
							<input type="text" id="txtTotalDiff" name="txtTotalDiff" class="text rightAligned" style="width: 134px;" readonly="readonly" />
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div style="width: 100%; float: left;" align="center">
			<input type="button" class="disabledButton" id="btnDetails" name="btnDetails" value="Details" style="width: 100px;" tabindex="203"/>
		</div>
	</div>
</div>
<script type="text/javascript">
	var tab = null;
	
	function initializeBatchChecking() {
		setModuleId("GIACS354");
		setDocumentTitle("Batch Checking");
		dateTag="";
		initializeAll();
		initializeTabs();
		initializeAccordion();
		getPrevExtractParams();
		fireEvent($("grossTab"), "click");
	}
	
	function getPrevExtractParams() {
		new Ajax.Request(contextPath+"/GIACBatchCheckController?action=getPrevExtractParams",{
			parameters: {
				batchType: $("rdoProduction").checked ? "B" : "C"
			},
			method: "POST",
			onComplete : function (response){
				if(checkErrorOnResponse(response)){
					var prevArray = [];
					prevArray = JSON.parse(response.responseText);
					for ( var b = 0; b < prevArray.rec.length; b++) {
						if (prevArray.rec[b]['vExists'] == "TRUE") {
							$("txtFromDate").setAttribute("prevFromDate", prevArray.rec[b]['fromDate']);
							$("txtToDate").setAttribute("prevToDate", prevArray.rec[b]['toDate']);
							$("txtFromDate").value = prevArray.rec[b]['fromDate'];
							$("txtToDate").value = prevArray.rec[b]['toDate'];
							
							$$("input[name='extractUsing']").each(function(rdo) {
								if ($(rdo).value == prevArray.rec[b]['dateTag']) {
									$(rdo).checked = true;
								}
							});
							dateTag = prevArray.rec[b]['dateTag'];
						}else {
							$("rdoPostingDate").checked = true;
							dateTag = "P";
							showMessageBox("You have not extracted any values yet.", imgMessage.INFO);
						}
					}
				}
			}							 
		});	
	}
	
	function checkDates() {
		if ($F("txtFromDate") != "" || $F("txtToDate") != "" ) {
			if ($F("txtFromDate") == $("txtFromDate").getAttribute("prevFromDate") && $F("txtToDate") == $("txtToDate").getAttribute("prevToDate")) {
				//showWaitingMessageBox("You have already extracted values with these dates. Do you still want to re-extract?", imgMessage.INFO, extractBatchChecking);
				showConfirmBox("Confirmation", "Data has been extracted within the specified parameter/s. Do you wish to continue extraction?", "Yes", "No", extractBatchChecking, null, 2);
			}else {
				getDateTag();
				extractBatchChecking();
			}
		}
	}
	
	function getTable(tab) {
		getDateTag();
		try {	//get records per selected table
			new Ajax.Updater("tableDiv", contextPath + "/GIACBatchCheckController", {
				method: "POST",
				parameters: {
					action: "getMainTable",
					table: tab,
					fromDate: $F("txtFromDate"),
					toDate: $F("txtToDate"),
					dateTag: dateTag
					},
				asynchronous: true,
				evalScripts: true,
				onCreate: function() {
					showNotice("Processing data, Please Wait..." + contextPath);
				}, 
				onComplete: function() {
					hideNotice();
					setTotalFields(null);
				}
			});
		} catch(e) {
			showErrorMessage("getTable",e);
		}
	}
	
	function getNetTable(){
		var objBatchExtNet = new Object();
		try{
			objBatchExtNet.objBatchExtNetListing = JSON.parse('${net}');
			objBatchExtNet.batchExtMainNetList = objBatchExtNet.objBatchExtNetListing.rows || [];
			tbgMainNet = {
					url: contextPath+"/GIACBatchCheckController?action=showBatchChecking&refresh=1",
				options: {
					width: '900px',
					height: '306px',
					id: 1,
					onCellFocus: function(element, value, x, y, id){
						batchExtractNetTableGrid.keys.removeFocus(batchExtractNetTableGrid.keys._nCurrentFocus, true);
						batchExtractNetTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus: function(){
						batchExtractNetTableGrid.keys.removeFocus(batchExtractNetTableGrid.keys._nCurrentFocus, true);
						batchExtractNetTableGrid.keys.releaseKeys();
		            },
	           	 	onSort: function(){
		           	 	batchExtractNetTableGrid.keys.removeFocus(batchExtractNetTableGrid.keys._nCurrentFocus, true);
						batchExtractNetTableGrid.keys.releaseKeys();
	           	 	},
		            prePager: function(){
		            	batchExtractNetTableGrid.keys.removeFocus(batchExtractNetTableGrid.keys._nCurrentFocus, true);
						batchExtractNetTableGrid.keys.releaseKeys();
		            },
					onRefresh: function(){
						batchExtractNetTableGrid.keys.removeFocus(batchExtractNetTableGrid.keys._nCurrentFocus, true);
						batchExtractNetTableGrid.keys.releaseKeys();
					},
					toolbar: {
						elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onFilter: function(){
							batchExtractNetTableGrid.keys.removeFocus(batchExtractNetTableGrid.keys._nCurrentFocus, true);
							batchExtractNetTableGrid.keys.releaseKeys();
						}
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
						id : "lineName",
						title : "Line",
						width : '160px',
						filterOption : true
					},
					{
						id : "grossAmt",
						title : "Gross Amount",
						width : '172px',
						align : 'right',
						titleAlign : 'right',
						geniisysClass: 'money'
					},
					{
						id : "faculAmt",
						title : "Prem Ceded To Facul",
						width : '180px',
						align : 'right',
						titleAlign : 'right',
						geniisysClass: 'money'
					},
					{
						id : "treatyAmt",
						title : "Prem Ceded To Treaty",
						width : '180px',
						align : 'right',
						titleAlign : 'right',
						geniisysClass: 'money'
					},
					{
						id : "difference",
						title : "Net Amount",
						width : '173px',
						align : 'right',
						titleAlign : 'right',
						geniisysClass: 'money'
					}
					],
				rows: objBatchExtNet.batchExtMainNetList
			};
		
			batchExtractNetTableGrid = new MyTableGrid(tbgMainNet);
			batchExtractNetTableGrid.pager = objBatchExtNet.objBatchExtNetListing;
			batchExtractNetTableGrid.render("tableDiv");
			batchExtractNetTableGrid.afterRender = function(y) {
				disableButton("btnDetails");
				setTotalFields("net");
				//getTotalAmountForNet();
				if(batchExtractNetTableGrid.geniisysRows.length != 0){
					$("txtTotalGross").value  = formatCurrency(batchExtractNetTableGrid.geniisysRows[0].grossTotal);
					$("txtTotalPrem").value = formatCurrency(batchExtractNetTableGrid.geniisysRows[0].faculTotal);
					$("txtTotalBal").value	 = formatCurrency(batchExtractNetTableGrid.geniisysRows[0].treatyTotal);
					$("txtTotalDiff").value  = formatCurrency(batchExtractNetTableGrid.geniisysRows[0].diffTotal);
				}
			};
			
		}catch (e) {
			showErrorMessage("getNetTable", e);
		}	
	}

	function getTotalAmountForNet() {
		new Ajax.Request(contextPath+"/GIACBatchCheckController",{
			parameters: {
				action: "getTotalNet"
			},
			method: "POST",
			onComplete : function (response){
				if(checkErrorOnResponse(response)){
					tempArray = [];
					tempArray = JSON.parse(response.responseText);
					for ( var b = 0; b < tempArray.rec.length; b++) {
						$("txtTotalGross").value  = formatCurrency(parseFloat(nvl(tempArray.rec[b]['grossAmtTotal'], "0")));
						$("txtTotalPrem").value = formatCurrency(parseFloat(nvl(tempArray.rec[b]['faculAmtTotal'], "0")));
						$("txtTotalBal").value	 = formatCurrency(parseFloat(nvl(tempArray.rec[b]['treatyAmtTotal'], "0")));
						$("txtTotalDiff").value  = formatCurrency(parseFloat(nvl(tempArray.rec[b]['differenceTotal'], "0")));
					}
				}
			}							 
		});	
	}
	
	function setTotalFields(net) {
		if (net != null) {
			$("tableDiv").setStyle({margin : '10px 10px 10px'});
			$("tdTotal").setStyle({width : '160px'});
			$("txtTotalGross").setAttribute("type", "text");
			$("txtTotalPrem").setStyle({width : '170px'});
			$("txtTotalBal").setStyle({width : '170px'});
			$("txtTotalDiff").setStyle({width : '170px'});
		}else {
			$("tableDiv").setStyle({margin : '0px 0px 10px'});
			$("tdTotal").setStyle({width : '448px'});
			$("txtTotalGross").setAttribute("type", "hidden");
			$("txtTotalPrem").setStyle({width : '134px'});
			$("txtTotalBal").setStyle({width : '134px'});
			$("txtTotalDiff").setStyle({width : '134px'});
			$("txtTotalGross").value = "";
			$("txtTotalPrem").value	 = "";
			$("txtTotalBal").value	 = "";
			$("txtTotalDiff").value  = "";
		}
	}
	
	function getDateTag() {
		if($("rdoPostingDate").checked == true){
			dateTag = "P";
		}else {
			dateTag = "T";
		}
	}
		
	function extractBatchChecking() {	
		new Ajax.Request(contextPath+"/GIACBatchCheckController", {
			parameters: {
				action: "extractBatchChecking",
				fromDate: $F("txtFromDate"),
				toDate: $F("txtToDate"),
				dateTag: dateTag,
				batchType: $("rdoProduction").checked ? "B" : "C", 	//marco - 02.23.2015
				tab: $("rdoProduction").checked ? null : tab		//
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function() {
				showNotice("Please wait...extracting records...");
			},
			onComplete: function(response) {
				hideNotice();
				if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
					showWaitingMessageBox(response.responseText, imgMessage.INFO, function(){
						if($("rdoProduction").checked){
							fireEvent($("grossTab"), "click");
						}else{
							fireEvent($("outTab"), "click");
						}
					});
				}
			}
		});
	}
	
	function checkRecords(){
		new Ajax.Request(contextPath+"/GIACBatchCheckController", {
			parameters: {
				action: "checkRecords",
				fromDate: $F("txtFromDate"),
				toDate: $F("txtToDate"),
				batchType: $("rdoProduction").checked ? "B" : "C"
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function() {
				showNotice("Please wait...extracting records...");
			},
			onComplete: function(response) {
				hideNotice();
				if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
					showGenericPrintDialog("Print Batch Checking", printReport, function(){$("csvOptionDiv").show();}, true); //Deo [02.02.2017]: inserted onLoadFunc (SR-5923)
				}
			}
		});
	}

	function exportToExcel(content){
		var reports = [];
		
		if($("rdoProduction").checked){
			reports = [{"reportId":"GIACR354_GROSS", "sheetName":"Gross Premiums"},
		               {"reportId":"GIACR354_FACULTATIVE", "sheetName":"Premiums Ceded to Facul"},
		               {"reportId":"GIACR354_TREATY", "sheetName":"Premiums Ceded to Treaty"},
		               {"reportId":"GIACR354_NET", "sheetName":"Net Premiums" }];
		}else{
			reports = [{"reportId":"GIACR354_OUTSTANDING", "sheetName":"Outstanding Losses"},
			           {"reportId":"GIACR354_LOSSES", "sheetName":"Losses Paid"}];
		}
		
		new Ajax.Request(content, {
			parameters : {destination : "file",
						  fileType :"XLS",
						  multiSheet: "Y",
						  reportList: prepareJsonAsParameter(reports)},
			onCreate: showNotice("Generating report, please wait..."),
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					copyFileToLocal(response);
				}
			}
		});
	}
	
	function printReport(){
		try {
			var reportId = $("rdoProduction").checked ? "GIACR354" : "GIACR354_CLAIMS";
			var content = contextPath + "/EndOfMonthPrintReportController?action=printReport&reportId="+reportId;
			
			if("screen" == $F("selDestination")){
				showPdfReport(content, "Batch Checking");
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {noOfCopies : $F("txtNoOfCopies"),
						  	      printerName : $F("selPrinter")},
					onCreate: showNotice("Processing, please wait..."),				
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							
						}
					}
				});
			}else if("file" == $F("selDestination")){
				if($("rdoPdf").checked){
					new Ajax.Request(content, {
						parameters : {destination : "file",
									  fileType : "PDF"},
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								copyFileToLocal(response);
							}
						}
					});
				} else if ($("rdoCsv").checked) { //Deo [02.02.2017]: add start (SR-5923)
					new Ajax.Request(content, {
						method : "POST",
						parameters : {
							destination : "file",
							fileType : "CSV"
						},
						evalScripts : true,
						asynchronous : true,
						onCreate : showNotice("Generating report, please wait..."),
						onComplete : function(response) {
							hideNotice();
							if (checkErrorOnResponse(response)) {
								copyFileToLocal(response, "csv");
								deleteCSVFileFromServer(response.responseText);
							}
						}
					});							 //Deo [02.02.2017]: add ends (SR-5923)
				}else{
					exportToExcel(content);
				}
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
	
	//DATE FIELDS
	$("txtFromDate").observe("focus", function(){
		if ($("hrefFromDate").disabled == true) return;
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) : "";
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
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("From Date should not be later than To Date.", "I", "txtToDate");
			$("txtToDate").clear();
			return false;
		}
	});	
	
	//BUTTONS
	$("hrefFromDate").observe("click", function() {
		scwShow($("txtFromDate"),this, null);
	});

	$("hrefToDate").observe("click", function() {
		scwShow($("txtToDate"),this, null);
	});	

	$("grossTab").observe("click", function () {
		getTable("gross");
	});
	
	$("faculTab").observe("click", function () {
		getTable("facul");
	});
	
	$("treatyTab").observe("click", function () {
		getTable("treaty");
	});
	
	$("netTab").observe("click", function () {
 		getNetTable();
	});
	
	$("outTab").observe("click", function(){
		tab = "O";
		getTable("outstanding");
	});
	
	$("lossTab").observe("click", function(){
		tab = "L";
		getTable("paid");
	});
	
	$("rdoProduction").observe("click", function(){
		$$("li").each(function(l){
			if(nvl(l.getAttribute("name"), "") == "prodGroup"){
				l.setStyle("display: block;");
			}else if(nvl(l.getAttribute("name"), "") == "claimGroup"){
				l.setStyle("display: none;");
			}
		});
		getPrevExtractParams();
		fireEvent($("grossTab"), "click");
	});
	
	$("rdoClaims").observe("click", function(){
		$$("li").each(function(l){
			if(nvl(l.getAttribute("name"), "") == "claimGroup"){
				l.setStyle("display: block;");
			}else if(nvl(l.getAttribute("name"), "") == "prodGroup"){
				l.setStyle("display: none;");
			}
		});
		getPrevExtractParams();
		fireEvent($("outTab"), "click");
	});
	
	$("btnExtract").observe("click", function() {
		if (checkAllRequiredFieldsInDiv("batchCheckingExtractHeaderDiv")) {
			if ($F("txtFromDate") != "" || $F("txtToDate") != "" ) {
				checkDates();
			}
		}
	});
	
	$("btnPrint").observe("click", function() {
		if (checkAllRequiredFieldsInDiv("batchCheckingExtractHeaderDiv")) {
			checkRecords();
		}
	});
	
	
	observeReloadForm("reloadForm", showBatchChecking);

	observeCancelForm("batchCheckingExit", "", function(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	});
	initializeBatchChecking();
</script>