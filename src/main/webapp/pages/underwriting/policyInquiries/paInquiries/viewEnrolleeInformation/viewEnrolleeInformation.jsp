<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="gipis122MainDiv" name="gipis122MainDiv" style="height: 790px;">
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
		<div style="float: right;" class="toolbarsep" id="btnToolbarPrintSep">&#160;</div>
		<div class="toolButton" style="float: right;">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/print.png) left center no-repeat;" id="btnToolbarPrint">Print</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/printDisabled.png) left center no-repeat;" id="btnToolbarPrintDisabled">Print</span>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Enrollee Basic Information</label>
	   	</div>
	</div>
	<div id="gipis122" name="gipis122">
		<div align="center" id="policyNoFormDiv" class="sectionDiv">
			<table style="margin-top: 5px; margin-bottom: 10px;">
				<tr>
					<td class="rightAligned">Policy No.</td>
					<td class="leftAligned">
						<input class="polNoReq allCaps required" type="text" id="txtLineCd" name="txtLineCd" style="width: 40px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="1" />
						<input class="allCaps required" type="text" id="txtSublineCd" name="txtSublineCd" style="width: 80px; float: left; margin: 2px 4px 0 0" maxlength="7" tabindex="2" />
						<input class="allCaps required" type="text" id="txtIssCd" name="txtIssCd" style="width: 40px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="3" />
						<input class="rightAligned integerNoNegativeUnformattedNoComma required" type="text" id="txtIssueYy" name="txtIssueYy" style="width: 40px; float: left; margin: 2px 4px 0 0" maxlength="3" tabindex="4" />
						<input class="rightAligned integerNoNegativeUnformattedNoComma required" type="text" id="txtPolSeqNo" name="txtPolSeqNo" style="width: 75px; float: left; margin: 2px 4px 0 0" maxlength="8" tabindex="5" />
						<input class="rightAligned integerNoNegativeUnformattedNoComma required" type="text" id="txtRenewNo" name="txtRenewNo" style="width: 30px; float: left;" maxlength="3" tabindex="6" />
						<span class="lovSpan" style="border: none; height: 21px; margin: 2px 4px 0 0; margin-left: 5px;">
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPolicyNo" name="searchPolicyNo" alt="Go" tabindex="7" style="margin: 2px 0 4px 0; float: left;" />
						</span>
					</td>
					<td class="rightAligned" style="padding-left: 38px;">Ref. Pol. No.</td>
					<td class="leftAligned">
						<input id="txtRefPolNo" type="text" style="width: 180px;" tabindex="8" maxlength="30" readonly="readonly">
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Assured</td>
					<td class="leftAligned" colspan="3">
						<input id="txtAssdName" type="text" style="width: 700px;" tabindex="9" maxlength="500" readonly="readonly">
					</td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv">
			<div id="groupedItemInfoTableDiv" style="padding-top: 10px; padding-left: 10px;">
				<div id="groupedItemInfoTable" style="height: 280px;"></div>
			</div>
		</div>	
		<div class="sectionDiv">
			<div id="groupedItemInfoDtlTableDiv" style="padding-top: 10px; padding-left: 10px;">
				<div id="groupedItemInfoDtlTable" style="height: 280px;"></div>
			</div>
			<div style="padding-bottom: 10px;" align="center">
				<input type="button" class="button" id="btnCoverages" value="Coverages" style="width: 130px;" tabindex="10">
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	setModuleId("GIPIS212");
	setDocumentTitle("Enrollee Basic Information");
	initializeAll();
	checkUserAccess();
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");
	disableToolbarButton("btnToolbarPrint");
	disableButton("btnCoverages");
	$("txtLineCd").focus();
	
	var policyId;
	
	function checkUserAccess(){
		try{
			new Ajax.Request(contextPath+"/GIACAccTransController?action=checkUserAccess2", {
				method: "POST",
				parameters: {
					moduleName: "GIPIS212"
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(response.responseText == 0){
						showWaitingMessageBox('You are not allowed to access this module.', imgMessage.ERROR, 
								function(){
							goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", "");
						});  
						
					}
				}
			});
		}catch(e){
			showErrorMessage('checkUserAccess', e);
		}
	}
	
	var jsonGroupedItemInfo = JSON.parse('${jsonGroupedItemInfo}');
	objCurrGroupedItem = {};
	
	groupedItemInfoTableModel = {
			id : 1,
			url : contextPath + "/GIPIGroupedItemsController?action=showGipis212&refresh=1&lineCd=" + $F("txtLineCd") 
					+ "&sublineCd=" + $F("txtSublineCd")
					+ "&issCd=" + $F("txtIssCd")
					+ "&issueYy=" + $F("txtIssueYy")
					+ "&polSeqNo=" + $F("txtPolSeqNo")
					+ "&renewNo=" + $F("txtRenewNo"),
			options : {
				hideColumnChildTitle: true,
				width : '900px',
				height : '270px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					tbgGroupedItemInfo.keys.removeFocus(tbgGroupedItemInfo.keys._nCurrentFocus, true);
					tbgGroupedItemInfo.keys.releaseKeys();
					objCurrGroupedItem = tbgGroupedItemInfo.geniisysRows[y];
					objCurrGroupedItem.selectedIndex = y;
					showGroupedItemDtl(true);
					
					objCurrGroupedItemDtl = null;
					tbgGroupedItemDtlInfo.keys.removeFocus(tbgGroupedItemDtlInfo.keys._nCurrentFocus, true);
					tbgGroupedItemDtlInfo.keys.releaseKeys();
					readyCoverageDtl(false);
					
					enableToolbarButton("btnToolbarPrint");
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					objCurrGroupedItem = null;
					tbgGroupedItemInfo.keys.removeFocus(tbgGroupedItemInfo.keys._nCurrentFocus, true);
					tbgGroupedItemInfo.keys.releaseKeys();
					showGroupedItemDtl(false);
					
					objCurrGroupedItemDtl = null;
					tbgGroupedItemDtlInfo.keys.removeFocus(tbgGroupedItemDtlInfo.keys._nCurrentFocus, true);
					tbgGroupedItemDtlInfo.keys.releaseKeys();
					readyCoverageDtl(false);
					
					disableToolbarButton("btnToolbarPrint");
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						objCurrGroupedItem = null;
						tbgGroupedItemInfo.keys.removeFocus(tbgGroupedItemInfo.keys._nCurrentFocus, true);
						tbgGroupedItemInfo.keys.releaseKeys();
						showGroupedItemDtl(false);
						
						objCurrGroupedItemDtl = null;
						tbgGroupedItemDtlInfo.keys.removeFocus(tbgGroupedItemDtlInfo.keys._nCurrentFocus, true);
						tbgGroupedItemDtlInfo.keys.releaseKeys();
						readyCoverageDtl(false);
					}
				},
				beforeSort : function(){
					objCurrGroupedItem = null;
					tbgGroupedItemInfo.keys.removeFocus(tbgGroupedItemInfo.keys._nCurrentFocus, true);
					tbgGroupedItemInfo.keys.releaseKeys();
					showGroupedItemDtl(false);
					
					objCurrGroupedItemDtl = null;
					tbgGroupedItemDtlInfo.keys.removeFocus(tbgGroupedItemDtlInfo.keys._nCurrentFocus, true);
					tbgGroupedItemDtlInfo.keys.releaseKeys();
					readyCoverageDtl(false);
				},
				onSort: function(){
					objCurrGroupedItem = null;
					tbgGroupedItemInfo.keys.removeFocus(tbgGroupedItemInfo.keys._nCurrentFocus, true);
					tbgGroupedItemInfo.keys.releaseKeys();
					showGroupedItemDtl(false);
					
					objCurrGroupedItemDtl = null;
					tbgGroupedItemDtlInfo.keys.removeFocus(tbgGroupedItemDtlInfo.keys._nCurrentFocus, true);
					tbgGroupedItemDtlInfo.keys.releaseKeys();
					readyCoverageDtl(false);
				},
				onRefresh: function(){
					objCurrGroupedItem = null;
					tbgGroupedItemInfo.keys.removeFocus(tbgGroupedItemInfo.keys._nCurrentFocus, true);
					tbgGroupedItemInfo.keys.releaseKeys();
					showGroupedItemDtl(false);
					
					objCurrGroupedItemDtl = null;
					tbgGroupedItemDtlInfo.keys.removeFocus(tbgGroupedItemDtlInfo.keys._nCurrentFocus, true);
					tbgGroupedItemDtlInfo.keys.releaseKeys();
					readyCoverageDtl(false);
				}
			},
			columnModel : [
				{
					id : 'recordStatus',
					title : '',
					width : '0',
					visible : false
				}, 
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},
				//added by robert SR 5157 12.22.15
				{
					id : 'itemNo',
					width : '0',
					visible : false
				},
				{
					id : 'groupedItemNo',
					width : '0',
					visible : false
				},
				//end of codes by robert SR 5157 12.22.15
				{	id:'deleteSw',
					sortable:	false,
					align:		'center',
					title:		'&#160;&#160;D', //A', changed to D by robert SR 5157 12.22.15
					altTitle: 'Delete Switch',
					width:		'25px',
					editable:  false,
					hideSelectAllBox: true,
					editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}	
		            	}
		            })
				},
				{
					id : 'groupedItemTitle',
					filterOption : true,
					title : 'Enrollee Name',
					width : '500px'
				},
				/* { removed by robert SR 5157 12.22.15
						id : 'controlTypeCd',
						filterOption : true,
						title : 'Control Type Code',
						width : '110px',
						filterOptionType: 'integerNoNegative'
				}, */
				{ // added by robert SR 5157 12.22.15
					id: 'controlTypeCd controlTypeDesc',
					title: 'Control Type',
					children: [
						   {
								id: 'controlTypeCd',
								title: 'Control Type Code',
								width: 50,
								filterOption: true,
								align: 'right',
								filterOptionType: 'integerNoNegative'
							},
							{
								id: 'controlTypeDesc',
								title: 'Control Type Desc',
								width: 150,
								filterOption: true
							}
					]
				}, // end of codes by robert SR 5157 12.22.15
				{
					id : 'controlCd',
					filterOption : true,
					title : 'Control Code',
					width : '138px' //changed width by robert SR 5157 12.22.15
				}
			], rows : jsonGroupedItemInfo.rows
	};
	tbgGroupedItemInfo = new MyTableGrid(groupedItemInfoTableModel);
	tbgGroupedItemInfo.pager = jsonGroupedItemInfo;
	tbgGroupedItemInfo.render('groupedItemInfoTable');
	
	function showGroupedItemDtl(show){	
		try{	
			if(show){
				var policyId = objCurrGroupedItem.policyId;
				//var groupedItemTitle = objCurrGroupedItem.groupedItemTitle; //removed by robert SR 5157 12.22.15
				var itemNo = objCurrGroupedItem.itemNo; //added by robert SR 5157 12.22.15
				var groupedItemNo = objCurrGroupedItem.groupedItemNo; //added by robert SR 5157 12.22.15
				tbgGroupedItemDtlInfo.url = contextPath+"/GIPIGroupedItemsController?action=showGipis212GroupedItemDtl&policyId=" + policyId + "&itemNo=" + itemNo + "&groupedItemNo=" + groupedItemNo; //added params by robert SR 5157 12.22.15
				tbgGroupedItemDtlInfo._refreshList();	
			} else {
				if($("groupedItemInfoTableDiv") != null){
					clearTableGridDetails(tbgGroupedItemDtlInfo);
				}
			}
		}catch(e){
			showErrorMessage("showGroupedItemDtl",e);
		}
	}
	
	jsonGroupedItemDtlInfo = new Object();
	objCurrGroupedItemDtl = {};
	var groupedItemInfoDtlTableModel = {
			id: 2,
			options : {
				hideColumnChildTitle: true,
				width : '900px',
				height : '270px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					tbgGroupedItemDtlInfo.keys.removeFocus(tbgGroupedItemDtlInfo.keys._nCurrentFocus, true);
					tbgGroupedItemDtlInfo.keys.releaseKeys();
					objCurrGroupedItemDtl = tbgGroupedItemDtlInfo.geniisysRows[y];
					objCurrGroupedItemDtl.selectedIndex = y;
					readyCoverageDtl(true);
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					objCurrGroupedItemDtl = null;
					tbgGroupedItemDtlInfo.keys.removeFocus(tbgGroupedItemDtlInfo.keys._nCurrentFocus, true);
					tbgGroupedItemDtlInfo.keys.releaseKeys();
					readyCoverageDtl(false);
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						objCurrGroupedItemDtl = null;
						tbgGroupedItemDtlInfo.keys.removeFocus(tbgGroupedItemDtlInfo.keys._nCurrentFocus, true);
						tbgGroupedItemDtlInfo.keys.releaseKeys();
						readyCoverageDtl(false);
					}
				},
				beforeSort : function(){
					objCurrGroupedItemDtl = null;
					tbgGroupedItemDtlInfo.keys.removeFocus(tbgGroupedItemDtlInfo.keys._nCurrentFocus, true);
					tbgGroupedItemDtlInfo.keys.releaseKeys();
					readyCoverageDtl(false);
				},
				onSort: function(){
					objCurrGroupedItemDtl = null;
					tbgGroupedItemDtlInfo.keys.removeFocus(tbgGroupedItemDtlInfo.keys._nCurrentFocus, true);
					tbgGroupedItemDtlInfo.keys.releaseKeys();
					readyCoverageDtl(false);
				},
				onRefresh: function(){
					objCurrGroupedItemDtl = null;
					tbgGroupedItemDtlInfo.keys.removeFocus(tbgGroupedItemDtlInfo.keys._nCurrentFocus, true);
					tbgGroupedItemDtlInfo.keys.releaseKeys();
					readyCoverageDtl(false);
				},				
				prePager: function(){
					objCurrGroupedItemDtl = null;
					tbgGroupedItemDtlInfo.keys.removeFocus(tbgGroupedItemDtlInfo.keys._nCurrentFocus, true);
					tbgGroupedItemDtlInfo.keys.releaseKeys();
					readyCoverageDtl(false);
				}
			},
			columnModel : [
				{
					id : 'recordStatus',
					title : '',
					width : '0',
					visible : false
				}, {
					id : 'divCtrId',
					width : '0',
					visible : false
				},
				{	id:'deleteSw',
					sortable:	false,
					align:		'center',
					title:		'&#160;&#160;D', //A', changed to D by robert SR 5157 12.22.15
					altTitle: 'Delete Switch',
					width:		'25px',
					editable:  false,
					hideSelectAllBox: true,
					editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}	
		            	}
		            })
				},
				{
					id : 'endt',
					filterOption : true,
					title : 'Policy / Endt #',
					width : '120px'
				},
				{
					id : 'effDate',
					title : 'Effectivity Date',
					width : '120px'
				},
				{
					id : 'itemNo',
					filterOption : true,
					title : 'Item No.',
					titleAlign : 'right',
					align : 'right',
					width : '120px',
					filterOptionType: 'integerNoNegative'
				},
				{
					id : 'groupedItemNo',
					filterOption : true,
					title : 'Grp. Item No.',
					titleAlign : 'right',
					align : 'right',
					width : '120px',
					filterOptionType: 'integerNoNegative'
				},
				{
					id : "tsiAmt",
					title : "TSI Amount",
					titleAlign : 'right',
					width : '120px',
					geniisysClass: 'money',
					align : 'right',
				},
				{
					id : "premAmt",
					title : "Prem. Amount",
					titleAlign : 'right',
					width : '120px',
					geniisysClass: 'money',
					align : 'right',
				},
				{
					id : 'packageCd',
					title : 'Plan',
					width : '120px'
				}
			],
			rows: []
	};
	tbgGroupedItemDtlInfo = new MyTableGrid(groupedItemInfoDtlTableModel);
	tbgGroupedItemDtlInfo.pager = jsonGroupedItemDtlInfo;
	tbgGroupedItemDtlInfo.mtgId = 2;
	tbgGroupedItemDtlInfo.render('groupedItemInfoDtlTable');
	
	function readyCoverageDtl(show){	
		try{	
			if(show){
				enableButton("btnCoverages");
			} else {
				disableButton("btnCoverages");
			}
		}catch(e){
			showErrorMessage("readyCoverageDtl",e);
		}
	}
	
	$("searchPolicyNo").observe("click", function(){
		showPolicyNoLov();
	});
	
	function showPolicyNoLov(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
				action : "getGipis212PolicyNoLov",
				moduleId :  "GIPIS212",
				lineCd   : $F("txtLineCd"),
				sublineCd : $F("txtSublineCd"),
				issCd : $F("txtIssCd"),
				issueYy : $F("txtIssueYy"),
				polSeqNo : $F("txtPolSeqNo"),
				renewNo : $F("txtRenewNo"),
				page : 1
			},
			title: "List of Policy Numbers",
			width: 700,
			height: 400,
			columnModel : [
				{
					id : "policyNo",
					title: "Policy No.",
					width: '150px',
				},
				{
					id : "assdName",
					title: "Assured Name",
					width: '380px',
					renderer: function(value) {
						return unescapeHTML2(value);
					}
				},
				{
					id : "refPolNo",
					title: "Ref. Pol. No.",
					width: '150px',
					renderer: function(value) {
						return unescapeHTML2(value);
					}
				}
			],
			autoSelectOneRecord: true,
			onSelect: function(row) {
				$("txtLineCd").value = row.lineCd;
				$("txtSublineCd").value = row.sublineCd;
				$("txtIssCd").value = row.issCd;
				$("txtIssueYy").value = formatNumberDigits(row.issueYy, 2);
				$("txtPolSeqNo").value = formatNumberDigits(row.polSeqNo, 6);
				$("txtRenewNo").value = formatNumberDigits(row.renewNo, 2);
				$("txtRefPolNo").value = unescapeHTML2(row.refPolNo);
				$("txtAssdName").value = unescapeHTML2(row.assdName);
				$("txtLineCd").readOnly = true;
				$("txtSublineCd").readOnly = true;
				$("txtIssCd").readOnly = true;
				$("txtIssueYy").readOnly = true;
				$("txtPolSeqNo").readOnly = true;
				$("txtRenewNo").readOnly = true;
				policyId = row.policyId;
				disableSearch("searchPolicyNo");
				enableToolbarButton("btnToolbarEnterQuery");
				enableToolbarButton("btnToolbarExecuteQuery");
			},
			onCancel: function (){
				
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
			}
		});
	}
	
	function validateNumberFields(id, decimal, form){
		if($F(id) != ""){
			if(isNaN($F(id))){
				$(id).clear();
			}else{
				$(id).value = formatNumberDigits($F(id), decimal);
			}
		}
	}
	$("txtIssueYy").observe("change", function(){validateNumberFields("txtIssueYy", 2, "09");});
	$("txtPolSeqNo").observe("change", function(){validateNumberFields("txtPolSeqNo", 6, "099999");});
	$("txtRenewNo").observe("change", function(){validateNumberFields("txtRenewNo", 2, "09");});
	
	$("btnCoverages").observe("click", function(){
		viewCoverages();
	});
	
	function viewCoverages(){
		try {
			coveragesOverlay = Overlay.show(contextPath+"/GIPIGroupedItemsController", {
				urlContent: true,
				urlParameters: {action    : "showCoveragesOverlay",																
								ajax      : "1",
								policyId  : objCurrGroupedItemDtl.policyId,
								groupedItemNo : objCurrGroupedItemDtl.groupedItemNo,
								itemNo : objCurrGroupedItemDtl.itemNo,
								lineCd : objCurrGroupedItemDtl.lineCd
								
				},
			    title: "Peril",
			    height: 400,
			    width: 700,
			    draggable: true
			});
		} catch (e) {
			showErrorMessage("Distribution by Peril Overlay Error: " , e);
		}
	}
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		tbgGroupedItemInfo.url = contextPath + "/GIPIGroupedItemsController?action=showGipis212&refresh=1&lineCd=" + $F("txtLineCd") 
		+ "&sublineCd=" + $F("txtSublineCd")
		+ "&issCd=" + $F("txtIssCd")
		+ "&issueYy=" + $F("txtIssueYy")
		+ "&polSeqNo=" + $F("txtPolSeqNo")
		+ "&renewNo=" + $F("txtRenewNo")
		+ "&policyId=" + policyId;
		tbgGroupedItemInfo._refreshList();
		disableToolbarButton("btnToolbarExecuteQuery");
		if (tbgGroupedItemInfo.geniisysRows.length < 1) {
			showMessageBox("Query caused no records to be retrieved.", "I");
		}
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		showGipis212();
	});
	
	$("btnToolbarPrint").observe("click", function(){
		showGenericPrintDialog400("Print Enrollee Information", onOkPrintGipis212, onLoadPrintGipis212, true);
	});
	
	var reports = [];
	function onOkPrintGipis212(){
		if(polOrDate == "2"){
			if(fromDate == "" || toDate == ""){
				showMessageBox("Required fields must be entered.", imgMessage.INFO);
				return false;
			}
		}
		
		if(reportOption == "1"){
			reportId = 'GIPIR210';
			reportTitle = 'Enrollee Register';
		} else if(reportOption == "2"){
			reportId = 'GIPIR211';
			reportTitle = 'Enrollee Register (Detailed)';
		} else if(reportOption == "3"){
			reportId = 'GIPIR212';
			reportTitle = 'Enrollee Register (Summary)';
		}
		
		var content;
		content = contextPath+"/PolicyInquiryPrintController?action=printGipis212Reports&reportId=" + reportId 
				+ "&printerName=" + $F("selPrinter")					
		        + "&lineCd=" + $F("txtLineCd")
		        + "&sublineCd=" + $F("txtSublineCd")
		        + "&issCd=" + $F("txtIssCd")
		        + "&issueYy=" + $F("txtIssueYy")
		        + "&polSeqNo=" + $F("txtPolSeqNo")
		        + "&renewNo=" + $F("txtRenewNo")
		        + "&fromDate=" + $F("txtFromDate")
		        + "&toDate=" + $F("txtToDate")
		        + "&dateOption=" + dateOption
		        + "&polOrDate=" + polOrDate;
		
		if($F("selDestination") == "screen"){
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
						showMessageBox("Printing Complete.", "I");
					}
				}
			});
		}else if($F("selDestination") == "file"){
			//added by clperello | 06.10.2014
			 var fileType = "PDF";
		
			if($("rdoPdf").checked)
				fileType = "PDF";
			/* else if ($("rdoExcel").checked)
				fileType = "XLS"; */  // commented out jhing 04.07.2016 GENQA 5306 causes problem in printing CSV
			else if ($("rdoCsv").checked)
				fileType = "CSV"; 
			//end here clperello | 06.10.2014
			
			new Ajax.Request(content, {
				method: "POST",
				parameters : {destination : "file",
							  fileType    : fileType}, //$("rdoPdf").checked ? "PDF" : "XLS"}, commented out by clperello 
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Generating report, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						if (fileType == "CSV"){ //added by clperello | 06.10.2014
							copyFileToLocal(response, "csv");
							deleteCSVFileFromServer(response.responseText);
						} else 
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
		if ("screen" == $F("selDestination")) {
			showMultiPdfReport(reports);
			reports = [];
		}
	}
	
	function onLoadPrintGipis212(){
		polOrDate = "1";
		dateOption = "1";
		reportOption = "1";
		fromDate = "";
		toDate = "";
		
		var content = 
			"<div class='sectionDiv' style='height: 212px; border: none;'>" +
				"<div align='center' id='byParamsFormDiv'>" +
					"<table style='margin-top: 5px;'>" +
						"<tr>" +
							"<td>" +
								"<input type='radio' id='rdoByPolicy' name='byPolOrDateOption' value='1' style='margin-left: 5px; float: left;' checked='checked'/>" +
								"<label for='rdoByPolicy' style='margin-top: 3px;'>By Policy</label>" +
							"</td>" +
							"<td class='leftAligned' style='padding-left: 10px;' colspan='2'>" +
								"<input class='polNoReq allCaps' readonly='readonly' type='text' id='txtPrintLineCd' name='txtPrintLineCd' value='" + $F("txtLineCd") + "' style='width: 30px; float: left; margin: 2px 4px 0 0' maxlength='2' />" +
								"<input class='allCaps' type='text' readonly='readonly' id='txtPrintSublineCd' name='txtPrintSublineCd' value='" + $F("txtSublineCd") + "' style='width: 45px; float: left; margin: 2px 4px 0 0' maxlength='7' />" +
								"<input class='allCaps' type='text' readonly='readonly' id='txtPrintIssCd'name='txtPrintIssCd' value='" + $F("txtIssCd") + "' style='width: 30px; float: left; margin: 2px 4px 0 0' maxlength='2' />" +
								"<input class='rightAligned integerNoNegativeUnformattedNoComma' type='text' readonly='readonly' id='txtPrintIssueYy' name='txtPrintIssueYy' value='" + $F("txtIssueYy") + "' style='width: 30px; float: left; margin: 2px 4px 0 0' maxlength='3' />" +
								"<input class='rightAligned integerNoNegativeUnformattedNoComma' type='text' readonly='readonly' id='txtPrintPolSeqNo' name='txtPrintPolSeqNo' value='" + $F("txtPolSeqNo") + "' style='width: 50px; float: left; margin: 2px 4px 0 0' maxlength='8' />" +
								"<input class='rightAligned integerNoNegativeUnformattedNoComma' type='text' readonly='readonly' id='txtPrintRenewNo' name='txtPrintRenewNo' value='" + $F("txtRenewNo") + "' style='width: 30px; float: left;' maxlength='3' />" +
							"</td>" +
						"</tr>" +
						"<tr>" +
							"<td>" +
								"<input type='radio' id='rdoByDate' name='byPolOrDateOption' value='2' style='margin-left: 5px; float: left;' />" +
								"<label for='rdoByDate' style='margin-top: 3px;'>By Date</label>" +
							"</td>" +
							"<td>" +
							    "<label style='margin-left: 5px; margin-top: 8px;'>From</label>" +
								"<div id='txtFromDateDiv' class='' style='float: left; border: solid 1px gray; width: 107px; height: 20px; margin-left: 10px; margin-top: 5px;'>" +
									"<input type='text' id='txtFromDate' class='' style='float: left; margin-top: 0px; margin-right: 3px; width: 80px; height: 14px; border: none;' name='txtFromDate' readonly='readonly' />" +
									"<img id='imgFromDate' alt='imgFromDate' style='margin-top: 1px; margin-left: 1px;' class='hover' src='${pageContext.request.contextPath}/images/misc/but_calendar.gif'/>" +
								"</div>" +
							"</td>" +
							"<td>" +
							    "<label style='margin-left: 5px; margin-top: 8px;'> To </label>" +
								"<div id='txtToDateDiv' class='' style='float: left; border: solid 1px gray; width: 107px; height: 20px; margin-left: 10px; margin-top: 5px;'>" +
									"<input type='text' id='txtToDate' class='' style='float: left; margin-top: 0px; margin-right: 3px; width: 80px; height: 14px; border: none;' name='txtToDate' readonly='readonly' />" +
									"<img id='imgToDate' alt='imgToDate' style='margin-top: 1px; margin-left: 1px;' class='hover' src='${pageContext.request.contextPath}/images/misc/but_calendar.gif'/>" +
								"</div>" +
							"</td>" +
						"</tr>" +
					"</table>" +
				"</div>" +
				"<div class='sectionDiv' style='height: 60px; width: 361px; margin-left: 5px; margin-top: 5px;'>" +
					"<div align='center' id='byDateParamsDiv'>" +
						"<table style='margin-top: 5px;'>" +	
							"<tr>" +
								"<td>" +
									"<input type='radio' id='rdoEffDate' name='byDateOption' value='1' style='margin-left: 5px; float: left;' checked='checked'/>" +
									"<label for='rdoEffDate' style='margin-top: 3px;'>Effectivity Date</label>" +
								"</td>" +
								"<td style='padding-left: 20px;'>" +
									"<input type='radio' id='rdoIssDate' name='byDateOption' value='3' style='margin-left: 5px; float: left;' />" +
									"<label for='rdoIssDate' style='margin-top: 3px;'>Issue Date</label>" +
								"</td>" +
							"</tr>" +
							"<tr>" +
								"<td>" +
									"<input type='radio' id='rdoAccEntDate' name='byDateOption' value='2' style='margin-left: 5px; float: left;'/>" +
									"<label for='rdoAccEntDate' style='margin-top: 3px;'>Accounting Entry Date</label>" +
								"</td>" +
								"<td style='padding-left: 20px;'>" +
									"<input type='radio' id='rdoBookingDate' name='byDateOption' value='4' style='margin-left: 5px; float: left;' />" +
									"<label for='rdoBookingDate' style='margin-top: 3px;'>Booking Date</label>" +
								"</td>" +
							"</tr>" +
						"</table>" +							
					"</div>" +
				"</div>" +
				"<div class='sectionDiv' style='height: 70px; width: 361px; margin-left: 5px; margin-top: 5px;'>" +
					"<div align='center' id='byReportParamsDiv'>" +
						"<table style='margin-top: 5px;'>" +
							"<tr>" +
								"<td>" +
									"<input type='radio' id='rdoEnrolleeRegister' name='byReportOption' value='1' style='margin-left: 5px; float: left;' checked='checked'/>" +
									"<label for='rdoEnrolleeRegister' style='margin-top: 3px;'>Enrollee Register</label>" +
								"</td>" +
							"</tr>" +
							"<tr>" +
								"<td>" +
									"<input type='radio' id='rdoEnrolleeRegisterWC' name='byReportOption' value='2' style='margin-left: 5px; float: left;'/>" +
									"<label for='rdoEnrolleeRegisterWC' style='margin-top: 3px;'>Enrollee Register (with Coverage)</label>" +
								"</td>" +
							"</tr>" +
							"<tr>" +
								"<td>" +
									"<input type='radio' id='rdoEnrolleeSummary' name='byReportOption' value='3' style='margin-left: 5px; float: left;'/>" +
									"<label for='rdoEnrolleeSummary' style='margin-top: 3px;'>Enrollee Summary</label>" +
								"</td>" +
							"</tr>" +
						"</table>" +
					"</div>" +
				"</div>" +
			"</div>";
		$("printDialogFormDiv3").update(content); 
		$("printDialogFormDiv3").show();
		$("printDialogMainDiv").up("div",1).style.height = "395px"; /*"385px" edited By MarkS 05.10.2016 SR-5306 */
		$($("printDialogMainDiv").up("div",1).id).up("div",0).style.height = "420px";
		
		$("txtFromDateDiv").addClassName("disabled");
		$("txtFromDate").addClassName("disabled");
		disableDate("imgFromDate");
		$("txtFromDate").clear();
		
		$("txtToDateDiv").addClassName("disabled");
		$("txtToDate").addClassName("disabled");
		disableDate("imgToDate");
		$("txtToDate").clear();
		
		$("rdoEffDate").disabled = true;
		$("rdoIssDate").disabled = true;
		$("rdoAccEntDate").disabled = true;
		$("rdoBookingDate").disabled = true;
		
		$("imgFromDate").observe("click", function(){
			scwShow($('txtFromDate'),this, null);
		});
		$("imgToDate").observe("click", function(){
			scwShow($('txtToDate'),this, null);
		});
		
		$("txtFromDate").observe("focus", function(){
			if ($("txtToDate").value != "" && this.value != "") {
				if (compareDatesIgnoreTime(Date.parse($F("txtFromDate")),Date.parse($("txtToDate").value)) == -1) {
					customShowMessageBox("From Date should not be later than To Date.","E","txtFromDate");
					this.clear();
				}
			}
			
			fromDate = this.value;
		});
		
		$("txtToDate").observe("focus", function(){
			if ($("txtFromDate").value != "" && this.value != "") {
				if (compareDatesIgnoreTime(Date.parse($F("txtFromDate")),Date.parse($("txtToDate").value)) == -1) {
					customShowMessageBox("From Date should not be later than To Date.","E","txtToDate");
					this.clear();
				}
			}
			
			toDate = this.value;
		});
		
		$$("input[name='byPolOrDateOption']").each(function(radio){
			radio.observe("click", function(){
				setPolOrDateOption(radio.value);
			});
		});
		
		$$("input[name='byDateOption']").each(function(radio){
			radio.observe("click", function(){
				setByDateOption(radio.value);
			});
		});
		
		$$("input[name='byReportOption']").each(function(radio){
			radio.observe("click", function(){
				setByReportOption(radio.value);
			});
		});
		$("csvOptionDiv").show(); //marco - 07.21.2014
	}
	
	var polOrDate = "1";
	var dateOption = "1";
	var reportOption = "1";
	var fromDate = "";
	var toDate = "";
	
	function setByDateOption(option){
		dateOption = option;
	}
	
	function setByReportOption(option){
		reportOption = option;
	}
	
	function setPolOrDateOption(option){
		if(option == "1"){
			polOrDate = "1";
			$("txtFromDateDiv").addClassName("disabled");
			$("txtFromDate").addClassName("disabled");
			$("txtFromDateDiv").removeClassName("required");
			$("txtFromDate").removeClassName("required");
			disableDate("imgFromDate");
			$("txtFromDate").clear();
			
			$("txtToDateDiv").addClassName("disabled");
			$("txtToDate").addClassName("disabled");
			$("txtToDateDiv").removeClassName("required");
			$("txtToDate").removeClassName("required");
			disableDate("imgToDate");
			$("txtToDate").clear();
			
			$("rdoEffDate").disabled = true;
			$("rdoIssDate").disabled = true;
			$("rdoAccEntDate").disabled = true;
			$("rdoBookingDate").disabled = true;
			
			$("rdoEnrolleeSummary").disabled = false;
		} else {
			polOrDate = "2";
			$("txtFromDateDiv").removeClassName("disabled");
			$("txtFromDate").removeClassName("disabled");
			$("txtFromDateDiv").addClassName("required");
			$("txtFromDate").addClassName("required");
			enableDate("imgFromDate");
			
			$("txtToDateDiv").removeClassName("disabled");
			$("txtToDate").removeClassName("disabled");
			$("txtToDateDiv").addClassName("required");
			$("txtToDate").addClassName("required");
			enableDate("imgToDate");
			
			$("rdoEffDate").disabled = false;
			$("rdoIssDate").disabled = false;
			$("rdoAccEntDate").disabled = false;
			$("rdoBookingDate").disabled = false;
			
			$("rdoEnrolleeRegister").checked = true;
			$("rdoEnrolleeSummary").disabled = true;
		}
	}
	
	$("btnToolbarExit").observe("click",function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
</script>