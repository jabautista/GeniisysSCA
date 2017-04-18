<div id="checksPaidPerPayeeMainDiv" class="sectionDiv" style="border: none;">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>View Checks Paid per Payee</label>
			<span class="refreshers" style="margin-top: 0;">
		 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div id="parametersDiv" class="sectionDiv">
		<table style="margin-top: 10px; margin-bottom: 10px;">
			<tr>
				<td class="rightAligned" width="130px">Company</td>
				<td>
					<div id="fundCdDiv" style="float: left; width: 70px; height: 19px; margin-left: 5px; border: 1px solid gray;" class="required">
						<input id="txtFundCd" title="Fund Code" type="text" maxlength="3" class="required" style="float: left; height: 13px; width: 45px; margin: 0px; border: none;" tabindex="24001">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgFundCdLOV" name="imgFundCdLOV" alt="Go" style="float: right;" tabindex="24002"/>
					</div>
				</td>
				<td>
					<input type="text" id="txtFundDesc" style="width: 220px; margin-top: 3x;" readonly="readonly" tabindex="24003"/>
				</td>
				<td class="rightAligned" width="100px">Branch</td>
				<td>
					<div id="branchCdDiv" class="required" style="float: left; width: 70px; height: 19px; margin-left: 5px; border: 1px solid gray;">
						<input id="txtBranchCd" title="Branch Code" type="text" maxlength="2" class="required" style="float: left; height: 13px; width: 45px; margin: 0px; border: none;" tabindex="24004">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgBranchCdLOV" name="imgBranchCdLOV" alt="Go" style="float: right;" tabindex="24005"/>
					</div>
				</td>
				<td>
					<input type="text" id="txtBranchName" style="width: 220px; margin-top: 3x;" readonly="readonly" tabindex="24006"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Payee Class</td>
				<td>
					<div id="payeeClassCdDiv" class="required" style="float: left; width: 70px; height: 19px; margin-left: 5px; border: 1px solid gray;">
						<input id="txtPayeeClassCd" title="Fund Code" type="text" maxlength="2" class="required" style="float: left; height: 13px; width: 45px; margin: 0px; border: none;" tabindex="24007">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgPayeeClassCdLOV" name="imgPayeeClassCdLOV" alt="Go" style="float: right;" tabindex="24008"/>
					</div>
				</td>
				<td>
					<input type="text" id="txtClassDesc" style="width: 220px; margin-top: 3x;" readonly="readonly" tabindex="24009"/>
				</td>
				<td class="rightAligned">Payee</td>
				<td>
					<div id="payeeNoDiv" class="required" style="float: left; width: 70px; height: 19px; margin-left: 5px; border: 1px solid gray;">
						<input id="txtPayeeNo" title="Payee Number" type="text" maxlength="12" class="required" style="float: left; height: 13px; width: 45px; margin: 0px; border: none;" tabindex="24010">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgPayeeNoLOV" name="imgPayeeNoLOV" alt="Go" style="float: right;" tabindex="24011"/>
					</div>
				</td>
				<td>
					<input type="text" id="txtPayeeName" style="width: 220px; margin-top: 3x;" readonly="readonly" tabindex="24012"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">From</td>
				<td colspan="2">
					<div id="fromDateDiv" class="required" style="float: left; border: solid 1px gray; width: 120px; height: 20px; margin-left: 5px; margin-top: 2px;">
						<input type="text" id="txtFromDate" class="required" style="float: left; margin-top: 0px; margin-right: 3px; height: 14px; width: 92px; border: none;" name="txtFromDate" readonly="readonly" tabindex="24013"/>
						<img id="imgFromDate" alt="imgFromDate" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"/>
					</div>
					<label style="margin: 6px 0px 0px 41px; ">To</label>
					<div id="toDateDiv" class="required" style="float: left; border: solid 1px gray; width: 120px; height: 20px; margin-left: 5px; margin-top: 2px;">
						<input type="text" id="txtToDate" class="required" style="float: left; margin-top: 0px; margin-right: 3px; height: 14px; width: 92px; border: none;" name="txtToDate" readonly="readonly" tabindex="24013"/>
						<img id="imgToDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"/>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div id="viewChecksPaid" class="sectionDiv" style="height: 340px; margin-bottom: 20px;">
		<div id="viewChecksPaidTGDiv" class="sectionDiv" style="float: left; width: 898px; height: 230px; margin: 10px 0px 0px 10px; border: none;">
			
		</div>
		<div class="sectionDiv" style="border: none; margin-top: 10px;">
			<table width="100%">
				<tr>
					<td class="rightAligned" width="145px">Particulars</td>
					<td colspan="3">
						<div style="border: 1px solid gray; height: 19px; width: 661px; margin-left: 4px;">
							<textarea id="txtParticulars" readonly="readonly" name="txtParticulars" style="border: none; height: 12px; resize: none; width: 635px; vertical-align: text-top;" maxlength="4000"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditParticulars" id="editParticularsText" tabindex="24014"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">User ID</td>
					<td class="leftAligned">
						<input type="text" id="txtUserId" style="width: 200px;" readonly="readonly" tabindex="24015"/>
					</td>
					<td class="rightAligned" width="137px">Last Update</td>
					<td class="leftAligned">
						<input type="text" id="txtLastUpdate" style="width: 200px;" readonly="readonly" tabindex="24016"/>
					</td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv" style="border: none;">
			<input type="button" id="btnPrint" class="button" value="Print" style="width: 100px;"/>
		</div>
	</div>
</div>
<script type="text/JavaScript">
try{
	setModuleId("GIACS240");
	setDocumentTitle("View Checks Paid per Payee");
	var query = false;
	
	try{
		var objGIACS240 = new Object();
		objGIACS240.objCheckPaidPerPayeeTableGrid = JSON.parse('${json}');
		objGIACS240.objCheckPaidPerPayee = objGIACS240.objCheckPaidPerPayeeTableGrid.rows || []; 
		
		var checkPaidPerPayeeModel = {
			url:contextPath+"/GIACInquiryController?action=showGIACS240&refresh=1&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate")
						   +"&fundCd="+$F("txtFundCd")+"&branchCd="+$F("txtBranchCd")+"&payeeClassCd="+$F("txtPayeeClassCd")+"&payeeNo="+$F("txtPayeeNo"),
			options:{
				id: 1,
				width: '900px',
				height: '207px',
				onCellFocus: function(element, value, x, y, id){
					var obj = checkPaidPerPayeeTableGrid.geniisysRows[y];
					populateFields(obj); 
					
					checkPaidPerPayeeTableGrid.keys.removeFocus(checkPaidPerPayeeTableGrid.keys._nCurrentFocus, true);
					checkPaidPerPayeeTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus:function(element, value, x, y, id){
					checkPaidPerPayeeTableGrid.keys.removeFocus(checkPaidPerPayeeTableGrid.keys._nCurrentFocus, true);
					checkPaidPerPayeeTableGrid.keys.releaseKeys();
				},
				toolbar:{
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onRefresh: function() {
						checkPaidPerPayeeTableGrid.keys.removeFocus(checkPaidPerPayeeTableGrid.keys._nCurrentFocus, true);
						checkPaidPerPayeeTableGrid.keys.releaseKeys();
					}
				},
			},
			columnModel:[
		 		{   id: 'recordStatus',
				    title: '',
				    width: '0px',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	id: 'divCtrId',
					width: '0px',
					visible: false
				},
				{	id: 'checkNo',
					title: 'Check No.',
					width: '115px',
					visible: true,
					filterOption: true
				},
				{	id: 'checkDate',
					title: 'Check Date',
					width: '90px',
					align: 'center',
					visible: true
				},
				{	id: 'department',
					title: 'Department',
					width: '150px',
					visible: true,
					filterOption: true
				},
				{	id: 'bankName',
					title: 'Bank',
					width: '175px',
					visible: true,
					filterOption: true
				},
				{	id: 'bankAcctNo',
					title: 'Account No.',
					width: '150px',
					visible: true,
					filterOption: true
				},
				{	id: 'dvAmt',
					title: 'Disbursement Amount',
					width: '160px',
					align: 'right',
					geniisysClass: 'money',
					visible: true
				},
			],
			rows: objGIACS240.objCheckPaidPerPayee
		};
		
		checkPaidPerPayeeTableGrid = new MyTableGrid(checkPaidPerPayeeModel);
		checkPaidPerPayeeTableGrid.pager = objGIACS240.objCheckPaidPerPayeeTableGrid;
		checkPaidPerPayeeTableGrid._mtgId = 1;
		checkPaidPerPayeeTableGrid.render('viewChecksPaidTGDiv');
		checkPaidPerPayeeTableGrid.afterRender = function(){
			if(query){
				if(checkPaidPerPayeeTableGrid.geniisysRows.length == 0){
					showMessageBox("Query caused no records to be retrieved.", "I");
					disableButton("btnPrint");
					disableToolbarButton("btnToolbarPrint");
					enableToolbarButton("btnToolbarExecuteQuery");
					enableToolbarButton("btnToolbarEnterQuery");
				}else{
					enableButton("btnPrint");
					enableToolbarButton("btnToolbarPrint");
					enableToolbarButton("btnToolbarEnterQuery");
					disableToolbarButton("btnToolbarExecuteQuery");
				}
			}
		};
	}catch(e){
		showErrorMessage("checkPaidPerPayeeTableGrid",e);
	}
	
	function populateFields(obj){
		$("txtParticulars").value = obj == null ? null : unescapeHTML2(obj.particulars);
		$("txtUserId").value = obj == null ? null : obj.userId;
		$("txtLastUpdate").value = obj == null ? null : obj.lastUpdate;
	}
	
	$("btnToolbarEnterQuery").observe("click", function(){
		query = false;
		disableButton("btnPrint");
		disableToolbarButton("btnToolbarPrint");
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		$("txtFundCd").clear();
		$("txtFundDesc").clear();
		$("txtBranchCd").clear();
		$("txtBranchName").clear();
		$("txtPayeeClassCd").clear();
		$("txtClassDesc").clear();
		$("txtPayeeNo").clear();
		$("txtPayeeName").clear();
		$("txtFromDate").clear();
		$("txtToDate").clear();
		$("txtParticulars").clear();
		$("txtUserId").clear();
		$("txtLastUpdate").clear();
		$("txtFundCd").focus();
		
		executeQuery();
		
		query = false;
		
		checkPaidPerPayeeTableGrid.url = contextPath+"/GIACInquiryController?action=showGIACS240&refresh=1";
		checkPaidPerPayeeTableGrid._refreshList();
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		if($F("txtFundCd") == "" || $F("txtBranchCd") == "" || $F("txtPayeeClassCd") == "" || $F("txtPayeeNo") == ""
				|| $F("txtFromDate") == "" || $F("txtToDate") == ""){
			showMessageBox(objCommonMessage.REQUIRED, "I");
			$$("input[class='required']").each(function(a){
				if($F(a.id) == ""){
					$(a.id).focus();
					throw $break;
				}
			});
		}else{
			query = true;
			executeQuery();
		}
	});
	
	function executeQuery(){
		try{
			checkPaidPerPayeeTableGrid.url = contextPath+"/GIACInquiryController?action=showGIACS240&refresh=1&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate")
					+"&fundCd="+$F("txtFundCd")+"&branchCd="+$F("txtBranchCd")+"&payeeClassCd="+$F("txtPayeeClassCd")+"&payeeNo="+$F("txtPayeeNo");	

			checkPaidPerPayeeTableGrid._refreshList();
		}catch(e){
			showErrorMessage("btnToolbarExecuteQuery", e);
		}
	}	
	
	function printReport(){
		showGenericPrintDialog("Checks Paid", onPrintFunc, "", true);
	}
	
	function onPrintFunc(){
		var content;
		content = contextPath+"/GeneralDisbursementPrintController?action=printGIACR240&reportId=GIACR240&printerName="+$F("selPrinter")					
				+"&payeeClassCd="+$F("txtPayeeClassCd")+"&payeeNo="+$F("txtPayeeNo")+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");
		if($F("selDestination") == "screen"){
			showPdfReport(content, "Paid Checks");		
		}else if($F("selDestination") == "printer"){
			if($F("txtNoOfCopies") == 0 || $F("txtNoOfCopies") >= 2147483647){
				customShowMessageBox("Invalid value for No. of Copies.", "E", "txtNoOfCopies");
				return false;
			}
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
			new Ajax.Request(content, {
				method: "POST",
				parameters : {destination : "file",
							  fileType    : $("rdoPdf").checked ? "PDF" : "XLS"},
				evalScripts: true,
				asynchronous: true,
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
	}
	
	$("btnPrint").observe("click", printReport);
	$("btnToolbarPrint").observe("click", printReport);
	
	$("btnToolbarExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	});
	
	$("editParticularsText").observe("click", function() {
		showEditor("txtParticulars", 4000, "true");
	});
	
	$("imgFromDate").observe("click", function(){
		scwShow($("txtFromDate"),this, null);
		toggleToolbar();
	});
	
	$("imgToDate").observe("click", function(){
		scwShow($("txtToDate"),this, null);
		toggleToolbar();
	});
	
	function showFundCdLOV(isIconClicked){
		try {
			var searchString = ((isIconClicked || isIconClicked == null) ? "%" : nvl($F("txtFundCd"), "%"));	
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getCompanyLOV",
					searchString : searchString //nvl($F("txtFundCd"), "%")
				},
				title : "List of Companies",
				width : 370,
				height : 386,
				autoSelectOneRecord: true,
				columnModel : [ {
					id : "fundCd",
					title : "Fund Code",
					width : '90px',
				}, 
				{
					id : "fundDesc",
					title : "Fund Desc",
					width : '265px'
				},
				],
				draggable : true,
				filterText: searchString,
				onSelect : function(row) {
					$("txtFundCd").value = unescapeHTML2(row.fundCd);
					$("txtFundDesc").value = unescapeHTML2(row.fundDesc);
					$("txtBranchCd").focus();
					toggleToolbar();
				}
			});
		} catch (e) {
			showErrorMessage("showFundCdLOV", e);
		}
	}
	
	$("imgFundCdLOV").observe("click", showFundCdLOV);
	
	function showPayeeClassCdLOV(isIconClicked){
		try {
			var searchString = ((isIconClicked || isIconClicked == null) ? "%" : nvl($F("txtPayeeClassCd"), "%"));
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getPayeeClassGiacs240LOV",
					searchString : searchString //nvl($F("txtPayeeClassCd"), '%')
				},
				title : "List of Payee Class",
				width : 370,
				height : 386,
				autoSelectOneRecord: true,
				columnModel : [ {
					id : "payeeClassCd",
					title : "Payee Class Code",
					width : '110px'
				}, 
				{
					id : "classDesc",
					title : "Class Desc",
					width : '245px'
				},
				],
				draggable : true,
				filterText: searchString,
				onSelect : function(row) {
					$("txtPayeeClassCd").value = row.payeeClassCd;
					$("txtClassDesc").value = unescapeHTML2(row.classDesc);
					$("txtPayeeNo").clear();
					$("txtPayeeName").clear(); 
					$("txtPayeeNo").focus();
					toggleToolbar();
				}
			});
		} catch (e) {
			showErrorMessage("showPayeeClassCdLOV", e);
		}
	}
	
	$("imgPayeeClassCdLOV").observe("click", showPayeeClassCdLOV);
	
	function showBranchCdLOV(isIconClicked){
		try {
			var searchString = ((isIconClicked || isIconClicked == null) ? "%" : nvl($F("txtBranchCd"), "%"));	
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS240BranchLOV",
					moduleId : "GIACS240",
					gfunFundCd : $F("txtFundCd"),
					searchString : searchString //nvl($F("txtBranchCd"), '%')
				},
				title : "List of Branches",
				width : 370,
				height : 386,
				autoSelectOneRecord: true,
				columnModel : [ {
					id : "branchCd",
					title : "Branch Code",
					width : '90px'
				}, 
				{
					id : "branchName",
					title : "Branch Name",
					width : '265px'
				},
				],
				draggable : true,
				filterText: searchString,
				onSelect : function(row) {
					$("txtBranchCd").value = unescapeHTML2(row.branchCd);
					$("txtBranchName").value = unescapeHTML2(row.branchName);
					$("txtPayeeClassCd").focus();
					toggleToolbar();
				}
			});
		} catch (e) {
			showErrorMessage("showBranchCdLOV", e);
		}
	}
	
	$("imgBranchCdLOV").observe("click", showBranchCdLOV);
	
	function showPayeeLOV(isIconClicked){
		try {
			var searchString = ((isIconClicked || isIconClicked == null) ? "%" : nvl($F("txtPayeeNo"), "%"));
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getPayeeGiacs240LOV",
					payeeClassCd : $F("txtPayeeClassCd"),
					searchString : searchString //nvl($F("txtPayeeNo"), '%')
				},
				title : "List of Payees",
				width : 400,
				height : 386,
				autoSelectOneRecord: true,
				columnModel : [ {
					id : "payeeNo",
					title : "Payee Number",
					width : '90px'
				}, 
				{
					id : "payeeName",
					title : "Payee Name",
					width : '295px'
				},
				],
				draggable : true,
				filterText: searchString,
				onSelect : function(row) {
					$("txtPayeeNo").value = row.payeeNo;
					$("txtPayeeName").value = unescapeHTML2(row.payeeName);
					$("txtPayeeClassCd").value = row.payeeClassCd;
					$("txtClassDesc").value = unescapeHTML2(row.classDesc);
					toggleToolbar();
				}
			});
		} catch (e) {
			showErrorMessage("showPayeeLOV", e);
		}
	}
	
	$("imgPayeeNoLOV").observe("click", showPayeeLOV);
	
	$("txtFromDate").observe("focus", function(){
		var from = Date.parse($F("txtFromDate"));
		var to = Date.parse($F("txtToDate"));
		
		if(!$F("txtToDate") == "" && !$F("txtFromDate") == ""){
			if(to < from){
				customShowMessageBox("From Date should not be later than To Date.", "I", "txtFromDate");
				$("txtFromDate").clear();
			}
		}
		
		toggleToolbar();
	});
	
	$("txtToDate").observe("focus", function(){
		var from = Date.parse($F("txtFromDate"));
		var to = Date.parse($F("txtToDate"));
		
		if(!$F("txtFromDate") == "" && !$F("txtToDate") == ""){
			if(to < from){
				customShowMessageBox("From Date should not be later than To Date.", "I", "txtToDate");
				$("txtToDate").clear();
			}
		}
		
		toggleToolbar();
	});
	
	function doKeyUp(id){
		$(id).observe("keyup", function(){
			$(id).value = $(id).value.toUpperCase();
		});
	}
	
	doKeyUp("txtFundCd");
	var prevFundCd = "";
	var prevFundName = "";
	$("txtFundCd").observe("focus", function(){
		prevFundCd = $F("txtFundCd");
		prevFundName = $F("txtFundDesc");
	});
	$("txtFundCd").observe("change", function(){
		if($F("txtFundCd") == ""){
			$("txtFundDesc").clear();
			toggleToolbar();
		}else{
			/*new Ajax.Request(contextPath+"/GIACInquiryController?action=validateFundCdGiacs240",{
				parameters: {
					fundCd : $F("txtFundCd"),
					moduleId : "GIACS240"
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if(response.responseText == ""){
						showFundCdLOV();
						//$("txtFundCd").value = prevFundCd;
						//$("txtFundDesc").value = prevFundName; 
						$("txtFundCd").clear();
						$("txtFundDesc").clear();
					}else{
						$("txtFundDesc").value = response.responseText;
						toggleToolbar();
					}
				}
			});*/ // replaced with code below : shan 10.22.2014
			showFundCdLOV(false);
		}
	});
	
	doKeyUp("txtBranchCd");
	var prevBranchCd = "";
	var prevBranchName = "";
	$("txtBranchCd").observe("focus", function(){
		prevBranchCd = $F("txtBranchCd");
		prevBranchName = $F("txtBranchName");
	});
	$("txtBranchCd").observe("change", function(){
		if($F("txtBranchCd") == ""){
			$("txtBranchName").clear();
			toggleToolbar();
		}else{
			/*new Ajax.Request(contextPath+"/GIACInquiryController?action=validateBranchCdGiacs240",{
				parameters: {
					branchCd : $F("txtBranchCd"),
					moduleId : "GIACS240"
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if(response.responseText == ""){
						showBranchCdLOV();
						//$("txtBranchCd").value = prevBranchCd;
						//$("txtBranchName").value = prevBranchName; 
						$("txtBranchCd").clear();
						$("txtBranchName").clear();
					}else{
						$("txtBranchName").value = response.responseText;
						toggleToolbar();
					}
				}
			});*/ // replaced with code below : shan 10.22.2014
			showBranchCdLOV(false);
		}
	});
	
	doKeyUp("txtPayeeClassCd");
	var prevPayeeClassCd = "";
	var prevClassDesc = "";
	$("txtPayeeClassCd").observe("focus", function(){
		prevPayeeClassCd = $F("txtPayeeClassCd");
		prevClassDesc = $F("txtClassDesc");
	});
	$("txtPayeeClassCd").observe("change", function(){
		if($F("txtPayeeClassCd") == ""){
			$("txtClassDesc").clear();
			toggleToolbar();
		}else{
			/*new Ajax.Request(contextPath+"/GIACInquiryController?action=validatePayeeClassCdGiacs240",{
				parameters: {
					payeeClassCd : $F("txtPayeeClassCd")
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if(response.responseText == ""){
						showPayeeClassCdLOV();
						//$("txtPayeeClassCd").value = prevPayeeClassCd;
						//$("txtClassDesc").value = prevClassDesc; 
						$("txtPayeeClassCd").clear();
						$("txtClassDesc").clear(); 
					}else{
						$("txtClassDesc").value = response.responseText;
						toggleToolbar();
					}
				}
			});*/ // replaced with code below : shan 10.22.2014
			showPayeeClassCdLOV(false);
		}
	});
	
	doKeyUp("txtPayeeNo");
	var prevPayeeNo = "";
	var prevPayeeName = "";
	$("txtPayeeNo").observe("focus", function(){
		prevPayeeNo = $F("txtPayeeNo");
		prevPayeeName = $F("txtPayeeName");
	});
	$("txtPayeeNo").observe("change", function(){
		if($F("txtPayeeNo") == ""){
			$("txtPayeeName").clear();
			toggleToolbar();
		}else{
			/* if(isNaN($F("txtPayeeNo"))){
				customShowMessageBox("Invalid Payee Number. Valid value should be from 1 to 999999999999", "I", "txtPayeeNo");
				$("txtPayeeNo").value = prevPayeeNo;
				$("txtPayeeName").value = prevPayeeName; 
			}else{ */
				if($F("txtPayeeClassCd") == ""){
					customShowMessageBox("Payee Class Cd is required.", "I", "txtPayeeClassCd");
					$("txtPayeeNo").clear();
				}else{
					/*new Ajax.Request(contextPath+"/GIACInquiryController?action=validatePayeeNoGiacs240",{
						parameters: {
							payeeNo : isNaN($F("txtPayeeNo")) ? 0 : $F("txtPayeeNo"),
							payeeClassCd : $F("txtPayeeClassCd")
						},
						evalScripts: true,
						asynchronous: true,
						onComplete: function(response){
							var json = JSON.parse(response.responseText);
							if(json.payeeName == null){
								showPayeeLOV();
								//$("txtPayeeNo").value = prevPayeeNo;
								//$("txtPayeeName").value = prevPayeeName; 
								$("txtPayeeNo").clear();
								$("txtPayeeName").clear(); 
							}else{
								$("txtPayeeName").value = json.payeeName;
								$("txtPayeeClassCd").value = json.payeeClassCd;
								$("txtClassDesc").value = json.classDesc;
								toggleToolbar();
							}
						}
					});*/ // replaced with code below : shan 10.22.2014
					showPayeeLOV(false);
				}
			//}
		}
	});
	
	function toggleToolbar(){
		if(($F("txtFundCd") != "") && ($F("txtBranchCd") != "") && ($F("txtPayeeClassCd") != "") && ($F("txtPayeeNo") != "") 
				&& ($F("txtFromDate") != "") && ($F("txtToDate") != "")){
			enableToolbarButton("btnToolbarExecuteQuery");
		}else{
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	}
	
	$("mainNav").hide();
	$("txtFundCd").focus();
	disableButton("btnPrint");
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");
	disableToolbarButton("btnToolbarPrint");
	observeReloadForm("reloadForm", showGIACS240);
}catch(e){
	showErrorMessage("checksPaidPerPayee.jsp", e);
}
</script>