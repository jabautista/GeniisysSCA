<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="viewExposuresPerPAEnrolleesMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
   			<label>View Exposures PA Enrollees</label>
	   	</div>
	</div>
	
	<div class="sectionDiv">
		<div id="paramsDiv" name="paramsDiv" style="width: 898px; margin: 10px 10px 10px 10px;" class="sectionDiv">
			<div style="float:left; width: 470px; margin: 10px 5px 10px 10px;">
				<table border="0" cellpadding="2">
					<tr style="height:20px;"><td colspan="4">Search By:</td></tr>
					<tr style="height:30px;">
						<td style="width:110px;">
							<input type="radio" id="rdoInceptDate" name="rdoSearchByGrp" value="inceptDate" title="Incept Date" tabindex="101" style="float:left; margin: 0 5px 2px 5px;" />
							<label id="lblRdoInceptDate" for="rdoInceptDate" style="float:left;">Incept Date</label>
						</td>
						<td style="width:130px;">
							<input type="radio" id="rdoEffectivityDate" name="rdoSearchByGrp" value="effectivityDate" title="Effectivity Date" tabindex="102" style="float:left; margin: 0 5px 2px 5px;" />
							<label id="lblRdoEffectivityDate" for="rdoEffectivityDate" style="float:left;">Effectivity Date</label>
						</td>
						<td style="width:110px;">
							<input type="radio" id="rdoIssueDate" name="rdoSearchByGrp" value="issueDate" title="Issue Date" tabindex="103" style="float:left; margin: 0 5px 2px 5px;" />
							<label id="lblRdoIssueDate" for="rdoIssueDate" style="float:left;">Issue Date</label>
						</td>
						<td style="width:110px;">
							<input type="radio" id="rdoExpiryDate" name="rdoSearchByGrp" value="expiryDate" title="Expiry Date" tabindex="104" style="float:left; margin: 0 5px 2px 5px;" />
							<label id="lblRdoExpiryDate" for="rdoExpiryDate" style="float:left;">Expiry Date</label>
						</td>
					</tr>
				</table>
			</div>
			
			<div id="dateFieldsDiv" name="dateFieldsDiv" style="float:left; width: 390px; margin: 10px 0 10px 20px;">
				<table border="0">
					<tr>
						<td>
							<input type="radio" id="rdoAsOf" name="rdoDateGrp" value="asOf" title="As Of" tabindex="105" style="float:left; margin: 3px 5px 2px 5px;" />
							<label id="lblRdoAsOf" for="rdoAsOf" style="float:left; margin-top:3px;">As Of</label>
						</td>
						<td>
							<div id="asOfDateDiv" style="float: left; width: 140px;" class="withIconDiv">
								<input type="text" id="txtAsOfDate" name="txtAsOfDate" class="withIcon" readonly="readonly" style="width: 115px;" tabindex="106" /> 
								<img id="hrefAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As Of Date" />
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<input type="radio" id="rdoFromTo" name="rdoDateGrp" value="fromTo" title="From" tabindex="107" style="float:left; margin: 0 5px 2px 5px;" />
							<label id="lblRdoFromTo" for="rdoFromTo" style="float:left;">From</label>
						</td>
						<td>
							<div id="fromDateDiv" style="float: left; width: 140px;" class="withIconDiv">
								<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon" readonly="readonly" style="width: 115px;" tabindex="108" /> 
								<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" />
							</div>
						</td>
						<td><label style="margin: 5px 5px 2px 2px;">To</label>
							<div id="toDateDiv" style="float: left; width: 140px;" class="withIconDiv">
								<input type="text" id="txtToDate" name="txtToDate" class="withIcon" readonly="readonly" style="width: 115px; float:left;" tabindex="109" /> 
								<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" />
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
	
	<div id="tgMainDiv" class="sectionDiv" style="margin-top:2px;">
		<div id="exposureTGDiv" name="exposureTGDiv" style="margin: 10px 10px 0 10px; width: 898px; height:330px;"></div>
		
		<div id="exposureFieldsDiv" name="exposureFieldsDiv" class="sectionDiv" style="width:898px; margin: 10px 10px 30px 10px;">
			<table style="margin: 10px 10px 10px 10px;">
				<tr>
					<td class="rightAligned" style="width:150px;">Assured</td>
					<td colspan="3"><input type="text" id="txtAssdName" name="txtAssdName" style="margin-left:5px; width:645px;" tabindex="201" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width:150px;">Inception Date</td>
					<td><input type="text" id="txtInceptionDate" name="txtInceptionDate" style="margin-left: 5px; width:200px;"  tabindex="202" readonly="readonly" /></td>
					<td class="rightAligned" style="width:225px;">Expiry Date</td>
					<td><input type="text" id="txtExpiryDate" name="txtExpiryDate" style="margin-left: 5px; width:200px;"  tabindex="203" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Effectivity Date</td>
					<td><input type="text" id="txtEffectivityDate" name="txtEffectivityDate" style="margin-left: 5px; width:200px;"  tabindex="204" readonly="readonly" /></td>
					<td class="rightAligned">Issue Date</td>
					<td><input type="text" id="txtIssueDate" name="txtIssueDate" style="margin-left: 5px; width:200px;"  tabindex="205" readonly="readonly" /></td>
				</tr>
			</table>
		</div>
	</div>
			
</div>

<script type="text/javascript">
	var objExposureInfo  = new Object();
	var isQueryExecuted = false;
	
	objExposureInfo.exposureTableGrid = JSON.parse('${exposureList}');
	objExposureInfo.exposureRows = objExposureInfo.exposureTableGrid.rows || [];
	objExposureInfo.exposureRow = null;
	
	try {
		var searchBy = ( $("rdoInceptDate").checked ? "inceptDate" : ( $("rdoEffectivityDate").checked ?  "effectivityDate" : ( $("rdoIssueDate").checked ? "issueDate" : "expiryDate") ) );
		var searchDate = ( $("rdoAsOf").checked ? "asOf" : "fromTo");
		exposureTableModel = {
				url: contextPath + "/GIPIPolbasicController?action=showViewExposuresPerPAEnrollees&refresh=1"
								 + "&searchBy=" 	+ searchBy
								 + "&searchDate=" 	+ searchDate
								 + "&asOfDate=" 	+ $F("txtAsOfDate")
								 + "&fromDate=" 	+ $F("txtFromDate")
								 + "&toDate=" 		+ $F("txtToDate"),
						id: 1,
						options: {
							id: 1,
							height: '310px',
							width: '900px',
							hideColumnChildTitle: true,
							onCellFocus: function(element, value, x, y, id){
								objExposureInfo.selectedRow = exposureTableGrid.geniisysRows[y];
								populateFields(objExposureInfo.selectedRow);
								exposureTableGrid.keys.removeFocus(exposureTableGrid.keys._nCurrentFocus, true);
								exposureTableGrid.keys.releaseKeys();
							},
							onRemoveRowFocus: function(){
								objExposureInfo.selectedRow = null;
								populateFields(null);
								exposureTableGrid.keys.removeFocus(exposureTableGrid.keys._nCurrentFocus, true);
								exposureTableGrid.keys.releaseKeys();
							},
							onSort: function(){
								exposureTableGrid.onRemoveRowFocus();
							},
							toolbar: {
								elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
								onRefresh: function(){
									exposureTableGrid.onRemoveRowFocus();
								},
								onFilter: function(){
									exposureTableGrid.onRemoveRowFocus();
								}
							},
						},
						columnModel: [{   
										id: 'recordStatus',
									    width: '0px',
									    visible: false,
									    editor: 'checkbox',
									    sortable: false
									},
									{	
										id: 'divCtrId',
										width: '0px',
										visible: false,
									    sortable: false
									},
									{	
										id: 'policyNo',
										width: '0px',
										title: 'Policy Number',
										visible: false,
										filterOption: true,
									    sortable: false
									},
									{	
										id: 'endtNo',
										width: '0px',
										title: 'Endorsement Number',
										visible: false,
										filterOption: true,
									    sortable: false
									},
									{	
										id: 'currencyRtChk',
										width: '30px',
										title: '&nbsp;&nbsp;D',
										titleAlign: 'center',
										align: 'center',
										sortable: true,
									    editable: false,
										defaultValue: false,
										otherValue: false,
									    editor: new MyTableGrid.CellCheckbox({
								            getValueOf: function(value){
							            		if (value){
													return "Y";
							            		} else {
													return "N";	
							            		}	
							            	}
									    })
									},
									{
										id: 'lineCd sublineCd issCd issueYy polSeqNo renewNo',
										title: 'Policy Number',
										width: 210,
										//filterOption: true,
										sortable: true,
										children: [
													{
														id: 'lineCd',
														title: 'Line Cd',
														width: 30					
													},
													{
														id: 'sublineCd',
														title: 'Subline Cd',
														width: 50					
													},
													{
														id: 'issCd',
														title: 'Issue Cd',
														width: 30					
													},
													{
														id: 'issueYy',
														title: 'Issue Yy',
														width: 30,
														align: 'right',
														renderer: function(value){
															return formatNumberDigits(value, 2);
														}
													},
													{
														id: 'polSeqNo',
														title: 'Pol Seq No',
														width: 60,
														align: 'right',
														renderer: function(value){
															return formatNumberDigits(value, 7);
														}				
													},
													{
														id: 'renewNo',
														title: 'Renew No',
														width: 30,
														align: 'right',
														renderer: function(value){
															return formatNumberDigits(value, 2);
														}				
													}
										]
									},
									{
										id: 'endtIssCd endtYy endtSeqNo',
										title: 'Endorsement Number',
										width: 120,
										//filterOption: true,
										sortable: true,
										children: [
													{
														id: 'endtIssCd',
														title: 'endIssCd',
														width: 30					
													},
													{
														id: 'endtYy',
														title: 'endtYy',
														width: 30,
														align: 'right',
														renderer: function(value){
															return formatNumberDigits(value, 2);
														}				
													},
													{
														id: 'endtSeqNo',
														title: 'endtSeqNo',
														width: 70,
														align: 'right',
														renderer: function(value){
															return formatNumberDigits(value, 7);
														}					
													}
										]
									},
									{	
										id: 'item',
										width: '200px',
										title: 'Item/Group Name',
										filterOption: true
									},
									{
										id: 'tsiAmtOrig',
										title: 'Sum Insured',
										titleAlign: 'right',
										align: 'right',
										width: '135px',
										visible: true,
										filterOption: true,
										filterOptionType: 'number',
										renderer: function(value){
											return formatCurrency(nvl(value, "0"));
										}
									},
									{
										id: 'premAmtOrig',
										title: 'Premium',
										titleAlign: 'right',
										align: 'right',
										width: '135px',
										visible: true,
										filterOption: true,
										filterOptionType: 'number',
										renderer: function(value){
											return formatCurrency(nvl(value, "0"));
										}
									}
						],
						rows: objExposureInfo.exposureRows
		};
		exposureTableGrid = new MyTableGrid(exposureTableModel);
		exposureTableGrid.pager = objExposureInfo.exposureTableGrid;
		exposureTableGrid.render('exposureTGDiv');
	} catch(e){
		showErrorMessage("View Exposure Per PA Enrollees Table Grid: ",e);
	}
	
	function initializeDefaultValues(){
		enableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarPrint");
		
		$("rdoInceptDate").checked = true;	
		$("rdoAsOf").checked = true;
		$("txtAsOfDate").value = dateFormat(new Date(), 'mm-dd-yyyy');
		disableDate("hrefFromDate");
		disableDate("hrefToDate");
		$("mtgHB1").hide();
	}
	
	function populateFields(row){
		$("txtAssdName").value 			= row != null ? unescapeHTML2(nvl(row.assdName, "")) : "";
		$("txtInceptionDate").value 	= row != null ? unescapeHTML2(nvl(row.inceptDate, "")) : "";
		$("txtExpiryDate").value 		= row != null ? unescapeHTML2(nvl(row.expiryDate, "")) : "";
		$("txtEffectivityDate").value 	= row != null ? unescapeHTML2(nvl(row.effDate, "")) : "";
		$("txtIssueDate").value 		= row != null ? unescapeHTML2(nvl(row.issueDate, "")) : "";
	}
	
	function validateDates(fieldName) {
		var elemDateFr = Date.parse($F("txtFromDate"), "mm-dd-yyyy");
		var elemDateTo = Date.parse($F("txtToDate"), "mm-dd-yyyy");
		var proceed = true;
		if ($F("txtToDate") != "" && $F("txtFromDate") != "") {
			var output = compareDatesIgnoreTime(elemDateFr, elemDateTo);
			if (output < 0) {
				$(fieldName).value = "";
				proceed = false;
				customShowMessageBox( "From Date should not be later than To Date.", "I", fieldName);
			}
		}
		return proceed;
	}
	
	function validateDateFrom() {
		validateDates('txtFromDate');
	}
	function validateDateTo() {
		validateDates('txtToDate');
	}
	function executeQuery(reset){
		var searchBy = ( $("rdoInceptDate").checked ? "inceptDate" : ( $("rdoEffectivityDate").checked ?  "effectivityDate" : ( $("rdoIssueDate").checked ? "issueDate" : "expiryDate") ) );
		var searchDate = ( $("rdoAsOf").checked ? "asOf" : "fromTo");
		exposureTableGrid.url = contextPath  + "/GIPIPolbasicController?action=showViewExposuresPerPAEnrollees&refresh=1"
											 + "&searchBy=" 	+ (reset ? "" : searchBy)
											 + "&searchDate=" 	+ searchDate
											 + "&asOfDate=" 	+ $F("txtAsOfDate")
											 + "&fromDate=" 	+ $F("txtFromDate")
											 + "&toDate=" 		+ $F("txtToDate");
		exposureTableGrid._refreshList();
	}
	function disableAllItems(disable){
		disable ? disableDate("hrefAsOfDate") : enableDate("hrefAsOfDate");
		disable ? disableDate("hrefFromDate") : enableDate("hrefFromDate");
		disable ? disableDate("hrefToDate") : enableDate("hrefToDate");
		
		$("rdoInceptDate").disabled = disable;
		$("rdoEffectivityDate").disabled = disable;
		$("rdoIssueDate").disabled = disable;
		$("rdoExpiryDate").disabled = disable;
		
		$("rdoAsOf").disabled = disable;
		$("rdoFromTo").disabled = disable;		
	}
	
	function clickRdoAsOf(){
		$("txtFromDate").removeClassName("required");
		$("fromDateDiv").removeClassName("required");
		$("fromDateDiv").removeAttribute("style");
		$("fromDateDiv").setAttribute("style", "float: left; width: 140px;");
		$("txtToDate").removeClassName("required");
		$("toDateDiv").removeClassName("required");
		$("toDateDiv").removeAttribute("style");
		$("toDateDiv").setAttribute("style", "float: left; width: 140px;");
		
		disableDate("hrefFromDate");
		disableDate("hrefToDate");
		
		$("txtFromDate").value = "";
		$("txtToDate").value = "";
		
		$("txtAsOfDate").value = dateFormat(new Date(), 'mm-dd-yyyy');
		enableDate("hrefAsOfDate");
		$("rdoAsOf").checked = true;
	}

	function checkReport(){
		validateReportId("GIPIR209", "Exposures for PA Enrollees");
	}
	
	function validateReportId(reportId, reportTitle){
		try {
			new Ajax.Request(contextPath+"/GICLGeneratePLAFLAController",{
				parameters: {
					action:		"validateReportId",
					reportId:	reportId
				},
				ashynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if (response.responseText == "Y"){
							printReport(reportId, reportTitle);
						}else{
							showMessageBox("No existing records found in GIIS_REPORTS.", "E");
						}
					}
				}
			});
		} catch(e){
			showErrorMessage("validateReportId",e);
		}
	}
	
	function printReport(reportId, reportTitle){
		try {
			if(checkAllRequiredFieldsInDiv("dateFieldsDiv")){
				var fileType = "";
				if($("rdoPdf").disabled == false /* && $("rdoExcel").disabled == false */){
					//fileType = $("rdoPdf").checked ? "PDF" : "XLS";
					fileType = "PDF"; //please revise when csv is available -andrew
				}
				var searchBy = ( $("rdoInceptDate").checked ? "inceptDate" : ( $("rdoEffectivityDate").checked ?  "effectivityDate" : ( $("rdoIssueDate").checked ? "issueDate" : "expiryDate") ) );
				var defaultAsOfDate = ( ($F("txtAsOfDate") == "" && $F("txtFromDate") == "" && $F("txtToDate") == "") ? dateFormat(new Date(), 'mm-dd-yyyy') : "");
				var content = contextPath+"/PolicyInquiryPrintController?action=printGIPIR209"
							+ "&noOfCopies=" + $F("txtNoOfCopies")
							+ "&printerName=" + $F("selPrinter")
							+ "&destination=" + $F("selDestination")
							+ "&reportId=" + reportId
							+ "&reportTitle=" + reportTitle
							+ "&fileType=" + fileType
							+ "&moduleId=" + "GIPIS209"
							+ "&searchBy=" + searchBy
							+ "&defaultAsOfDate=" + defaultAsOfDate
							+ "&asOfDate=" + $F("txtAsOfDate")
							+ "&fromDate=" + $F("txtFromDate")
							+ "&toDate=" + $F("txtToDate");

				printGenericReport(content, reportTitle);
				overlayGenericPrintDialog.close();
			}
		} catch(e){
			showErrorMessage("printReport", e);
		}
	}
	
	$("hrefAsOfDate").observe("click", function() {
		scwShow($('txtAsOfDate'), this, null);
	});
	
	$("hrefFromDate").observe("click", function() {
		scwShow($('txtFromDate'), this, null);
	});

	$("hrefToDate").observe("click", function() {
		scwShow($('txtToDate'), this, null);
	});
	
	$("rdoFromTo").observe("click", function(){
		$("txtAsOfDate").clear();
		disableDate("hrefAsOfDate");
		
		$("txtFromDate").addClassName("required");
		$("txtToDate").addClassName("required");
		$("fromDateDiv").addClassName("required");
		$("toDateDiv").addClassName("required");
		enableDate("hrefFromDate");
		enableDate("hrefToDate");
	});
	
	$("rdoAsOf").observe("click", clickRdoAsOf);
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("dateFieldsDiv")){
			isQueryExecuted = true;		
			
			disableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
			enableToolbarButton("btnToolbarPrint");
			disableAllItems(true);
			executeQuery(false);
		}
	});
	$("btnToolbarEnterQuery").observe("click", function(){
		isQueryExecuted = false;
		
		disableToolbarButton("btnToolbarEnterQuery");
		enableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarPrint");
		populateFields(null);
		disableAllItems(false);
		clickRdoAsOf();
		$("rdoInceptDate").checked = true;
		executeQuery(true);
	});
	$("btnToolbarPrint").observe("click", function(){
		showGenericPrintDialog("Print Exposures for PA Enrollees", checkReport, "", true);
	});
	$("btnToolbarExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", "");	
	});
	
	setDocumentTitle("View Exposures per PA Enrollees");
	setModuleId("GIPIS209");
	initializeAll();
	initializeDefaultValues();
	observeChangeTagOnDate("hrefFromDate", "txtFromDate", validateDateFrom);
	observeChangeTagOnDate("hrefToDate", "txtToDate", validateDateTo);
</script>